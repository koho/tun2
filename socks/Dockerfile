FROM alpine:3.16

RUN cd /tmp && wget https://github.com/ambrop72/badvpn/archive/master.zip && unzip master.zip \
    && mkdir badvpn-master/build && cd badvpn-master/build \
    && apk add --no-cache --virtual .build-deps build-base cmake linux-headers git autoconf libtool automake zlib-dev openssl asciidoc xmlto libpcre32 libev-dev \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_TUN2SOCKS=1 \
    && make install \
    && apk del .build-deps \
    && cd /tmp \
    && rm -rf /tmp/master.zip /tmp/badvpn-master

COPY tun2socks.sh /usr/bin/

ENTRYPOINT ["/usr/bin/badvpn-tun2socks"]
