import { createApp } from "vue";
import { Capacitor } from "@capacitor/core";
import { App as CapacitorApp } from "@capacitor/app";

import GUI_PLUGIN from "shakespeare-gui";
import "shakespeare-gui/style.css";

import App from "./App.vue";

const app = createApp(App);

app.use(GUI_PLUGIN, {
  view: "mobile",
  darkmode: true,
  commandNamespace: {
    shutdown: () => {
      if (
        window.confirm(
          "Are you sure that you want to quit? Your progress will be keeped in cache, but better to ensure that you can access it later without wiping all your work"
        )
      ) {
        if (Capacitor.isNativePlatform()) {
          CapacitorApp.exitApp();
        } else {
          window.close();
        }
      }
    },
  },
});

app.mount("#app");
