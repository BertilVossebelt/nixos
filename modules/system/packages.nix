# /etc/nixos/modules/system/packages.nix
{ config, pkgs, inputs, ... }:

{
  virtualisation.docker.enable = true;
  environment.systemPackages = with pkgs; [
    git
    micro

    # Add Home Manager CLI
    inputs.home-manager.packages.${pkgs.system}.home-manager
  ];
}
