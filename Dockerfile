FROM node:alpine
LABEL MAINTAINER="chobon@aliyun.com"

ARG UID=1000
ARG GID=1000
ARG A_PORT=4000
ENV PORT=${A_PORT}

EXPOSE ${PORT}

# RUN apk add --no-cache nodejs && \
#     apk add --no-cache git && \
#     rm -rf /var/cache/apk/*


RUN apk add --no-cache shadow sudo git && \
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

#install hexo
#ENV HEXO_VERSION = 

USER hexo

RUN  npm install -g hexo-cli

WORKDIR /home/hexo

RUN hexo init blog && npm install

VOLUME /home/hexo/blog
WORKDIR /home/hexo/blog

EXPOSE ${PORT}

CMD ["hexo", "server"]