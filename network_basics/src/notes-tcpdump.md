```sh
watch -t -n.1 "netstat -tapn | grep 12345"
watch -t -n.1 'ss -4ant "( sport = 3333 or dport = 3333 )"'
sudo tcpdump -ilo -nnvSX -s0 port 12345
```

