{
  description = "Multi-host flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
  };

  outputs = { self, nixpkgs, home-manager, ... }:

  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };

    # Hosts
    hosts = ["nixos-desktop" "laptop"];

    # Create a nixosSystem for a host
    makeConfig = host: let
      hostPath = ./hosts/${host}/configuration.nix;
      hostConfig = if builtins.pathExists hostPath then import hostPath else {};
    in
    nixpkgs.lib.nixosSystem {
      inherit system pkgs;

      modules = [
        ./hardware-configuration.nix
        ./modules/system/bootloader.nix
        ./modules/common.nix
        ./modules/system/packages.nix
        ./modules/system/desktop-kde.nix
        ./modules/system/users.nix
        ./modules/home/git-setup.nix

        # Home Manager integration
        home-manager.nixosModules.home-manager
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
