#!/bin/sh

# This is the script that builds the .7z distribution files I upload to Github.

# Requirements:

# C:\MinGW32 and C:\MinGW64 contain MinGW for x86 and x86-64.
# C:\ResourceHacker contains Resource Hacker.
# wget and 7z (7-zip) are available in the current $PATH.

# Example:

# ./build.sh "dir 2015.06.29"


TARGET="$1"


echo "Creating target folders... "

mkdir "$TARGET (win32)"
mkdir "$TARGET (win64)"


echo "Downloading Love2D..."

mkdir "$TARGET (win32)/love2d"
mkdir "$TARGET (win64)/love2d"

wget --no-check-certificate https://bitbucket.org/rude/love/downloads/love-0.9.2-win32.zip -O "love-win32.zip"
wget --no-check-certificate https://bitbucket.org/rude/love/downloads/love-0.9.2-win64.zip -O "love-win64.zip"

7z e love-win32.zip -o"$TARGET (win32)/love2d"
7z e love-win64.zip -o"$TARGET (win64)/love2d"


echo "Overwriting Love2D icons..."

/c/ResourceHacker/ResourceHacker.exe -addoverwrite "$TARGET (win32)/love2d/love.exe", "$TARGET (win32)/love2d/love.exe", "dir.ico", ICONGROUP, MAINICON, 0
/c/ResourceHacker/ResourceHacker.exe -addoverwrite "$TARGET (win64)/love2d/love.exe", "$TARGET (win64)/love2d/love.exe", "dir.ico", ICONGROUP, MAINICON, 0


echo "Adding dir..."

mkdir "$TARGET (win32)/dir"
cp -R ../Documentation ../Screenshot ../Source ../README.md "$TARGET (win32)/dir"

mkdir "$TARGET (win64)/dir"
cp -R ../Documentation ../Screenshot ../Source ../README.md "$TARGET (win64)/dir"


echo "Adding stub launcher..."

/c/MinGW32/bin/windres dir.rc -O coff -o dir_win32.res
/c/MinGW32/bin/gcc -I /c/MinGW32/include dir.c dir_win32.res -O2 -mwindows -o "$TARGET (win32)/dir.exe"

/c/MinGW64/bin/windres dir.rc -O coff -o dir_win64.res
/c/MinGW64/bin/gcc -I /c/MinGW64/include dir.c dir_win64.res -O2 -mwindows -o "$TARGET (win64)/dir.exe"


echo "Compressing..."

7z a "$TARGET (win32).7z" "$TARGET (win32)"
7z a "$TARGET (win64).7z" "$TARGET (win64)"


echo "Cleaning..."

rm -rf "$TARGET (win32)" "$TARGET (win64)"
rm love-win32.zip love-win64.zip
rm dir_win32.res dir_win64.res

