# /etc/nixos/modules/networking.nix
{ config, pkgs, ... }:

{
  # Timezone & locale
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  # Networking
  networking.firewall.enable = true;
  networking.networkmanager.enable = true;

  # Virtualisation networking
  virtualisation.libvirtd.enable = true;
}
