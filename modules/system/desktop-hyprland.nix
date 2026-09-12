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

  # Fix unpopulated/missing XDG application menus for standalone DEs
  environment.etc."xdg/menus/applications.menu".text = builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
  environment.sessionVariables.XDG_MENU_PREFIX = "plasma-";
}
