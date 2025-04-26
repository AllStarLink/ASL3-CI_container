FROM debian:stable as build

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y wget procps

RUN sysctl net.ipv6.conf.all.disable_ipv6 && \
    cd /usr/src && \
    ls -la && \
    wget https://docs.phreaknet.org/script/phreaknet.sh && \
    chmod +x phreaknet.sh && \
    ./phreaknet.sh make && \
    phreaknet install --dahdi --lightweight --alsa --fast --devmode --testsuite
