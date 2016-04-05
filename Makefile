install: rc 

rc:
	ln -sf $(PWD) $(HOME)/.zsh
	git clone git@github.com:tarjoilija/zgen "$(HOME)/.zgen" || true
	find . -type f \( -iname ".z*" ! -iname ".zcompdump*" \) | while read -r path; do \
		 ln -sf "$$PWD/$$path" "$(HOME)/$$path"; \
	done

	@echo Done!
