FROM perl:latest

COPY . /home/app-perldiver

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y build-essential && \
    apt-get install -y cpanminus

RUN cd /home/app-perldiver && ls && cpanm -n --installdeps .
# RUN cat /root/.cpanm/work/*/build.log
