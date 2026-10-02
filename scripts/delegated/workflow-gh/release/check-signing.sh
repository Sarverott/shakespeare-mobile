#!/usr/bin/env bash
# Refuse to release without the signing key: an unsigned or randomly signed APK
# could never be updated by the next release.
#
# env KEYSTORE_BASE64   the upload keystore (repository secret)
# shellcheck source=scripts/delegated/workflow-gh/_lib.sh
source "$(dirname "$0")/../_lib.sh"

if [ -z "${KEYSTORE_BASE64:-}" ]; then
  echo "::error::KEYSTORE_BASE64 secret is missing, refusing to publish an unsigned or randomly signed APK."
  exit 1
fi
echo "Signing key is present."
