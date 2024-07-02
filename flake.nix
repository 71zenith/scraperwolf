{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      librewolf = pkgs.librewolf.override {
        extraPrefs = ''
          pref("devtools.source-map.client-service.enabled", false);
          pref("librewolf.console.logging_disabled", true)
          pref("devtools.toolbox.host", "window");
          pref("privacy.resistFingerprinting", false);
          pref("webgl.disabled", false);
          pref("librewolf.debugger.force_detach", true);
        '';
      };
    in {
      packages = {
        inherit librewolf;
        default = librewolf;
      };
    })
    // {
      overlays = rec {
        default = librewolf;
        librewolf = final: prev: {inherit (self.packages.${final.system}) librewolf;};
      };
    };
}
