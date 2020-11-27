#!/usr/bin/env make -f
.POSIX:
.SUFFIXES:

.PHONY: help
help: ## Show this help (default)
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: things/right.scad ## Build the keyboard configuratoin

things/right-plate.scad: src/dactyl_keyboard/dactyl.clj
	lein run src/dactyl_keyboard/dactyl.clj
things/left.scad: src/dactyl_keyboard/dactyl.clj
	lein run src/dactyl_keyboard/dactyl.clj
things/right.scad: src/dactyl_keyboard/dactyl.clj
	lein run src/dactyl_keyboard/dactyl.clj

things/right-5x6-plate.scad: things/right-plate.scad
	cp $< $@
things/left-5x6.scad: things/left.scad
	cp $< $@
things/right-5x6.scad: things/right.scad
	# patch -p1 < 5x6.patch
	cp $< $@
	# git checkout src/dactyl_keyboard/dactyl.clj

things/right-5x6-plate.svg: things/right-5x6-plate.scad
	openscad -o $@ $< >/dev/null 2>&1
things/right-5x6-plate.dxf: things/right-5x6-plate.scad
	openscad -o $@ $< >/dev/null 2>&1
things/left-5x6.stl: things/left-5x6.scad
	openscad -o $@ $< >/dev/null 2>&1
things/right-5x6.stl: things/right-5x6.scad
	openscad -o $@ $< >/dev/null 2>&1

5x6: things/left-5x6.stl things/right-5x6.stl things/right-5x6-plate.dxf ## build the 5x6 version of the keyboard

.PHONY: clean
clean: ## Cleanup the build
	@rm -vf game graphics.o physics.o input.o
