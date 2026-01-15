{ config, pkgs, ... }:

{
    services.xserver.enable = true;
    services.desktopManager.plasma6.enable = true;
    services.xserver.windowManager.i3.enable = false;
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.xserver.xkb = {
        layout = "us";
        variant = "";
    };
}
