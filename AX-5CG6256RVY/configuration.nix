# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

 # boot.initrd.luks.devices."luks-1cd5702a-5787-4d32-aca1-7e8a943bb366".device =
  #  "/dev/disk/by-uuid/1cd5702a-5787-4d32-aca1-7e8a943bb366";

  networking.hostName = "AX-5CG6256RVY"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable Flakes & Cleanup
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Enable Flakes
  # nix.settings.experimental-features = [
  #  "nix-command"
  # "flakes"
  # ];

  #Enable Cosmic Desktop
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.axnix = {
    isNormalUser = true;
    description = "axmurder";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      nh
    ];

  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  #To allow Broadcom card for Wifi 
   nixpkgs.config.permittedInsecurePackages = [
     "broadcom-sta-6.30.223.271-57-6.15.7"
      ];
  

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    curl
    pciutils
    microsoft-edge
    ferdium
    protonvpn-gui
    protonvpn-cli
    gitkraken
    btop
    vscode
    bitwarden
    expressvpn
    onlyoffice-desktopeditors
    libreoffice-fresh
    gitkraken
    direnv
    vlc
    deluge
    htop
    glances
    mission-center
    pkgs.gnome-disk-utility
    pkgs.python312
    orca-slicer
    fastfetch
    meld
    winetricks
    dust
    barrier
    teams-for-linux
    cobang
    dbeaver-bin
    gimp
    freecad
    github-desktop
    obs-studio
    #teamviewer
    kdePackages.kdenlive
    yubikey-manager
    yubikey-personalization-gui
    zoom-us
    openscad
    libredwg
    kdePackages.gwenview
    evil-helix
    helix-gpt
    nh
    wineWowPackages.staging
    wineWowPackages.waylandFull
    winbox4
    dupeguru
    google-fonts
    flatpak
    inputs.zen-browser.packages.x86_64-linux.default
    inputs.zen-browser.packages.x86_64-linux.specific
    inputs.zen-browser.packages.x86_64-linux.generic
    inputs.nixvim.packages.x86_64-linux.default
  ];

  services.flatpak.packages = [
    #"com.microsoft.Edge"
  ];

  #kernel options
  boot = {
    # Kernel
    kernelPackages = pkgs.linuxPackages_zen;
    # This is for OBS Virtual Cam Support
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    # Needed For Some Steam Games
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
    # Make /tmp a tmpfs
    tmp = {
      useTmpfs = false;
      tmpfsSize = "30%";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  #services.teamviewer.enable = true;
  services.printing.enable = true;
  services.flatpak.enable = true;

  systemd.services.flatpak-repo = {
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

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
  system.stateVersion = "24.11"; # Did you read the comment?

}
