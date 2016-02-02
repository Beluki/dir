#!/bin/sh

# Builds the .7z distribution that I upload to Github for the MinGW64 stub.
# It's meant to be run from MSYS2.
# Requirements: 7z, wget and gcc.


# Love2D 0.9.2 url:

LOVE_WIN64_URL="https://bitbucket.org/rude/love/downloads/love-0.9.2-win64.zip"

# Target filename:

TARGET="dir $(date "+%Y.%m.%d") (win64)"


echo "Creating .love file..."

pushd .
cd ../Source
7z a ../Tools/dir.love -r . -tzip
popd


echo "Creating target folder..."

mkdir "$TARGET" "$TARGET/dir" "$TARGET/love2d"


echo "Adding dir..."

cp dir.love "$TARGET/dir"


echo "Adding Love2D..."

wget --no-check-certificate "$LOVE_WIN64_URL" -O "love-win64.zip"
7z e love-win64.zip -o"$TARGET/love2d"


echo "Adding launcher..."

windres dir.rc -O coff -o dir_win64.res
gcc -Wall dir.c dir_win64.res -O2 -mwindows -o "$TARGET/dir.exe"


echo "Compressing..."

7z a "$TARGET.7z" "$TARGET"


echo "Cleaning..."

rm -rf "$TARGET"

rm dir.love
rm love-win64.zip
rm dir_win64.res

