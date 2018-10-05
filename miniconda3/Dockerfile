FROM continuumio/miniconda3


COPY . /app

RUN conda install --yes --file /app/requirements.txt 
RUN pip install -r /app/prequire.txt

EXPOSE 80 443 5000


