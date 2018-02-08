FROM alpine AS build-env
RUN apk add --update --no-cache openssl wget curl-dev openssl-dev musl-dev make gcc
RUN wget https://tenet.dl.sourceforge.net/project/dirb/dirb/2.22/dirb222.tar.gz
RUN tar -zxvf dirb222.tar.gz
RUN cd dirb222
RUN chmod +x /dirb222/configure
RUN /dirb222/configure
RUN make

FROM scratch
COPY --from=build-env /dirb /dirb
COPY --from=build-env /dirb222/wordlists /wordlists
COPY --from=build-env /usr/lib/libcurl.so.4 /usr/lib/libcurl.so.4
COPY --from=build-env /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
COPY --from=build-env /lib/libssl.so.43 /lib/libssl.so.43
COPY --from=build-env /lib/libcrypto.so.41 /lib/libcrypto.so.41
COPY --from=build-env /lib/libz.so.1 /lib/libz.so.1
ENTRYPOINT ["/dirb"]
