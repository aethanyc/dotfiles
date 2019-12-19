#!/bin/bash

CURR_DIR=`pwd`

echo "Install dotfiles"
pushd ~

ln -is ${CURR_DIR}/.bash_profile
ln -is ${CURR_DIR}/.bashrc
ln -is ${CURR_DIR}/.gdbinit
ln -is ${CURR_DIR}/.gitconfig
ln -is ${CURR_DIR}/.hgrc
ln -is ${CURR_DIR}/mozconfigs .mozconfigs

popd
echo "Done!"
