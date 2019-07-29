#!/bin/bash

# bach to root
cd `dirname "$0"`
cd ..

hugo server -D -E -F -w --cleanDestinationDir 
