{
  inputs = {
    devenv.url = "github:cachix/devenv";
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
  };
  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
    extra-substituters = "https://devenv.cachix.org https://cache.nixos.org https://nix-community.cachix.org";
  };
  outputs = {
    devenv,
    nixpkgs,
    self,
    systems,
    ...
  } @ inputs: let
    for-each-system = nixpkgs.lib.genAttrs (import systems);
  in {
    packages = for-each-system (system: {
      devenv-up = self.devShells.${system}.default.config.procfileScript;
    });
    devShells = for-each-system (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = devenv.lib.mkShell {
        inherit inputs pkgs;
        modules = [
          ({config, ...}: {
            packages = [
              pkgs.zellij
            ];
          })
        ];
      };
    });
  };
}
