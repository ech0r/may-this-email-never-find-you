{
  description = "Godot 4 dev environment with Rust support";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ rust-overlay.overlays.default ];
        pkgs = import nixpkgs {
          inherit system;
          overlays = overlays;
        };

        godot = pkgs.godot_4; # From nixpkgs unstable
        rust = pkgs.rust-bin.stable.latest.default;
      in {
        devShells.default = pkgs.mkShell {
          name = "godot4-dev";

          buildInputs = [
            godot
            rust
            pkgs.cargo
            pkgs.gcc
            pkgs.pkg-config
            pkgs.openssl
            pkgs.vulkan-tools
            pkgs.vulkan-loader
            pkgs.libxkbcommon
            pkgs.libpulseaudio
            pkgs.libGL
          ];

          shellHook = ''
            echo "🔧 Godot 4 + Rust dev environment loaded"
            echo "👉 Run 'godot4' to open the editor"
          '';
        };
      });
}

