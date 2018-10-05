#FROM python:3.6
#FROM blitznote/debase:18.04
FROM tensorflow/tensorflow:latest-py3

# dont use --no-install-recommends 
#RUN apt update && apt install -y python3 python3-pip portaudio19-dev python3-setuptools

#RUN apt-get update && apt-get install -y \
#    apt-utils \
#    portaudio19-dev \
#    python-pyaudio \
#    libjack-jackd2-dev \
#    curl
#    g++ \
#    gcc \
#    git \
#    libcunit1-dev \
#    libfreetype6-dev \
#    libleveldb-dev \
#    libsndfile-dev \
#    libsox* \
#    libssl-dev \
#    libudev-dev \
#    libzmq3-dev \
#    pkg-config \
#    software-properties-common \
#    sox \
#    tar \
#    unzip \
#    wget \
#    supervisor \
# && rm -rf /var/lib/apt/lists/*

COPY . /app

RUN pip3 --no-cache-dir install -r /app/requirements.txt 

EXPOSE 80 443 5000

# Remove all our dev junk and then we'll put back only
# runtime stuff
#RUN apt-get purge -y \
#    build-essential \
#    python3-pip

RUN apt clean autoclean && apt autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/

