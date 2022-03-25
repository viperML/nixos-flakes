{
  config,
  pkgs,
  ...
}: {
  home.file.".config/nix/nix.conf".source = ../../misc/nix.conf;

  /*
    Add your config
  */
}
