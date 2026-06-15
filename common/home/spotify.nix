{
  pkgs,
  ...
}:
{
  home.packages =
    let
      go-librespot = pkgs.buildGoModule rec {
        pname = "go-librespot";
        version = "0.7.1.1";
        src = pkgs.fetchFromGitHub {
          owner = "dubeyKartikay";
          repo = pname;
          rev = "v${version}";
          hash = "sha256-Hq9Qk8f8oKzpBwsbLNAvPO7qam3bh4L4RPUQC67/NZY=";
        };
        buildInputs = with pkgs; [
          alsa-lib
          flac
          libogg
          libvorbis
        ];
        nativeBuildInputs = with pkgs; [
          pkg-config
        ];
        vendorHash = "sha256-5J5i2Wc0zHCdvJ3aUkftXeMKS5X8jWimup0Ir4HLuS8=";
      };

      lazyspotify = pkgs.buildGoModule rec {
        pname = "lazyspotify";
        version = "0.3.3";
        src = pkgs.fetchFromGitHub {
          owner = "dubeyKartikay";
          repo = pname;
          rev = "v${version}";
          hash = "sha256-CftrW3has9BHePgGG4b1Dg4tpZlAcmiRnIzu75d6LJE=";
        };
        ldflags = [
          "-X github.com/dubeyKartikay/lazyspotify/buildinfo.PackagedDaemonPath=${go-librespot}/bin/daemon"
        ];
        vendorHash = "sha256-Axdt3/3ZOZY9Z5VUI6Wh77oIREOO26ODMyEgtscTmn8=";
      };
    in
    [
      lazyspotify
    ];
}
