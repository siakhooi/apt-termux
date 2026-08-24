#!/usr/bin/env bash

set -euo pipefail

if [[ ! -f apt-ftparchive.conf ]]; then
    echo "apt-ftparchive.conf is not found." >&2
    exit 1
fi
set -x

mkdir -p docs/dists/stable/main/binary-{amd64,all}
mkdir -p cache
apt-ftparchive generate apt-ftparchive.conf
apt-ftparchive -c apt-ftparchive.conf release docs/dists/stable > docs/dists/stable/Release

if [[ -z $GPG_PRIVATE_KEY ]]; then
    echo "GPG_PRIVATE_KEY is not defined." >&2
    exit 1
fi

GNUPGHOME="$(mktemp -d)"
readonly GNUPGHOME
export GNUPGHOME

echo "$GPG_PRIVATE_KEY" | base64 -d | gpg --import
gpg --list-keys

gpg --clearsign \
    --output docs/dists/stable/InRelease \
    docs/dists/stable/Release

gpg --armor --detach-sign \
    --output docs/dists/stable/Release.gpg \
    docs/dists/stable/Release
