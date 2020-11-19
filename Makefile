# Copyright 2020 Oliver Smith
# SPDX-License-Identifier: GPL-3.0-or-later
DESTDIR :=

# Nothing to compile
default:
	$(info usage: 'make DESTDIR="..." install')

install:
	cd config && for cfg in settings.conf modules/*.conf; do \
		install -Dm644 "$$cfg" \
			"$(DESTDIR)/etc/calamares/$$cfg" || exit 1; \
	done

	install -Dm644 logo.png \
		"$(DESTDIR)/usr/share/calamares/branding/default-mobile/logo.png"
	install -Dm755 ondev-prepare.sh \
		"$(DESTDIR)/usr/bin/ondev-prepare"
	install -Dm755 ondev-boot.sh \
		"$(DESTDIR)/usr/bin/ondev-boot"
	install -Dm755 ondev-boot-mount.sh \
		"$(DESTDIR)/usr/bin/ondev-boot-mount"
	install -Dm755 postmarketos-ondev.initd \
		"$(DESTDIR)/etc/init.d/postmarketos-ondev"

.PHONY: default install
