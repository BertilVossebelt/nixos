# /etc/nixos/users.nix
{ config, pkgs, ... }:

{
  users.users.ajv = {
    isNormalUser = true;
    description = "AJ Vossebelt";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  system.activationScripts.fixNixosPermissions.text = ''
    if [ -d "/etc/nixos/.git" ]; then
      chown -R ajv:users /etc/nixos
    fi
  '';
}
