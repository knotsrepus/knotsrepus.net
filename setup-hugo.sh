#!/usr/bin/env bash

case "$(uname)" in
    Darwin)
        OSTYPE="macOS"
        ;;
    
    Linux)
        OSTYPE="Linux"
        ;;
    
    CYGWIN*|MINGW*|MSYS*)
        OSTYPE="Windows"
        ;;
    
    *)
        echo "This script only supports Windows/macOS/Linux. Please install Hugo manually from: https://gohugo.io" >&2
        exit
        ;;
esac

case "$(uname -m)" in
    arm64)
        ARCH="ARM64"
        ;;
    
    arm*)
        ARCH="ARM"
        ;;
    
    x86_64)
        ARCH="64bit"
        ;;
    
    *)
        ARCH="32bit"
        ;;
esac

DOWNLOAD_URL=$(curl -s https://api.github.com/repos/gohugoio/hugo/releases/latest \
        | grep browser_download_url \
        | grep ${OSTYPE}-${ARCH} \
        | cut -d '"' -f 4)

echo $DOWNLOAD_URL

mkdir -p tmp
cd tmp

if [ $OSTYPE = "Windows" ]
then
    curl -sSL $DOWNLOAD_URL > hugo.zip
    unzip -o hugo.zip
    cp hugo.exe ../
else
    curl -sSL $DOWNLOAD_URL > hugo.tar.gz
    tar xvzf hugo.tar.gz
    cp hugo ../
fi

cd ../
rm -r tmp
