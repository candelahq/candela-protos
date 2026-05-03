{
  description = "candela-protos — Canonical Protobuf definitions for the Candela platform";

  inputs = {
    flake-schemas.url = "https://flakehub.com/f/DeterminateSystems/flake-schemas/*";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, flake-schemas, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs {
          inherit system;
        };
      });
    in {
      schemas = flake-schemas.schemas;

      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            # ── Buf & Protobuf ────────────────────────────────
            buf                  # Lint, format, build, push
            protobuf             # protoc compiler

            # ── General dev tooling ───────────────────────────
            git
            gh                   # GitHub CLI
            lefthook             # Git hooks manager
            jq                   # JSON inspection
          ];

          shellHook = ''
            echo ""
            echo "🕯️  candela-protos dev shell"
            echo "   buf  : $(buf --version 2>&1)"
            echo ""

            # Install lefthook git hooks (only if not already present)
            if [ -d .git ] && ! grep -q 'LEFTHOOK' .git/hooks/pre-commit 2>/dev/null; then
              lefthook install 2>/dev/null
            fi
          '';
        };
      });
    };
}
