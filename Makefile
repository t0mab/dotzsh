install: rc 

rc:
	ln -sf $(PWD) $(HOME)/.zsh
	find . -type f \( -iname ".z*" ! -iname ".zcompdump*" \) | while read -r path; do \
		 ln -sf "$$PWD/$$path" "$(HOME)/$$path"; \
	done
