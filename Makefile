NAME     := TankTruckReverse
DEST_DIR := $(HOME)/projets/addons/TankTruckReverse/versions
VERSION  := $(shell git describe --tags --abbrev=0 2>/dev/null)

# Fichiers du code addon, listés explicitement (garde-fou check-packaging).
ADDON_FILES := \
	TankTruckReverse.toc \
	TankTruckReverse.lua \
	Core/Trigger.lua \
	Media/backup_beep.ogg \
	Textures/icon.tga

.PHONY: zip test help

# Tests Busted en conteneur (aucun runtime Lua local requis).
test:
	@docker build -f Dockerfile.test -t tanktruckreverse-test . && \
		docker run --rm -v "$(CURDIR)":/addon tanktruckreverse-test

zip:
	@[ -n "$(VERSION)" ] || { echo "Erreur : aucun tag git trouvé. Exemple : git tag v1.0.0"; exit 1; }
	@python3 tools/check-packaging.py $(ADDON_FILES)
	@mkdir -p "$(DEST_DIR)"
	@python3 -c "\
import os, zipfile; \
name = '$(NAME)'; \
dest = '$(DEST_DIR)/$(NAME)-$(VERSION).zip'; \
files = '$(ADDON_FILES)'.split(); \
zf = zipfile.ZipFile(dest, 'w', zipfile.ZIP_DEFLATED); \
[ zf.write(p, name + '/' + p) for p in files ]; \
zf.close(); \
print('→', dest)"

help:
	@echo "Usage:"
	@echo "  make test        # lance les tests Busted (Docker)"
	@echo "  git tag v1.0.0   # créer un tag"
	@echo "  make zip         # génère $(DEST_DIR)/$(NAME)-v1.0.0.zip"
