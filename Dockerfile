FROM ubuntu:22.04
RUN apt update
#install python
RUN apt install -y python3 python3-pip python3-venv python3-dev build-essential libxml2-dev libxslt1-dev libffi-dev libpq-dev libssl-dev zlib1g-dev

RUN mkdir -p /opt/final_project
COPY .. /opt/project
WORKDIR /opt/project/
RUN pip install --no-cache-dir -r requirements.txt
RUN echo "SECRET_KEY='$(python3 statuspage/generate_secret_key.py)'" >> /opt/project/statuspage/statuspage/configuration.py
RUN /opt/project/upgrade.sh


RUN python3 -m venv . 
RUN . /opt/project/venv/bin/activate
WORKDIR /opt/project/statuspage

EXPOSE  8000
CMD [ "python3", "manage.py", "runserver", "0.0.0.0:8000", "--insecure"]
