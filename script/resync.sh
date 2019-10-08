#!/bin/bash

# bach to root
cd `dirname "$0"`
cd ..


rm -rf theme
git clone https://github.com/keaising/hugo-primer.git themes/hugo-primer

rm -rf public
git clone https://github.com/keaising/keaising.github.io.git public

