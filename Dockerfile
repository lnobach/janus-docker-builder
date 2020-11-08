FROM alpine:3.12

RUN apk add --no-cache sudo curl autoconf automake libtool pkgconf build-base \
  glib-dev libconfig-dev libnice-dev jansson-dev openssl-dev zlib \
  gengetopt libwebsockets-dev git

ARG USRSCTP_VERSION=4098a99f47eb7145f6f7ce0b66a19f6b1b13ebfa
ARG LIBSRTP_VERSION=v2.3.0
ARG JANUS_VERSION=v0.10.7

RUN cd /tmp && \
    git clone https://github.com/sctplab/usrsctp && \
    cd usrsctp && \
    git checkout $USRSCTP_VERSION && \
    ./bootstrap && \
    ./configure --prefix=/usr && \
    make && make install && \
    rm -r /tmp/usrsctp


RUN cd /tmp && \
    git clone https://github.com/cisco/libsrtp && \
    cd libsrtp && \
    git checkout $LIBSRTP_VERSION && \
    ./configure --prefix=/usr --enable-openssl && \
    make shared_library && make install && \
    rm -r /tmp/libsrtp

# JANUS

RUN cd /tmp && \
    git clone https://github.com/meetecho/janus-gateway && \
    cd janus-gateway && \
    git checkout $JANUS_VERSION && \
    ./autogen.sh && \
    ./configure --disable-rabbitmq --disable-mqtt --disable-boringssl && \
    make && \
    make install && \
    make configs && \
    rm -r /tmp/janus-gateway && \
    adduser --uid 1000 -D janus

COPY entrypoint /entrypoint

CMD [ "/entrypoint" ]
