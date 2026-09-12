# /etc/nixos/modules/system/packages.nix
{ config, pkgs, inputs, ... }:

{
  # Allow dynamically linked executables (e.g. bundled binaries in JetBrains IDEs)
  programs.nix-ld.enable = true;

  virtualisation.docker.enable = false;
  environment.systemPackages = with pkgs; [
    git
    micro
    nodejs
    home-manager

    # Break-glass: kept at system level so a terminal (autogen config binds
    # SUPER+Q -> kitty) and a browser survive a home-manager wipe.
    kitty
    firefox-devedition
];
}
