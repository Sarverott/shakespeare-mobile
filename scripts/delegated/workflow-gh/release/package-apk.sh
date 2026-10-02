#!/usr/bin/env bash
# Give the release APK its public name: shakespeare-mobile-vX.Y.Z.apk
#
# env TAG_NAME   release tag (from bump.sh)
# outputs        apk_path
# shellcheck source=scripts/delegated/workflow-gh/_lib.sh
source "$(dirname "$0")/../_lib.sh"

mkdir -p release_assets
APK="release_assets/shakespeare-mobile-${TAG_NAME}.apk"
cp android/app/build/outputs/apk/release/app-release.apk "$APK"
output apk_path "$APK"
echo "Packaged APK: $APK"
