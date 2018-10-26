help: .FORCERUN
	@echo 'Makre Build System'
	@echo 'Syntax: make [-f Makefile] <command> [a=b [...]]'
	@echo 'Commands:'
	@echo 'help - View this help'
	@echo 'project - Build the project'
	@echo 'installraw - Install a package (Vars: name=NAME_OF_PKG folder=PKG_FOLDER )'
	@echo 'init - Create a new project'
project: .FORCERUN
	@touch -d "1 minute ago" build/timestamp
	@echo makre: \*** Starting build at `date`
	@echo makre: \*** Starting pre-build
	@MAKRE_ROOT=`pwd`;for D in `find ./packages/ -mindepth 1 -maxdepth 1 -type d`;do cd $$D;echo makre: \*** Pre-building using $${PWD##*/};make --no-print-directory pre;echo makre: \*** Finished pre-build using $${PWD##*/};cd $$MAKRE_ROOT;done
	@echo makre: \*** Finished pre-build
	@echo makre: \*** Starting build
	@MAKRE_ROOT=`pwd`;for D in `find ./packages/ -mindepth 1 -maxdepth 1 -type d`;do cd $$D;echo makre: \*** Building using $${PWD##*/};make --no-print-directory build;echo makre: \*** Finished build using $${PWD##*/};cd $$MAKRE_ROOT;done
	@echo makre: \*** Finished build
	@echo makre: \*** Cleaning build system...
	@find ./build/tmp -mindepth 1 ! -newer ./build/timestamp -delete
	@find ./build/output -mindepth 1 ! -newer ./build/timestamp -delete
	@echo makre: \*** Finished clean
	@echo makre: \*** Starting post-build
	@MAKRE_ROOT=`pwd`;for D in `find ./packages/ -mindepth 1 -maxdepth 1 -type d`;do cd $$D;echo makre: \*** Post-building using $${PWD##*/};make --no-print-directory post;echo makre: \*** Finished postbuild using $${PWD##*/};cd $$MAKRE_ROOT;done
	@echo makre: \*** Finished post-build
	@rm build/timestamp
	@echo makre: \*** Finished build at `date`
init: .FORCERUN
	-@mkdir build
	-@mkdir packages
	-@mkdir build/tmp
	-@mkdir build/output
	-@mkdir project
	-@mkdir project/files
	-@mkdir project/packages
installraw: .FORCERUN
	-@mkdir packages/$(name)
	-@mkdir project/packages/$(name)
	@for D in `find $(folder)/pkg/ -mindepth 1`;do cp -r $$D packages/$(name);done
	@for D in `find $(folder)/cfg/ -mindepth 1`;do cp -r $$D project/packages/$(name);done
.FORCERUN:
	@:
