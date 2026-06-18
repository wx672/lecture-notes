#!/bin/bash

tmp=$(mktemp)

while read LINE; do
  echo $LINE >> $tmp
done

      
