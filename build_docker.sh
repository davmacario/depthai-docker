#!/bin/bash

docker build -t testimage .
docker run --rm \
  -v /dev/bus/usb:/dev/bus/usb \
  --device-cgroup-rule='c 189:* rmw' \
  testimage