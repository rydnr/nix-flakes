{
  description = "Flake for nixpkgs' dbus-next";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/24.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixos { inherit system; };
      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          default = dbus-next-python312;
          dbus-next-python39 = shared.devShell-for {
            banner = "${
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python39
              }/bin/banner.sh";
            extra-namespaces = "";
            nixpkgs-release = nixpkgsRelease;
            package = packages.dbus-next-python39;
            python = pkgs.python39;
            inherit archRole layer org pkgs repo space;
          };
          dbus-next-python310 = shared.devShell-for {
            banner = "${
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python310
              }/bin/banner.sh";
            extra-namespaces = "";
            nixpkgs-release = nixpkgsRelease;
            package = packages.dbus-next-python310;
            python = pkgs.python310;
            inherit archRole layer org pkgs repo space;
          };
          dbus-next-python311 = shared.devShell-for {
            banner = "${
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python311
              }/bin/banner.sh";
            extra-namespaces = "";
            nixpkgs-release = nixpkgsRelease;
            package = packages.dbus-next-python311;
            python = pkgs.python311;
            inherit archRole layer org pkgs repo space;
          };
          dbus-next-python312 = shared.devShell-for {
            banner = "${
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python312
              }/bin/banner.sh";
            extra-namespaces = "";
            nixpkgs-release = nixpkgsRelease;
            package = packages.dbus-next-python312;
            python = pkgs.python312;
            inherit archRole layer org pkgs repo space;
          };
          dbus-next-python313 = shared.devShell-for {
            banner = "${
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python313
              }/bin/banner.sh";
            extra-namespaces = "";
            nixpkgs-release = nixpkgsRelease;
            package = packages.dbus-next-python313;
            python = pkgs.python313;
            inherit archRole layer org pkgs repo space;
          };
        };
        packages = rec {
          default = dbus-next-python312;
          dbus-next-python39 = pkgs.python39.pkgs.dbus-next;
          dbus-next-python310 = pkgs.python310.pkgs.dbus-next;
          dbus-next-python311 = pkgs.python311.pkgs.dbus-next;
          dbus-next-python312 = pkgs.python312.pkgs.dbus-next;
          dbus-next-python313 = pkgs.python313.pkgs.dbus-next;
        };
      });
}
