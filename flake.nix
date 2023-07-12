{

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ...}@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs {inherit system;};
      in {
        # Intended for nixos-25.05
        # https://github.com/NixOS/nixpkgs/blob/nixos-25.05/pkgs/tools/networking/openssh/common.nix
        packages.openssh_hacks = pkgs.openssh.overrideAttrs (finalAttrs: previousAttrs: {
          pname = previousAttrs.pname + "_hacks";
          version = "10.0p2";
          src = pkgs.lib.sources.cleanSource ./.;
          # If building from git, you'll need autoconf installed to build the
          # configure script.
          # See https://github.com/openssh/openssh-portable#building-from-git
          nativeBuildInputs =
            [ pkgs.autoreconfHook ] ++ previousAttrs.nativeBuildInputs
          ;
        });
        devShell = pkgs.mkShell { buildInputs = []; };
      }
    )
  ;

}

