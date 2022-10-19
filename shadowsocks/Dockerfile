FROM tun2/socks

FROM shadowsocks/shadowsocks-libev

USER root

RUN cd /tmp \
    && apk add --no-cache --virtual .build-deps build-base linux-headers git autoconf libtool automake zlib-dev openssl asciidoc xmlto libpcre32 libev-dev \
    && git clone https://github.com/shadowsocks/simple-obfs.git \
    && cd simple-obfs \
    && git submodule update --init --recursive \
    && ./autogen.sh \
    && ./configure && make \
    && make install \
    && cd /tmp \
    && apk del .build-deps \
    && rm -rf /tmp/simple-obfs

COPY --from=0 /usr/bin/*tun2socks* /usr/bin/

RUN apk add jq libev

COPY run.sh /bin/run.sh

CMD ["/bin/sh", "/bin/run.sh"]
