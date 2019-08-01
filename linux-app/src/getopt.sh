#!/bin/bash

while getopts hf:l OPT; do
  case $OPT in
    h) echo "usage: `basename $0` [-h] [-f file] [-l]"
       exit 1 ;;
    l) echo "option: l" ;;
    f) echo "filename: $OPTARG" ;;
  esac
done
