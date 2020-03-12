FROM ubuntu

RUN apt-get update && \
    apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
        bash-completion \
        ca-certificates \
        cmake \
        less \
        man-db \
        nano \
        pkg-config \
        sudo \
        tree \
        vim \
        wget \
        xz-utils \
        build-essential \
        git \
        unzip \
        libjack-jackd2-dev \
        libmp3lame-dev \
        libopencore-amrnb-dev \
        libopencore-amrwb-dev \
        libsdl1.2-dev \
        libtheora-dev \
        libva-dev \
        libvdpau-dev \
        libvorbis-dev \
        libx11-dev \
        libxfixes-dev \
        libxvidcore-dev \
        texi2html \
        yasm \
        zlib1g-dev \
        libsdl1.2-dev \
        libvpx-dev \
        libopus-dev \
        libjpeg-dev \
        libtiff5-dev \
        libpng-dev \
        libgstreamer-plugins-base1.0-0 \
        libgstreamer-plugins-base1.0-dev \
        libgstreamer1.0-0 \
        libgstreamer1.0-dev \
        gstreamer1.0-plugins-base \
        gstreamer1.0-plugins-good \
        gstreamer1.0-plugins-bad \
        gstreamer1.0-plugins-ugly \
        gstreamer1.0-libav \
        gstreamer1.0-omx \
        gstreamer1.0-tools \
        libavcodec-dev \
        libavformat-dev \
        libswscale-dev \
        libv4l-dev \
        v4l-utils \
        libxvidcore-dev \
        libx264-dev \
        x264 \
        libavcodec-dev \
        libavformat-dev \
        libswscale-dev \
        libv4l-dev \
        v4l-utils \
        libass-dev \
        libhdf5-dev \
        libhdf5-serial-dev \
        libgtk2.0-dev \
        libqt4-dev \
        libqt4-opengl-dev \
        libatlas-base-dev \
        gfortran \
        python3-pip \
        python3.7-dev \
        python-dev \
        python3.7 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1

RUN git clone git://source.ffmpeg.org/ffmpeg.git /sources/ffmpeg
WORKDIR /sources/ffmpeg
RUN ./configure \
  --enable-gpl \
  --enable-libass \
  --enable-shared \
  --disable-static \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-nonfree
RUN make -j$(nproc)
RUN make -j$(nproc) install
RUN ldconfig -v

RUN git clone --recurse-submodules --branch 4.2.0 https://github.com/opencv/opencv.git /sources/opencv
RUN git clone --recurse-submodules --branch 4.2.0 https://github.com/opencv/opencv_contrib.git /sources/opencv-contrib
WORKDIR /sources/opencv/build
RUN python3.7 -m pip install -U pip setuptools
RUN python3.7 -m pip install numpy
RUN ln -sf /usr/bin/python3.7 /usr/bin/python3
RUN apt-get install -y libgtk2.0-dev libtbb-dev qt5-default libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libavresample-dev
RUN cmake \
  -D CMAKE_BUILD_TYPE=RELEASE \
  -D CMAKE_INSTALL_PREFIX=/usr/local \
  -D WITH_TBB=ON \
  -D BUILD_NEW_PYTHON_SUPPORT=ON \
  -D WITH_V4L=ON \
  -D INSTALL_C_EXAMPLES=ON \
  -D INSTALL_PYTHON_EXAMPLES=ON \
  -D BUILD_EXAMPLES=ON \
  -D WITH_QT=ON \
  -D WITH_OPENGL=ON \
  -D WITH_FFMPEG=ON \
  ..
RUN make -j$(nproc)
RUN make -j$(nproc) install
RUN ldconfig -v

ENV OpenCV_DIR=/sources/opencv/build

WORKDIR /sources/openvino-source
COPY vino_install.conf .
RUN apt-get install --yes cpio
RUN wget https://gas-and-oil-storage.s3.amazonaws.com/vino.tgz
RUN tar -xvzf vino.tgz --strip-components=1
RUN bash install.sh --silent vino_install.conf
RUN bash /sources/openvino/openvino/deployment_tools/inference_engine/samples/build_samples.sh

ENV LD_LIBRARY_PATH=/opt/intel/opencl:/sources/openvino/openvino_2019.3.376/deployment_tools/inference_engine/external/hddl/lib:/sources/openvino/openvino_2019.3.376/deployment_tools/inference_engine/external/gna/lib:/sources/openvino/openvino_2019.3.376/deployment_tools/inference_engine/external/mkltiny_lnx/lib:/sources/openvino/openvino_2019.3.376/deployment_tools/inference_engine/external/tbb/lib:/sources/openvino/openvino_2019.3.376/deployment_tools/inference_engine/lib/intel64:/sources/openvino/openvino_2019.3.376/openvx/lib
ENV INTEL_CVSDK_DIR=/sources/openvino/openvino_2019.3.376
ENV InferenceEngine_DIR=/sources/openvino/openvino_2019.3.376/deployment_tools/inference_engine/share
ENV PYTHONPATH=/sources/openvino/openvino_2019.3.376/python/python3.7:/sources/openvino/openvino_2019.3.376/python/python3:/sources/openvino/openvino_2019.3.376/deployment_tools/open_model_zoo/tools/accuracy_checker:/sources/openvino/openvino_2019.3.376/deployment_tools/model_optimizer
ENV INTEL_OPENVINO_DIR=/sources/openvino/openvino_2019.3.376
ENV HDDL_INSTALL_DIR=/sources/openvino/openvino_2019.3.376/deployment_tools/inference_engine/external/hddl
ENV PATH=$PATH:/sources/openvino/openvino_2019.3.376/deployment_tools/model_optimizer

RUN apt-get install -y libgeos-dev curl autoconf libtool

RUN mkdir -p /etc/udev/rules.d/ &&  echo -e "\
SUBSYSTEM==\"usb\", ATTRS{idProduct}==\"2150\", ATTRS{idVendor}==\"03e7\", GROUP=\"users\", MODE=\"0666\", ENV{ID_MM_DEVICE_IGNORE}=\"1\"\n\
SUBSYSTEM==\"usb\", ATTRS{idProduct}==\"2485\", ATTRS{idVendor}==\"03e7\", GROUP=\"users\", MODE=\"0666\", ENV{ID_MM_DEVICE_IGNORE}=\"1\"\n\
SUBSYSTEM==\"usb\", ATTRS{idProduct}==\"f63b\", ATTRS{idVendor}==\"03e7\", GROUP=\"users\", MODE=\"0666\", ENV{ID_MM_DEVICE_IGNORE}=\"1\"\n\
" > /etc/udev/rules.d/97-myriad-usbboot.rules && ldconfig

WORKDIR /opt
RUN curl -L https://github.com/libusb/libusb/archive/v1.0.22.zip --output v1.0.22.zip && \
    unzip v1.0.22.zip && cd libusb-1.0.22 && \
    ./bootstrap.sh && \
    ./configure --disable-udev --enable-shared && \
    make -j4
RUN apt-get update && \
    apt-get install -y --no-install-recommends libusb-1.0-0-dev && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /opt/libusb-1.0.22/libusb
RUN /bin/mkdir -p '/usr/local/lib' && \
    /bin/bash ../libtool   --mode=install /usr/bin/install -c   libusb-1.0.la '/usr/local/lib' && \
    /bin/mkdir -p '/usr/local/include/libusb-1.0' && \
    /usr/bin/install -c -m 644 libusb.h '/usr/local/include/libusb-1.0' && \
    /bin/mkdir -p '/usr/local/lib/pkgconfig' && \
    cd  /opt/libusb-1.0.22/ && \
    /usr/bin/install -c -m 644 libusb-1.0.pc '/usr/local/lib/pkgconfig' && \
    ldconfig

RUN python3 -m pip install requests pyyaml
# Add samples
WORKDIR /root
COPY openvino_python_samples/ ./openvino_python_samples/

ENV MODELS_PATH /root/openvino_models/
RUN python3 /sources/openvino/openvino/deployment_tools/tools/model_downloader/downloader.py --name face-detection-retail* --output_dir $MODELS_PATH
RUN python3 /sources/openvino/openvino/deployment_tools/tools/model_downloader/downloader.py --name age-gender-recognition-retail* --output_dir $MODELS_PATH

CMD python3 /root/openvino_python_samples/openvino_face_detection.py --face-target-device MYRIAD --ag-target-device MYRIAD --face-model-xml $MODELS_PATH/intel/face-detection-retail-0005/FP32/face-detection-retail-0005.xml --face-model-bin $MODELS_PATH/intel/face-detection-retail-0005/FP32/face-detection-retail-0005.bin --ag-model-xml $MODELS_PATH/intel/age-gender-recognition-retail-0013/FP32/age-gender-recognition-retail-0013.xml --ag-model-bin $MODELS_PATH/intel/age-gender-recognition-retail-0013/FP32/age-gender-recognition-retail-0013.bin --input-type cam --input 0