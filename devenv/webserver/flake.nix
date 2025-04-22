{
  inputs = {
    devenv.url = "github:cachix/devenv";
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
  };
  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= fossar.cachix.org-1:Zv6FuqIboeHPWQS7ysLCJ7UT7xExb4OE8c4LyGb5AsE= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
    extra-substituters = "https://devenv.cachix.org https://cache.nixos.org https://fossar.cachix.org https://nix-community.cachix.org";
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
      default = let 
        domain = "localhost";
        debug-flag = true;
        backend-subdomain = "image-detect";
      in devenv.lib.mkShell {
        inherit inputs pkgs;
        modules = [
          ({config, ...}: {
            certificates = [
              "*.${domain}"
            ];
            enterShell = ''
              sudo sysctl -w net.ipv4.ip_unprivileged_port_start=0;
            '';
            hosts = {
              "*.${domain}" = "localhost";
            };
            packages = [pkgs.procps pkgs.toybox];
            services = {
              caddy = {
                config = ''
                  {
                  ${if debug-flag then ''
                    debug
                  '' else ""}
                  }
                '';
                enable = true;
                package = pkgs.caddy;
                virtualHosts."${backend-subdomain}.${domain}" = {
                  extraConfig = ''
                    reverse_proxy :8080
                    tls ${config.env.DEVENV_STATE}/mkcert/_wildcard.${domain}.pem ${config.env.DEVENV_STATE}/mkcert/_wildcard.${domain}-key.pem
                  '';
                };
              };
            };
          })
        ];
      };
    });
  };
}
