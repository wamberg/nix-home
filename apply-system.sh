#!/bin/sh
pushd ~/dev/nix-home
sudo nixos-rebuild switch --flake .#
popd
