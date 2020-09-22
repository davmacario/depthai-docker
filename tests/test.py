import cv2
print(f"OpenCV version: {cv2.__version__}")
import numpy
print(f"NumPy version: {numpy.__version__}")
import depthai
print(f"DepthAI version: {depthai.__version__}")
import requests
print(f"Requests version: {requests.__version__}")
try:
    import open3d
    print(f"Open3d version: {open3d.__version__}")
except:
    print(f"Open3d library not found")
import argcomplete

