#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

shopt -s dotglob

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

cry() {
	>&2 echo -e $@
}

install() {
	file=$1
	echo -e "${GREEN}Installing ${file} to $HOME${NC}"
	relative=$(realpath --relative-base=$HOME $file)
	ln --symbolic --interactive --verbose $relative $HOME/$(basename $file) 
}

for file in $dir/configuration/*; do
	if [ -f $file ]; then
		install $file
	else
		cry "${RED}Don't know what to do with${NC} $file"
	fi
done

