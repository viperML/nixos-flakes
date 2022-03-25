{
  config,
  pkgs,
  inputs,
  self,
  ...
}: {
  # Systemd-boot has less configuration options but just works (TM)
  boot.loader.systemd-boot.enable = true;
  # Enable if EFI install
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "HOSTNAME";
  networking.networkmanager.enable = true;

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  # Usually not needed if using a Desktop Manager
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  services.xserver = {
    enable = true;
    libinput.enable = true;

    # To enable plasma
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;

    # Or to enable gnome
    displayManager.gdm.enable = false;
    desktopManager.gnome.enable = false;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.USER = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "audio"
      "video"
      "networkmanager"
    ];
    initialPassword = "1234";
  };
  # Just enable Home-manager for the user
  home-manager.users.USER = _: {};

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    firefox
    neovim
  ];

  system.stateVersion = "21.11";
  system.configurationRevision = self.rev or null;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {inherit inputs self;};
  home-manager.sharedModules = [
    {
      home.stateVersion = config.system.stateVersion;
    }
  ];
}
