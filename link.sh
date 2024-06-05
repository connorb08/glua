#!/usr/bin/env bash

cd "$(dirname "$0")"
root_dir="$(pwd)"
cd ./addons

for folder in */; do
    ln -s "$(pwd)/$folder" "$root_dir/server/garrysmod/addons/"
done

