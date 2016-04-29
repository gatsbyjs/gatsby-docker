# gatsby-nginx
Docker image that builds and hosts a Gatsby site

## Usage
```
# Building
gatsby build
docker build -t your/image .

# Executing
docker run -ti -p 80:80 your/image
```
