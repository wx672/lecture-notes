#!/bin/bash

function screencapture(){
  ffmpeg -f x11grab -s 1920x1080 -r 30 -i :0.0 \
         -c:v libx264 -crf 0 -preset ultrafast screen.mkv
}

w2pdf(){
  libreoffice --convert-to pdf:writer_pdf_Export "$1"
}
 
rfc(){
    [[ -n "$1" ]] || {
		cat <<EOF
  rfc - Command line RFC viewer
  Usage: rfc <index>
EOF
		return 1
	}
	find /usr/share/doc/RFC/ -type f -iname "rfc$1.*" | xargs less
}

