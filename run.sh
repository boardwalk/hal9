#!/bin/sh
set -e
NODE_PATH=./output:$NODE_PATH node -e "require('Main').main();"
