#!/bin/sh
set -e
export NODE_PATH=./output:$NODE_PATH
node -e "require('Hal9.Backend').main();"
