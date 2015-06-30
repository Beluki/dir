#!/bin/sh

# This is the script that builds the .7z distribution files I upload to Github.

# Requirements:

# C:\MinGW32 and C:\MinGW64 contain MinGW for x86 and x86-64.
# wget and 7z (7-zip) are available in the current $PATH.

# Example:

# ./release.sh "dir 2015.06.29"


LOVE_WIN32_URL="https://bitbucket.org/rude/love/downloads/love-0.9.2-win32.zip"
LOVE_WIN64_URL="https://bitbucket.org/rude/love/downloads/love-0.9.2-win64.zip"

TARGET="$1"
TARGET_WIN32="$TARGET (win32)"
TARGET_WIN64="$TARGET (win64)"


echo "Creating .love file..."

pushd .
cd ../Source
7z a ../Tools/dir.love -r . -tzip
popd


echo "Creating target folders..."

mkdir "$TARGET_WIN32" "$TARGET_WIN32/dir" "$TARGET_WIN32/love2d"
mkdir "$TARGET_WIN64" "$TARGET_WIN64/dir" "$TARGET_WIN64/love2d"


echo "Adding dir..."

cp dir.love "$TARGET_WIN32/dir"
cp dir.love "$TARGET_WIN64/dir"


echo "Adding Love2D..."

wget --no-check-certificate "$LOVE_WIN32_URL" -O "love-win32.zip"
wget --no-check-certificate "$LOVE_WIN64_URL" -O "love-win64.zip"

7z e love-win32.zip -o"$TARGET_WIN32/love2d"
7z e love-win64.zip -o"$TARGET_WIN64/love2d"


echo "Adding launcher..."

/c/MinGW32/bin/windres dir.rc -O coff -o dir_win32.res
/c/MinGW32/bin/gcc -Wall dir.c dir_win32.res -O2 -mwindows -o "$TARGET_WIN32/dir.exe"

/c/MinGW64/bin/windres dir.rc -O coff -o dir_win64.res
/c/MinGW64/bin/gcc -Wall dir.c dir_win64.res -O2 -mwindows -o "$TARGET_WIN64/dir.exe"


echo "Compressing..."

7z a "$TARGET (win32).7z" "$TARGET_WIN32"
7z a "$TARGET (win64).7z" "$TARGET_WIN64"


echo "Cleaning..."

rm dir.love
rm -rf "$TARGET (win32)" "$TARGET (win64)"
rm love-win32.zip love-win64.zip
rm dir_win32.res dir_win64.res

