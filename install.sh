#!/bin/bash

CURR_DIR=`pwd`

echo "Installing files ..."

pushd ~
ln -is ${CURR_DIR}/.bash_profile
ln -is ${CURR_DIR}/.bashrc
ln -is ${CURR_DIR}/.gitconfig
ln -is ${CURR_DIR}/.hgrc
ln -is ${CURR_DIR}/mozconfigs .mozconfigs
popd

pushd ~/bin
ln -is ${CURR_DIR}/bin/ccls
popd

echo "Done!"
