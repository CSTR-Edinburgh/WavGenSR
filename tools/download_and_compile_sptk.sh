#!/bin/bash

# 1. Get and compile SPTK
echo "Downloading SPTK-3.9:======================================================="
wget http://downloads.sourceforge.net/sp-tk/SPTK-3.9.tar.gz
tar xzf SPTK-3.9.tar.gz
rm SPTK-3.9.tar.gz

echo "Compiling SPTK:============================================================="
(
    cd SPTK-3.9;
    ./configure --prefix=$PWD/build;
    make;
    make install
)
echo "All tools successfully compiled!!"
