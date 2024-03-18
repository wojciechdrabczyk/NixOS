{
  description = "NixOS Flake for @wojtekd configs";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    #sops-nix.url = "github:Mic92/sops-nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    deploy-rs.url = "github:serokell/deploy-rs";
  };
  outputs = {
    self,
    nixpkgs,
    nixos-wsl,
    vscode-server,
    home-manager,
    deploy-rs,
    ...
  } @ inputs: {
    nixosConfigurations = let
      userConfig = {
        userName = "wojtek";
        fullName = "Wojciech Drabczyk";
        userEmail = "wojtek@lycal.dev";
      };
      systemConfig = system: modules: prof:
        nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs userConfig;};
          inherit system;
          modules =
            [
              home-manager.nixosModules.home-manager
              ({
                config,
                pkgs,
                ...
              }: {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.wojtek = import ./modules/home;
                home-manager.extraSpecialArgs = {
                  inherit inputs prof userConfig;
                };
              })
              ./modules/nixos/system.nix
            ]
            ++ modules;
        };
    in {
      vm = systemConfig "x86_64-linux" [./hosts/vm/vm.nix] [./modules/home/common ./modules/home/work];
    };
  };
}
