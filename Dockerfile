FROM openvino/ubuntu18_dev:2020.4
# FROM openvino/ubuntu20_dev:latest

WORKDIR /app/
ADD models/face-detection-retail-0004/ models/face-detection-retail-0004/
ADD demo.mp4 .
ADD test_openvino.py .
USER root
RUN apt-get update
RUN apt-get install -y python3 python3-pip udev
RUN echo 'SUBSYSTEM=="usb", ATTRS{idVendor}=="03e7", MODE="0666"' | tee /etc/udev/rules.d/80-movidius.rules
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y build-essential cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev
RUN apt-get install -y ffmpeg libsm6 libxext6 libgl1-mesa-glx
RUN python3 -m pip install --upgrade pip

USER openvino
ENV PYTHONUNBUFFERED 1

CMD source /opt/intel/openvino/bin/setupvars.sh && python3 test_openvino.py

### Added:
RUN apt-get install usbutils libusb-1.0-0-dev -y
# RUN lsusb
# RUN uname -a
# RUN lsb_release -a
# RUN lsusb -v
# RUN ls -la /dev/bus/usb
# RUN ls -la /sys/bus/usb
#CMD source /opt/intel/openvino/bin/setupvars.sh && uname -a && lsb_release -a && ls -la /dev/bus/usb && ls -la /sys/bus/usb/devices