{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (pkgs.rustPlatform.buildRustPackage (finalAttrs: {
      name = "superseedr";
      src = fetchFromGitHub {
        owner = "Jagalite";
        repo = "superseedr";
        rev = "HEAD";
        hash = "sha256-dyp/OOKG5Aw+BxZ2bANTEjcMGSljNUGEoZ3L15aKr8A=";
      };

      buildInputs = [ pkgs.openssl ];
      cargoBuildFlags = [ "--no-default-features" ];
      cargoHash = "sha256-5jtkYW++OdF7mKHl6Yw/xshbt/oEVvG3PFa+xnDqE9k=";
      nativeBuildInputs = [ pkgs.pkg-config ];
    }))
  ];
}
