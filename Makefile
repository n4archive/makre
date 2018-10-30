include Makre.mk
include project.mk
Makre.mk:
	@echo Makre not found
	@wget https://nift4.github.io/makre/project/files/Makre.mk
project.mk:
	@wget -O project.tar https://nift4.github.io/makre/NewProject.txz
	@tar Jxf project.tar
	@rm project.tar
