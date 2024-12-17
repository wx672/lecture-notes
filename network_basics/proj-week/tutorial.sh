#!/bin/bash

. ~/.local/bin/ttyrec-utils

clear
echo "Hi! In this tutorial, I will show you how to write your lab report." | PV
ttyplayhelp
echo
echo "You only need 3 tools:" | PV
echo "1. A terminal - for executing commands and running your programs" | PV
echo "2. Emacs - for writing your report" | PV
echo "3. A web browser - for viewing the lab instruction which is at:" | PV
echo -e "\thttp://cs6.swfu.edu.cn/~wx672/lecture_notes/network_basics/proj-week/proj-week.html" | PV
echo
echo "Now, follow me step by step to get your work done..." | PV
echo 
echo "First, you need to make a new directory, say, 20231152xxx" | PV; prompt; 
echo "mkdir 20231152xxx" | PV; waiting
echo "Get into this directory, and download the sample file." | PV; prompt; 
echo "cd 20231152xxx" | PV; prompt; 
echo "wget http://cs6.swfu.edu.cn/~wx672/lecture_notes/network_basics/proj-week/20231152xxx.org" | PV; waiting
echo "Of course you should rename this file to, for example, 20241152888.org" | PV; prompt; 
echo "mv 20231152xxx.org 20231152888.org" | PV; waiting
echo "Open the lab instruction in your web browser, and follow it to do your work." | PV; prompt; 
echo "$(tput setaf 3)lynx$(tput setaf 7) http://cs6.swfu.edu.cn/~wx672/lecture_notes/network_basics/proj-week/proj-week.html" | PV; waiting
echo "$(tput setaf 3)lynx$(tput setaf 7) is a text based web browser." | PV
echo "Of course you can use $(tput setaf 3)google-chrome$(tput setaf 7) instead if you like." | PV
echo
echo "Open the org file with emacs" | PV; prompt; 
echo "emacsclient 20231152xxx.org &" | PV; waiting
echo "You have a lot to do here." | PV
echo "I am not going to show you how to use Emacs at this moment." | PV
echo "Simply put, in emacs, type $(tput setaf 3)C-h t$(tput setaf 7) for a quick tutorial." | PV
echo "If you still have no idea about $(tput setaf 3)emacs org-mode$(tput setaf 7), you should follow this tutorial to get a feel:" | PV
echo -e "\thttp://orgmode.org/worg/org-tutorials/orgtutorial_dto.html#sec-2" | PV
echo
echo "OK, after you've done with your org file, now it's time to generate a html file from it." | PV
echo "This is quite easy. In emacs..." | PV
echo "1. save your org file by typing $(tput setaf 3)C-x C-s$(tput setaf 7)" | PV
echo "2. type $(tput setaf 3)C-c C-e h o$(tput setaf 7) to export your org file into a html file" | PV; waiting
echo "Now, the html file should be shown in your google-chrome window." | PV
echo "Check it and make sure it looks good." | PV
echo "Now you can pack your work into a $(tput setaf 3)tgz$(tput setaf 7) file." | PV; prompt;
echo "cd .." | PV; prompt;
echo "tar zcf 20231152xxx.tgz 20231152xxx/" | PV; prompt;
echo "ls" | PV; waiting;
echo "Now you can send this tgz file to me via email (wx672ster+net@gmail.com)." | PV
havefun2
echo
sleep 2
