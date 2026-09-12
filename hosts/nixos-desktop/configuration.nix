{ config, pkgs, ... }:

{
  networking.hostName = "nixos-desktop";

  # Release this machine was first installed on — do not bump on upgrades.
  system.stateVersion = "26.05";

  # Machine-specific kernel params
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "amdgpu.dc=1" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
}
