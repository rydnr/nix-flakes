{
  description = "A Nix flake for anthropic 0.2.6 Python package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python3;
        pythonPackages = python.pkgs;
      in rec {
        packages = {
          anthropic-0.2.6 = (import ./anthropic-0.2.6.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          anthropic = packages.anthropic-0.2.6;
          default = packages.anthropic;
          meta = with lib; {
            description = ''
# Anthropic Python SDK

This python repo provides access to Anthropic's safety-first language model APIs.

For more information on our APIs, please check out [Anthropic's documentation](https://console.anthropic.com/docs).

## How to use

```
pip install .
export ANTHROPIC_API_KEY=<insert token here>
python examples/basic_sync.py
python examples/basic_stream.py
python examples/count_tokens.py
```

'';
            license = licenses.mit;
            homepage = "None";
            maintainers = with maintainers; [ ];
          };
        };
        defaultPackage = packages.default;
        devShell = pkgs.mkShell {
          buildInputs = with pkgs.python3Packages; [ packages.default ];
        };
        shell = flake-utils.lib.mkShell {
          packages = system: [ self.packages.${system}.default ];
        };
      });
}
