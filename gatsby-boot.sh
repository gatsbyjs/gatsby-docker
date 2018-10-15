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
	yarn
fi

# Decide what to do
if [ "$CMD" == "develop" ]; then
	rm -rf ./public

	shift
	exec gatsby develop --host 0.0.0.0 --port $GATSBY_PORT $@
elif [ "$CMD" == "build" ]; then
	rm -rf ./public

	shift
	exec gatsby build $@
elif [ "$CMD" == "serve" ]; then
	shift
	exec gatsby serve --host 0.0.0.0 --port $GATSBY_PORT $@
elif [ "$CMD" == "stage" ]; then
	rm -rf ./public

	shift
	gatsby build
	exec gatsby serve --host 0.0.0.0 --port $GATSBY_PORT $@
fi

# Or just exec
exec gatsby $@
