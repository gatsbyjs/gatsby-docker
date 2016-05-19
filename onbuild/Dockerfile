#IMAGE gatsby/docker:onbuild
FROM gatsby/nginx:development
MAINTAINER José Moreira <jose.moreira@junglecloud.com>

ONBUILD ARG tag=gatsby/site
ONBUILD ADD . /gatsby
ONBUILD RUN cd /gatsby && gatsby build

# Creating a Docker IMAGE
ONBUILD RUN cd /gatsby \
    && echo "FROM gatsby/docker:runtime" > public/
    && docker build -t $tag .
