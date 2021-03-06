all:

.ONESHELL:

graphviz-2.42.3.tar.gz:
	curl -LO https://www2.graphviz.org/Packages/stable/portable_source/graphviz-2.42.3.tar.gz

graphviz-2.42.3: graphviz-2.42.3.tar.gz
	tar -xf graphviz-2.42.3.tar.gz

.PHONY: graphviz-build
graphviz-build: graphviz-2.42.3
	set -e
	cd graphviz-2.42.3

	./configure
	(cd lib/gvpr && make --quiet mkdefs CFLAGS="-w") # build the mkdefs binary

	mkdir -p FEATURE
	cp -v ../configs/sfio ../configs/vmalloc FEATURE/

	emconfigure ./configure --without-x --without-freetype2 --without-fontconfig --without-libgd --without-glut \
	    --without-sfdp --disable-ltdl --without-ortho --without-digcola --prefix $(CURDIR)/graphviz \
	    --disable-java --disable-lua --disable-sharp --enable-static --disable-shared \
	    CFLAGS="-Oz -w -flto" LDFLAGS="-Oz -s MALLOC=dlmalloc -flto"

	# https://github.com/emscripten-core/emscripten/issues/10331
# 	sed -i .bak 's:/\* #undef HAVE_DRAND48 \*/:#define\ HAVE_DRAND48\ 1:g' config.h

	(cd lib && emmake make -j4 install)
	(cd plugin && emmake make -j4 install)

.PHONY: dist
dist: dist/index-node.js dist/index-browser.js

.PHONY: dist/index-node.js
dist/index-node.js:
	mkdir -p dist
	emcc --memory-init-file 0 -s MODULARIZE=1 -s FILESYSTEM=0 -o dist/index-node.js dot-wasm.c \
	    -I graphviz/include -I graphviz/include/graphviz -L graphviz/lib -L graphviz/lib/graphviz \
	    -lcdt -lcgraph -lcdt -lgvc -lcdt -lgvplugin_core -lgvc -lgvplugin_dot_layout -lpathplan -lgvc -lcdt -lpathplan \
	    -s EXPORTED_RUNTIME_METHODS="['cwrap', 'UTF8ToString']" -s ENVIRONMENT="node" \
	    -s ASSERTIONS=0 -flto --llvm-lto 1 -Oz --closure 1

.PHONY: dist/index-browser.js
dist/index-browser.js:
	mkdir -p dist
	emcc --memory-init-file 0 -s MODULARIZE=1 -s FILESYSTEM=0 -o dist/index-browser.js dot-wasm.c \
	    -I graphviz/include -I graphviz/include/graphviz -L graphviz/lib -L graphviz/lib/graphviz \
	    -lcdt -lcgraph -lcdt -lgvc -lcdt -lgvplugin_core -lgvc -lgvplugin_dot_layout -lpathplan -lgvc -lcdt -lpathplan \
	    -s EXPORTED_RUNTIME_METHODS="['cwrap', 'UTF8ToString']" -s ENVIRONMENT="web,worker" \
	    -s ASSERTIONS=0 -flto --llvm-lto 1 -Oz --closure 1

dot-wasm-native: dot-wasm-native.c
	clang -g dot-wasm-native.c -o dot-wasm-native \
	    -I/usr/local/include/ -L/usr/local/lib -L/usr/local/lib/graphviz \
	    -lcgraph -lcdt -lgvpr -lgvc -lgvplugin_core -lgvplugin_dot_layout