#!/usr/bin/env bash
# Copyright (C) 2017 Maximilian Huber
# based on documentation found at https://getcomposer.org/doc/faqs/how-to-install-composer-programmatically.md

################################################################################
## Configuration:
# commit hash of https://github.com/composer/getcomposer.org

current_github_hash="5fd32f776359b8714e2647ab4cd8a7bed5f3714d"
# version of composer (must be present in https://github.com/composer/getcomposer.org/tree/${current_github_hash}/web/download)
version="1.3.2"

##
################################################################################

################################################################################
# prepare

set -e
cd "$( dirname "${BASH_SOURCE[0]}" )/.."

if [[ "$1" == "-h" ]]; then
    cat <<EOF
This script is used to install composer in version=${version}.
The composer artifact is downloaded from https://github.com/composer/getcomposer.org with commit_hash=${current_github_hash}.
(These values are hardcoded in the script)

It should be called like
   \$ ${BASH_SOURCE[0]} [-h] [/target/install/path] [-f]
where the optionional path argument is internally called \`install_dir\`

Note: If one passes an relative path (e.g. install_dir=./utils) this gets resolved relative to the project root

The \`install_dir\` defaults to
  - /usr/local/bin  - if the script is called by root or via sudo
  - ./utils   - otherwise
EOF
    exit 0
fi

# if run as root, install by default to /usr/bin, otherwise install to ./utils
if [ "$EUID" -ne 0 ]; then
    install_dir="${1:-utils}"
else
    install_dir="${1:-/usr/local/bin}"
fi

if [ ! -d "$install_dir" ]; then
    echo "install_dir=\"${install_dir}\" is not present (currently at \"$(pwd)\")"
    exit 1
fi

filename="composer"
target="$install_dir/$filename"

################################################################################
# do the install

echo "composer $version will be installed to: $target (this will override any old executable)"
wget -q \
     -O "$target" \
     "https://github.com/composer/getcomposer.org/raw/$current_github_hash/web/download/$version/composer.phar"
chmod +x "$target"
