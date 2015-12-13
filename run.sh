#!/bin/sh
set -e
NODE_PATH=$(pwd)/output:$NODE_PATH node -e "require('Main').main();"
