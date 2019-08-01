#!/bin/bash

. ~/.bin/ttyrec-utils

clear; ttyplayhelp
echo
echo "Now I am going to show you how to package and submit your OS coursework." | PV
echo 
echo "First, in emacs, open your org file, and export it into a html file." | PV; prompt
echo "cd 20121152888" | PV; prompt
echo "emacsclient 20121152888.org &" | PV; waiting
echo "Now, in your org file buffer, type 'C-c C-e h' to export it to a html file." | PV; waiting; prompt
echo "ls -l" | PV; waiting
echo "You can view this newly generated html file in your web browser." | PV; prompt
echo "google-chrome 20121152888.html &" | PV
echo "If it looks good, now you can pack your coursework directory into a tgz file." | PV; prompt
echo "cd .." | PV; prompt 
echo "ls -l" | PV; prompt
echo "tar zcf 20121152888.tgz 20121152888/" | PV; prompt
echo "ls -l" | PV; waiting
echo "Now you can send this tgz file to me via email." | PV; waiting

