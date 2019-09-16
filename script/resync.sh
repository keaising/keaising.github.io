#!/bin/bash

# bach to root
cd `dirname "$0"`
cd ..

git submodule sync
git submodule update --init --recursive --remote

git submodule foreach git pull

cd public
git checkout master

cd ..
cd src/gen
git checkout master

cd ../..
cd themes/hugo-primer
git checkout master
