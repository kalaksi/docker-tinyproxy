FROM alpine:3.10.3
LABEL maintainer="kalaksi@users.noreply.github.com"

# See tinyproxy.conf for better explanation of these values.
# Insert any value (preferably "yes") to disable the Via-header:
ENV DISABLE_VIA_HEADER ""
# Set this to e.g. tinyproxy.stats to enable stats-page on that address:
ENV STAT_HOST ""
ENV MAX_CLIENTS ""
ENV MIN_SPARE_SERVERS ""
ENV MAX_SPARE_SERVERS ""
# A space separated list:
ENV ALLOWED_NETWORKS ""

# Use a custom UID/GID instead of the default system UID which has a greater possibility
# for collisions with the host and other containers.
ENV TINYPROXY_UID 57981
ENV TINYPROXY_GID 57981

RUN apk add --no-cache \
      tinyproxy

RUN mv /etc/tinyproxy/tinyproxy.conf /etc/tinyproxy/tinyproxy.default.conf && \
    chown -R ${TINYPROXY_UID}:${TINYPROXY_GID} /etc/tinyproxy /var/run/tinyproxy /var/log/tinyproxy

EXPOSE 8888

# Tinyproxy seems to be OK for getting privileges dropped beforehand
USER ${TINYPROXY_UID}:${TINYPROXY_GID}
CMD set -eu; \
    CONFIG='/etc/tinyproxy/tinyproxy.conf'; \
    if [ ! -f "$CONFIG"  ]; then \
        cp /etc/tinyproxy/tinyproxy.default.conf "$CONFIG"; \
        ([ -z "$DISABLE_VIA_HEADER" ] || sed -i "s|^#DisableViaHeader .*|DisableViaHeader Yes|" "$CONFIG"); \
        ([ -z "$STAT_HOST" ]          || sed -i "s|^#StatHost .*|StatHost \"${STAT_HOST}\"|" "$CONFIG"); \
        ([ -z "$MIN_SPARE_SERVERS" ]  || sed -i "s|^MinSpareServers .*|MinSpareServers $MIN_SPARE_SERVERS|" "$CONFIG"); \
        ([ -z "$MIN_SPARE_SERVERS" ]  || sed -i "s|^StartServers .*|StartServers $MIN_SPARE_SERVERS|" "$CONFIG"); \
        ([ -z "$MAX_SPARE_SERVERS" ]  || sed -i "s|^MaxSpareServers .*|MaxSpareServers $MAX_SPARE_SERVERS|" "$CONFIG"); \
        ([ -z "$ALLOWED_NETWORKS" ]   || for network in $ALLOWED_NETWORKS; do echo "Allow $network" >> "$CONFIG"; done); \
        sed -i 's|^LogFile |# LogFile |' "$CONFIG"; \
    fi; \
    exec /usr/bin/tinyproxy -d;
