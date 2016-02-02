#!/bin/bash

# Builds the dir.love file that I upload to Github for releases.

echo "Creating .love file..."

pushd .
cd ../Source
7z a ../Tools/dir.love -r . -tzip
popd

