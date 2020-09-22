#!/bin/bash

set -e
docker-compose build rpi

docker-compose up -d rpi

until sshpass -p "raspberry" ssh -p 2222 pi@localhost true >/dev/null 2>&1; do
  echo "wait"
  sleep 0.1
done

echo "dsada"

sshpass -p "raspberry" scp -P 2222 install.sh pi@localhost:/home/pi/install.sh
echo "TOO"
sshpass -p "raspberry" ssh -p 2222 pi@localhost bash install.sh
