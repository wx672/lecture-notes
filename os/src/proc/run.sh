#!/bin/bash
if $(grep gcc $1 | cut -d\" -f2); then /tmp/a.out; fi
