# Based on the LinuxServer.io DuckDNS image https://github.com/linuxserver/docker-duckdns
# and other images, like the Unifi controller https://github.com/linuxserver/docker-unifi-controller/blob/master/Dockerfile

# Using Ubuntu instead of Alpine, since MBBSEmu is not Alpine compatible.
FROM lsiobase/ubuntu:focal

# version from the MBBSEMU repo: https://github.com/mbbsemu/MBBSEmu/releases
ARG VERSION="042822-1"

LABEL build_version="MBBSEmu version:- ${VERSION}"
LABEL maintainer="kwilliams312"

# Gets rid of an obnoxious, red, scary looking non-error during build.
# https://askubuntu.com/questions/344962/how-do-i-correct-this-error-with-debootstrap-in-ubuntu-server-12-04-3
ARG DEBIAN_FRONTEND=noninteractive

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENV DOTNET_BUNDLE_EXTRACT_BASE_DIR=/tmp

ENV CONFIG_PATH=/config
ENV EMULATOR_PATH=/app

# note libicu66 is specific to ubuntu 20.04, libicu60 is for 18.04
RUN \
 apt-get update && apt upgrade -y && \
 apt-get install -qy --no-install-recommends \
	libicu66 \
	wget \
	unzip 


RUN cd ${EMULATOR_PATH}
RUN wget https://github.com/mbbsemu/MBBSEmu/releases/download/v1.0-alpha-042822/mbbsemu-linux-x64-${VERSION}.zip        
RUN unzip mbbsemu-linux-x64-${VERSION}.zip
RUN rm mbbsemu*.zip

RUN chmod a+x MBBSEmu

VOLUME ${CONFIG_PATH}
WORKDIR ${CONFIG_PATH}
