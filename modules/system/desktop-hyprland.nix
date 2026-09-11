# /etc/nixos/modules/system/desktop-hyprland.nix
{ config, pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config.Hyprland = {
      default = [ "hyprland" "gtk" ];
      "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
      "org.freedesktop.impl.portal.Inhibit"  = [ "gtk" ];
    };
  };

  # Hint Electron/Chromium apps to use Wayland natively
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

}
