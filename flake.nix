{
  description = "A devShell example";

  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url  = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      with pkgs;
      {
        devShells.default = mkShell {
          buildInputs = [
            openssl
            pkg-config
            exa
            fd
            rust-bin.beta.latest.default
            clippy
            rust-analyzer
          ];

          shellHook = ''
            alias ls=exa
            alias find=fd
          '';
        };
        packages.testa = 
            rustPlatform.buildRustPackage {
                name = "testa";
                src = ./.;
                cargoLock = {
                    lockFile = ./Cargo.lock;
                };
            };
             }
    );
}

# {
#   description = "Rust example flake for Zero to Nix";

#   inputs = {
#     nixpkgs.url = "github:NixOS/nixpkgs";
#     rust-overlay.url = "github:oxalica/rust-overlay";
#   };

#   outputs = { self, nixpkgs, rust-overlay }:
#     let
#       # Systems supported
#       allSystems = [
#         "x86_64-linux" # 64-bit Intel/AMD Linux
#         "aarch64-linux" # 64-bit ARM Linux
#         "x86_64-darwin" # 64-bit Intel macOS
#         "aarch64-darwin" # 64-bit ARM macOS
#       ];

#       # Helper to provide system-specific attributes
#       forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
#         pkgs = import nixpkgs { inherit system; };
#       });
#     in
#     {
#         packages = forAllSystems ({ pkgs }: {
#             default = pkgs.rustPlatform.buildRustPackage {
#                 name = "testa";
#                 src = ./.;
#                 cargoLock = {
#                     lockFile = ./Cargo.lock;
#                 };
#             };
#         });

#         # devShell = nixpkgs.mkShell {
#         #   nativeBuildInputs = with nixpkgs; [
#         #     (pkgs.rust-bin.stable.latest.default.override {
#         #           extensions = [ "rust-src" "cargo" "rustc" ];
#         #     })
#         #     gcc
#         #   ];
#         #   RUST_SRC_PATH = "${nixpkgs.rust-bin.stable.latest.default.override {
#         #       extensions = [ "rust-src" ];
#         #   }}/lib/rustlib/src/rust/library";
#         #   buildInputs = with nixpkgs; [
#         #     openssl.dev
#         #     glib.dev
#         #     pkg-config
#         #     just
#         #   ];
#         # };
#     };
# }
