#!/usr/bin/env bash
#
# This script builds the application from source for multiple platforms.

set -eu -o pipefail

# Get the parent directory of where this script is.
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
DIR="$( cd -P "$( dirname "$SOURCE" )/.." && pwd )"

# Just force this for now...
DIR1="$HOME/dev/spkane/todo-for-terraform/terraform-provider-todo"
DIR2="$HOME/dev/spkane/todo-for-terraform/cmd/todo-list-server"
declare -a DIRS=("${DIR1}" "${DIR2}")

for DIR in "${DIRS[@]}"; do
    # Change into that directory
    cd "$DIR"
    APP=$(basename "${DIR}")
    
    # Get the git commit
    GIT_COMMIT=$(git rev-parse HEAD)
    GIT_DIRTY=$(test -n "`git status --porcelain`" && echo "+CHANGES" || true)
    
    # Determine the arch/os combos we're building for
    XC_ARCH=${XC_ARCH:-"386 amd64 arm arm64"}
    XC_OS=${XC_OS:-linux darwin windows freebsd openbsd solaris}
    XC_EXCLUDE_OSARCH="!darwin/arm !darwin/386"
    
    # Delete the old dir
    echo "==> Removing old bin & pkg directories in: ${DIR}..."
    rm -f bin/*
    rm -rf pkg/*
    mkdir -p bin/
    
    # If its dev mode, only build for ourself
    set +u
    if [[ -z "${TF_DEV}" ]]; then
        TF_DEV="false"
    fi
    set -u

    set +u
    if [[ -z "${LD_FLAGS}" ]]; then
        LD_FLAGS=""
    fi
    set -u
    
    if [[ "${TF_DEV}" == "true" ]]; then
        XC_OS=$(go env GOOS)
        XC_ARCH=$(go env GOARCH)
    
        # Allow LD_FLAGS to be appended during development compilations

        LD_FLAGS="-X main.GitCommit=${GIT_COMMIT}${GIT_DIRTY} $LD_FLAGS"
    fi
    
    if ! which gox > /dev/null; then
        echo "==> Installing gox..."
        go get -u github.com/mitchellh/gox
    fi
    
    # Instruct gox to build statically linked binaries
    export CGO_ENABLED=0
    
    # In release mode we don't want debug information in the binary
    set +u
    if [[ -z "${TF_RELEASE}" ]]; then
        TF_RELEASE="false"
    fi
    set -u

    if [[ "${TF_RELEASE}" == "true" ]]; then
        LD_FLAGS="-s -w"
    fi
    
    # Ensure all remote modules are downloaded and cached before build so that
    # the concurrent builds launched by gox won't race to redundantly download them.
    go mod download
    
    # Build!
    echo "==> Building..."
    gox \
        -os="${XC_OS}" \
        -arch="${XC_ARCH}" \
        -osarch="${XC_EXCLUDE_OSARCH}" \
        -ldflags "${LD_FLAGS}" \
        -output "pkg/{{.OS}}_{{.Arch}}/${PWD##*/}" \
        .
    
    # Move all the compiled things to the $GOPATH/bin
    GOPATH=${GOPATH:-$(go env GOPATH)}
    case $(uname) in
        CYGWIN*)
            GOPATH="$(cygpath $GOPATH)"
            ;;
    esac
    OLDIFS=$IFS
    IFS=: MAIN_GOPATH=($GOPATH)
    IFS=$OLDIFS
    
    # Create GOPATH/bin if it's doesn't exists
    if [ ! -d $MAIN_GOPATH/bin ]; then
        echo "==> Creating GOPATH/bin directory..."
        mkdir -p $MAIN_GOPATH/bin
    fi
    
    # Copy our OS/Arch to the bin/ directory
    DEV_PLATFORM="./pkg/$(go env GOOS)_$(go env GOARCH)"
    if [[ -d "${DEV_PLATFORM}" ]]; then
        for F in $(find ${DEV_PLATFORM} -mindepth 1 -maxdepth 1 -type f); do
            cp ${F} bin/
            cp ${F} ${MAIN_GOPATH}/bin/
        done
    fi
    
    if [ "${TF_DEV}x" = "x" ]; then
        # Zip and copy to the dist dir
        echo "==> Packaging..."
        for PLATFORM in $(find ./pkg -mindepth 1 -maxdepth 1 -type d); do
            OSARCH=$(basename ${PLATFORM})
            echo "--> ${OSARCH}"
    
            pushd $PLATFORM >/dev/null 2>&1
            zip ../${APP}-${OSARCH}.zip ./*
            popd >/dev/null 2>&1
        done
    fi
    
    # Done!
    echo
    echo "==> Results:"
    ls -hl bin/
done
