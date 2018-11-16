[![Travis CI Build Status](https://travis-ci.org/gatsbyjs/gatsby-docker.svg?branch=master)](https://travis-ci.org/gatsbyjs/gatsby-docker)

# gatsbyjs/gatsby
Docker image that builds hosts a Gatsby site

This image has two major tags:

* `latest` - will serve your assets on production using up an nginx server

* `onbuild` - builds your project and creates a new docker image

## Usage

1. Build your project's public assets with `gatsby build`
1. Create a `Dockerfile`, as below, at the root of your project:
    ```dockerfile
    FROM gatsbyjs/gatsby:onbuild
    ```
1. Build your project's docker image:
    ```bash
    docker build -t myproject/website .
    ```
1. Upload to the registry
    ```bash
    docker push myproject/website
    ```
1. Use it
    ```bash
    docker run --rm -p 80:80 myproject/website
    # Open your browser at http://localhost
    ```

## Configuration

The way Nginx behaves can be configured using environment variables.

_Please refer the docker run command options for the --env-file flag where you can specify all required environment variables in a single file. This will save you from writing a potentially long docker run command. Alternatively you can use docker-compose._

Below is the complete list of available options that can be used to customize your Nginx configuration:

| Environment variable      | Default                                                                                                      | Description                                                                                                                                                                                                                                                                            |
|---------------------------|--------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `CHARSET`                 | `utf-8`                                                                                                      | Charset being used in `Content-Type` response header field. See http://nginx.org/en/docs/http/ngx_http_charset_module.html                                                                                                                                                             |
| `WORKER_CONNECTIONS`      | `1024`                                                                                                       | The maximum number of simultaneous connections that can be opened by a worker process. See http://nginx.org/en/docs/ngx_core_module.html#worker_connections                                                                                                                            |
| `HTTP_PORT`               | `80`                                                                                                         | The address and / or port for IP, or the path for a UNIX-domain socket on which the server will accept requests. See http://nginx.org/en/docs/http/ngx_http_core_module.html#listen                                                                                                    |
| `PUBLIC_PATH`             | `/pub`                                                                                                       | The path to the directory from which files are being served. See http://nginx.org/en/docs/http/ngx_http_core_module.html#root                                                                                                                                                          |
| `GZIP_TYPES`              | `application/javascript application/x-javascript application/rss+xml text/javascript text/css image/svg+xml` | MIME types in addition to `text/html` for which gzip compression should be enabled. See http://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip_types                                                                                                                             |
| `GZIP_LEVEL`              | `6`                                                                                                          | Gzip compression level of a response. See http://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip_comp_level                                                                                                                                                                      |
| `CACHE_IGNORE`            | `html`                                                                                                       | Regular expression to specify which paths shouldn't be cachable (header `Cache-Control` set to `no-store`).                                                                                                                                                                            |
| `CACHE_PUBLIC`            | `ico\|jpg\|jpeg\|png\|gif\|svg\|js\|jsx\|css\|less\|swf\|eot\|ttf\|otf\|woff\|woff2`                                        | Regular expression to specify which paths should be cachable (headers `Cache-Control` set to `public` and `Expires` set to the value of `$CACHE_PUBLIC_EXPIRATION`).                                                                                                                   |
| `CACHE_PUBLIC_EXPIRATION` | `1y`                                                                                                         | Time to set for header `Expires`. See http://nginx.org/en/docs/http/ngx_http_headers_module.html#expires                                                                                                                                                                               |
| `TRAILING_SLASH`          | `true`                                                                                                       | Specifies if paths should end with a trailing slash or not. Prevents [duplicated content](https://moz.com/learn/seo/duplicate-content) by redirecting requests to URLs ending with a slash to its non-trailing-slash equivalent if set to `true` and the other way around for `false`. |
| `CUSTOM_SERVER_CONFIG`          | ` `                                                                                                       | Need to add some advanced/custom nginx config? No problem, you can inject through this environment variable. **NOTE:** would be discarded if `/etc/nginx/server.conf` is present. |
| `DEBUG`                   | `false`                                                                                                      | If set to `true` the configuration is being printed before the server starts.                                                                                                                                                                                                          |

### Append rules for the server block in nginx config

You can mount a file to `/etc/nginx/server.conf` to extend the server block in nginx config. This could be useful if you have defined client only routes in GatsbyJS. For example for client only rules on path `/client-only` the content of your mounted file should be like:

  ```
  rewrite ^/client-only/([^.]*?/)$ /client-only/index.html;
  ```

Alternatively you can use a custom Dockerfile and copy the file on build:

  ```Dockerfile
  FROM gatsbyjs/gatsby:latest
  COPY nginx-server-rules.conf /etc/nginx/server.conf
  ```
  
**NOTE:** By adding the file `/etc/nginx/server.conf`, all the contents of the `CUSTOM_SERVER_CONFIG` environment variable will be discarded.
