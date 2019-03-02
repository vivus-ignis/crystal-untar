FROM ubuntu:bionic
RUN apt-get update && apt-get install -y gnupg2 curl ca-certificates
RUN curl -sL "https://keybase.io/crystal/pgp_keys.asc" | apt-key add -
RUN echo "deb https://dist.crystal-lang.org/apt crystal main" > /etc/apt/sources.list.d/crystal.list
RUN apt-get update && apt-get install -y build-essential git autoconf libtool crystal gdb valgrind
RUN git clone https://github.com/tklauser/libtar.git
WORKDIR /libtar
RUN libtoolize --force \
 && aclocal \
 && autoheader \
 && automake --force-missing --add-missing \
 && autoconf \
 && ./configure \
 && make CFLAGS="-g -DDEBUG" \
 && make install
RUN echo '/usr/local/lib' > /etc/ld.so.conf.d/libtar.conf && ldconfig
