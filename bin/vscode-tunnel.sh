#!/bin/bash

PARENT_DIR=$(dirname "$(dirname "$(readlink -f "$0")")")

curl -Lk 'https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64' --output "$PARENT_DIR/vscode_cli.tar.gz"
tar -xf "$PARENT_DIR/vscode_cli.tar.gz" -C "$PARENT_DIR" && rm "$PARENT_DIR/vscode_cli.tar.gz"
"$PARENT_DIR/code" tunnel --accept-server-license-terms
