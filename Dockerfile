FROM ubuntu:22.04
RUN apt update
#install python
RUN apt install -y python3 python3-pip python3-venv python3-dev build-essential libxml2-dev libxslt1-dev libffi-dev libpq-dev libssl-dev zlib1g-dev

RUN mkdir -p /opt/final_project
COPY opt/final/project ..
