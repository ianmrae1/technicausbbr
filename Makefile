PREFIX ?= /usr

PACKAGE_OUTPUT_DIR = pkg

SOURCE_DIR = src
PACKAGE_NAME = technicabr
PACKAGE_VERSION = 1.3.0

TARGET_DIR = $(PREFIX)/src/$(PACKAGE_NAME)-$(PACKAGE_VERSION)

SRCDIR = src
HEADER_FILE = technicabr.h

UDEV_SRCDIR = udev
UDEV_RULES_FILE = technicabr.rules
UDEV_TARGET_FOLDER = /etc/udev/rules.d

all:
	$(MAKE) -C $(SRCDIR) all
	
.PHONY: clean
clean:
	$(MAKE) -C $(SRCDIR) clean


.PHONY: install-header
install-header:
	cp $(SRCDIR)/$(HEADER_FILE) $(PREFIX)/include/$(HEADER_FILE)
	chown root:root $(PREFIX)/include/$(HEADER_FILE)
	chmod 0644 $(PREFIX)/include/$(HEADER_FILE)
	
.PHONY: uninstall-header
uninstall-header:
	if [ -a $(PREFIX)/include/$(HEADER_FILE) ]; then rm $(PREFIX)/include/$(HEADER_FILE); fi

.PHONY: install-udev
install-udev:
	cp $(UDEV_SRCDIR)/$(UDEV_RULES_FILE) $(UDEV_TARGET_FOLDER)/$(UDEV_RULES_FILE)
	chown root:root $(UDEV_TARGET_FOLDER)/$(UDEV_RULES_FILE)
	chmod 0644 $(UDEV_TARGET_FOLDER)/$(UDEV_RULES_FILE)
	udevadm control -R
	
.PHONY: uninstall-udev
uninstall-udev:
	if [ -a $(UDEV_TARGET_FOLDER)/$(UDEV_RULES_FILE) ]; then rm $(UDEV_TARGET_FOLDER)/$(UDEV_RULES_FILE); fi
	udevadm control -R

.PHONY: install-common
install-common: install-header install-udev

.PHONY: uninstall-common
uninstall-common: uninstall-header uninstall-udev

.PHONY: install-dkms	
install-dkms: clean install-common
	mkdir -p $(PREFIX)/src
	cp -R $(SRCDIR) $(TARGET_DIR)
	chown -R root:root $(TARGET_DIR)
	chmod -R o-rwx $(TARGET_DIR)
	sed -i -e "s/^PACKAGE_NAME=\".*\"$$/PACKAGE_NAME=\"$(PACKAGE_NAME)\"/"\
		-e "s/^PACKAGE_VERSION=\".*\"$$/PACKAGE_VERSION=\"$(PACKAGE_VERSION)\"/"\
		$(TARGET_DIR)/dkms.conf
	dkms add -m $(PACKAGE_NAME) -v $(PACKAGE_VERSION)
	dkms build -m $(PACKAGE_NAME) -v $(PACKAGE_VERSION)
	dkms install -m $(PACKAGE_NAME) -v $(PACKAGE_VERSION)
	
.PHONY: uninstall-dkms
uninstall-dkms: uninstall-common
	dkms remove -m $(PACKAGE_NAME) -v $(PACKAGE_VERSION) --all
	rm -rf $(TARGET_DIR)
	
.PHONY: package
package: clean
	tar -czf $(PACKAGE_OUTPUT_DIR)/$(PACKAGE_NAME)-$(PACKAGE_VERSION).tar.gz\
		--transform "s|^|$(PACKAGE_NAME)-$(PACKAGE_VERSION)/|"\
		$(SRCDIR)/ $(UDEV_SRCDIR)/ Makefile README
