# Crowdsec configuration development environment

This project is a Docker Compose based template for [CrowdSec](https://docs.crowdsec.net/) configuration development.

## Usage

Configuration files go into the **develop** directory.

Test results will get stored in the **results** directory.

Run `docker-compose -f compose.dev.yaml up --watch` (or `./start.sh`) to start the development environment.

This automatically rebuilds the container when changes are detected, runs tests, and places test artifacts into the **results** directory.

What next? Start here: <https://docs.crowdsec.net/docs/parsers/create>

## Notes

**compose.dev.yaml** sets an environment variable **CONTAINER_LINGER** which is used in the entrypoint script to keep the container up,
otherwise `compose watch` stops watching after container exit.
