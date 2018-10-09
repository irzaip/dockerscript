#!/bin/bash
exec docker run -it --runtime=nvidia -d -p 80:80 -p 8888:8888 --rm -v /home/ubuntu/projects:/notebooks/projects --name ml_toys irzaip/ml_toys:gpu-0.9.3
