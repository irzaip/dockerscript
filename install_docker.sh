#!/bin/bash

# uninstall old docker
sudo apt remove -y docker docker-engine docker.io docker-compose
if [ -f /usr/local/bin/docker-compose ]; then sudo rm /usr/local/bin/docker-compose; fi
# Update the apt package index
sudo apt update
# Install packages to allow apt to use a repository over HTTPS
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# Verify that you now have the key with the fingerprint 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88, 
# by searching for the last 8 characters of the fingerprint.
sudo apt-key fingerprint 0EBFCD88
# set up the stable repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# Update the apt package index
sudo apt update
# Install the latest version of Docker CE
sudo apt install -y docker-ce
# install docker-compose
# sudo apt  install -y docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
# install json manipulation shell jq
sudo apt install -y jq
sudo apt autoremove -y
sudo systemctl restart docker

# install nvidia-docker2 docker plugin
NVIDIA=
while true
do
    echo
    read -r -p "Install Nvidia-Docker 2.0? [y/N] " input
    case $input in
        [yY][eE][sS]|[yY]) NVIDIA=1; break;;
        [nN][oO]|[nN]|$'') NVIDIA=0; break;;
        *) echo "invalid input";;
    esac
done

if [ $NVIDIA -gt 0 ]; then
    RED='\033[1;91m'
    GREEN='\033[0;92m'
    NC='\033[0m' # No Color

    sudo apt update && sudo apt install -y bash-completion software-properties-common && \
    sudo add-apt-repository ppa:graphics-drivers/ppa -y && \
    sudo apt update && sudo apt install -y ubuntu-drivers-common lshw && \
    sudo apt autoremove -y && \
    hw=$(sudo ubuntu-drivers autoinstall)
    if [[ $hw =~ ^No\ drivers* ]]; then
        printf "\nGPU: ${RED}$hw${NC}\n\n"
    else
        vga=$(sudo lshw -C display)
        printf "\n${GREEN}$vga${NC}\n\n"
    fi
    # ubuntu-drivers devices
    # If there is nvidia-docker 1.0 already, it needs to be removed.
    docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
    sudo apt purge -y nvidia-docker
    # Set the repository and update
    curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
    curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
    sudo apt update
    # Install nvidia-docker 2.0
    sudo apt install -y nvidia-docker2
    sudo pkill -SIGHUP dockerd
fi

# stop docker daemon
sudo systemctl stop docker

# tweak docker store location
USEOTHERDIR=
while true
do
    echo
    read -r -p "Change docker graph location other than (/var/lib/docker)? [y/N] " input
    case $input in
        [yY][eE][sS]|[yY]) USEOTHERDIR=1; break;;
        [nN][oO]|[nN]|$'') USEOTHERDIR=0; break;;
        *) echo "invalid input";;
    esac
done

DIRG=
if [ $USEOTHERDIR -gt 0 ]; then
    echo
    read -r -p "Your new graph location? " graph
    DIRG=$(echo $graph | sed '1 s/\/docker//' | sed -e s./$..g)
    #[ ! -d $DIRG ] && mkdir -p $DIRG
    if ! sudo test -d $DIRG; then
        sudo mkdir -p $DIRG
    fi
    
    # save docker content to new location
    rsync -aqxP /var/lib/docker $DIRG

    # manipulating json can use other tool like jq: http://stedolan.github.io/jq/
    daemonjson="/etc/docker/daemon.json"
    if ! sudo test -f $daemonjson; then
    	sudo touch $daemonjson
    	sudo tee -a $daemonjson <<EOF
{
    "graph": "$DIRG/docker",
    "storage-driver": "overlay"
}
EOF
    else
        # sudo sed -i '$s%}%,\n"graph": "$DIRG/docker",\n"storage-driver": "overlay"\n}%' $daemonjson
        sudo cat $daemonjson | jq ".+={\"graph\": \"$DIRG/docker\", \"storage-driver\": \"overlay\"}" | sudo tee /tmp/tmp.json && sudo mv /tmp/tmp.json $daemonjson
    fi
    sudo systemctl stop docker
    sudo rm -rf /var/lib/docker

fi

# add user access to run other than root
sudo usermod -G docker $(whoami)

# start docker daemon
sudo systemctl start docker

if [ $NVIDIA -gt 0 ]; then
    RUN=
    while true
    do
        echo
        read -r -p "Run nvidia/cuda for checking your gpu? [y/N] " input
        case $input in
            [yY][eE][sS]|[yY]) RUN=1; break;;
            [nN][oO]|[nN]|$'') RUN=0; break;;
            *) echo "invalid input";;
        esac
    done
    if [ $RUN -gt 0 ]; then
	    sudo docker run --runtime=nvidia --rm nvidia/cuda nvidia-smi
    fi
fi

# activate new group
# sudo su -l $(whoami)

echo
cat <<EOF
Installation Note:
------------------
if something went wrong when running nvidia-docker2.
Please check:
apt-cache madison nvidia-docker2 nvidia-container-runtime
Then choose one which match docker version (docker -v)
then install using apt. example:
sudo apt-get install nvidia-docker2=2.0.3+docker18.03.1–1
the reload docker
sudo pkill -SIGHUP dockerd
and run again
docker run --runtime=nvidia --rm nvidia/cuda nvidia-smi
or
sudo docker run --rm --runtime=nvidia nvidia/cuda:9.0-devel nvcc --version

Some interesting container:

# jupyter notebook with TensorFlow powered by GPU and OpenCv
sudo nvidia-docker run --rm --name tf1 -p 8888:8888 -p 6006:6006 redaboumahdi/image_processing:gpu jupyter notebook --allow-root
# jupyter notebook with TensorFlow powered by CPU and OpenCV
sudo docker run --rm --name tf1 -p 8888:8888 -p 6006:6006 redaboumahdi/image_processing:cpu jupyter notebook --allow-root

More interesting info can be read on last section of this installer.

Happy coding!
EOF

<< ////
Real-Time Object Recognition
Now it is time to test our configuration and spend some time with our machine learning algorithms. The following code 
helps us track objects over frames with our webcam. It is a sample of code taken from the internet, you can find the 
github repository at the end of the article.

First of all, we need to open the access to the xserver to our docker image. There are different ways of doing so. 
The first one opens an access to your xserver to anyone. Other methods are described in the links at the end of the article.

> xhost +local:root
Then we will bash to our Docker image using this command:

> sudo docker run -p 8888:8888 --device /dev/video0 --env="DISPLAY" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" -it image_processing bash
We will need to clone the github repository, which is a real-time object detector:

> git clone https://github.com/datitran/object_detector_app.git && cd object_detector_app/
Finally, you can launch the python code:

> python object_detection_app.py
The code that we are using uses OpenCV. It is know as one of the most used libraries for image processing and available 
for C++ as well as Python.

You should see the following output, OpenCV will open your webcam and render a video. OpenCV will also find any object 
in the frame and print the label of the predicted object.
////
