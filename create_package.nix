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
        map (version: let 
          strippedVersion = builtins.substring 4 (builtins.stringLength version) version;
          in ''
          # Transform version string (e.g., nix_3_4_5 -> nix_3.4.5)
          transformedVersion=$(echo ${strippedVersion} | tr '_' '.')
          drv=${nixVersions.${version}}
          tar -czf $out/nix_$transformedVersion-${system}.tar.gz -C $drv nix
        '') versions
      )}
    '';
}