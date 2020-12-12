{ pkgs ? import <nixpkgs> {} }:
  with pkgs; mkShell {
    nativeBuildInputs = [
      # Haven't gotten `freetds` to work via nix... For now, see the repo's
      # Brewfile; e.g. `brew bundle install`
      # freetds
      # pgloader
    ];
}
