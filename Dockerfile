FROM mhart/alpine-node:12.11
MAINTAINER Trey Jones "trey@eyesoreinc.com"

ENV VERSION "8.3.6"
ENV WATCHMAN_VERSION '4.9.0'

RUN apk add --update --no-cache python python-dev py-pip \
	bash libtool openssl-dev \
	git make gcc g++ automake autoconf linux-headers

# stop git from being stupid
RUN git config --global user.email "docker@ng" && git config --global user.name "eyesore ng"

# install watchman
RUN mkdir -p /containerbuild/watchman
ADD https://github.com/facebook/watchman/archive/v${WATCHMAN_VERSION}.zip     /containerbuild/watchman
RUN cd /containerbuild/watchman && \
    unzip v${WATCHMAN_VERSION}.zip && \
    cd watchman-${WATCHMAN_VERSION} && \
    ./autogen.sh && \
    ./configure --enable-lenient && \
    make && \
    make install

RUN npm i @angular/cli@${VERSION} -g

RUN apk del python-dev py-pip automake autoconf linux-headers \
	bash libtool openssl-dev && \
	rm -R /containerbuild/watchman

RUN mkdir /ng && mkdir /ngdist

# mount source
VOLUME /ng

# mount output dir container
VOLUME /ngdist

WORKDIR /ng

ENTRYPOINT ["ng"]
