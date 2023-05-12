{
  description = "A Nix flake for jina-hubble-sdk 0.35.0 Python package";

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
          jina-hubble-sdk-0.35.0 = (import ./jina-hubble-sdk-0.35.0.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          jina-hubble-sdk = packages.jina-hubble-sdk-0.35.0;
          default = packages.jina-hubble-sdk;
          meta = with lib; {
            description = ''
# jina-hubble-sdk

<img alt="PyPI" src="https://img.shields.io/pypi/v/jina-hubble-sdk">
<img src="https://codecov.io/gh/jina-ai/jina-hubble-sdk/branch/main/graph/badge.svg?token=Sttz9HTmDq"/>


## Install

```shell
pip install jina-hubble-sdk
```

```shell
conda install jina-hubble-sdk -c conda-forge
```

## Core functionality

* Python API and CLI.
* Authentication and token management.
* Artifact management.

## [Documentation](https://docs.jina.ai/jina-ai-cloud/login/)


<!-- start support-pitch -->
## Support

- Join our [Slack community](https://slack.jina.ai) and chat with other Jina community members about ideas.
- Join our [Engineering All Hands](https://youtube.com/playlist?list=PL3UBBWOUVhFYRUa_gpYYKBqEAkO4sxmne) meet-up to discuss your use case and learn Jina's new features.
    - **When?** The second Tuesday of every month
    - **Where?**
      Zoom ([see our public events calendar](https://calendar.google.com/calendar/embed?src=c_1t5ogfp2d45v8fit981j08mcm4%40group.calendar.google.com&ctz=Europe%2FBerlin)/[.ical](https://calendar.google.com/calendar/ical/c_1t5ogfp2d45v8fit981j08mcm4%40group.calendar.google.com/public/basic.ics))
      and [live stream on YouTube](https://youtube.com/c/jina-ai)
- Subscribe to the latest video tutorials on our [YouTube channel](https://youtube.com/c/jina-ai)

## Join Us

Hubble Python SDK is backed by [Jina AI](https://jina.ai) and licensed under [Apache-2.0](./LICENSE). [We are actively hiring](https://jobs.jina.ai) AI engineers, solution engineers to build the next neural search ecosystem in opensource.

<!-- end support-pitch -->

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
