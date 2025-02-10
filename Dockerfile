ARG BASE_VERSION=12
FROM debian:${BASE_VERSION}
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install tar zip unzip gzip bzip2 && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install python3 jq daemonize gettext
ARG CROWDSEC_VERSION=latest
WORKDIR /work
RUN echo $CROWDSEC_VERSION; \
    if [ "$CROWDSEC_VERSION" = "latest" ]; then \
        archive_url="https://github.com/crowdsecurity/crowdsec/releases/latest/download/crowdsec-release.tgz"; \
    else \
        archive_url="https://github.com/crowdsecurity/crowdsec/releases/download/v${CROWDSEC_VERSION}/crowdsec-release.tgz"; \
    fi; \
    curl -L "$archive_url" | tar -xvz --strip-components=1 -C .;
# the test_env.sh script creates a test env at ./tests
RUN ./test_env.sh
# dockerfile-utils: ignore
WORKDIR ./tests
ADD --link https://github.com/crowdsecurity/hub.git ./hub/
# mount point for dev content that will be merged into test env at runtime
ENV IMPORT_VOLUME="/import"
VOLUME "${IMPORT_VOLUME}"
# mount point for exporting test results to host
ENV EXPORT_VOLUME="/export"
VOLUME "${EXPORT_VOLUME}"
COPY --chmod=755 scripts/* /scripts/
ENTRYPOINT [ "/scripts/entrypoint.sh" ]
