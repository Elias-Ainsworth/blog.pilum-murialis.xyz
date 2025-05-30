{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
    flake-parts.url = "github:hercules-ci/flake-parts";
    thornemacs = {
      url = "github:elias-ainsworth/thornemacs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      perSystem =
        { pkgs, system, ... }:
        {
          packages = {
            publish = pkgs.writeShellApplication {
              name = "publish";
              runtimeInputs = with pkgs; [
                inputs.thornemacs.packages.${system}.default
                coreutils
              ];
              text = ''
                emacs --batch --load publish.el t --eval '(org-publish "site" t)'
              '';
            };
          };

          devShells = rec {
            default = development;
            development = pkgs.callPackage ./shell.nix { inherit inputs; };
          };
        };
    };
}
