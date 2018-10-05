#FROM python:3.6

FROM blitznote/debase:18.04

# dont use --no-install-recommends 
RUN apt update && apt install -y python3 python3-pip portaudio19-dev python3-setuptools

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
RUN apt-get purge -y \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    gfortran \
    git \
    libarmadillo-dev \
    libarpack2-dev \
    libflann-dev \
    libhdf5-serial-dev \
    liblapack-dev \
    libtiff5-dev \
    openssh-client \
    python-dev \
    python-numpy \
    python-software-properties \
    software-properties-common \
    wget \
    automake \
    libtool \
    libspatialite-dev \
    libhdf5-dev \
    subversion \
    libjsoncpp-dev \
    libboost-filesystem1.55-dev \
    libboost-iostreams1.55-dev \
    libboost-program-options1.55-dev \
    libboost-system1.55-dev \
    libboost-thread1.55-dev \
    subversion \
    clang \
    libproj-dev \
    libc6-dev \
    libnetcdf-dev \
    libpng-dev \
    libjpeg-dev \
    libgif-dev \
    libwebp-dev \
    libhdf4-alt-dev \
    libhdf5-dev \
    libpq-dev \
    libxerces-c-dev \
    unixodbc-dev \
    libsqlite3-dev \
    libgeos-dev \
    libmysqlclient-dev \
    libltdl-dev \
    libcurl4-openssl-dev \
    libspatialite-dev \
    libdap-dev\
    ninja \
    cython \
    python3-pip

RUN apt clean autoclean && apt autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/

CMD ["python", "/app/justrepeat.py"]

