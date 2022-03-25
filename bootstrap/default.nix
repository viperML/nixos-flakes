{
  mkShell,
  nix,
  git,
}:
mkShell
{
  name = "bootstrap-shell";
  packages = [
    # nix package from nixos-unstable will support flakes
    nix
    git
    # apply-hostname
  ];
  shellHook = ''
    echo ""
    echo "Welcome to the bootstrap shell!"
    echo "Inside this shell you have access to flakes before we enabled them systemd-wide"
    echo "- Update to the latest nixpkgs"
    echo "  $ nix flake update"
    echo "- Move your HARDWARE config to this flake"
    echo "  $ sudo mv /etc/nixos/hardware-configuration.nix $PWD/nixos-modules/"
    echo "  $ sudo chown -R $USER:$(id -gn) nixos-modules"
    echo "- Also wipe /etc/nixos so you dont use it by mistake"
    echo "  $ sudo rm -rf /etc/nixos"
    echo "- Change all ocurrences of HOSTNAME with your desired hostname"
    echo "  $ sed -i 's/HOSTNAME/$(cat /etc/hostname)/g' $PWD/flake.nix"
    echo "- Edit ./nixos-modules/home-manager.nix and change USER for your user"
    echo "  $ sed -i 's/USER/$USER/g' $PWD/nixos-modules/home-manager.nix"
    echo "- Install"
    echo "  $ sudo -E nixos-rebuild switch --flake $PWD"
    echo ""
  '';
  NIX_USER_CONF_FILES = "${../nix.conf}";
}
