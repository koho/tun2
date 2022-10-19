FROM tun2/socks

FROM p4gefau1t/trojan-go

COPY --from=0 /usr/bin/*tun2socks* /usr/bin/

RUN apk add jq

COPY run.sh /bin/run.sh

ENTRYPOINT []

CMD ["/bin/sh", "/bin/run.sh"]
