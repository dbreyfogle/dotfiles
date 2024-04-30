#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

curl -Lk 'https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64' --output "$SCRIPT_DIR/vscode_cli.tar.gz"
tar -xf "$SCRIPT_DIR/vscode_cli.tar.gz" -C "$SCRIPT_DIR" && rm "$SCRIPT_DIR/vscode_cli.tar.gz"
"$SCRIPT_DIR/code" tunnel --accept-server-license-terms
