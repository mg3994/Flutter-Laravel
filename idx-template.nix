{pkgs, ...}: 
let 
  flutter = pkgs.fetchzip {
    url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.2-stable.tar.xz";
  };
  
in {
     packages = [
        pkgs.curl
        pkgs.gnutar
        pkgs.xz
        pkgs.git
        pkgs.busybox
    ];

    bootstrap = ''
      cp -rf ${flutter} flutter
      chmod -R u+w flutter
      PUB_CACHE=/tmp/pub-cache ./flutter/bin/flutter create "$out"
      mkdir -p "$out"/.{flutter-sdk,idx}
      mv flutter "$out/.flutter-sdk/flutter"
      echo ".flutter-sdk/flutter" >> "$out/.gitignore"
      mkdir -p "$out/.idx"
      chmod +x run.sh
      ./run.sh
      install --mode u+rw  "$out"/.idx/dev.nix
    '';
}
