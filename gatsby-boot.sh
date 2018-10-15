#!/bin/sh
set -e

GATSBY_WORKDIR=${GATSBY_WORKDIR:-/gatsby}
GATSBY_PORT=${GATSBY_PORT:-8000}

cd "$GATSBY_WORKDIR"

# Initialize Gatsby if no manifest found
if [ ! -f "./package.json" ]; then
	echo "Initializing Gatsby..."
	gatsby new $GATSBY_WORKDIR
	# Ensure packages are locked and up to date
	npm install
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
elif [ "$1" == "stage" ]; then
	rm -rf ./public

	shift
	gatsby build
	exec gatsby serve --host 0.0.0.0 --port $GATSBY_PORT $@
fi

exec $@
