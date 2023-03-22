#!/bin/bash

set -x

aria2c \
    --https-proxy=$HTTPS_PROXY \
    --http-proxy=$HTTP_PROXY \
    --no-proxy=$NO_PROXY \
    --input-file ./models/links.txt \
    --dir ./models \
    --continue