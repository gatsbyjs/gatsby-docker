FROM node:alpine
LABEL maintainer="timo.traulsen@gmail.com"

RUN apk add --no-cache make gcc g++ python bash
RUN yarn global add gatsby

WORKDIR /app

ADD package.json .

RUN yarn install