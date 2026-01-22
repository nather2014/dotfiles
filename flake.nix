{
  description = "Backend dev environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        jdk21
        maven
        gradle
        jdt-language-server

        neovim

        git
        curl
        wget
        unzip
        ripgrep
        fd
        jq
        httpie

        direnv

        postgresql_16

        docker
        docker-compose

        kubectl
        kubernetes-helm
        kind

        awscli2
        terraform
      ];
    };
  };
}
