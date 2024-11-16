{
  description = "Flake for nixpkgs' dbus-next.";

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
        packages = rec {
          default = dbus-next-python312;
          dbus-next-python38 = pkgs.python38.pkgs.dbus-next;
          dbus-next-python39 = pkgs.python39.pkgs.dbus-next;
          dbus-next-python310 = pkgs.python310.pkgs.dbus-next;
          dbus-next-python311 = pkgs.python311.pkgs.dbus-next;
          dbus-next-python312 = pkgs.python312.pkgs.dbus-next;
        };
      });
}
