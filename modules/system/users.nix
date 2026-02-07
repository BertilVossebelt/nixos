# /etc/nixos/modules/system/users.nix
{ config, pkgs, ... }:

{
  users.users.ajv = {
    isNormalUser = true;
    description = "AJ Vossebelt";
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.bash;
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
