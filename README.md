# OTA Community Edition (mono)-lith

Easy to run, secure, open source [tuf](https://theupdateframework.io/)/[uptane](https://uptane.github.io/) over the air (OTA) updates.

You may not want or need to run [ota-community-edition](https://github.com/advancedtelematic/ota-community-edition) using a microservice architecure. A monolith might fit your use case better if you just want to try `ota-community-edition` or if your organization doesn't need to serve millions of devices. A monolith architecture is easier to deploy and manage, and uses less resources.

This project bundles all the scala apps included in [ota-community-edition](https://github.com/advancedtelematic/ota-community-edition) into a application that can be executed in a single container. The app can be easily configured using a single configuration file and avoids the usage of environment variables to simplifly configuration. Additionally, a `docker-compose` file is provided to run the application. This means you no longer need a kubernetes cluster if you just want to try or test `ota-community-edition`.

For small deployments, you don't need kubernetes. This solution can fit your organization better. With this app you could run ota in a single machine/vm + mariadb and kafka.

## Active branches

Currently there are three active branches in this repository:

- `master`. `ota-community-edition` running without webapp and with kafka, using a single scala app.

- `webapp`. The webapp is broken in `ota-community-edition` and therefore is not included in `ota-lith/master`. The `webapp` branch includes patched version of `webapp` that does not rely on user profile and is therefore working with both `ota-community-edition` and `ota-lith`.

## Pending changes and dependencies
  
This project depends on changes to other `ota-community-edition` repositories. The changes were incorporated into this repository using `git subtree`, and they will need to be updated using the same method once those changes are merged upstream. 

The following forks/branches are included using git subtree:

- campaigner https://github.com/simao/campaigner/tree/ota-lith
- device-registry https://github.com/simao/ota-device-registry/tree/ota-lith
- director https://github.com/simao/director/tree/ota-lith
- libats https://github.com/simao/libats/tree/ota-lith
- treehub https://github.com/simao/treehub/tree/ota-lith
- treehub https://github.com/simao/treehub/tree/ota-lith
- tuf https://github.com/simao/ota-tuf/tree/ota-lith

## Building

To build a container running the services, run `sbt docker:publishLocal`

## Configuration

Configuration is done through a single config file, rather than using enviroment variables. This is meant to simplify the deployment scripts and just pass a `configFile=file.conf` argument to the container, or when needed, using system properties (`-Dkey=value`). An example config file is provied in `ota-lith-ce.conf`.

## Running

If you already have kafka and mariadb instances you can just run the ota-lith binary using sbt or docker.

### Using sbt

You'll need a valid ota-lith.conf, then run:

    sbt -Dconfig.file=$(pwd)/ota-lith.conf run

### Using docker

The scala apps run in a single container, but you'll need kafka and mariadb. Write a valid ota-lith.conf.

    sbt docker:publishLocal
    docker run --name=ota-lith -v $(pwd)/ota-lith.conf:/tmp/ota-lith.conf advancedtelematic/ota-lith:latest -Dconfig.file=/tmp/ota-lith.conf

## Running With Docker Compose

If you don't have kafka or mariadb running and just want to try ota-ce, run using docker-compose:

1. Generate the required certificates using `scripts/gen-server-certs.sh` 

2. Update /etc/hosts

3. build docker image

`sbt docker:publishLocal`

4. Run docker-compose 
 
`docker-compose -f ota-ce.yaml up`

5. Test

For example `curl director.ota.ce/health/version`

6. You can now create device credentials and provision devices

Run `scripts/gen-device.sh`. This will create a new dir in `ota-ce-gen/devices/:uuid` where `uuid` is the id of the new device. You can run `aktualizr` in that directory using:

    aktualizr --run-mode=once --config=config.toml
    
7. You can now deploy updates to the devices

## Deploy updates

You can either use the API directly or use [ota-cli](https://github.com/simao/ota-cli/) to deploy updates. After provisioning devices (see above).

Before using the api or `ota-cli` you will need to generate a valid `credentials.zip`. Run `scripts/get-credentials.zip`.

To deploy an update using the API and a custom campaign, see [api-updates.md](docs/api-updates.md).

To deploy an update using [ota-cli](https://github.com/simao/ota-cli/) with or without a custom campaign see [updates-ota-cli.md](docs/updates-ota-cli.md).

## Related

- https://github.com/simao/ota-cli
- https://github.com/advancedtelematic/ota-community-edition
- https://docs.ota.here.com/getstarted/dev/index.html
- https://docs.ota.here.com/ota-client/latest/aktualizr-config-options.html
