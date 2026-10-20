{
  description = "Reproducible Data Science with Nix and T";

  inputs = {
    nixpkgs.url = "github:rstats-on-nix/nixpkgs/2026-09-23";
    tlang = {
      url = "github:b-rodrigues/tlang/v0.56.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  # Configure Cachix caches if needed
  nixConfig = {
    extra-substituters = [
      "https://rstats-on-nix.cachix.org"
    ];
    extra-trusted-public-keys = [
      "rstats-on-nix.cachix.org-1:vdiiVgocg6WeJrODIqdprZRUrhi1JzhBnXv7aWI6+F0="
    ];
  };

  outputs = { self, nixpkgs, tlang, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system}.extend (final: prev: {
          jpmml-statsmodels = prev.jpmml-statsmodels.overrideAttrs (oldAttrs: {
            fetchedMavenDeps = oldAttrs.fetchedMavenDeps.overrideAttrs (_: {
              outputHash = "sha256-p3JFcsZsN/0ZNoOnC0fMrKnKNY0iCJpFlrrgDy4EtLs=";
            });
          });
        });

        tlang-pkg = tlang.packages.${system}.default.overrideAttrs (old:
          let
            jpmmls = builtins.filter (p: (p.pname or "") == "jpmml-statsmodels") old.buildInputs;
            oldJpmml = if jpmmls != [] then builtins.head jpmmls else null;
          in {
            buildInputs = map (pkg:
              if (pkg.pname or "") == "jpmml-statsmodels"
              then pkgs.jpmml-statsmodels
              else pkg
            ) old.buildInputs;
            installPhase =
              if oldJpmml != null then
                builtins.replaceStrings
                  [ oldJpmml.outPath ]
                  [ "${pkgs.jpmml-statsmodels}" ]
                  (builtins.unsafeDiscardStringContext old.installPhase)
              else
                old.installPhase;
          }
        );

        rpkgs = builtins.attrValues {
          inherit (pkgs.rPackages)
            dplyr
            ggplot2
            knitr
            purrr
            quarto
            reticulate
            rmarkdown
            withr
            ;
        };

        pyconf = builtins.attrValues {
          inherit (pkgs.python313Packages)
            beautifulsoup4
            lxml
            numpy
            pandas
            plotnine
            polars
            pyarrow
            requests
            scipy
            xlsx2csv
            ;
        };

        jlconf = pkgs.julia_110-bin.withPackages [
          "Arrow"
          "DataFrames"
          "LinearAlgebra"
          "SparseArrays"
        ];

        tex = pkgs.texliveSmall.withPackages (ps: with ps; [
          amsmath
          framed
          fvextra
          environ
          fontawesome5
          orcidlink
          lualatex-math
          pdfcol
          tcolorbox
          tikzfill
        ]);

        system_packages = builtins.attrValues {
          inherit (pkgs) R glibcLocalesUtf8 quarto python313;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          LOCALE_ARCHIVE = if system == "x86_64-linux" then "${pkgs.glibcLocalesUtf8}/lib/locale/locale-archive" else "";
          LANG = "en_US.UTF-8";
          LC_ALL = "en_US.UTF-8";
          LC_TIME = "en_US.UTF-8";
          LC_MONETARY = "en_US.UTF-8";
          LC_PAPER = "en_US.UTF-8";
          LC_MEASUREMENT = "en_US.UTF-8";

          RETICULATE_PYTHON = "${pkgs.python313}/bin/python3";

          buildInputs = pkgs.lib.flatten [
            tlang-pkg
            jlconf
            pyconf
            rpkgs
            tex
            system_packages
          ];
        };
      }
    );
}
