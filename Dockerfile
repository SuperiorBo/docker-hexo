FROM ghcr.io/superiorbo/alpine:latest AS base
LABEL MAINTAINER=chobon@aliyun.com

ENV HEXO_MODE=server
ENV HEXO_DOUBAN=true
ENV HEXO_RUNAS=hexo

# change ALIYUN apk source
# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN addgroup hexo && \
    adduser -D -g "" -s /bin/sh -G hexo hexo

WORKDIR /home/hexo

RUN apk --update --no-progress --no-cache add git nodejs npm openssh && \
    npm install -g hexo-cli && \
    hexo init . && \
    npm install hexo-deployer-git && \
    #npm install hexo-generator-json-content && \
    npm install hexo-theme-butterfly && \
    npm install hexo-douban && \
    npm install hexo-tag-aplayer && \
    npm install cheerio && \
    npm install hexo-renderer-pug && \
    npm install hexo-renderer-stylus && \
    npm install hexo-wordcount && \
    npm install hexo-abbrlink && \
    npm install hexo-generator-search && \
    npm install hexo-generator-sitemap && \
    npm install hexo-renderer-ejs && \
    npm install hexo-renderer-marked && \
    rm -rf /var/cache/apk/*

# copy local files
ADD root /

VOLUME /home/hexo/source /home/hexo/themes /home/hexo/.ssh 

RUN chown -R hexo .

EXPOSE 4000