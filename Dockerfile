#os
FROM python:3.10

#copy files from github-repo
RUN mkdir -p /opt/project
COPY . /opt/project
WORKDIR /opt/project

#install requirements
RUN apt update && apt install -y build-essential libxml2-dev libxslt1-dev libffi-dev libpq-dev libssl-dev zlib1g-dev \
        && pip install --no-cache-dir -r requirements.txt \
        && echo "SECRET_KEY='$(python3 statuspage/generate_secret_key.py)'" >> /opt/project/statuspage/statuspage/configuration.py \
        && /opt/project/upgrade.sh \
        && python3 -m venv . \
        && . /opt/project/venv/bin/activate

#change working dir
WORKDIR /opt/project/statuspage

#opening port and running app
EXPOSE  8000
#CMD [ "python3", "manage.py", "runserver", "0.0.0.0:8000", "--insecure"]
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "statuspage.wsgi:application"]                                                                        
