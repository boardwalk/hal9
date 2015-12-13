#!/bin/sh
set -e
psc 'src/**/*.purs' \
    --ffi 'src/**/*.js' \
    'bower_components/purescript-*/src/**/*.purs' \
    --ffi 'bower_components/purescript-*/src/**/*.js'
