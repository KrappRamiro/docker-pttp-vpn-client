# We have to use edge because its the branch were pptclient is located
# https://pkgs.alpinelinux.org/package/edge/testing/x86_64/pptpclient
FROM alpine:edge

# Enable edge/testing repository
# We enable edge/testing repository because thats where pptpclient is
# We also install pptpclient and curl
RUN echo "@testing https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk add --no-cache pptpclient@testing curl

# Create the /dev/ppp device node
RUN mknod /dev/ppp c 108 0

# Debugging and logging configuration
RUN mkdir -p /var/log/ppp


# Start the VPN connection manually with runtime credentials
# See https://ppp.samba.org/pppd.html

# require-mppe   # Enforces Microsoft Point-to-Point Encryption (MPPE) for secure communication
# usepeerdns     # Uses the DNS servers provided by the VPN server for name resolution
# defaultroute   # Adds the VPN connection as the default route for all traffic
# debug          # Enables debug mode to output detailed connection information for troubleshooting
# dump           # Dumps the configuration settings for inspection (useful for debugging)
# logfd 2        # Directs log output to file descriptor 2 (stderr), so it appears in the Docker logs
# silent         # See https://askubuntu.com/a/320384
# nodetach       # Prevents pppd from running in the background, keeping the process attached to the console

CMD pppd pty "pptp $VPN_SERVER --nolaunchpppd" \
    user "$VPN_USER" \
    password "$VPN_PASS" \
    #require-mppe \
    usepeerdns \
    defaultroute \
    debug \
    dump \
    logfd 2 \
    nodetach \
    lcp-echo-interval 30 \
    lcp-echo-failure 4
