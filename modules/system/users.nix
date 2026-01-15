{ config, pkgs, ... }:

{
  users.users = {
    ajv = {
      isNormalUser = true;
      description = "AJ Vossebelt";
      extraGroups = [ "wheel" "networkmanager" ];
      shell = pkgs.zsh;
      packages = with pkgs; [
        kdePackages.kate
      ];
    };
  };
}
