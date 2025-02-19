{
  description = "Flake for glance - A self-hosted dashboard";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
  let
    system = "x86_64-linux";  # Adjust if needed
    pkgs = import nixpkgs { inherit system; };
  in
  {
    packages.${system}.default = pkgs.buildGoModule rec {
      pname = "glance";
      version = "0.7.3";

      src = ./.;

      vendorHash = "sha256-lURRHlZoxbuW1SXxrxy2BkMndcEllGFmVCB4pXBad8Q=";

      excludedPackages = [ "scripts/build-and-ship" ];

      nativeBuildInputs = [
        pkgs.go_1_24
      ];

      passthru = {
        updateScript = pkgs.nix-update-script { };
        tests.service = pkgs.nixosTests.glance;
      };

      meta = with pkgs.lib; {
        homepage = "https://github.com/glanceapp/glance";
        changelog = "https://github.com/glanceapp/glance/releases/tag/v${version}";
        description = "Self-hosted dashboard that puts all your feeds in one place";
        mainProgram = "glance";
        license = licenses.agpl3Only;
        maintainers = [ maintainers.dvn0 ];
      };
    };
  };
}
