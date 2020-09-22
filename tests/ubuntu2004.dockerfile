FROM ubuntu:20.04

RUN apt-get update && apt-get -y install sudo

RUN useradd -m tester && echo "tester:tester" | chpasswd && adduser tester sudo && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER tester
WORKDIR /home/tester

COPY install.sh .

RUN bash install.sh

ADD test.py .

RUN python3 test.py