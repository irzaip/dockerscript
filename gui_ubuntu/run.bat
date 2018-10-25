docker build -t firefox .
set -name DISPLAY -value 127.0.0.1:0.0
docker run -ti --rm -e DISPLAY=192.168.88.67:0.0 firefox