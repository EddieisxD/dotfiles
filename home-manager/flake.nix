{
  inputs = {
    nixpkgs.url = "github:Nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, home-manager, ... }: let
    system = "x86_64-linux";
    pkgs   = import nixpkgs { inherit system; config.allowUnfree = true; };
    user   = "addy";
  in {
    homeConfiguration.${user} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ ./home.nix ];
    }; 
  };
}
