#!/bin/sh
set -e
NODE_PATH=./output:$NODE_PATH node -e "require('Hal9.Backend').main();"
