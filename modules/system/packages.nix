{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    micro
    firefox-devedition
    signal-desktop
  ];
}
