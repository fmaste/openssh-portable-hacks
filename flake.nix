{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        # From https://github.com/NixOS/nixpkgs/blob/nixos-23.05/pkgs/tools/networking/openssh/common.nix
        packages.openssh_hacks = pkgs.openssh.overrideAttrs (finalAttrs: previousAttrs: {
          pname = previousAttrs.pname + "_hacks";
          # src = ./.;
          src = pkgs.lib.sources.cleanSource ./.;
          # If building from git, you'll need autoconf installed to build the
          # configure script. The following commands will check out and build
          # portable OpenSSH from git:
          # https://github.com/openssh/openssh-portable#building-from-git
          nativeBuildInputs =
            [ pkgs.autoreconfHook ] ++ previousAttrs.nativeBuildInputs
          ;
        });
        devShell = pkgs.mkShell { buildInputs = []; };
      }
    )
  ;
}
