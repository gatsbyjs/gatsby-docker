# gatsby/docker
A set of Docker images that builds and hosts a Gatsby site

## Usage

### `Dockerfile` placement

Just place up a file with the name `Dockerfile` on your project's root with
the following content:

`Dockerfile`
```Dockerfile
FROM gatsby/docker:onbuild
```

### Build your image

The process of building the image is also simple as the first step, the only
thing you may notice is the way you supply your final image tag name.

```bash
docker build --build-arg tag=you_username/your_site .
```

## Images

### gatsby/docker:runtime

The `runtime` tag holds an alpine-based image which has a nginx http service
built on top of `cusspvz/nginx`, which allows you to enhance its configuration
through environment variables.

**It is the perfect candidate to be the base of your Gatsby site public image.**

### gatsby/docker:development

The `development` tag holds an alpine-based image already loaded-in with lots
of resources that you would need during the `development` and `build` stage.

We've created this not only as the base for our `onbuild` image, but also for
the exceptions, that could be yours.

Imagine you will need system dependencies during the `build` stage, such as
`imagemagick`, `graphicsmagick` or any other we didn't have on the `onbuild`,
you just have to create your own `development` image based on this one.

I encourage you to [fill up an Issue] requesting system dependencies to be part
of it on every case you find, because probably We've forgotten some of them.

### gatsby/docker:onbuild

The `onbuild` tag is the simplest, it just have some black magic!

It is based on the `development` tag and it handles the entire build process
of your Gatsby site, you just have to sit back and relax.

Interested about what goes arround under the hood?
It just:

* loads up all your project's files into a folder
* installs dependencies and builds up the public files
* creates a new docker image
  * based on the `runtime` tag
  * loads up all public files over it
