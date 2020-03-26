FROM dobor/alpine-base:latest
LABEL MAINTAINER=chobon@aliyun.com

ENV HEXO_MODE=server

# change ALIYUN apk source
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

WORKDIR /home/hexo

RUN apk --update --no-progress  add --no-cache git nodejs npm openssh && \
    npm config set registry https://registry.npm.taobao.org && \
    npm install -g hexo-cli --save && \
    hexo init . && \
    npm install hexo-deployer-git --save && \
    #npm install hexo-generator-json-content --save && \
    #npm install --save hexo-tag-aplayer
    #npm install cheerio@0.22.0 --save && \
    #npm install hexo-renderer-pug --save && \
    #npm install hexo-renderer-stylus --save
    rm -rf /var/cache/apk/*

# copy local files
ADD root /

VOLUME /home/hexo/source /home/hexo/themes /home/hexo/.ssh

RUN addgroup hexo && \
    adduser -D -g "" -s /bin/sh -G hexo hexo && \
    chmod a+x /usr/bin/hexo

EXPOSE 4000