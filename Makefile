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

	install -Dm755 ondev-prepare.sh \
		"$(DESTDIR)/usr/bin/ondev-prepare"
	install -Dm755 ondev-boot.sh \
		"$(DESTDIR)/usr/bin/ondev-boot"

.PHONY: default install
