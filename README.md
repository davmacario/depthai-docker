# DepthAI-Docker

This repository contains Dockerfile, that allows you to run OpenVINO on DepthAI inside a Docker container.

Example script that is ran - `test_openvino.py` - opens `demo.mp4` recording, runs face detection network, crops 
the face from video frame and prints cropped frame size to stdout.

It's purpose is to show the ability to run DepthAI in NCS2 mode

## Run

```
./build_docker.sh
```

The script will build the `Dockerfile` and run the built image (which will run `test_openvino.py`).

Be sure to have [Docker installed](https://docs.docker.com/get-docker/)