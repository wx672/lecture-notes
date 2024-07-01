#!/bin/bash

exec 3<>/dev/tcp/cs6.swfu.edu.cn/80
cat >&3 <<EOF
GET /~wx672/debian-install/install.sh HTTP/1.1
Host: cs6.swfu.edu.cn
Connection: close

EOF

cat <&3 > install.sh

[[ -s install.sh ]] && {
  sed -i -e '1,/################/d' install.sh
  chmod +x install.sh
} || {
  echo install.sh file is not properly downloaded.
  exit 1
}
