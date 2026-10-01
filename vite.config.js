import { writeFileSync } from "node:fs";
import { fileURLToPath, URL } from "node:url";

import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";

const outDir = fileURLToPath(new URL("./src/gui", import.meta.url));

// https://vite.dev/config/
// The app core lives in src/app; its build lands in src/gui, which is Capacitor's webDir.
export default defineConfig({
  root: fileURLToPath(new URL("./src/app", import.meta.url)),
  base: "./",
  plugins: [
    vue(),
    {
      // emptyOutDir wipes src/gui, keep its placeholder tracked by git
      name: "keep-webdir-placeholder",
      closeBundle: () => writeFileSync(`${outDir}/.gitkeep`, ""),
    },
  ],
  resolve: {
    // shakespeare-gui is linked from ../shakespeare-gui, make it use this app's Vue
    dedupe: ["vue"],
  },
  build: {
    outDir,
    emptyOutDir: true,
    rolldownOptions: {
      output: {
        // shakespeare-gui provides/injects its controllers by class name, minification must not rename them
        keepNames: true,
      },
    },
  },
});
