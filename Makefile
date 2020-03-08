all: graphviz-2.42.3 graphviz-build dist/index.js

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
	   CFLAGS="-Oz -w" LDFLAGS="-Oz -s MALLOC=dlmalloc"

	# https://github.com/emscripten-core/emscripten/issues/10331
	sed -i .bak 's:/\* #undef HAVE_DRAND48 \*/:#define\ HAVE_DRAND48\ 1:g' config.h

	(cd lib && emmake make -j4 install)
	(cd plugin && emmake make -j4 install)

.PHONY: dist/index.js
dist/index.js:
	mkdir -p dist
	emcc --memory-init-file 0 -s MODULARIZE=1 -s NO_FILESYSTEM=1 -o dist/index.js dot-wasm.c \
	-I graphviz/include -I graphviz/include/graphviz -L graphviz/lib -L graphviz/lib/graphviz \
	-lcdt -lcgraph -lcdt -lgvc -lcdt -lgvplugin_core -lgvc -lgvplugin_dot_layout -lpathplan -lgvc -lcdt -lpathplan \
	-s EXPORTED_RUNTIME_METHODS="['cwrap', 'UTF8ToString']" -s ASSERTIONS=0 --llvm-lto 1 -Oz --closure 1
