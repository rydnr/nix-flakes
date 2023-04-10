# This file was @generated by cargo2nix 0.11.0.
# It is not intended to be manually edited.

args@{
  release ? true,
  rootFeatures ? [
    "tiktoken/default"
  ],
  rustPackages,
  buildRustPackages,
  hostPlatform,
  hostPlatformCpu ? null,
  hostPlatformFeatures ? [],
  target ? null,
  codegenOpts ? null,
  profileOpts ? null,
  rustcLinkFlags ? null,
  rustcBuildFlags ? null,
  mkRustCrate,
  rustLib,
  lib,
  workspaceSrc,
}:
let
  workspaceSrc = if args.workspaceSrc == null then ./. else args.workspaceSrc;
in let
  inherit (rustLib) fetchCratesIo fetchCrateLocal fetchCrateGit fetchCrateAlternativeRegistry expandFeatures decideProfile genDrvsByProfile;
  profilesByName = {
    release = builtins.fromTOML "incremental = true\n";
  };
  rootFeatures' = expandFeatures rootFeatures;
  overridableMkRustCrate = f:
    let
      drvs = genDrvsByProfile profilesByName ({ profile, profileName }: mkRustCrate ({ inherit release profile hostPlatformCpu hostPlatformFeatures target profileOpts codegenOpts rustcLinkFlags rustcBuildFlags; } // (f profileName)));
    in { compileMode ? null, profileName ? decideProfile compileMode release }:
      let drv = drvs.${profileName}; in if compileMode == null then drv else drv.override { inherit compileMode; };
in
{
  cargo2nixVersion = "0.11.0";
  workspace = {
    tiktoken = rustPackages.unknown.tiktoken."0.3.3";
  };
  "registry+https://github.com/rust-lang/crates.io-index".aho-corasick."0.7.20" = overridableMkRustCrate (profileName: rec {
    name = "aho-corasick";
    version = "0.7.20";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "cc936419f96fa211c1b9166887b38e5e40b19958e5b895be7c1f93adec7071ac"; };
    features = builtins.concatLists [
      [ "default" ]
      [ "std" ]
    ];
    dependencies = {
      memchr = rustPackages."registry+https://github.com/rust-lang/crates.io-index".memchr."2.5.0" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".autocfg."1.1.0" = overridableMkRustCrate (profileName: rec {
    name = "autocfg";
    version = "1.1.0";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "d468802bab17cbc0cc575e9b053f41e72aa36bfa6b7f55e3529ffa43161b97fa"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".bit-set."0.5.3" = overridableMkRustCrate (profileName: rec {
    name = "bit-set";
    version = "0.5.3";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "0700ddab506f33b20a03b13996eccd309a48e5ff77d0d95926aa0210fb4e95f1"; };
    features = builtins.concatLists [
      [ "default" ]
      [ "std" ]
    ];
    dependencies = {
      bit_vec = rustPackages."registry+https://github.com/rust-lang/crates.io-index".bit-vec."0.6.3" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".bit-vec."0.6.3" = overridableMkRustCrate (profileName: rec {
    name = "bit-vec";
    version = "0.6.3";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "349f9b6a179ed607305526ca489b34ad0a41aed5f7980fa90eb03160b69598fb"; };
    features = builtins.concatLists [
      [ "std" ]
    ];
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".bitflags."1.3.2" = overridableMkRustCrate (profileName: rec {
    name = "bitflags";
    version = "1.3.2";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "bef38d45163c2f1dde094a7dfd33ccf595c92905c8f8f4fdc18d06fb1037718a"; };
    features = builtins.concatLists [
      [ "default" ]
    ];
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".bstr."1.4.0" = overridableMkRustCrate (profileName: rec {
    name = "bstr";
    version = "1.4.0";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "c3d4260bcc2e8fc9df1eac4919a720effeb63a3f0952f5bf4944adfa18897f09"; };
    features = builtins.concatLists [
      [ "alloc" ]
      [ "default" ]
      [ "std" ]
      [ "unicode" ]
    ];
    dependencies = {
      memchr = rustPackages."registry+https://github.com/rust-lang/crates.io-index".memchr."2.5.0" { inherit profileName; };
      once_cell = rustPackages."registry+https://github.com/rust-lang/crates.io-index".once_cell."1.17.1" { inherit profileName; };
      regex_automata = rustPackages."registry+https://github.com/rust-lang/crates.io-index".regex-automata."0.1.10" { inherit profileName; };
      serde = rustPackages."registry+https://github.com/rust-lang/crates.io-index".serde."1.0.159" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".cfg-if."1.0.0" = overridableMkRustCrate (profileName: rec {
    name = "cfg-if";
    version = "1.0.0";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "baf1de4339761588bc0619e3cbc0120ee582ebb74b53b4efbf79117bd2da40fd"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".fancy-regex."0.10.0" = overridableMkRustCrate (profileName: rec {
    name = "fancy-regex";
    version = "0.10.0";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "0678ab2d46fa5195aaf59ad034c083d351377d4af57f3e073c074d0da3e3c766"; };
    features = builtins.concatLists [
      [ "default" ]
      [ "perf" ]
      [ "unicode" ]
    ];
    dependencies = {
      bit_set = rustPackages."registry+https://github.com/rust-lang/crates.io-index".bit-set."0.5.3" { inherit profileName; };
      regex = rustPackages."registry+https://github.com/rust-lang/crates.io-index".regex."1.7.3" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".indoc."1.0.9" = overridableMkRustCrate (profileName: rec {
    name = "indoc";
    version = "1.0.9";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "bfa799dd5ed20a7e349f3b4639aa80d74549c81716d9ec4f994c9b5815598306"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".libc."0.2.141" = overridableMkRustCrate (profileName: rec {
    name = "libc";
    version = "0.2.141";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "3304a64d199bb964be99741b7a14d26972741915b3649639149b2479bb46f4b5"; };
    features = builtins.concatLists [
      [ "default" ]
      [ "std" ]
    ];
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".lock_api."0.4.9" = overridableMkRustCrate (profileName: rec {
    name = "lock_api";
    version = "0.4.9";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "435011366fe56583b16cf956f9df0095b405b82d76425bc8981c0e22e60ec4df"; };
    dependencies = {
      scopeguard = rustPackages."registry+https://github.com/rust-lang/crates.io-index".scopeguard."1.1.0" { inherit profileName; };
    };
    buildDependencies = {
      autocfg = buildRustPackages."registry+https://github.com/rust-lang/crates.io-index".autocfg."1.1.0" { profileName = "__noProfile"; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".memchr."2.5.0" = overridableMkRustCrate (profileName: rec {
    name = "memchr";
    version = "2.5.0";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "2dffe52ecf27772e601905b7522cb4ef790d2cc203488bbd0e2fe85fcb74566d"; };
    features = builtins.concatLists [
      [ "default" ]
      [ "std" ]
    ];
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".memoffset."0.6.5" = overridableMkRustCrate (profileName: rec {
    name = "memoffset";
    version = "0.6.5";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "5aa361d4faea93603064a027415f07bd8e1d5c88c9fbf68bf56a285428fd79ce"; };
    features = builtins.concatLists [
      [ "default" ]
    ];
    buildDependencies = {
      autocfg = buildRustPackages."registry+https://github.com/rust-lang/crates.io-index".autocfg."1.1.0" { profileName = "__noProfile"; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".once_cell."1.17.1" = overridableMkRustCrate (profileName: rec {
    name = "once_cell";
    version = "1.17.1";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "b7e5500299e16ebb147ae15a00a942af264cf3688f47923b8fc2cd5858f23ad3"; };
    features = builtins.concatLists [
      [ "alloc" ]
      [ "default" ]
      [ "race" ]
      [ "std" ]
    ];
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".parking_lot."0.12.1" = overridableMkRustCrate (profileName: rec {
    name = "parking_lot";
    version = "0.12.1";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "3742b2c103b9f06bc9fff0a37ff4912935851bee6d36f3c02bcc755bcfec228f"; };
    features = builtins.concatLists [
      [ "default" ]
    ];
    dependencies = {
      lock_api = rustPackages."registry+https://github.com/rust-lang/crates.io-index".lock_api."0.4.9" { inherit profileName; };
      parking_lot_core = rustPackages."registry+https://github.com/rust-lang/crates.io-index".parking_lot_core."0.9.7" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".parking_lot_core."0.9.7" = overridableMkRustCrate (profileName: rec {
    name = "parking_lot_core";
    version = "0.9.7";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "9069cbb9f99e3a5083476ccb29ceb1de18b9118cafa53e90c9551235de2b9521"; };
    dependencies = {
      cfg_if = rustPackages."registry+https://github.com/rust-lang/crates.io-index".cfg-if."1.0.0" { inherit profileName; };
      ${ if hostPlatform.isUnix then "libc" else null } = rustPackages."registry+https://github.com/rust-lang/crates.io-index".libc."0.2.141" { inherit profileName; };
      ${ if hostPlatform.parsed.kernel.name == "redox" then "syscall" else null } = rustPackages."registry+https://github.com/rust-lang/crates.io-index".redox_syscall."0.2.16" { inherit profileName; };
      smallvec = rustPackages."registry+https://github.com/rust-lang/crates.io-index".smallvec."1.10.0" { inherit profileName; };
      ${ if hostPlatform.isWindows then "windows_sys" else null } = rustPackages."registry+https://github.com/rust-lang/crates.io-index".windows-sys."0.45.0" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".proc-macro2."1.0.56" = overridableMkRustCrate (profileName: rec {
    name = "proc-macro2";
    version = "1.0.56";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "2b63bdb0cd06f1f4dedf69b254734f9b45af66e4a031e42a7480257d9898b435"; };
    features = builtins.concatLists [
      [ "proc-macro" ]
    ];
    dependencies = {
      unicode_ident = rustPackages."registry+https://github.com/rust-lang/crates.io-index".unicode-ident."1.0.8" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".pyo3."0.17.3" = overridableMkRustCrate (profileName: rec {
    name = "pyo3";
    version = "0.17.3";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "268be0c73583c183f2b14052337465768c07726936a260f480f0857cb95ba543"; };
    features = builtins.concatLists [
      [ "default" ]
      [ "extension-module" ]
      [ "indoc" ]
      [ "macros" ]
      [ "pyo3-macros" ]
      [ "unindent" ]
    ];
    dependencies = {
      cfg_if = rustPackages."registry+https://github.com/rust-lang/crates.io-index".cfg-if."1.0.0" { inherit profileName; };
      indoc = buildRustPackages."registry+https://github.com/rust-lang/crates.io-index".indoc."1.0.9" { profileName = "__noProfile"; };
      libc = rustPackages."registry+https://github.com/rust-lang/crates.io-index".libc."0.2.141" { inherit profileName; };
      memoffset = rustPackages."registry+https://github.com/rust-lang/crates.io-index".memoffset."0.6.5" { inherit profileName; };
      parking_lot = rustPackages."registry+https://github.com/rust-lang/crates.io-index".parking_lot."0.12.1" { inherit profileName; };
      pyo3_ffi = rustPackages."registry+https://github.com/rust-lang/crates.io-index".pyo3-ffi."0.17.3" { inherit profileName; };
      pyo3_macros = buildRustPackages."registry+https://github.com/rust-lang/crates.io-index".pyo3-macros."0.17.3" { profileName = "__noProfile"; };
      unindent = rustPackages."registry+https://github.com/rust-lang/crates.io-index".unindent."0.1.11" { inherit profileName; };
    };
    buildDependencies = {
      pyo3_build_config = buildRustPackages."registry+https://github.com/rust-lang/crates.io-index".pyo3-build-config."0.17.3" { profileName = "__noProfile"; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".pyo3-build-config."0.17.3" = overridableMkRustCrate (profileName: rec {
    name = "pyo3-build-config";
    version = "0.17.3";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "28fcd1e73f06ec85bf3280c48c67e731d8290ad3d730f8be9dc07946923005c8"; };
    features = builtins.concatLists [
      [ "default" ]
      [ "extension-module" ]
      [ "resolve-config" ]
    ];
    dependencies = {
      once_cell = rustPackages."registry+https://github.com/rust-lang/crates.io-index".once_cell."1.17.1" { inherit profileName; };
      target_lexicon = rustPackages."registry+https://github.com/rust-lang/crates.io-index".target-lexicon."0.12.6" { inherit profileName; };
    };
    buildDependencies = {
      target_lexicon = buildRustPackages."registry+https://github.com/rust-lang/crates.io-index".target-lexicon."0.12.6" { profileName = "__noProfile"; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".pyo3-ffi."0.17.3" = overridableMkRustCrate (profileName: rec {
    name = "pyo3-ffi";
    version = "0.17.3";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "0f6cb136e222e49115b3c51c32792886defbfb0adead26a688142b346a0b9ffc"; };
    features = builtins.concatLists [
      [ "default" ]
      [ "extension-module" ]
    ];
    dependencies = {
      libc = rustPackages."registry+https://github.com/rust-lang/crates.io-index".libc."0.2.141" { inherit profileName; };
    };
    buildDependencies = {
      pyo3_build_config = buildRustPackages."registry+https://github.com/rust-lang/crates.io-index".pyo3-build-config."0.17.3" { profileName = "__noProfile"; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".pyo3-macros."0.17.3" = overridableMkRustCrate (profileName: rec {
    name = "pyo3-macros";
    version = "0.17.3";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "94144a1266e236b1c932682136dc35a9dee8d3589728f68130c7c3861ef96b28"; };
    dependencies = {
      proc_macro2 = rustPackages."registry+https://github.com/rust-lang/crates.io-index".proc-macro2."1.0.56" { inherit profileName; };
      pyo3_macros_backend = rustPackages."registry+https://github.com/rust-lang/crates.io-index".pyo3-macros-backend."0.17.3" { inherit profileName; };
      quote = rustPackages."registry+https://github.com/rust-lang/crates.io-index".quote."1.0.26" { inherit profileName; };
      syn = rustPackages."registry+https://github.com/rust-lang/crates.io-index".syn."1.0.109" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".pyo3-macros-backend."0.17.3" = overridableMkRustCrate (profileName: rec {
    name = "pyo3-macros-backend";
    version = "0.17.3";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "c8df9be978a2d2f0cdebabb03206ed73b11314701a5bfe71b0d753b81997777f"; };
    dependencies = {
      proc_macro2 = rustPackages."registry+https://github.com/rust-lang/crates.io-index".proc-macro2."1.0.56" { inherit profileName; };
      quote = rustPackages."registry+https://github.com/rust-lang/crates.io-index".quote."1.0.26" { inherit profileName; };
      syn = rustPackages."registry+https://github.com/rust-lang/crates.io-index".syn."1.0.109" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".quote."1.0.26" = overridableMkRustCrate (profileName: rec {
    name = "quote";
    version = "1.0.26";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "4424af4bf778aae2051a77b60283332f386554255d722233d09fbfc7e30da2fc"; };
    features = builtins.concatLists [
      [ "default" ]
      [ "proc-macro" ]
    ];
    dependencies = {
      proc_macro2 = rustPackages."registry+https://github.com/rust-lang/crates.io-index".proc-macro2."1.0.56" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".redox_syscall."0.2.16" = overridableMkRustCrate (profileName: rec {
    name = "redox_syscall";
    version = "0.2.16";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "fb5a58c1855b4b6819d59012155603f0b22ad30cad752600aadfcb695265519a"; };
    dependencies = {
      bitflags = rustPackages."registry+https://github.com/rust-lang/crates.io-index".bitflags."1.3.2" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".regex."1.7.3" = overridableMkRustCrate (profileName: rec {
    name = "regex";
    version = "1.7.3";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "8b1f693b24f6ac912f4893ef08244d70b6067480d2f1a46e950c9691e6749d1d"; };
    features = builtins.concatLists [
      [ "aho-corasick" ]
      [ "default" ]
      [ "memchr" ]
      [ "perf" ]
      [ "perf-cache" ]
      [ "perf-dfa" ]
      [ "perf-inline" ]
      [ "perf-literal" ]
      [ "std" ]
      [ "unicode" ]
      [ "unicode-age" ]
      [ "unicode-bool" ]
      [ "unicode-case" ]
      [ "unicode-gencat" ]
      [ "unicode-perl" ]
      [ "unicode-script" ]
      [ "unicode-segment" ]
    ];
    dependencies = {
      aho_corasick = rustPackages."registry+https://github.com/rust-lang/crates.io-index".aho-corasick."0.7.20" { inherit profileName; };
      memchr = rustPackages."registry+https://github.com/rust-lang/crates.io-index".memchr."2.5.0" { inherit profileName; };
      regex_syntax = rustPackages."registry+https://github.com/rust-lang/crates.io-index".regex-syntax."0.6.29" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".regex-automata."0.1.10" = overridableMkRustCrate (profileName: rec {
    name = "regex-automata";
    version = "0.1.10";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "6c230d73fb8d8c1b9c0b3135c5142a8acee3a0558fb8db5cf1cb65f8d7862132"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".regex-syntax."0.6.29" = overridableMkRustCrate (profileName: rec {
    name = "regex-syntax";
    version = "0.6.29";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "f162c6dd7b008981e4d40210aca20b4bd0f9b60ca9271061b07f78537722f2e1"; };
    features = builtins.concatLists [
      [ "default" ]
      [ "unicode" ]
      [ "unicode-age" ]
      [ "unicode-bool" ]
      [ "unicode-case" ]
      [ "unicode-gencat" ]
      [ "unicode-perl" ]
      [ "unicode-script" ]
      [ "unicode-segment" ]
    ];
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".rustc-hash."1.1.0" = overridableMkRustCrate (profileName: rec {
    name = "rustc-hash";
    version = "1.1.0";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "08d43f7aa6b08d49f382cde6a7982047c3426db949b1424bc4b7ec9ae12c6ce2"; };
    features = builtins.concatLists [
      [ "default" ]
      [ "std" ]
    ];
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".scopeguard."1.1.0" = overridableMkRustCrate (profileName: rec {
    name = "scopeguard";
    version = "1.1.0";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "d29ab0c6d3fc0ee92fe66e2d99f700eab17a8d57d1c1d3b748380fb20baa78cd"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".serde."1.0.159" = overridableMkRustCrate (profileName: rec {
    name = "serde";
    version = "1.0.159";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "3c04e8343c3daeec41f58990b9d77068df31209f2af111e059e9fe9646693065"; };
    features = builtins.concatLists [
      [ "alloc" ]
      [ "std" ]
    ];
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".smallvec."1.10.0" = overridableMkRustCrate (profileName: rec {
    name = "smallvec";
    version = "1.10.0";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "a507befe795404456341dfab10cef66ead4c041f62b8b11bbb92bffe5d0953e0"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".syn."1.0.109" = overridableMkRustCrate (profileName: rec {
    name = "syn";
    version = "1.0.109";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "72b64191b275b66ffe2469e8af2c1cfe3bafa67b529ead792a6d0160888b4237"; };
    features = builtins.concatLists [
      [ "clone-impls" ]
      [ "default" ]
      [ "derive" ]
      [ "extra-traits" ]
      [ "full" ]
      [ "parsing" ]
      [ "printing" ]
      [ "proc-macro" ]
      [ "quote" ]
    ];
    dependencies = {
      proc_macro2 = rustPackages."registry+https://github.com/rust-lang/crates.io-index".proc-macro2."1.0.56" { inherit profileName; };
      quote = rustPackages."registry+https://github.com/rust-lang/crates.io-index".quote."1.0.26" { inherit profileName; };
      unicode_ident = rustPackages."registry+https://github.com/rust-lang/crates.io-index".unicode-ident."1.0.8" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".target-lexicon."0.12.6" = overridableMkRustCrate (profileName: rec {
    name = "target-lexicon";
    version = "0.12.6";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "8ae9980cab1db3fceee2f6c6f643d5d8de2997c58ee8d25fb0cc8a9e9e7348e5"; };
    features = builtins.concatLists [
      [ "default" ]
    ];
  });
  
  "unknown".tiktoken."0.3.3" = overridableMkRustCrate (profileName: rec {
    name = "tiktoken";
    version = "0.3.3";
    registry = "unknown";
    src = fetchCrateLocal workspaceSrc;
    dependencies = {
      bstr = rustPackages."registry+https://github.com/rust-lang/crates.io-index".bstr."1.4.0" { inherit profileName; };
      fancy_regex = rustPackages."registry+https://github.com/rust-lang/crates.io-index".fancy-regex."0.10.0" { inherit profileName; };
      pyo3 = rustPackages."registry+https://github.com/rust-lang/crates.io-index".pyo3."0.17.3" { inherit profileName; };
      regex = rustPackages."registry+https://github.com/rust-lang/crates.io-index".regex."1.7.3" { inherit profileName; };
      rustc_hash = rustPackages."registry+https://github.com/rust-lang/crates.io-index".rustc-hash."1.1.0" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".unicode-ident."1.0.8" = overridableMkRustCrate (profileName: rec {
    name = "unicode-ident";
    version = "1.0.8";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "e5464a87b239f13a63a501f2701565754bae92d243d4bb7eb12f6d57d2269bf4"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".unindent."0.1.11" = overridableMkRustCrate (profileName: rec {
    name = "unindent";
    version = "0.1.11";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "e1766d682d402817b5ac4490b3c3002d91dfa0d22812f341609f97b08757359c"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".windows-sys."0.45.0" = overridableMkRustCrate (profileName: rec {
    name = "windows-sys";
    version = "0.45.0";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "75283be5efb2831d37ea142365f009c02ec203cd29a3ebecbc093d52315b66d0"; };
    features = builtins.concatLists [
      [ "Win32" ]
      [ "Win32_Foundation" ]
      [ "Win32_System" ]
      [ "Win32_System_LibraryLoader" ]
      [ "Win32_System_SystemServices" ]
      [ "Win32_System_WindowsProgramming" ]
      [ "default" ]
    ];
    dependencies = {
      windows_targets = rustPackages."registry+https://github.com/rust-lang/crates.io-index".windows-targets."0.42.2" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".windows-targets."0.42.2" = overridableMkRustCrate (profileName: rec {
    name = "windows-targets";
    version = "0.42.2";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "8e5180c00cd44c9b1c88adb3693291f1cd93605ded80c250a75d472756b4d071"; };
    dependencies = {
      ${ if hostPlatform.config == "aarch64-pc-windows-gnullvm" then "windows_aarch64_gnullvm" else null } = rustPackages."registry+https://github.com/rust-lang/crates.io-index".windows_aarch64_gnullvm."0.42.2" { inherit profileName; };
      ${ if hostPlatform.config == "aarch64-pc-windows-msvc" || hostPlatform.config == "aarch64-uwp-windows-msvc" then "windows_aarch64_msvc" else null } = rustPackages."registry+https://github.com/rust-lang/crates.io-index".windows_aarch64_msvc."0.42.2" { inherit profileName; };
      ${ if hostPlatform.config == "i686-pc-windows-gnu" || hostPlatform.config == "i686-uwp-windows-gnu" then "windows_i686_gnu" else null } = rustPackages."registry+https://github.com/rust-lang/crates.io-index".windows_i686_gnu."0.42.2" { inherit profileName; };
      ${ if hostPlatform.config == "i686-pc-windows-msvc" || hostPlatform.config == "i686-uwp-windows-msvc" then "windows_i686_msvc" else null } = rustPackages."registry+https://github.com/rust-lang/crates.io-index".windows_i686_msvc."0.42.2" { inherit profileName; };
      ${ if hostPlatform.config == "x86_64-pc-windows-gnu" || hostPlatform.config == "x86_64-uwp-windows-gnu" then "windows_x86_64_gnu" else null } = rustPackages."registry+https://github.com/rust-lang/crates.io-index".windows_x86_64_gnu."0.42.2" { inherit profileName; };
      ${ if hostPlatform.config == "x86_64-pc-windows-gnullvm" then "windows_x86_64_gnullvm" else null } = rustPackages."registry+https://github.com/rust-lang/crates.io-index".windows_x86_64_gnullvm."0.42.2" { inherit profileName; };
      ${ if hostPlatform.config == "x86_64-pc-windows-msvc" || hostPlatform.config == "x86_64-uwp-windows-msvc" then "windows_x86_64_msvc" else null } = rustPackages."registry+https://github.com/rust-lang/crates.io-index".windows_x86_64_msvc."0.42.2" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".windows_aarch64_gnullvm."0.42.2" = overridableMkRustCrate (profileName: rec {
    name = "windows_aarch64_gnullvm";
    version = "0.42.2";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "597a5118570b68bc08d8d59125332c54f1ba9d9adeedeef5b99b02ba2b0698f8"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".windows_aarch64_msvc."0.42.2" = overridableMkRustCrate (profileName: rec {
    name = "windows_aarch64_msvc";
    version = "0.42.2";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "e08e8864a60f06ef0d0ff4ba04124db8b0fb3be5776a5cd47641e942e58c4d43"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".windows_i686_gnu."0.42.2" = overridableMkRustCrate (profileName: rec {
    name = "windows_i686_gnu";
    version = "0.42.2";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "c61d927d8da41da96a81f029489353e68739737d3beca43145c8afec9a31a84f"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".windows_i686_msvc."0.42.2" = overridableMkRustCrate (profileName: rec {
    name = "windows_i686_msvc";
    version = "0.42.2";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "44d840b6ec649f480a41c8d80f9c65108b92d89345dd94027bfe06ac444d1060"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".windows_x86_64_gnu."0.42.2" = overridableMkRustCrate (profileName: rec {
    name = "windows_x86_64_gnu";
    version = "0.42.2";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "8de912b8b8feb55c064867cf047dda097f92d51efad5b491dfb98f6bbb70cb36"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".windows_x86_64_gnullvm."0.42.2" = overridableMkRustCrate (profileName: rec {
    name = "windows_x86_64_gnullvm";
    version = "0.42.2";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "26d41b46a36d453748aedef1486d5c7a85db22e56aff34643984ea85514e94a3"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".windows_x86_64_msvc."0.42.2" = overridableMkRustCrate (profileName: rec {
    name = "windows_x86_64_msvc";
    version = "0.42.2";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "9aec5da331524158c6d1a4ac0ab1541149c0b9505fde06423b02f5ef0106b9f0"; };
  });
  
}
