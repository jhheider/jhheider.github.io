#!/bin/sh
# Regenerate the heider.cc installer scripts from install-template.ab.
# Requires amber (via pkgx). Run from anywhere; outputs to the repo root.
#
# Add a line per tool as installers are wanted. The repo's release assets
# must follow the shared naming: <name>-{linux,macos}-{aarch64,x86_64}.tar.gz
set -e

cd "$(dirname "$0")"
AMBER="${AMBER:-pkgx amber}"

gen() {
    name="$1"
    repo="$2"
    tmp="$(mktemp)"
    sed -e "s/__NAME__/$name/g" -e "s|__REPO__|$repo|g" install-template.ab > "$tmp.ab"
    $AMBER build "$tmp.ab" "../$name.sh"
    rm -f "$tmp" "$tmp.ab"
    echo "generated ../$name.sh"
}

gen penknife jhheider/penknife
gen edikt jhheider/edikt
# gen pdcst jhheider/pdcst   # enable when the repo goes public with releases
