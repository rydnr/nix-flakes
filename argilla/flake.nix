{
  description = "Open-source data curation platform for LLMs";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    flit = {
      url = "github:rydnr/nix-flakes/flit-3.9.0?dir=flit";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixos { inherit system; };
        description = "Open-source data curation platform for LLMs";
        license = pkgs.lib.licenses.asl20;
        homepage = "https://www.argilla.io";
        maintainers = with pkgs.lib.maintainers; [ ];
        shellHook-for = package: ''
          export PNAME="${package.pname}";
          export PVERSION="${package.version}";
          export PS1="\[\033[01;32m\][\$PNAME-\$PVERSION]\[\033[00m\] \[\033[01;34m\]\W \$\[\033[00m\] "
        '';
        argilla-1_8_0-for = python:
          python.pkgs.buildPythonPackage rec {
            pname = "argilla";
            version = "1.8.0";
            src = python.pkgs.fetchPypi {
              inherit pname version;
              sha256 = "sha256-HXh6ZmZc9EAxTaxGdRFM/l80YroBm0nY59SHxKBF/FQ=";
            };
            format = "pyproject";

            nativeBuildInputs =
              [ flit.packages.${system}.flit-core python.pkgs.setuptools ];

            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };

      in rec {
        packages = {
          argilla-1_8_0-python37 = argilla-1_8_0-for pkgs.python37;
          argilla-1_8_0-python38 = argilla-1_8_0-for pkgs.python38;
          argilla-1_8_0-python39 = argilla-1_8_0-for pkgs.python39;
          argilla-1_8_0-python310 = argilla-1_8_0-for pkgs.python310;
          latest-python37 = packages.argilla-1_8_0-python37;
          latest-python38 = packages.argilla-1_8_0-python38;
          latest-python39 = packages.argilla-1_8_0-python39;
          latest-python310 = packages.argilla-1_8_0-python310;
          latest = packages.latest-python310;
          default = packages.latest;
        };
        defaultPackage = packages.default;
        devShells = {
          argilla-1_8_0-python37 = pkgs.mkShell {
            buildInputs = [ packages.argilla-1_8_0-python37 ];
            shellHook = shellHook-for packages.latest-python37;
          };
          argilla-1_8_0-python38 = pkgs.mkShell {
            buildInputs = [ packages.argilla-1_8_0-python38 ];
            shellHook = shellHook-for packages.latest-python38;
          };
          argilla-1_8_0-python39 = pkgs.mkShell {
            buildInputs = [ packages.argilla-1_8_0-python39 ];
            shellHook = shellHook-for packages.latest-python39;
          };
          argilla-1_8_0-python310 = pkgs.mkShell {
            buildInputs = [ packages.argilla-1_8_0-python310 ];
            shellHook = shellHook-for packages.latest-python310;
          };
          latest-python37 = devShells.argilla-1_8_0-python37;
          latest-python38 = devShells.argilla-1_8_0-python38;
          latest-python39 = devShells.argilla-1_8_0-python39;
          latest-python310 = devShells.argilla-1_8_0-python310;
          latest = devShells.latest-python310;
          default = devShells.latest;
        };
      });
}
