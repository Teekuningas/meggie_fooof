#!/bin/bash

echo "Building package for local platform.."
conda-build -c cibr -c conda-forge --output-folder conda-bld/ --python 36 .
conda-build -c cibr -c conda-forge --output-folder conda-bld/ --python 37 .
conda-build -c cibr -c conda-forge --output-folder conda-bld/ --python 38 .
conda-build -c cibr -c conda-forge --output-folder conda-bld/ --python 39 .

echo "Converting package to other platforms"
platforms=( osx-64 linux-32 linux-64 win-32 win-64 )
find conda-bld/linux-64/ -name *.tar.bz2 | while read file
do
    echo $file
    for platform in "${platforms[@]}"
    do
       conda convert --platform $platform $file  -o conda-bld/
    done

done

echo "Uploading packages to anaconda cloud"
find conda-bld/ -name *.tar.bz2 | while read file
do
    echo "Uploading file $file"
    anaconda upload $file
done

echo "Cleaning build directory"
rm -fr conda-bld/*

echo "Releasing conda package done!"
