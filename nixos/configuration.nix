# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  sources = import ./lon.nix;
  lanzaboote = import sources.lanzaboote {
    inherit pkgs;
  };
  unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz") {
  config.allowUnfree = true;
};
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
      lanzaboote.nixosModules.lanzaboote
    ];
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  boot = {
    loader.systemd-boot.enable = false; #secure boot lanzaboote thingy
    loader.efi.canTouchEfiVariables = true;
    tmp.cleanOnBoot = true;
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    resumeDevice = "/dev/nvme0n1p5";
    kernelParams = [
      "resume=/dev/nvme0n1p5"
      "resume_offset=14252032"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];
    kernel.sysctl = {
      "vm.swappiness" = 180;
      "vm.page-cluster" = 0;
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100; # Creates compressed swap = ~50% extra effective RAM
  };

  networking = {
    # Enable networking
    networkmanager.enable = true;
    hostName = "nixos"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  home-manager.users.dziks0nn = { pkgs, ... }: {
    home.stateVersion = "25.11";
    imports = [ <catppuccin/modules/home-manager> ];
    nixpkgs.config.allowUnfree = true;

    #config symlinks
    home.file = builtins.mapAttrs (_: src: { source = src; }) {
      ".zshrc" = ../zshrc;
      ".config/hypr/hyprland.lua" = ../hypr/hyprland.lua;
      ".config/hypr/hyprscripts" = ../hypr/hyprscripts;
      ".config/waybar" = ../waybar;
      ".config/rofi" = ../rofi;
    };

    catppuccin = {
      enable = true;
      flavor = "mocha";
      accent = "mauve";
      vscode.profiles.default.enable = false;
    };

    programs = {
      yazi.enable = true;
      firefox.enable = true;
      btop.enable = true;
      hyprlock.enable = true;
      vscode.enable = true;
      waybar.enable = true;
      micro.enable = true;
      ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = {
          "github.com" = {
            hostname = "github.com";
            user = "git";
            identityFile = "~/.ssh/id_ed25519";
          };
        };
      };

      git = {
        enable = true;
        settings = {
          user.name = "Dziksonn";
          user.email = "40899061+Dziksonn@users.noreply.github.com";
          pull.rebase = true;
          init.defaultBranch = "main";
        };
      };
      
      lazygit = {
        enable = true;
        settings = {
          git.pagers = [
            {pager = "delta --dark --pager='-RF'";}
          ];
        };
      };

      kitty = {
        enable = true;
        font.name = "JetBrainsMono Nerd Font";
        font.size = 12;
        settings = {
          shell = "/run/current-system/sw/bin/zsh";
        };
        extraConfig = ''
          map ctrl+left send_text all \x1b[1;5D
          map ctrl+right send_text all \x1b[1;5C
          map ctrl+backspace send_text all \x08
        '';
      };

      java = {
        enable = true;
        package = pkgs.jdk21;
      };
    };

    services = {
      mako = {
        enable = true;
        settings = {
          anchor = "top-center";
          output = "DP-1";
        };
      };
      wlsunset = {
        enable = true;
        temperature = {
          day = 6500;
          night = 3000;
        };
        sunrise = "06:00";
        sunset = "18:00";
      };
    };
    
    #made so that signal go first when typing "sign" in rofi, and also changed name to "GIMP" instead of "GNU Image Manipulation Program"
    xdg.desktopEntries.gimp = {
      name = "GIMP";
      genericName = "Image Editor";
      exec = "gimp %U";
      icon = "gimp";
      mimeType = [ "image/bmp" "image/gif" "image/jpeg" "image/png" "image/tiff" ];
      categories = [ "Graphics" "2DGraphics" "RasterGraphics" ];
      settings = {
        Keywords = "GIMP;graphic;illustration;painting;";
      };
    };
  };

  users.users.dziks0nn = {
    isNormalUser = true;
    description = "Dziks0nn";
    extraGroups = [ "networkmanager" "wheel" "uinput" "input" "gamemode" "docker"];
    shell = pkgs.zsh;
  };

  services = {
    #X11 windowing system, can be disabled for wayland
    xserver = {
      enable = true;
      xkb = {
        layout = "pl";
        variant = "";
      };
      # Load nvidia driver for Xorg and Wayland
      videoDrivers = ["nvidia"];
    };

    #KDE Plasma (used as backup in case hyprland breaks)
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;

    printing.enable = true;
    blueman.enable = true;

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    libinput = {
      enable = true;
        mouse = {
          accelProfile = "flat";
          accelSpeed = "0.0";
        };
      };
  };

  programs = {
    hyprland.enable = true;
    gamemode.enable = true;
    zsh = {
      enable = true;
      enableCompletion = false; #zplug will handle it
      interactiveShellInit = ''
        source ${pkgs.zplug}/share/zplug/init.zsh
      '';
    };
  };

  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    rofi
    wget
    pavucontrol
    playerctl
    lon
    sbctl
    hyprpicker
    clipse
    wl-clipboard
    hyprshot
    jq
    grim
    slurp
    libnotify
    hyprpolkitagent
    hyprls
    wlsunset
    wlogout
    nvtopPackages.nvidia
    easyeffects
    gamescope
    mangohud
    p7zip
    delta
    fastfetch
    gimp
    signal-desktop
    ncdu
    zsh
    zplug
    rustdesk-flutter
    mpv
    krita
    prismlauncher
    nix-tree
    localsend
    mtr #traceroute thingy
    micro-full #file editor
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  virtualisation.docker = {
    enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  hardware.graphics = {
    enable = true;
  };

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    open = true;

    # Enable the Nvidia settings menu,
	  # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pl_PL.UTF-8";
      LC_IDENTIFICATION = "pl_PL.UTF-8";
      LC_MEASUREMENT = "pl_PL.UTF-8";
      LC_MONETARY = "pl_PL.UTF-8";
      LC_NAME = "pl_PL.UTF-8";
      LC_NUMERIC = "pl_PL.UTF-8";
      LC_PAPER = "pl_PL.UTF-8";
      LC_TELEPHONE = "pl_PL.UTF-8";
      LC_TIME = "pl_PL.UTF-8";
    };
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  console.keyMap = "pl2";
  time.timeZone = "Europe/Warsaw";
  time.hardwareClockInLocalTime = true;

  # fileSystems."/mnt/windows" = {
  #   device = "/dev/nvme0n1p5";
  #   fsType = "ntfs-3g";
  #   options = [ "rw" "exec" "uid=1000" "gid=100" "dmask=000" "fmask=000" "nofail" "remove_hiberfile"];
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
