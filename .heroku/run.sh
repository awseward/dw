#!/usr/bin/env bash

set -euo pipefail

_sep() { echo -e "\n\n--------------------\n\n"; }

### Setup ./bin/

mkdir -v -p bin
PATH="${PATH}:$(pwd)/bin"; export PATH
echo "PATH=${PATH}"

_sep

### Install uplink

curl -L https://github.com/storj/storj/releases/latest/download/uplink_linux_amd64.zip -o uplink_linux_amd64.zip
unzip -o uplink_linux_amd64.zip
chmod +x uplink
mv uplink bin/
rm -f uplink_linux_amd64.zip

which uplink && uplink version

_sep

### Install dhall

readonly dhall_ver='1.37.1'
readonly dhall_tar="dhall-${dhall_ver}-x86_64-linux.tar.bz2"

wget "https://github.com/dhall-lang/dhall-haskell/releases/download/${dhall_ver}/${dhall_tar}" \
  && tar -xjvf "./${dhall_tar}" \
  && rm -rvf "./${dhall_tar}"

which dhall && dhall --version

_sep

### Install pgloader

which pgloader && pgloader --version # See Aptfile for actual install details

_sep

### Install shmig

git clone git://github.com/mbucc/shmig.git
git -C ./shmig checkout 81006b75e31b0772d68f4e988194c4eb33f0c4eb
cp ./shmig/shmig ./bin/

_sep

### Install uq

readonly uq_ver='0.1.0'
readonly uq_tar="uq-${uq_ver}.tar.gz"

wget "https://github.com/awseward/uq/releases/download/${uq_ver}/${uq_tar}" \
  && tar -zxvf "./${uq_tar}" \
  && mv "./uq" ./bin/ \
  && rm -rf "${uq_tar}"
