# /etc/nixos/flake.nix
{
  description = "Multi-host flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
  };

  outputs = { self, nixpkgs, ... } @ inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    # Hosts
    hosts = ["nixos-desktop" "laptop"];

    # Create a nixosSystem for a host
    makeConfig = host: let
      hostPath = ./hosts/${host}/configuration.nix;
      hostConfig = if builtins.pathExists hostPath then import hostPath else {};
    in
    nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      specialArgs = { inherit inputs; };

      modules = [
        ./hardware-configuration.nix
        ./modules/system/bootloader.nix
        ./modules/system/networking.nix
        ./modules/system/audio.nix
        ./modules/system/security.nix
        ./modules/system/packages.nix
        ./modules/system/desktop-kde.nix
        ./modules/system/desktop-hyprland.nix
        ./modules/system/users.nix

        # Add home-manager
        inputs.home-manager.nixosModules.home-manager
      ] ++ [ hostConfig ];
    };
  in
  {
    # Dynamically create nixosConfigurations for all hosts
    nixosConfigurations = builtins.listToAttrs (map (h: {
      name = h;
      value = makeConfig h;
    }) hosts);
  };
}
