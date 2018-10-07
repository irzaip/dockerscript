#!/bin/bash
cd /notebooks/app
uwsgi --ini /notebooks/app/setting.ini
service nginx start
cd /notebooks
jupyter notebook --notebook-dir=/notebooks --no-browser --allow-root