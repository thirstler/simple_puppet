#!/bin/bash

[ -d ./pkgs ] || mkdir ./pkgs
rm -f ./pkgs/*

pushd modules

for n in jjr-*; do
    MODVER=$(grep '"version"' ${n}/metadata.json|gawk '{print $2}'|sed "s/,//"|sed "s/\"//g")
    echo "generating ${n}-${MODVER}.tar.gz"
    tar -czf ../pkgs/${n}-${MODVER}.tar.gz $n
done

pushd
