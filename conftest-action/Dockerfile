FROM hashicorp/terraform:0.14.3

WORKDIR /app/terraform

COPY docker-entrypoint.sh .

# Install make
RUN apk update && apk add make go && chmod +x /app/terraform/docker-entrypoint.sh

# Install conftest for running tests
ARG CONFTEST_VERSION=0.22.0
RUN wget -O /tmp/conftest.tar.gz https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz && \
    tar -xzf /tmp/conftest.tar.gz -C /usr/local/bin && rm /tmp/conftest.tar.gz

ENTRYPOINT ["/app/terraform/docker-entrypoint.sh"]