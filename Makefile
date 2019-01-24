include Makre.mk
include project.mk
Makre.mk:
	@echo Makre not found
	@wget https://nift4.github.io/makre/project/files/Makre.mk
project.mk:
	@touch project.mk
	
	
