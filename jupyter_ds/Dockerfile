#FROM nvcr.io/nvidia/tensorflow:18.08-py3
FROM ubuntu:xenial

ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y python python-dev python3.5 python3.5-dev python-pip virtualenv libssl-dev libpq-dev git libfontconfig1 libfontconfig1-dev

RUN pip install setuptools pip --upgrade --force-reinstall


WORKDIR /my-ml-files
RUN pip install jupyter
EXPOSE 8888
RUN pip install keras
