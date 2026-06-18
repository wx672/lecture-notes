#!/bin/bash

words=$@
string=linux
if echo "$words" | grep -q "$string"
then
  echo "<$string> found in <$words>"
else
  echo "<$string> not found in <$words>"
fi
