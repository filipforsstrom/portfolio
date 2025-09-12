{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};

      # Tiny static package containing index.html
      portfolio = pkgs.runCommand "portfolio-0.1.0" {} ''
        mkdir -p "$out"
        cp ${./index.html} "$out/index.html"
      '';

      # NixOS VM wired to serve `portfolio` with Caddy
      testVm = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit portfolio;};
        modules = [
          "${nixpkgs}/nixos/modules/profiles/minimal.nix"
          ./qemu.nix
          ./configuration.nix
        ];
      };
    in {
      packages = {
        inherit portfolio;
        default = portfolio;
      };

      apps.default = {
        type = "app";
        program = "${testVm.config.system.build.vm}/bin/run-${testVm.config.networking.hostName}-vm";
      };
    });
}
