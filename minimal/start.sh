#!/bin/bash

docker build -t depthai .
docker run --rm \
  -v /dev/bus/usb:/dev/bus/usb \
  --device-cgroup-rule='c 189:* rmw' \
  depthai