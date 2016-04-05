help:
	@echo 'Makefile for zsh dotfiles'
	@echo '' 
	@echo 'Usage:  make install'
	@echo 'To clean files installed: make clean'
	@echo 'Warning make sure you backup your stuff first!'

install: rc 

rc:
	@ln -sf "$$PWD" "$$HOME/.zsh"
	-@git clone  https://github.com/tarjoilija/zgen.git "$(HOME)/.zgen" || true
	@find . -type f \( -iname ".z*" ! -iname ".zcompdump*" \) | while read -r path; do \
		file="$${path:2}"; \
		ln -sf "$$PWD/$$file" "$(HOME)/$$file"; \
	done

	@echo Installing... Done!

clean:
	-@rm -rfi "$(HOME)/.zsh" || true
	-@rm -rfi "$(HOME)/.zshenv" || true
	-@rm -rfi "$(HOME)/.zlogin"|| true
	-@rm -rfi "$(HOME)/.zlogout"|| true
	-@rm -rfi "$(HOME)/.zprofile"|| true
	-@rm -rfi "$(HOME)/.zshrc"|| true
	-@rm -rf "$(HOME)/.zgen"|| true
	@echo Cleaning... Done !
