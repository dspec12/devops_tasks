# Note: For this use case the Litecoin version number is hardcoded. If this Dockerfile were to be supported longterm the version number should be converted to a variable.
# Used uphold/docker-litecoin-core Dockerfile as a general reference
# Source: https://github.com/uphold/docker-litecoin-core/blob/master/0.18/Dockerfile

FROM debian:stable-slim AS builder

WORKDIR /build

# Install dependancies; Cleanup
RUN apt-get update \
    && apt-get install -y wget ca-certificates gnupg2

# Fetch litecoin tar and signatures file
RUN wget https://download.litecoin.org/litecoin-0.18.1/linux/litecoin-0.18.1-x86_64-linux-gnu.tar.gz \
    && wget https://download.litecoin.org/litecoin-0.18.1/linux/litecoin-0.18.1-linux-signatures.asc

# Import Public GPG Key; Verify Fingerprint
# Source: https://download.litecoin.org/README-HOWTO-GPG-VERIFY-TEAM-MEMBERS-KEY.txt
RUN wget -O - 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xFE3348877809386C' | gpg --import \
    && gpg --fingerprint FE3348877809386C \
    && gpg --verify litecoin-0.18.1-linux-signatures.asc

# Uses the diff command to compare checksums. The following command will fail if an error occurs at any stage in the pipe.
# Source: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#run
RUN ["/bin/bash", "-c", "set -o pipefail && diff <(sha256sum litecoin-0.18.1-x86_64-linux-gnu.tar.gz) <(grep litecoin-0.18.1-x86_64-linux-gnu.tar.gz litecoin-0.18.1-linux-signatures.asc) && echo 'Tar Verified'"]

# Extract Tarball
RUN tar -zxvf litecoin-0.18.1-x86_64-linux-gnu.tar.gz


# Rebuild to reduce image size
FROM debian:stable-slim

# # Create & set working directory for litecoin
WORKDIR /opt/litecoin

# Create system user; Data dir; Set permissions
RUN useradd -r litecoin \
    && mkdir /opt/litecoin/litecoin-data \
    && chown -R litecoin:litecoin /opt/litecoin

COPY --from=builder /build/litecoin-0.18.1 .

# Run as system user
USER litecoin

EXPOSE 9332 9333 19332 19333 19444

# Run litecoin daemon on docker run // Using defaults (exluding the custom datadir location) to keep things simple
ENTRYPOINT ["/opt/litecoin/bin/litecoind", "-datadir=/opt/litecoin/litecoin-data"]