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

ssh ${host} -- mkdir -p bin
scp ${directory}/../bin/k8s ${host}:./bin/k8s
