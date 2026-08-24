default:
    @just --list
build:
    scripts/build.sh
clean:
    rm -rf docs/dists cache
gpg:
    scripts/gpg-generate-key.sh
