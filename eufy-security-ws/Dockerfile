ARG BUILD_FROM
FROM $BUILD_FROM

ARG EUFY_SECURITY_WS_VERSION

WORKDIR /usr/src/app
RUN \
    set -x \
    # The Alpine 3.23 base image (see build.yaml) ships Node.js 24 in its main
    # repository, so nodejs/npm install directly with no edge-repo workarounds.
    && apk add --no-cache \
        jq \
        nodejs \
        npm \
    && node --version \
    # Fail the build if the base ever regresses below Node 24.
    && case "$(node --version)" in v24.*) ;; *) echo "Expected Node 24, got $(node --version)" >&2; exit 1 ;; esac \
    && npm install --force \
    "eufy-security-ws@${EUFY_SECURITY_WS_VERSION}"

# FamiLock S3 Max (T85V0) lock support; see patch-t85v0.sh
COPY patch-t85v0.sh /tmp/
RUN sh /tmp/patch-t85v0.sh && rm /tmp/patch-t85v0.sh

COPY run.sh /
RUN chmod a+x /run.sh
WORKDIR /data

CMD [ "/run.sh" ]