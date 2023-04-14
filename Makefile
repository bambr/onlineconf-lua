##### Build defaults #####
LUA_VERSION =       5.1
PREFIX =            /usr/local
LUA_CMODULE_DIR =   $(PREFIX)/lib/lua/$(LUA_VERSION)
LUA_MODULE_DIR =    $(PREFIX)/share/lua/$(LUA_VERSION)
LUA_BIN_DIR =       $(PREFIX)/bin

.PHONY: all install

all: ;

install:
	mkdir -p $(DESTDIR)/$(LUA_MODULE_DIR)
	cp -r lua/* $(DESTDIR)/$(LUA_MODULE_DIR)/
