#!/bin/bash

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -c|--clean)
    echo "Hello"
    shift # past argument
    ;;
    -g|--good)
    echo "Goodbye"
    shift # past argument
    ;;
    *)
    shift # past argument
    ;;
esac
done