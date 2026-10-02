#!/usr/bin/env bash
# Write the upload keystore from its secret to a temporary file for Gradle.
#
# env KEYSTORE_BASE64   the upload keystore (repository secret)
# exports               ANDROID_KEYSTORE_PATH (read by android/app/build.gradle)
# shellcheck source=scripts/delegated/workflow-gh/_lib.sh
source "$(dirname "$0")/../_lib.sh"

KEYSTORE="${RUNNER_TEMP:-$(mktemp -d)}/upload-key.jks"
echo "$KEYSTORE_BASE64" | base64 -d > "$KEYSTORE"
export_env ANDROID_KEYSTORE_PATH "$KEYSTORE"
