docker build -t firefox .
set-variable -name DISPLAY -value 127.0.0.1:0.0
docker run -ti --rm -e DISPLAY=$DISPLAY firefox