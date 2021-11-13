{
  description = "Neptune bindings for lean";

  inputs = {
    lean = {
      url = github:yatima-inc/lean4/acs/add-nix-ability-for-native-libs;
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
    };

    neptune.url = github:yatima-inc/neptune/acs/add-flake-setup;
  };

  outputs = { self, lean, flake-utils, utils, nixpkgs, neptune }:
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
        pkgs = nixpkgs.leagacyPackages.${system};
        name = "Neptune";
        debug = false;
        inherit (utils.lib.${system}) buildCLib buildRustProject;
        neptune-rs = buildRustProject {
          root = ./bindings;
        };
        neptune-shim = buildCLib {
          name = "neptune-shim";
          src = ./c-shim;
          staticLibDeps = [ neptune-rs ];
        };
        BinaryTools = leanPkgs.buildLeanPackage {
          inherit debug;
          name = "BinaryTools";
          src = ./src;
        };
        project = leanPkgs.buildLeanPackage {
          inherit name debug;
          src = ./src;
          deps = [ BinaryTools ];
          nativeSharedLibs = [ neptune-shim ];
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
          inherit (project) modRoot sharedLib staticLib;
          inherit (leanPkgs) lean;
          tests = tests.executable;
        };

        checks.tests = tests;

        defaultPackage = project.sharedLib;
        devShell = pkgs.mkShell {
          buildInputs = [ leanPkgs.lean ];
          LEAN_PATH = "${leanPkgs.Lean.modRoot}";
          CPATH = "${leanPkgs.Lean.modRoot}";
        };
      });
}
