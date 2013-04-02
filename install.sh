#!/bin/bash

CURR_DIR=`pwd`

echo "Install dotfiles"
pushd ~

ln -is ${CURR_DIR}/.bashrc
ln -is ${CURR_DIR}/.gitconfig

popd
echo "Done!"
