#!/bin/sh
set -e
export NODE_PATH=./output:$NODE_PATH
psc 'src/**/*.purs' \
    --ffi 'src/**/*.js' \
    'bower_components/purescript-*/src/**/*.purs' \
    --ffi 'bower_components/purescript-*/src/**/*.js'
browserify frontend.js -o static/frontend.js
