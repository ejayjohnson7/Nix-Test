{
  inputs = {

    #nixpkgs.follows = "nixos-cosmic/nixpkgs-stable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    # nixpkgs-unstable.url = "nixpkgs/nicos-unstable";
    # nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    nixvim.url = "github:dc-tec/nixvim";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    # nixos-cosmic = {
    #  url = "github:lilyinstarlight/nixos-cosmic";
    #  inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      #nixos-cosmic,
      nixvim,
      zen-browser,
      nix-flatpak,
    }:
    {
      nixosConfigurations = {
        # NOTE: change "host" to your system's hostname
        AX-5CG6256RVY = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
           # {
           #   nix.settings = {
           #     substituters = [ "https://cosmic.cachix.org/" ];
           #     trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
           #   };
           # }
            # nixos-cosmic.nixosModules.default
            nix-flatpak.nixosModules.nix-flatpak
            ./configuration.nix
          ];
        };
      };
    };
}
