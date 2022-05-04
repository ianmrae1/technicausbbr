obj-m += technicabr.o

KVERSION = $(shell uname -r)
KBUILDROOT = /lib/modules/$(KVERSION)/build
KMAKEOPTS = -C $(KBUILDROOT) M=$(CURDIR)
all:
	$(MAKE) $(KMAKEOPTS) modules
clean:
	$(MAKE) $(KMAKEOPTS) clean