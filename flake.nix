{
  description = "Multi-host flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    upnote-src = { url = "https://download.getupnote.com/app/UpNote.AppImage"; flake = false; };
    affinity-nix.url = "github:mrshmllow/affinity-nix";
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, affinity-nix, ... } @ inputs:
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
        ./modules/system/libvirt-network.nix
        ./modules/system/common.nix
        ./modules/system/packages.nix
        ./modules/system/desktop-kde.nix
        ./modules/system/users.nix
        ./modules/system/windows-vm-domain.nix
        ./modules/system/windows-vm.nix

        # Flatpak modules
        inputs.nix-flatpak.nixosModules.nix-flatpak

        # Home Manager integration
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.ajv = {
            imports = [
              ./modules/home/git-setup.nix
            ];

            home.packages = [
              inputs.affinity-nix.packages.${pkgs.system}.v3
            ];

            # Enable AppImages here:
          };
        }
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
