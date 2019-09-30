FROM mhart/alpine-node:11.9
MAINTAINER Trey Jones "trey@eyesoreinc.com"

ENV VERSION "8.3.6"
ENV WATCHMAN_VERSION '4.9.0'

RUN apk add --update --no-cache python python-dev py-pip \
	bash libtool openssl-dev \
	git make gcc g++ automake autoconf linux-headers

# stop git from being stupid
RUN git config --global user.email "docker@ng" && git config --global user.name "eyesore ng"

# install watchman
RUN mkdir -p /build/watchman/
ADD https://github.com/facebook/watchman/archive/v${WATCHMAN_VERSION}.zip     /build/watchman
RUN cd /build/watchman && \
    unzip v${WATCHMAN_VERSION}.zip && \
    cd watchman-${WATCHMAN_VERSION} && \
    ./autogen.sh && \
    ./configure --enable-lenient && \
    make && \
    make install

RUN npm i @angular/cli@${VERSION} -g

RUN apk del python-dev py-pip automake autoconf linux-headers \
	bash libtool openssl-dev && \
	rm -R /build/watchman

RUN mkdir /ng

# mount source
VOLUME /ng
# mount output dir container
VOLUME /build

WORKDIR /ng

ENTRYPOINT ["ng"]
