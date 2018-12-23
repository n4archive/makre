help: .FORCERUN
	@echo 'Makre Build System'
	@echo 'Syntax: make [-f Makefile] <command> [a=b [...]]'
	@echo 'Commands:'
	@echo 'help - View this help'
	@echo 'project - Build the project'
	@echo 'installraw - Install a package (Vars: name=NAME_OF_PKG folder=PKG_FOLDER )'
	@echo 'installtar - Install a package in a txz (Vars: name=NAME_OF_PKG file=PKG_FILE_TXZ)'
	@echo 'install - Install a package from a repository. (Prefers up in sources.list)'
	@echo 'init - Create a new project'
	@if [ -d project/packages/makre/ovr/providers.desc.d/ ];then cd project/packages/makre/ovr/providers.desc.d/;for D in `find . ! -name .providers.desc.d -mindepth 1 -maxdepth 1 -type f`;do D=$$D bash -c 'echo $${D:2} - `cat $$D`';done;fi
project: .FORCERUN
	@touch -d "1 minute ago" build/timestamp
	@echo makre: \*** Starting build at `date`
	@touch build/tmp/.tmp
	@touch build/output/.output
	@echo makre: \*** Starting pre-build
	@MAKRE_ROOT=`pwd`;for D in `find ./packages/ -mindepth 1 -maxdepth 1 -type d`;do cd $$D;echo makre: \*** Pre-building using $${PWD##*/};make --no-print-directory pre MAKRE_ROOT=$$MAKRE_ROOT;echo makre: \*** Finished pre-build using $${PWD##*/};cd $$MAKRE_ROOT;done
	@echo makre: \*** Finished pre-build
	@echo makre: \*** Starting build
	@MAKRE_ROOT=`pwd`;for D in `find ./packages/ -mindepth 1 -maxdepth 1 -type d`;do cd $$D;echo makre: \*** Building using $${PWD##*/};make --no-print-directory build MAKRE_ROOT=$$MAKRE_ROOT;echo makre: \*** Finished build using $${PWD##*/};cd $$MAKRE_ROOT;done
	@echo makre: \*** Finished build
	@echo makre: \*** Cleaning build system...
	@find ./build/tmp -mindepth 1 ! -newer ./build/timestamp -delete
	@find ./build/output -mindepth 1 ! -newer ./build/timestamp -delete
	@echo makre: \*** Finished clean
	@echo makre: \*** Starting post-build
	@MAKRE_ROOT=`pwd`;for D in `find ./packages/ -mindepth 1 -maxdepth 1 -type d`;do cd $$D;echo makre: \*** Post-building using $${PWD##*/};make --no-print-directory post MAKRE_ROOT=$MAKRE_ROOT;echo makre: \*** Finished postbuild using $${PWD##*/};cd $$MAKRE_ROOT;done
	@echo makre: \*** Finished post-build
	@rm build/timestamp
	@echo makre: \*** Finished build at `date`
init: .FORCERUN
	-@touch project.mk
	-@mkdir build
	-@mkdir packages
	-@mkdir build/tmp
	-@touch build/tmp/.tmp
	-@mkdir build/output
	-@touch build/output/.output
	-@mkdir project
	-@mkdir project/files
	-@touch project/files/.files
	-@mkdir project/packages
	-@mkdir project/packages/makre
	-@echo "https://nift4.github.io/makre-packages/tar-files/" > project/packages/makre/sources.list
	-@mkdir project/packages/makre/ovr
	-@mkdir project/packages/makre/ovr/providers.d
	-@touch project/packages/makre/ovr/providers.d/.providers.d
	-@mkdir project/packages/makre/ovr/providers.desc.d
	-@touch project/packages/makre/ovr/providers.desc.d/.providers.desc.d
installraw: .FORCERUN
	-@mkdir packages/$(name)
	-@mkdir project/packages/$(name)
	@for D in `find $(folder)/pkg/ -mindepth 1`;do cp -r $$D packages/$(name);done
	@for D in `find $(folder)/cfg/ -mindepth 1`;do cp -r $$D project/packages/$(name);done
	@for D in `find $(folder)/ovr/ -mindepth 1`;do cp -r $$D project/packages/makre/ovr/;done
	@cd packages/$(name);make install
installtar: .FORCERUN
	-@mkdir pti
	@cd pti;tar xf ../$(file)
	@make installraw folder=pti name=$(name)
	@rm -r pti
install: .FORCERUN
	@for SRC in `cat project/packages/makre/sources.list`;do wget -O pkg.tar $${SRC}/$(name).tar;if [ -e;done
	@make installtar name=$(name) file=pkg.tar
	@rm pkg.tar
purge: .FORCERUN
	-@cd packages/$(name);make remove
	@rm -r packages/$(name) project/packages/$(name)
.FORCERUN:
	@:
%:
	-@cd project/packages/makre/ovr/providers.d/$@&&for D in `find . -type f -mindepth 1`;do make -f $$D;done
