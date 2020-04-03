FROM python:alpine
#FROM python:3.7-alpine

# Environment vars we can configure against
# But these are optional, so we won't define them now
#ENV HA_URL http://hass:8123
#ENV HA_KEY secret_key
#ENV DASH_URL http://hass:5050
#ENV EXTRA_CMD -D DEBUG

# API Port
EXPOSE 5050

# Mountpoints for configuration & certificates
VOLUME /conf
VOLUME /certs

# Copy appdaemon into image
WORKDIR /usr/src/app
# COPY . .

# Install timezone data
RUN apk -U upgrade -a && \
    apk add --no-cache git tzdata && \
# Download and build appdaemon
    git clone --branch=dev --recurse-submodules https://github.com/home-assistant/appdaemon.git . && \
# Fix for current dev branch
    pip3  install --no-cache-dir python-dateutil requests

# Install dependencies
RUN apk add --no-cache --virtual build-dependencies gcc openssl-dev libffi-dev musl-dev \
    && pip3 install --no-cache-dir . \
    && apk del build-dependencies

# Install additional packages
RUN apk add --no-cache curl && \
# Start script
    chmod +x /usr/src/app/dockerStart.sh
ENTRYPOINT ["./dockerStart.sh"]
