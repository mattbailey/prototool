#!/bin/sh

####################################################################################
##### ** THIS SCRIPT SHOULD ONLY BE CALLED BY THE CORRESPONDING MAKE TARGET ** #####
####################################################################################

set -eu

DIR="$(cd "$(dirname "${0}")/../.." && pwd)"
cd "${DIR}"

BUILD_DIR="brew"

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}/bin"
mkdir -p "${BUILD_DIR}/etc/bash_completion.d"
mkdir -p "${BUILD_DIR}/etc/zsh/site-functions"
mkdir -p "${BUILD_DIR}/share/man/man1"
go run internal/cmd/gen-prototool-bash-completion/main.go > "${BUILD_DIR}/etc/bash_completion.d/prototool"
go run internal/cmd/gen-prototool-zsh-completion/main.go > "${BUILD_DIR}/etc/zsh/site-functions/_prototool"
go run internal/cmd/gen-prototool-manpages/main.go "${BUILD_DIR}/share/man/man1"
CGO_ENABLED=0 \
  go build \
  -a \
  -installsuffix cgo \
  -o "${BUILD_DIR}/bin/prototool" \
  cmd/prototool/main.go
