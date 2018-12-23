#!/bin/sh
set -e

GATSBY_WORKDIR="/site"
GATSBY_PORT=${GATSBY_PORT:-8000}

cd "$GATSBY_WORKDIR"

# Initialize Gatsby if no manifest found
if [ ! -f "./package.json" ]; then
	echo "Initializing Gatsby..."
	gatsby new .
	# Ensure packages are locked and up to date
	yarn
fi

# Decide what to do
if [ "$1" == "develop" ]; then
	rm -rf ./public

	shift
	exec gatsby develop --host 0.0.0.0 --port $GATSBY_PORT $@
elif [ "$1" == "build" ]; then
	rm -rf ./public

	shift
	exec gatsby build $@
elif [ "$1" == "serve" ]; then
	shift
	exec gatsby serve --host 0.0.0.0 --port $GATSBY_PORT $@
elif [ "$1" == "stage" ]; then
	rm -rf ./public

	shift
	gatsby build
	exec gatsby serve --host 0.0.0.0 --port $GATSBY_PORT $@
fi

# Or just go through
exec $@
