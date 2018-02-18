FROM buildpack-deps:stretch-curl as downloader

ARG TLA_VERSION=1.5.6
ARG TLA_CHECKSUM=11272c4874866447fc1da9729ce700322e086c9a

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes --no-install-recommends unzip

ADD https://github.com/tlaplus/tlaplus/releases/download/v${TLA_VERSION}/TLAToolbox-${TLA_VERSION}-linux.gtk.x86_64.zip TLAToolbox-${TLA_VERSION}-linux.gtk.x86_64.zip

RUN echo "${TLA_CHECKSUM}  TLAToolbox-${TLA_VERSION}-linux.gtk.x86_64.zip" > TLAToolbox-${TLA_VERSION}-linux.gtk.x86_64.zip.sha1

RUN sha1sum --check --strict TLAToolbox-${TLA_VERSION}-linux.gtk.x86_64.zip.sha1

RUN unzip TLAToolbox-${TLA_VERSION}-linux.gtk.x86_64.zip



FROM openjdk:8u151-jre-stretch as tla

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install libcanberra-gtk-module

COPY --from=downloader ./toolbox /usr/local/bin/toolbox

ENV PATH="$PATH:/usr/local/bin/toolbox"

ENTRYPOINT toolbox
