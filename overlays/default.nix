# This file defines overlays
{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    # 包装一层：把根目录文件放到 share/rime-data/ 下
    rime-data-custom =
      final.runCommandLocal "rime-data-custom"
        {
          src = inputs.rime-data;
        }
        ''
          mkdir -p $out/share/rime-data
          cp -r $src/* $out/share/rime-data/
        '';

    fcitx5-rime = prev.fcitx5-rime.override {
      rimeDataPkgs = [ final.rime-data-custom ];
    };

    btop = prev.btop.override { cudaSupport = true; };
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
}
