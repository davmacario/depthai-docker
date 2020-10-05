FROM python:3.8

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install git udev

WORKDIR /app
RUN git clone https://github.com/luxonis/depthai.git
WORKDIR /app/depthai
RUN pip install -r requirements.txt

RUN echo 'SUBSYSTEM=="usb", ATTRS{idVendor}=="03e7", MODE="0666"' | tee /etc/udev/rules.d/80-movidius.rules

CMD python3 depthai_demo.py