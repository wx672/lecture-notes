#!/bin/bash

. ~/.bin/ttyrec-utils

clear; ttyplayhelp
cat | PV << EOA
Today I am going to show you how to do your OS coursework.
You only need 3 tools:
1. A terminal - for executing commands and running your programs
2. Emacs - for writing your codes and lab report
3. A web browser - for viewing the lab instruction which is at:
	http://cs2.swfu.edu.cn/~wx672/lecture_notes/os/lab.html

Now, follow me step by step to get your work done...

First, you need to make a new directory, for example, 20121152888, 
EOA
prompt;

echo "mkdir 20121152888" | PV; waiting
echo "Get into this directory, and download the sample file." | PV; prompt; 
echo "cd 20121152888" | PV; prompt; 
echo "wget http://cs2.swfu.edu.cn/~wx672/lecture_notes/os/sample-report/20081152xxx.org" | PV; waiting
echo "Rename this file to 20121152888.org" | PV; prompt; 
echo "mv 20081152xxx.org 20121152888.org" | PV; waiting
echo "Open the lab instruction in your web browser, and follow it to do your work." | PV; prompt; 
echo "google-chrome http://cs2.swfu.edu.cn/~wx672/lecture_notes/os/lab.html &" | PV; waiting
echo "Open the org file with emacs" | PV; prompt; 
echo "emacsclient 20121152888.org &" | PV; waiting
cat | PV << EOB
If you still have no idea about emacs org-mode, you should follow this tutorial to get a feel:
	http://orgmode.org/worg/org-tutorials/orgtutorial_dto.html#sec-2

OK, let's start our coursework...
The first part of your coursework is about the '/proc' file system.
EOB

echo "What's /proc? " |PV; sleep 1; echo -n "Take a look at the 'References'." | PV; waiting

cat | PV << EOC
Yes, you have a lot to read, a lot to learn.
You have to spend hours on reading and learning before you can write your report.
Yes, this is called 'study'. This is why you paid so much money to come to university.
So, you have to be very patient to read, to learn, and then to write your report.

After you get a sense about the /proc file system, it should be easy to answer the following questions.

The first one...
EOC
waiting

echo -e "This is not the answer, but a hint, which can help you to find the answer" | PV; prompt
echo -n "less /proc/cpuinfo" | PV; waiting
echo -e "See? This file details your CPU. And the answer is here. Easy, eh?" | PV; waiting

echo -n "The second one..."; waiting; prompt
echo "uname -a" | PV
echo -e "This command shows you the kernel version information." | PV
echo 

echo -n "The third ..." ; waiting; prompt
echo -n "uptime" | PV; waiting
echo -e "no explain needed, right?" | PV
echo
echo -n "The 4th ..."; waiting; prompt
echo -n "top" | PV; waiting
echo -e "\tus - user;\tsy - system;\tid - idle;" | PV
echo "Got it?" | PV
echo
echo -en "The 5th ..." ; waiting; prompt
echo "free" | PV; waiting

echo -en "The 6th ..." ; waiting; prompt
echo "free" | PV; waiting

echo -e "The 7th ..." ; prompt
echo "less /proc/diskstats" | PV; waiting

echo -e "The 8th ..." ; prompt
echo "less /proc/stat" ; waiting

echo -e "The 9th ..." ; prompt
echo "less /proc/1205/status" | PV; waiting

echo -e "The 10th ..." ; prompt
echo "less /proc/stat" | PV; waiting

echo -e "The 11th ..." ; prompt
echo "less /proc/stat" | PV; waiting

echo -e "The 12th ..." ; prompt
echo "less /proc/stat" | PV; waiting

echo -e "The 13th ..." ; prompt
echo -e "cd /proc/\`ps | head -2 | tail -1 | cut -f1 -d' '\` && ls -l" | PV; waiting
echo -e "Well, it's a long command. We can do it step by step..." | PV
echo -e "You see \` \`? Every thing between this quote pair is treated as command." | PV
echo -e "So you can try it..." | PV; prompt
echo "ps | head -2 | tail -1 | cut -f1 -d' '" | PV; waiting
echo "You know '|' means 'pipe', right? This pipe connects 'ps', 'head', 'tail', and 'cut' together." | PV
echo "You can try it step by step..." | PV; prompt
echo "ps" | PV; prompt
echo "ps | head -2" | PV; prompt
echo "ps | head -2 | tail -1" | PV; prompt
echo "ps | head -2 | tail -1 | cut -f1 -d' '" | PV; waiting
echo "Now you see, the output is just the PID of your bash command line." | PV
echo "And the very long command," | PV; prompt
echo -e "cd /proc/\`ps | head -2 | tail -1 | cut -f1 -d' '\` && ls -l" | PV
echo "can be changed to," | PV; prompt
echo "cd /proc/[the number you see] && ls -l" | PV
echo "Now, you should got your answer, right?" | PV; waiting

cat | PV << EOD
OK, we are done with the first part of our lab report.
Now you can pack your work into a tgz file, and email it to me.
In your email body, don't forget to answer the sum up questions.
Looking forward to seeing your email soon.
EOD
sleep 2
