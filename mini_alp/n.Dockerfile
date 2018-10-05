FROM gliderlabs/alpine:latest
MAINTAINER Bayu Irian <bayu.irian@gmail.com>
#RUN apk add --no-cache \
#    openrc
# bash like (sh, ash), sed, grep and many in coreutils are covered in busybox
RUN apk add --no-cache \
    bash \ 
    gawk \
    sed \ 
    grep \ 
    bc \
#    coreutils \
#    openssh \
#    mysql \
#    mysql-client \
#    postgresql \
#    postgresql-client \
    nginx \
    python3 \
    py3-pip \
#    openssl \
#    ca-certificates \
    && pip3 install --upgrade --no-cache-dir pip \
    && pip3 install --no-cache-dir virtualenv

RUN apk add --no-cache --virtual \
    .build-deps \
    python3-dev \
    build-base \
    linux-headers \
    pcre-dev \
    && pip3 install --no-cache-dir uwsgi \
    tensorflow \
	keras \
	tqdm \
	sounddevice \
	soundfile \
	librosa \
	Sastrawi \
	selenium \
	gensim \
	pyaudio \
	nltk \
	google-cloud-speech \
	google-cloud-storage \
	gTTS \
    && apk del .build-deps

#RUN  rm -rf /var/cache/apk/*

#make sure we get fresh keys (ssh)
RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key

ADD . /build

WORKDIR /myapp
#COPY . /myapp

# add entrypoint script
ADD docker-entrypoint.sh /usr/local/bin

RUN chmod 750 /build/system_services.sh \
    && /build/system_services.sh 

EXPOSE 22

ENTRYPOINT ["docker-entrypoint.sh"]
#CMD ["/usr/sbin/sshd","-D"]
#CMD ["/sbin/my_init"]

