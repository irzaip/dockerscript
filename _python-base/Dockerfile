FROM python:3.6

RUN apt-get update && apt-get install -y \
    apt-utils \
    curl
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

RUN pip3 --no-cache-dir install -U \
    Flask \
    h5py \
    librosa \
    numpy \
    scikit-image \
    scipy \
    setuptools \
    tensorflow==1.8.0 \
    webrtcvad \
    psutil

COPY app /app

EXPOSE 5000

