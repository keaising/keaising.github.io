#!/bin/bash
# bach to root
cd `dirname "$0"`
cd ..

git submodule sync
git submodule update --init --recursive --remote