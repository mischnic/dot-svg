all: graphviz-download graphviz-build main


graphviz-download:
	curl -LO https://www.mirrorservice.org/sites/distfiles.macports.org/graphviz/graphviz-2.40.1.tar.gz
	tar -xf graphviz-2.40.1.tar.gz

.ONESHELL:
graphviz-build:
	cd graphviz-2.40.1

	./configure --quiet
	(cd lib/gvpr && make --quiet mkdefs CFLAGS="-w")

	mkdir FEATURE
	cp -v ../configs/sfio ../configs/vmalloc FEATURE/

	emconfigure ./configure --without-x --without-freetype2 --without-fontconfig --without-libgd --without-glut \
	   --without-sfdp --disable-ltdl --without-ortho --without-digcola --prefix $(realpath ../graphviz) \
	   --disable-java --disable-lua --disable-sharp --enable-static --disable-shared CFLAGS="-Oz -w"
	(cd lib && emmake make -j4 install)
	(cd plugin && emmake make -j4 install)


main:
	emcc -Oz --memory-init-file 0 -s WASM=1 -s MODULARIZE=1 -o dist/dot-wasm.js dot-wasm.c \
	-I graphviz/include -I graphviz/include/graphviz -L graphviz/lib -L graphviz/lib/graphviz \
	-lcdt -lcgraph -lcdt -lgvc -lcdt -lgvplugin_core -lgvc -lgvplugin_dot_layout -lpathplan -lgvc -lcdt -lpathplan \
	-s EXPORTED_RUNTIME_METHODS="['ccall', 'UTF8ToString']"
