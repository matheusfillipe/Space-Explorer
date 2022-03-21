#!/usr/bin/env bash

VERSION=$(git describe --tags --abbrev=0)
cd build/
mkdir -p release

wget https://github.com/tcnksm/ghr/releases/download/v0.14.0/ghr_v0.14.0_linux_amd64.tar.gz
tar -xvzf ghr_*.tar.gz
mv ghr_*_amd64 ghr

rm -rf ./html/.git
rm -f ./html/index.php
rm -f ./html/composer.json

zip linux.zip linux/*
zip macos.zip macos/*
zip windows.zip windows/*
zip html5.zip ./html/*
mv *.zip release/

echo "RELEASE VERSION $VERSION"
./ghr/ghr -t ${GITHUB_TOKEN} -u ${CIRCLE_PROJECT_USERNAME} -r ${CIRCLE_PROJECT_REPONAME} -c ${CIRCLE_SHA1} -delete ${VERSION} ./release/
