{
  description = "Neptune bindings for lean";

  inputs = {
    lean = {
      url = github:leanprover/lean4;
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
  };

  outputs = { self, lean, flake-utils, utils, nixpkgs, naersk }:
    let
      supportedSystems = [
        # "aarch64-linux"
        # "aarch64-darwin"
        # "i686-linux"
        # "x86_64-darwin"
        "x86_64-linux"
      ];
    in
    flake-utils.lib.eachSystem supportedSystems (system:
      let
        leanPkgs = lean.packages.${system};
        pkgs = nixpkgs.legacyPackages.${system};
        lib = utils.lib.${system};
        inherit (lib) buildCLib buildRustProject makeBareDerivation;
        neptune-rs-bindings = (
          let lib = buildRustProject {
            src = ./bindings;
            buildInputs = with pkgs; [ libclc ];
            C_INCLUDE_PATH = "${leanPkgs.lean-bin-tools-unwrapped}/include";
          };
          in lib // {
            __toString = d: "${lib}/lib";
            libPath = "${lib}/lib/liblean_neptune_bindings.so";
            linkName = "lean_neptune_bindings";
          }
        );
        project = leanPkgs.buildLeanPackage {
          debug = false;
          name = "Neptune";
          src = ./src;
          nativeSharedLibs = [ neptune-rs-bindings ];
        };
        test = leanPkgs.buildLeanPackage {
          debug = false;
          name = "Tests";
          src = ./test;
          deps = [ project ];
        };
        joinDepsDerivations = getSubDrv:
          pkgs.lib.concatStringsSep ":" (map (d: "${getSubDrv d}") project.allExternalDeps);
      in
      {
        inherit project test;
        packages = {
          inherit neptune-rs-bindings;
          inherit (project) modRoot sharedLib staticLib lean-package;
          inherit (leanPkgs) lean;
          test = test.executable;
        };

        checks.test = test.executable;

        defaultPackage = test.executable;
        devShell = pkgs.mkShell {
          buildInputs = [ leanPkgs.lean-dev ];
          LEAN_PATH = "./src:./test:" + joinDepsDerivations (d: d.modRoot);
          LEAN_SRC_PATH = "./src:./test:" + joinDepsDerivations (d: d.src);
          C_INCLUDE_PATH = "${leanPkgs.lean-bin-tools-unwrapped}/include";
          CPLUS_INCLUDE_PATH = "${leanPkgs.lean-bin-tools-unwrapped}/include";
        };
      });
}
