# Base image
FROM ubuntu:20.04

# Set Timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN apt-get update &&  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git \
    unzip \
    clang \
    xserver-xorg \
    pkg-config \
    libgtk-3-dev \
    curl \
    cmake \
    ninja-build \
    wget \
    gnupg

RUN sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -

# RUN apt update && apt install -y google-chrome-stable

# Workdir
WORKDIR /workspace

# Setup Flutter
RUN git clone https://github.com/flutter/flutter.git && \
    mv flutter /opt/

ENV PATH $PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/flutter/bin

RUN flutter --version && \
    flutter doctor %% \
    flutter pub get

