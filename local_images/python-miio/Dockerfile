FROM alpine

RUN apk add --no-cache python3-dev libffi-dev openssl-dev build-base linux-headers && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    rm -rf /root/.cache /var/cache/apk/*

RUN pip3 install python-miio

ENTRYPOINT mirobo discover
