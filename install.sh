#!/bin/bash

echo -n 'enter mojolicious secret: '
read SECRET
echo $SECRET > .mojo_secret
mkdir local
mkdir log
mkdir storage
carton install
