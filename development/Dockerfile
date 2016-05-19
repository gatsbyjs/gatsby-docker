#IMAGE gatsby/docker:development
FROM alpine:edge
MAINTAINER José Moreira <jose.moreira@junglecloud.com>

# Install most needed dependencies for node/npm development
RUN apk --update add \
        nodejs docker git python tar bash curl \
        gcc g++ make automake \
        glib-dev libtool libc-dev libxml2-dev gettext file \
        libjpeg-turbo-dev tiff-dev libgsf-dev giflib-dev fftw-dev orc-dev \
        lcms2-dev poppler-dev poppler-glib librsvg-dev libwebp-dev

# libvips for sharp (fastest image handler)
RUN VIPS_SRC=/usr/src/vips \
    && mkdir -p $VIPS_SRC && cd $VIPS_SRC \
    && curl -qL http://www.vips.ecs.soton.ac.uk/supported/8.3/vips-8.3.0.tar.gz \
      | tar zxf - -C . --strip-components=1 \
    && ./configure --prefix=/usr \
    && make \
    && make install

# Install gatsby
RUN npm -g i gatsby
