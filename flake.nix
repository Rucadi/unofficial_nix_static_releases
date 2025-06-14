{
  description = "Flake with nix input and cross-compilable custom package";

  inputs = {
    nix_2_26_3.url = "github:NixOS/nix/2.26.3";
    nix_2_27_1.url = "github:NixOS/nix/2.27.1";
    nix_2_28_3.url = "github:NixOS/nix/2.28.3";
    nix_2_29_0.url = "github:NixOS/nix/2.29.0";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      nixInputs =
        self.inputs |> builtins.attrNames |> builtins.filter (name: builtins.substring 0 4 name == "nix_");

      nixPkgsForSystem =
        system:
        nixInputs
        |> map (name: {
          name = name;
          value = import ./extract_nix_bin.nix {
            drv = self.inputs.${name}.hydraJobs.buildStatic.nix-everything.${system};
            pkgs = import nixpkgs { inherit system; };
          };
        })
        |> builtins.listToAttrs;

      allPackages =
        systems
        |> map (system: {
          name = system;
          value = nixPkgsForSystem system;
        })
        |> builtins.listToAttrs;

      allVersionsTar =
        (
          systems
          |> map (
            system:
            let
              nixVersions = allPackages.${system};
            in
            {
              name = system;
              value = {
                default = import ./create_package.nix {
                  inherit nixVersions system;
                  pkgs = (import nixpkgs { inherit system; });
                };
              };
            }
          )
        )
        |> builtins.listToAttrs;

      mergedPackages =
        systems
        |> map (system: {
          name = system;
          value = allPackages.${system} // allVersionsTar.${system};
        })
        |> builtins.listToAttrs;
    in
    {
      packages = mergedPackages;
    };
}
