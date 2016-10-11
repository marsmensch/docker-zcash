#
# Dockerfile for the zcash beta and integrated cpuminer
# usage: docker run marsmensch/zcash-cpuminer
#
# tip me BTC at 1PboFDkBsW2i968UnehWwcSrM9Djq5LcLB
#▒███████▒ ▄████▄   ▄▄▄        ██████  ██░ ██ 
#▒ ▒ ▒ ▄▀░▒██▀ ▀█  ▒████▄    ▒██    ▒ ▓██░ ██▒
#░ ▒ ▄▀▒░ ▒▓█    ▄ ▒██  ▀█▄  ░ ▓██▄   ▒██▀▀██░
#  ▄▀▒   ░▒▓▓▄ ▄██▒░██▄▄▄▄██   ▒   ██▒░▓█ ░██ 
#▒███████▒▒ ▓███▀ ░ ▓█   ▓██▒▒██████▒▒░▓█▒░██▓
#░▒▒ ▓░▒░▒░ ░▒ ▒  ░ ▒▒   ▓▒█░▒ ▒▓▒ ▒ ░ ▒ ░░▒░▒
#░░▒ ▒ ░ ▒  ░  ▒     ▒   ▒▒ ░░ ░▒  ░ ░ ▒ ░▒░ ░
#░ ░ ░ ░ ░░          ░   ▒   ░  ░  ░   ░  ░░ ░
#  ░ ░    ░ ░            ░  ░      ░   ░  ░  ░
#░        ░   
#
# Step-by-step to start mining interactively on testnet
# 1) start the container
# docker run --interactive --tty --entrypoint=/bin/bash marsmensch/docker-zcash
#
# 2) run the zcashd daemon 
# zcashd -daemon
#
# 3) check the current state
# zcash-cli getinfo
# 
# You can also benchmark your configuration with
# time /usr/local/bin/zcash-cli zcbenchmark solveequihash 10

FROM		ubuntu:14.04
MAINTAINER Florian Maier <contact@marsmenschen.com>

ENV GIT_URL        git://github.com/zcash/zcash.git
ENV ZCASH_VERSION  v1.0.0-beta2
ENV REFRESHED_AT   2016-09-12
ENV ZCASH_CONF     /root/.zcash/zcash.conf

# install dependencies
RUN apt-get autoclean && apt-get autoremove && apt-get update && \
    apt-get -qqy install --no-install-recommends build-essential \
    automake ncurses-dev libcurl4-openssl-dev libssl-dev libgtest-dev \
    make autoconf automake libtool git apt-utils pkg-config libc6-dev \
    libcurl3-dev libudev-dev m4 g++-multilib unzip git python zlib1g-dev \
    wget bsdmainutils && \
    rm -rf /var/lib/apt/lists/*
    
# create code directory
RUN echo "check_certificate = off" > /root/.wgetrc && mkdir -p /opt/code/; cd /opt/code; \
    git clone ${GIT_URL} zcash && cd zcash && git checkout ${ZCASH_VERSION} && \
    ./zcutil/fetch-params.sh && ./zcutil/build.sh -j4 && cd /opt/code/zcash/src && \
    /usr/bin/install -c bitcoin-tx zcashd zcash-cli zcash-gtest -t /usr/local/bin/ && \
    rm -rf /opt/code/

# generate a dummy config    
RUN PASS=$(date | md5sum | cut -c1-24); mkdir -p /root/.zcash/; \
    printf '%s\n%s\n%s\n%s\n%s\n' "rpcuser=zcashrpc" "rpcpassword=${PASS}" \
    "testnet=1" "addnode=betatestnet.z.cash" "gen=1" >> ${ZCASH_CONF}     

# no parameters display help
ENTRYPOINT ["/usr/local/bin/zcashd"]
CMD ["--help"]
