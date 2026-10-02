# Self-hosted GitHub Actions runner for the Shakespeare repositories.
# Matches what our workflows expect from GitHub's ubuntu-latest: git, curl, jq, Python, a JDK and the Android SDK.
# Node.js, JDK 21, uv... still come from the setup-* actions, cached in the toolcache volume.
FROM ubuntu:24.04

# pinned and verified; update both together (task bump-versions prints the current ones)
ARG RUNNER_VERSION=2.337.0
ARG RUNNER_SHA256=70920811a4f8ad4328818682bca5c6469c1c942fab52448868071d0063816613
ARG ANDROID_CMDLINE_TOOLS=16111833
ARG ANDROID_CMDLINE_TOOLS_SHA256=0877a1d048fe4a24efe2eff536ca4223f7adeb58648bb81909d33c446918cfa8
# what android/variables.gradle compiles against
ARG ANDROID_PACKAGES="platform-tools platforms;android-36 build-tools;35.0.0"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    RUNNER_HOME=/opt/actions-runner \
    RUNNER_TOOL_CACHE=/opt/hostedtoolcache \
    ANDROID_HOME=/opt/android-sdk \
    ANDROID_SDK_ROOT=/opt/android-sdk

# apt packages follow the base image's security updates rather than exact pins
# hadolint ignore=DL3008
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates curl git jq unzip zip xz-utils python3 openjdk-21-jdk-headless \
 && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --uid 1001 runner \
 && mkdir -p "$RUNNER_TOOL_CACHE" /home/runner/.gradle /home/runner/.npm \
 && chown -R runner:runner "$RUNNER_TOOL_CACHE" /home/runner

WORKDIR $RUNNER_HOME
RUN curl -fsSL -o runner.tar.gz "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz" \
 && echo "${RUNNER_SHA256}  runner.tar.gz" | sha256sum -c - \
 && tar xzf runner.tar.gz && rm runner.tar.gz \
 && ./bin/installdependencies.sh \
 && rm -rf /var/lib/apt/lists/* \
 && chown -R runner:runner "$RUNNER_HOME"

RUN curl -fsSL -o /tmp/cmdline-tools.zip "https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_CMDLINE_TOOLS}_latest.zip" \
 && echo "${ANDROID_CMDLINE_TOOLS_SHA256}  /tmp/cmdline-tools.zip" | sha256sum -c - \
 && mkdir -p "$ANDROID_HOME/cmdline-tools" \
 && unzip -q /tmp/cmdline-tools.zip -d "$ANDROID_HOME/cmdline-tools" \
 && mv "$ANDROID_HOME/cmdline-tools/cmdline-tools" "$ANDROID_HOME/cmdline-tools/latest" \
 && rm /tmp/cmdline-tools.zip \
 && (yes || true) | "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" --licenses > /dev/null \
 && "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" $ANDROID_PACKAGES > /dev/null \
 && chown -R runner:runner "$ANDROID_HOME"

COPY --chmod=755 entrypoint.sh /entrypoint.sh

# stays root: only the entrypoint holds ACCESS_TOKEN, the runner and its jobs run as `runner`
ENTRYPOINT ["/entrypoint.sh"]
