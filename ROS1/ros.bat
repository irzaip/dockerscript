docker run -it --env="DISPLAY=192.168.88.67:0.0" --rm --env="LIBGL_ALWAYS_SOFTWARE=1" --env="QT_X11_NO_MITSHM=1" -p 11311:11311 --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" osrf/ros:indigo-desktop-full /bin/bash
#export containerId=$(docker ps -l -q)

#docker run -it --env="DISPLAY=192.168.88.67:0.0" --rm --env="QT_X11_NO_MITSHM=1" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" --name ros-gui --hostname ros-gui mjenz/ros-indigo-gui


