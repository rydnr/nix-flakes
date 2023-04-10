{ lib, rustPlatform, cargo2nix, ... }:

let
  rustLib = rustPlatform.rustLib;
  rustDeps = (import ./Cargo.nix) {
    inherit (cargo2nix)
      rustPackages buildRustPackages hostPlatform hostPlatformCpu
      hostPlatformFeatures target codegenOpts profileOpts rustcLinkFlags
      rustcBuildFlags mkRustCrate rustLib lib;
    workspaceSrc = ./.;
  };
  bstrDrv = rustDeps."unknown".bstr."1.4.0" { };
in rustPlatform.buildRustPackage rec {
  pname = "bstr";
  version = "1.4.0";

  src = bstrDrv.src;
  cargoSha256 = "";

  nativeBuildInputs = [ rustPlatform.rust.cargo ];

  meta = with lib; {
    description = "A byte string library";
    homepage = "https://github.com/BurntSushi/bstr";
    license = licenses.apsl20;
    maintainers = with maintainers; [ ];
  };
}
