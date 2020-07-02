FROM dobor/alpine-base:latest AS base
LABEL MAINTAINER=chobon@aliyun.com

FROM dobor/alpine-base:latest AS build

ENV HEXO_MODE=server
ENV HEXO_DOUBAN=true

# change ALIYUN apk source
# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN addgroup hexo && \
    adduser -D -g "" -s /bin/sh -G hexo hexo

WORKDIR /home/hexo

RUN apk --update --no-progress --no-cache add git nodejs npm openssh && \
    npm config set registry https://registry.npm.taobao.org && \
    npm install -g hexo-cli && \
    hexo init . && \
    npm install hexo-deployer-git && \
    #npm install hexo-generator-json-content && \
    npm install hexo-tag-aplayer && \
    npm install cheerio@0.22.0 && \
    npm install hexo-renderer-pug && \
    npm install hexo-renderer-stylus && \
    npm install hexo-wordcount && \
    npm install hexo-abbrlink && \
    npm install hexo-douban && \
    rm -rf /var/cache/apk/*

# copy local files
ADD root /

VOLUME /home/hexo/source /home/hexo/themes /home/hexo/.ssh 

RUN chown -R hexo .

EXPOSE 4000