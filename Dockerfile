# Copyright (c) 2018 kalaksi@users.noreply.github.com.
# This work is licensed under the terms of the MIT license. For a copy, see <https://opensource.org/licenses/MIT>.

FROM alpine:3.22.1
LABEL maintainer="kalaksi@users.noreply.github.com"

# See tinyproxy.conf for better explanation of these values.

# The port which the Tinyproxy service will listen on.
ENV PORT="8888"
# Insert any value (preferably "yes") to disable the Via-header:
ENV DISABLE_VIA_HEADER=""
# Set this to e.g. tinyproxy.stats to enable stats-page on that address
ENV STAT_HOST=""
ENV MAX_CLIENTS=""
# A space separated list. If not set or is empty, all networks are allowed.
ENV ALLOWED_NETWORKS=""
# One of Critical, Error, Warning, Notice, Connect, Info
ENV LOG_LEVEL=""
# Maximum number of seconds idle connections are allowed to remain open
ENV TIMEOUT=""
# Username for BasicAuth
ENV AUTH_USER=""
# Password for BasicAuth (letters and digits only)
ENV AUTH_PASSWORD=""
# The preferred way for providing passwords. You can use e.g. docker-compose secrets for which this
# variable has been configured for by default. Alternatively, you could bind-mount the
# password-file manually and change this if necessary
ENV AUTH_PASSWORD_FILE="/run/secrets/auth_password"

# Use a custom UID/GID instead of the default system UID which has a greater possibility
# for collisions with the host and other containers.
ENV TINYPROXY_UID="57981"
ENV TINYPROXY_GID="57981"

# Curl is for healthchecks.
RUN apk add --no-cache tinyproxy curl

RUN mv /etc/tinyproxy/tinyproxy.conf /etc/tinyproxy/tinyproxy.default.conf && \
    chown -R ${TINYPROXY_UID}:${TINYPROXY_GID} /etc/tinyproxy /var/log/tinyproxy

EXPOSE 8888

# Tinyproxy seems to be OK for getting privileges dropped beforehand
USER ${TINYPROXY_UID}:${TINYPROXY_GID}
CMD set -eu; \
    CONFIG='/etc/tinyproxy/tinyproxy.conf'; \
    if [ ! -f "$CONFIG"  ]; then \
        cp /etc/tinyproxy/tinyproxy.default.conf "$CONFIG"; \
        sed -i "s|^Allow |#Allow |" "$CONFIG"; \
        [    "$PORT" != "8888" ]                              && sed -i "s|^Port 8888|Port $PORT|" "$CONFIG"; \
        [ -z "$DISABLE_VIA_HEADER" ]                          || sed -i "s|^#DisableViaHeader .*|DisableViaHeader Yes|" "$CONFIG"; \
        [ -z "$STAT_HOST" ]                                   || sed -i "s|^#StatHost .*|StatHost \"${STAT_HOST}\"|" "$CONFIG"; \
        [ -z "$MAX_CLIENTS" ]                                 || sed -i "s|^MaxClients .*|MaxClients $MAX_CLIENTS|" "$CONFIG"; \
        [ -z "$ALLOWED_NETWORKS" ]                            || for network in $ALLOWED_NETWORKS; do echo "Allow $network" >> "$CONFIG"; done; \
        [ -z "$LOG_LEVEL" ]                                   || sed -i "s|^LogLevel .*|LogLevel ${LOG_LEVEL}|" "$CONFIG"; \
        [ -z "$TIMEOUT" ]                                     || sed -i "s|^Timeout .*|Timeout ${TIMEOUT}|" "$CONFIG"; \
        [ -z "$AUTH_USER" ] || [ -z "$AUTH_PASSWORD" ]        || sed -i "s|^#BasicAuth .*|BasicAuth ${AUTH_USER} ${AUTH_PASSWORD}|" "$CONFIG"; \
        [ -z "$AUTH_USER" ] || [ ! -f "$AUTH_PASSWORD_FILE" ] || sed -Ei "s|^#?BasicAuth .*|BasicAuth ${AUTH_USER} $(cat "$AUTH_PASSWORD_FILE")|" "$CONFIG"; \
        sed -i 's|^LogFile |# LogFile |' "$CONFIG"; \
    fi; \
    exec /usr/bin/tinyproxy -d;
