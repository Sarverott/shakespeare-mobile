#!/usr/bin/env bash
# Build the web part and hand it to the Android project:
# shakespeare-gui plugin → app core (src/gui) → Capacitor sync.
#
# env GUI_REF  branch or tag of shakespeare-gui to clone when ../shakespeare-gui is missing (default: master)
# shellcheck source=scripts/delegated/workflow-gh/_lib.sh
source "$(dirname "$0")/_lib.sh"

export HUSKY=0

if [ ! -d ../shakespeare-gui ]; then
  git clone --depth 1 --branch "${GUI_REF:-master}" https://github.com/Sarverott/shakespeare-gui.git ../shakespeare-gui
fi

(cd ../shakespeare-gui && npm ci && npm run build:lib)
npm ci
npm run build
npx cap sync android
