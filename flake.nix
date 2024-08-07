{
  description = "Flake for byedpi";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    packages.${system} = rec {
      default = pkgs.stdenv.mkDerivation {
        pname = "byedpi";
        version = "0.12.0";

        src = pkgs.fetchFromGitHub {
          owner = "hufrea";
          repo = "byedpi";
          rev = "main";
          sha256 = "tlxK8WWxoWvjftePzEj0P9ZQWHbKbcUlhmpIvji27Bg=";
        };

        buildInputs = [ pkgs.gnumake pkgs.gcc ];

        buildPhase = ''
          make
        '';

        installPhase = ''
          mkdir -p $out/bin
          cp ciadpi $out/bin/
        '';

        meta = with pkgs.lib; {
          description = "A simple tool to say goodbye to DPI";
          license = licenses.mit;
          platforms = platforms.unix;
        };
      };
    };

    devShell.${system} = pkgs.mkShell {
      buildInputs = [
        self.packages.${system}.default
      ];
    };
  };
}
