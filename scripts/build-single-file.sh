#!/bin/sh

set -e

mkdir -p build
mkdir -p build/debug

rm -f build/graphql.lua
rm -f build/debug/graphql.lua

darklua process --config .darklua-bundle.json src/init.lua build/graphql.lua
darklua process --config .darklua-bundle-dev.json src/init.lua build/debug/graphql.lua
