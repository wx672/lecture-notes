obj-m += hello-1.o

all:
	make -C /usr/src/linux-headers-$(shell uname -r) M=$(PWD) modules

clean:
	make -C /usr/src/linux-headers-$(shell uname -r) M=$(PWD) clean
