#!/usr/bin/env bash
echo "Running python-pip backup"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
pip3 freeze > $DIR/pip3-requirements.txt