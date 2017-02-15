# gatsbyjs/gatsby
Docker image that builds hosts a Gatsby site

This image has two major tags:

* `latest` - will serve your assets on production using up an nginx server

* `onbuild` - builds your project and creates a new docker image

## Usage

1. Insert the `Dockerfile` above at the root of your project:

  ```Dockerfile
  FROM gatsbyjs/gatsby:onbuild
  ```

2. Build your project's public assets with `gatsby build`

3. Build your project's docker image:

  ```bash
  docker build -t myproject/website .
  ```

4. Upload to the registry

  ```bash
  docker push myproject/website
  ```

5. Use it

  ```bash
  docker run --rm myproject/website
  ```
