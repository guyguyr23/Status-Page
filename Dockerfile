#os
FROM ubuntu:22.04

#copy files from github-repo
COPY .. /opt/project
WORKDIR /opt/project/

#install requirements
RUN apt update && apt install -y python3 python3-pip python3-venv python3-dev build-essential libxml2-dev libxslt1-dev libffi-dev libpq-dev libssl-dev zlib1g-dev \
        && mkdir -p /opt/final_project \
        && pip install --no-cache-dir -r requirements.txt \
        && echo "SECRET_KEY='$(python3 statuspage/generate_secret_key.py)'" >> /opt/project/statuspage/statuspage/configuration.py \
        && /opt/project/upgrade.sh \
        && python3 -m venv . \
        && . /opt/project/venv/bin/activate

#change working dir
WORKDIR /opt/project/statuspage

#opening port and running app
EXPOSE  8000
CMD [ "python3", "manage.py", "runserver", "0.0.0.0:8000", "--insecure"]
~                                                                           
