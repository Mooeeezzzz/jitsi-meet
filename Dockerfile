# base image
FROM node:10 as builder

RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils build-essential

RUN apt-get install -y nginx

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt  -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com"



USER node

WORKDIR  /home/node/


COPY package.json .

RUN  npm install


USER root

COPY . .

RUN  make all



COPY nginx/default /etc/nginx/sites-enabled/

EXPOSE  443

ENTRYPOINT ["nginx", "-g", "daemon off;"]
