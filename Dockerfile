FROM alpine:latest
LABEL MAINTAINER="chobon@aliyun.com"

ARG UID=1000
ARG GID=1000
ARG PORT=80

# change ALIYUN apk source
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN apk add --no-cache shadow sudo  && \
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


RUN apk --update --no-progress add git nodejs npm openssh \
&& rm -rf /var/cache/apk/* \
&& npm install -g hexo-cli

WORKDIR /home/hexo

RUN hexo init . \
&& npm install --save hexo-deployer-git

VOLUME ["/home/hexo/source","/home/hexo/themes","/root/.ssh"]

EXPOSE ${PORT}

USER hexo

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["/bin/sh"]