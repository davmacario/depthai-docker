# DepthAI-Docker

This repository contains Dockerfile, that allows you to run OpenVINO on DepthAI inside a Docker container

```
docker-compose build
docker-compose run main
```

Output (produces an error now)
```
WARNING: No Argument Control Done, You Can GET Runtime Errors
Available Devices:  ['CPU', 'MYRIAD']
Loading Face Detection Model   ....
Face Detection Input Layer:  input.1
Face Detection Output Layer:  527
Face Detection Input Shape:  [1, 3, 300, 300]
Face Detection Output Shape:  [1, 1, 200, 7]
E: [xLink] [      4013] [EventRead00Thr] eventReader:218	eventReader thread stopped (err -4)
E: [xLink] [      4013] [Scheduler00Thr] eventSchedulerRun:576	Dispatcher received NULL event!
E: [ncAPI] [      5013] [python3] ncDeviceOpen:965	can't open deviceMonitor stream due to unknown error
Traceback (most recent call last):
  File "/root/openvino_python_samples/openvino_face_detection.py", line 405, in <module>
    run_app()
  File "/root/openvino_python_samples/openvino_face_detection.py", line 87, in run_app
    FaceDetectionExecutable = OpenVinoIE.load_network(network=FaceDetectionNetwork, device_name=arguments.face_target_device)
  File "ie_api.pyx", line 85, in openvino.inference_engine.ie_api.IECore.load_network
  File "ie_api.pyx", line 92, in openvino.inference_engine.ie_api.IECore.load_network
RuntimeError: Can not init Myriad device: NC_ERROR
```