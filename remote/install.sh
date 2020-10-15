#!/bin/bash

set -euo pipefail

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

scp _bashrc boris@$hostName:./.bashrc
