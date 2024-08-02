FROM debian:bookworm

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y \
    vim \
    git \
    x11-common xserver-xorg \
    build-essential