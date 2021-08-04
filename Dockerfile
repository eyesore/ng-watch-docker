FROM node:14-alpine3.14 as base
MAINTAINER Trey Jones "trey@cortexdigitalinc.com"

ENV VERSION '^12.0.0'
ENV ANGULAR_PATH '/usr/local/lib/node_modules/@angular'

#############################
FROM base as builder
RUN npm i @angular/cli@${VERSION} -g

#################################
# I checked at v12, it's about 10% smaller than just using one stage
FROM base as release
COPY --from=builder "${ANGULAR_PATH}" "${ANGULAR_PATH}"
RUN mkdir /ng && mkdir /ngdist && ln -s "${ANGULAR_PATH}/cli/bin/ng" /usr/local/bin/ng

# mount source
VOLUME /ng

# mount output dir container
VOLUME /ngdist

WORKDIR /ng

ENTRYPOINT ["ng"]
