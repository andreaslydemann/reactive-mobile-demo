# Server

This is the backend for the demo reactive_mobile app. It contains a basic login system
and a system for creating and retrieving 'thoughts' which are just small blobs of text.

It uses JWT auth and is backed by Postgres with Rspec tests.

# Building with Docker

There are some build scripts for getting it running with docker. 
```shell
./scripts/build.sh # to build
./scripts/run.sh # to run the image
```

This will build the image (after creating db, running migrations etc) and run it in the foreground.

You can pass `-d` to the `run.sh` script to run it in the background.

# Tests

Run the tests via
```shell
bundle exec rspec
```

from within the running container (to get inside the container, you can run `docker exec -ti api bash`).
