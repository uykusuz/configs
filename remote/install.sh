#!/bin/bash

set -euo pipefail

directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

usage() {
    echo "Usage: $0 <hostname>"
}

if (( $# < 1 ));
then
    usage
    exit 1
fi

if [[ "$1" == "-h" || "$1" == "--help" ]];
then
    usage
    exit 0
fi

hostName=$1
host=boris@${hostName}

scp _bashrc ${host}:./.bashrc
scp _vimrc ${host}:./.vimrc

ssh ${host} -- mkdir -p bin && mkdir -p .k9s

binaries="k8s http-status start-tmux-k8s gitt"
for binary in ${binaries};
do
    scp ${directory}/../bin/${binary} ${host}:./bin/
done

scp ${directory}/../_k9s/skin.yml ${host}:./.k9s/
