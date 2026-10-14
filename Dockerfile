FROM debian:stable AS build

# Install build dependencies
RUN apt-get update && apt-get -y install \
	apt-utils build-essential devscripts fakeroot debhelper git lsb-release \
	libterm-readline-gnu-perl  libterm-readline-perl-perl libdistro-info-perl \
        gh ca-certificates wget python3-pip --no-install-recommends

# Install all test suite dependencies via native APT packages
RUN apt-get -y install \
    python3-pip \
    python3-attr python3-autobahn python3-automat python3-certifi python3-cffi \
    python3-charset-normalizer python3-constantly python3-construct python3-hyperlink \
    python3-idna python3-incremental python3-lxml python3-netifaces python3-numpy \
    python3-pycparser python3-openssl python3-yaml python3-requests \
    python3-service-identity python3-six python3-twisted python3-txaio \
    python3-typing-extensions python3-urllib3 python3-zope.interface python3-scapy \
    --no-install-recommends

# Install the 3 packages not available in Debian apt repositories
RUN pip3 install starpy@git+https://github.com/asterisk/starpy@1.1.1 --break-system-packages

ARG REL_VER
ARG RPT_VER
ARG AST_VER

RUN test -n "$REL_VER" && \
    test -n "$RPT_VER" && \
    test -n "$AST_VER"

#WORKDIR /usr/src
# Use build-asl3 to create current packages, then install, then re-create with linked source.
# This gets all of our config file properly setup.
ENV REL_VER=$REL_VER
ENV RPT_VER=$RPT_VER
ENV AST_VER=$AST_VER

RUN  git clone https://github.com/AllStarLink/asl3-asterisk.git && \
    ./asl3-asterisk/build-asl3 -t source build package && \
    cd /usr/src && \
    dpkg -i *.deb && \
    rm *.deb 
