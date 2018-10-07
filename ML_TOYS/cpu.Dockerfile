#FROM python:3.6
#FROM blitznote/debase:18.04
FROM tensorflow/tensorflow:latest-py3

# dont use --no-install-recommends 
#RUN apt update && apt install -y python3 python3-pip portaudio19-dev python3-setuptools

RUN apt update && apt install -y nginx

COPY ./app /notebooks/app

RUN mkdir /var/log/uwsgi
COPY ./app/default.nginx /etc/nginx/sites-available/default
COPY ./app/run_server.sh /run_server.sh
COPY ./app/pass.json /root/.jupyter/jupyter_notebook_config.json
RUN chmod +x /run_server.sh
RUN pip3 --no-cache-dir install -r /notebooks/app/requirements.txt 

EXPOSE 80 443 5000

# Remove all our dev junk and then we'll put back only
# runtime stuff
#RUN apt-get purge -y \
#    build-essential \
#    python3-pip

RUN apt clean autoclean && apt autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/


ENTRYPOINT ["bash", "/run_server.sh"]









