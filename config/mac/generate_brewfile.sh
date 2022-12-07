#!/usr/bin/env bash
echo "Running homebrew backup"
cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd
rm Brewfile
brew bundle dump