{
  description = "The Type Theory of Lean (LaTeX PDF)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      tex = pkgs.texliveFull;
    in
    {
      packages.${system}.default = pkgs.stdenvNoCC.mkDerivation {
        pname = "lean-type-theory";
        version = "0.1.0";
        src = self;

        nativeBuildInputs = [ tex ];

        buildPhase = ''
          runHook preBuild
          export HOME=$(mktemp -d)
          export TEXMFHOME="$HOME/.texmf"
          export TEXMFVAR="$HOME/.texmf-var"
          export XDG_CACHE_HOME="$HOME/.cache"
          latexmk -pdf -interaction=nonstopmode -halt-on-error main.tex
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          mkdir -p $out
          cp main.pdf $out/
          runHook postInstall
        '';
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = [ tex ];
      };
    };
}
