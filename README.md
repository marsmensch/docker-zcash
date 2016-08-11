[![](https://images.microbadger.com/badges/version/marsmensch/docker-zcash.svg)](http://microbadger.com/images/marsmensch/docker-zcash "Get your own version badge on microbadger.com")

# Dockerfile for the zcash alpha and cpuminer

usage: docker run marsmensch/zcash-cpuminer

Step-by-step to start mining interactively on testnet
1) start the container
docker run --interactive --tty --entrypoint=/bin/bash marsmensch/docker-zcash

2) run the zcashd daemon 
zcashd -daemon

3) check the current state
zcash-cli getinfo

tip me BTC at 1PboFDkBsW2i968UnehWwcSrM9Djq5LcLB
