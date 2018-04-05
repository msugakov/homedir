#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset
#set -o xtrace

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
	homepath=$(realpath --relative-to=$dir/configuration $file)
	echo -e "${GREEN}Installing ${file} to $HOME/$homepath${NC}"
	home_subdir=$(dirname $homepath)
	if [ "." != "$home_subdir" ]; then
		mkdir --parents --verbose $HOME/$home_subdir
	fi
	(cd $HOME; ln --symbolic --force --verbose $file $HOME/$homepath)
}

while IFS= read -r -d $'\0' file; do
	if [ -f $file ]; then
		install $file
	else
		cry "${RED}Don't know what to do with${NC} $file"
	fi
done < <(find $dir/configuration/ -type f -not -name "*.swp" -print0)

