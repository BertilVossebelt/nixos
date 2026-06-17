# /etc/nixos/modules/system/packages.nix
{ config, pkgs, inputs, ... }:

{
  virtualisation.docker.enable = false;
  environment.systemPackages = with pkgs; [
    git
    micro
    node

    # Add Home Manager CLI
    inputs.home-manager.packages.${pkgs.system}.home-manager
  ];
}
