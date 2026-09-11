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

    # Add Home Manager CLI
    inputs.home-manager.packages.${pkgs.system}.home-manager
  ];
}
