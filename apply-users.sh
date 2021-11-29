#!/bin/sh
pushd ~/dev/nix-home
nix build .#homeManagerConfigurations.wamberg.activationPackage
./result/activate
popd
