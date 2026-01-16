{ config, pkgs, ... }:

{
  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # Modern XDG Portal configuration for Plasma 6
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    config.common.default = "kde";
    # This helps apps like ZapZap use the native KDE file picker
    xdgOpenUsePortal = true;
  };

  # Forces KDE to look into Nix profiles for your .desktop files (icons)
  environment.sessionVariables = {
    XDG_DATA_DIRS = [
      "/run/current-system/sw/share"
      "~/.local/share"
    ];
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}
