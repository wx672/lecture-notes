#!/bin/bash

[[ -f "$1" ]] && logger "$1 exists." || logger "$1 not found."
