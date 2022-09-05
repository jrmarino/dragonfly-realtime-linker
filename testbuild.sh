#!/bin/sh

rm -rf build
mkdir build
cd build
cmake ../

make

echo product at build/rtld-elf/ld-elf.so.2
