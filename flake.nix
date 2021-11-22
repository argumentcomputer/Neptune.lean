{
  description = "Neptune bindings for lean";

  inputs = {
    lean = {
      url = github:yatima-inc/lean4/acs/add-nix-ability-for-native-libs;
    };

    naersk = {
      url = github:nix-community/naersk;
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = github:nixos/nixpkgs/nixos-21.05;
    flake-utils = {
      url = github:numtide/flake-utils;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils = {
      url = github:yatima-inc/nix-utils;
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.naersk.follows = "naersk";
    };

    # neptune.url = github:yatima-inc/neptune/acs/add-flake-setup;
  };

  outputs = { self, lean, flake-utils, utils, nixpkgs, naersk }:
    let
      supportedSystems = [
        # "aarch64-linux"
        # "aarch64-darwin"
        "i686-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    in
    flake-utils.lib.eachSystem supportedSystems (system:
      let
        leanPkgs = lean.packages.${system};
        pkgs = nixpkgs.legacyPackages.${system};
        name = "Neptune";
        debug = false;
        lib = utils.lib.${system};
        inherit (lib) buildCLib buildRustProject makeBareDerivation;
        bindings-with-include = makeBareDerivation {
          inherit system pkgs;
          buildInputs = with pkgs; [ coreutils-full ];
          name = "bindings-with-include";
          src = ./bindings;
          buildCommand = ''
            mkdir -p $out/include
            cp -r ${leanPkgs.lean-bin-tools-unwrapped}/include $out
            cp -r $src/* $out
          '';
        };
        neptune-rs-bindings = (
          let lib = buildRustProject {
            src = bindings-with-include;
            copyTarget = true;
            buildInputs = with pkgs; [ libclc ];
          };
          in lib // {
            __toString = d: "${d}/lib";
            libPath = "${lib}/lib/liblean_neptune_bindings.so";
            linkName = "liblean_neptune_bindings";
          }
        );
        BinaryTools = leanPkgs.buildLeanPackage {
          inherit debug;
          src = ./src;
          name = "BinaryTools";
        };
        project = leanPkgs.buildLeanPackage {
          inherit name debug;
          src = ./src;
          deps = [ BinaryTools ];
          nativeSharedLibs = [ neptune-rs-bindings ];
        };
        tests = leanPkgs.buildLeanPackage {
          inherit debug;
          name = "Tests";
          src = ./tests;
          deps = [ project ];
        };
      in
      {
        inherit project tests;
        packages = {
          inherit neptune-rs-bindings BinaryTools;
          inherit (project) modRoot sharedLib staticLib;
          tests = tests.executable;
        };

        apps.lean = flake-utils.lib.mkApp {
          drv = leanPkgs.lean;
        };

        checks.tests = tests;

        defaultPackage = project.sharedLib;
        devShell = pkgs.mkShell {
          buildInputs = [ leanPkgs.lean pkgs.glibc ];
          LEAN_PATH = "${leanPkgs.Lean.modRoot}";
          CPATH = "${leanPkgs.Lean.modRoot}";
        };
      });
}
