# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  sources = import ./lon.nix;
  lanzaboote = import sources.lanzaboote {
    inherit pkgs;
  };
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
      lanzaboote.nixosModules.lanzaboote
    ];

  home-manager.users.dziks0nn = { pkgs, ... }: {
	home.stateVersion = "25.11";
	nixpkgs.config.allowUnfree = true;
	imports = [ <catppuccin/modules/home-manager> ];

	catppuccin.enable = true;
	catppuccin.flavor = "mocha";
	catppuccin.accent = "mauve";

  programs.ssh = {
   enable = true;
   matchBlocks."github.com" = {
     hostname = "github.com";
     user = "git";
     identityFile = "~/.ssh/id_ed25519";
    };
  };

	programs.git = {
    enable = true;
    userName = "Dziksonn";
    userEmail = "40899061+Dziksonn@users.noreply.github.com";  # fill this in
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      git.pagers = [
        {
          pager = "delta --dark --pager='less -RF'";
        }
      ];
    };
  };
	programs.firefox.enable = true;
	programs.btop.enable = true;
	programs.kitty = {
		enable = true;
		font.name = "JetBrainsMono Nerd Font";
  		font.size = 12;
	};
	programs.waybar = {
		enable = true;
		style = builtins.readFile ./waybar/style.css;
	};
	programs.hyprlock.enable = true;
	services.mako = {
	  enable = true;
	  anchor = "top-center";
	  output = "DP-1";  # or whatever your monitor name is
	};
	programs.vscode.enable = true;
	programs.prismlauncher.enable = true;

services.wlsunset = {
  enable = true;

  temperature = {
    day = 6500;
    night = 3000;
  };

  sunrise = "06:00";
  sunset = "18:00";

  #gamma = 1.0;
  
  #For location based sunrise/sunset
  #
  #latitude = 23.5;
  #longitude = 91.7;
};

  };

  services.blueman.enable = true;
  programs.gamemode.enable = true;

  # Bootloader.
  #boot.loader.systemd-boot.enable = true; 
  boot.loader.systemd-boot.enable = false; #temp for secure boot
  boot.loader.efi.canTouchEfiVariables = true;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  swapDevices = [{
    device = "/swapfile";
    size = 16 * 1024;
  }];
  boot.resumeDevice = "/dev/nvme0n1p5";
  boot.kernelParams = [
    "resume=/dev/nvme0n1p5"
    "resume_offset=14252032"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];

fileSystems."/mnt/windows" = {
  device = "/dev/nvme0n1p3";
  fsType = "ntfs-3g";
  options = [ "rw" "exec" "uid=1000" "gid=100" "dmask=000" "fmask=000" "nofail" ];
};

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";
  time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  services.libinput = {
    enable = true;
    mouse = {
      accelProfile = "flat";
      accelSpeed = "0.0";
    };
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  programs.hyprland.enable = true;
  security.polkit.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "pl2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dziks0nn = {
    isNormalUser = true;
    description = "Dziks0nn";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  programs.steam = {
  enable = true;
  extest.enable = false;
  extraCompatPackages = [ pkgs.proton-ge-bin ];
  # Allow Steam to see outside paths
  package = pkgs.steam.override {
    extraLibraries = pkgs: [ ];
  };
};

# Add this — lets Steam see /mnt
hardware.steam-hardware.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
	rofi
	wget
	pavucontrol
	playerctl
	lon
	sbctl
	neovim
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
  stremio-linux-shell
	wlogout
	nvtopPackages.nvidia
	easyeffects
	gamescope
	mangohud
	p7zip
	lutris
	wine
	winetricks
	qbittorrent
	delta
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

  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

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
