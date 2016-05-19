#IMAGE gatsby/docker:runtime
FROM cusspvz/nginx:latest
MAINTAINER José Moreira <jose.moreira@junglecloud.com>

ADD public/ /pub

ENV GZIP_LEVEL=9 \
    GZIP_TYPES="application/javascript application/x-javascript application/rss+xml text/javascript text/css text/html image/svg+xml image/jpeg text/plain"
