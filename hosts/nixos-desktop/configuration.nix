{ config, pkgs, ... }:

{
  networking.hostName = "nixos-desktop";

  # Machine-specific kernel params
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "amdgpu.dc=1" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
}
