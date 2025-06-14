{ pkgs, drv }:

let
  binNixPath = "${drv}/bin/nix";

  copyNix =
    pkgs.runCommand "copy-nix-bin"
      {
        # No special build inputs needed
      }
      ''
        mkdir -p $out
        cp -L ${binNixPath} $out/nix
        chmod +x $out/nix
      '';
in
copyNix
