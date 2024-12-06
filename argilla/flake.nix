{
  description = "Nix flake for argilla";

  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    flit = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:rydnr/nix-flakes/flit-3.9.0.2?dir=flit";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/24.05";
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        description = "Open-source data curation platform for LLMs";
        license = pkgs.lib.licenses.asl20;
        homepage = "https://www.argilla.io";
        maintainers = with pkgs.lib.maintainers; [ ];
        shellHook-for = package: ''
          export PNAME="${package.pname}";
          export PVERSION="${package.version}";
          export PS1="\[\033[01;32m\][\$PNAME-\$PVERSION]\[\033[00m\] \[\033[01;34m\]\W \$\[\033[00m\] "
        '';
        argilla-for = { flit-core, python }:
          python.pkgs.buildPythonPackage rec {
            pname = "argilla";
            version = "2.4.0";
            src = python.pkgs.fetchPypi {
              inherit pname version;
              sha256 = "sha256-E+MdHaqpA24ydo8bUnsdvwjOvzZdHg+a9lQNtsu7ftQ=";
            };
            format = "pyproject";

            nativeBuildInputs =
              [ flit-core python.pkgs.setuptools ];

            propagatedBuildInputs = with python.pkgs; [ backoff deprecated httpx monotonic numpy pandas pydantic tqdm typer wrapt ];
            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };

      in rec {
        defaultPackage = packages.default;
        devShells = {
          argilla-python310 = pkgs.mkShell {
            buildInputs = [ packages.argilla-python310 ];
            shellHook = shellHook-for packages.latest-python310;
          };
          argilla-python311 = pkgs.mkShell {
            buildInputs = [ packages.argilla-python311 ];
            shellHook = shellHook-for packages.latest-python311;
          };
          argilla-python312 = pkgs.mkShell {
            buildInputs = [ packages.argilla-python312 ];
            shellHook = shellHook-for packages.latest-python312;
          };
          argilla-python313 = pkgs.mkShell {
            buildInputs = [ packages.argilla-python313 ];
            shellHook = shellHook-for packages.latest-python313;
          };
          default = devShells.argilla-python312;
        };
        packages = {
          argilla-python310 = argilla-for { flit-core = flit.packages.${system}.flit-core-python310; python = pkgs.python310; };
          argilla-python311 = argilla-for { flit-core = flit.packages.${system}.flit-core-python311; python = pkgs.python311; };
          argilla-python312 = argilla-for { flit-core = flit.packages.${system}.flit-core-python312; python = pkgs.python312; };
          argilla-python313 = argilla-for { flit-core = flit.packages.${system}.flit-core-python313; python = pkgs.python313; };
          default = packages.argilla-python312;
        };
      });
}
