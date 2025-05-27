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
                emacs -nw --load publish.el --eval '(progn (org-publish "site" t) (kill-emacs))'
              '';
            };
          };

          devShells = rec {
            default = development;
            development = pkgs.callPackage ./shell.nix { inherit inputs; };
          };
        };
      # flake = {
      #   nixosModules = rec {
      #     default = pilum-murialis-xyz;
      #     pilum-murialis-xyz = import ./flake/nixos.nix self;
      #   };
      # };
    };
}
