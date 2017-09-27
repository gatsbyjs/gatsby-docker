#!/bin/bash

# Check for variables
export CHARSET=${CHARSET:-utf-8}

export WORKER_CONNECTIONS=${WORKER_CONNECTIONS:-1024}
export HTTP_PORT=${HTTP_PORT:-80}
export NGINX_CONF=/etc/nginx/mushed.conf

export PUBLIC_PATH=${PUBLIC_PATH:-/pub}

export GZIP_TYPES=${GZIP_TYPES:-application/javascript application/x-javascript application/rss+xml text/javascript text/css image/svg+xml}
export GZIP_LEVEL=${GZIP_LEVEL:-6}

export CACHE_IGNORE=${CACHE_IGNORE:-html}
export CACHE_PUBLIC=${CACHE_PUBLIC:-ico|jpg|jpeg|png|gif|svg|js|jsx|css|less|swf|eot|ttf|otf|woff|woff2}
export CACHE_PUBLIC_EXPIRATION=${CACHE_PUBLIC_EXPIRATION:-1y}

if [ "$TRAILING_SLASH" = false ]; then
  REWRITE_RULE="rewrite ^(.+)/+\$ \$1 permanent"
else
  REWRITE_RULE="rewrite ^([^.]*[^/])\$ \$1/ permanent"
fi

# Build config
cat <<EOF > $NGINX_CONF
daemon              off;
worker_processes    1;
user                root;

events {
  worker_connections $WORKER_CONNECTIONS;
}

http {
  include       mime.types;
  default_type  application/octet-stream;

  keepalive_timeout  15;
  autoindex          off;
  server_tokens      off;
  port_in_redirect   off;
  sendfile           off;
  tcp_nopush         on;
  tcp_nodelay        on;

  client_max_body_size 64k;
  client_header_buffer_size 16k;
  large_client_header_buffers 4 16k;

  ## Cache open FD
  open_file_cache max=10000 inactive=3600s;
  open_file_cache_valid 7200s;
  open_file_cache_min_uses 2;

  ## Gzipping is an easy way to reduce page weight
  gzip                on;
  gzip_vary           on;
  gzip_proxied        any;
  gzip_types          $GZIP_TYPES;
  gzip_buffers        16 8k;
  gzip_comp_level     $GZIP_LEVEL;

  access_log         /dev/stdout;

  server {
    listen $HTTP_PORT;
    root $PUBLIC_PATH;

    index index.html;
    autoindex off;
    charset $CHARSET;

    error_page 404 /404.html;

    location ~* \.($CACHE_IGNORE)$ {
      add_header Cache-Control "no-store";
      expires    off;
    }
    location ~* \.($CACHE_PUBLIC)$ {
      add_header Cache-Control "public";
      expires +$CACHE_PUBLIC_EXPIRATION;
    }

    $REWRITE_RULE;

    try_files \$uri \$uri/ \$uri/index.html =404;
  }
}

EOF

[ "" != "$DEBUG" ] && cat $NGINX_CONF;

mkdir -p /run/nginx/
chown -R root:root /var/lib/nginx

exec nginx -c $NGINX_CONF
