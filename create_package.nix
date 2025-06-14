{ pkgs, system, nixVersions }:

pkgs.stdenvNoCC.mkDerivation {
  name = "all-nix-tars";

  nativeBuildInputs = [
    pkgs.gnutar
    pkgs.findutils
    pkgs.gzip
  ];

  buildCommand =
    let
      versions = builtins.attrNames nixVersions;
    in
    ''
      mkdir -p $out

      ${builtins.concatStringsSep "\n" (
        map (version: ''
          drv=${nixVersions.${version}}
          tar -czf $out/${version}-${system}.tar.gz -C $drv nix
        '') versions
      )}
    '';
}
