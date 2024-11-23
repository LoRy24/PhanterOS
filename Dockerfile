FROM ubuntu:latest

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y build-essential
RUN apt-get install -y make
RUN apt-get install -y qemu-system

VOLUME /pantheros/
WORKDIR /pantheros/
