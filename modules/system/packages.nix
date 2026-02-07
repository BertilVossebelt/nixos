# /etc/nixos/packages.nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    OVMF
    micro
    firefox-devedition
    signal-desktop
    tidal-hifi
    zapzap
    slack
    yaak
    jetbrains.rider
    # jetbrains.webstorm
    # jetbrains.pycharm
    # jetbrains.phpstorm
    # jetbrains.idea
    # davinci-resolve
  ];
}
