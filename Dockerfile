FROM alpine:latest
LABEL maintainer="chobon <chobon@aliyun.com>"

ARG UID=1000
ARG GID=1000
ARG PORT=4000

EXPOSE ${PORT}

# change ALIYUN apk source
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN apk --update --no-progress  add --no-cache shadow sudo git nodejs npm openssh && \
    rm -rf /var/cache/apk/* && \
    if [ -z "`getent group $GID`" ]; then \
      addgroup -S -g $GID hexo; \
    else \
      groupmod -n hexo `getent group $GID | cut -d: -f1`; \
    fi && \
    if [ -z "`getent passwd $UID`" ]; then \
      adduser -S -u $UID -G hexo -s /bin/sh hexo; \
    else \
      usermod -l hexo -g $GID -d /home/hexo -m `getent passwd $UID | cut -d: -f1`; \
    fi && \
    echo "hexo ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/hexo && \
    chmod 0440 /etc/sudoers.d/hexo

#ENV HEXO_VERSION = 

WORKDIR /home/hexo

RUN npm config set registry https://registry.npm.taobao.org && \
    npm install -g hexo-cli --save && \
    hexo init . && \
    npm install && \
    npm install hexo-deployer-git --save && \
    npm install hexo-generator-json-content --save && \
    #npm install --save hexo-tag-aplayer
    npm install cheerio@0.22.0 --save && \
    npm install hexo-renderer-pug --save && \
    npm install hexo-renderer-stylus --save

VOLUME ["/home/hexo/source","/home/hexo/themes","/home/hexo/.ssh"]

RUN chown -R hexo .

USER hexo

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["/bin/sh"]