{
  description = "Flake for byedpi";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs }: let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
  in {
    packages.x86_64-linux.default = pkgs.stdenv.mkDerivation {
      pname = "byedpi";
      version = "1.0.0";

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

    devShell.x86_64-linux = pkgs.mkShell {
      buildInputs = [
        self.packages.x86_64-linux.default
      ];
    };
  };
}
