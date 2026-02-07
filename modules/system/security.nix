# /etc/nixos/modules/system/security.nix
{ config, pkgs, ... }:

{
  # Polkit & permissions
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  # GNOME keyring (needed for some authentication)
  services.gnome.gnome-keyring.enable = true;

  # Nix configuration
  nix.package = pkgs.nix;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
