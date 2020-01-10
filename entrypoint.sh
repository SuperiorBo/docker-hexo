#!/bin/sh

if [ "$1" = 's' ] || [ "$1" = 'server' ]; then
    set -- /usr/bin/hexo clean && /usr/bin/hexo g && /usr/bin/hexo s -p 4000
fi

if [ "$1" = 'd' ] || [ "$1" = 'deploy' ]; then
    set -- /usr/bin/hexo clean && /usr/bin/hexo d -g
fi

exec "$@"
