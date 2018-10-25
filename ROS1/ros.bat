docker run -it --env="DISPLAY" --rm --env="QT_X11_NO_MITSHM=1" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" osrf/ros:indigo-desktop-full /bin/bash
export containerId=$(docker ps -l -q)