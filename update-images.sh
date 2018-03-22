#!/bin/bash
docker build $@ base    -t rce/base    && \
docker build $@ relay   -t rce/relay   && \
docker build $@ compute -t rce/compute
