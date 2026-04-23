{
  pkgs,
  lib,
  config,
  ...
}:
let
  scientifica-nerd = pkgs.scientifica.overrideAttrs (o: {
    nativeBuildInputs = (o.nativeBuildInputs or [ ]) ++ [ pkgs.nerd-font-patcher ];
    postInstall = (o.postInstall or "") + ''
      mkdir -p $out/share/fonts/truetype/scientifica-nerd
      for f in $out/share/fonts/truetype/*.ttf; do
        nerd-font-patcher --complete --outputdir $out/share/fonts/truetype/scientifica-nerd/ "$f"
      done
    '';
  });
in
{
  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    curie
    scientifica-nerd
  ];

  environment.variables = {
    ROSETTA_ADVERTISE_AVX = "1";
  };
}
