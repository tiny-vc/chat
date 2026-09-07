import { defineConfig } from "vitest/config";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
  build: {
    rollupOptions: {
      output: {
        onlyExplicitManualChunks: true,
        manualChunks(id) {
          if (id.includes("node_modules/dayjs/")) return "dayjs";
          if (id.includes("node_modules/rc-picker/")) return "rc-picker";
          const proPackage = id.match(
            /node_modules\/@ant-design\/(pro-[^/]+)\//,
          )?.[1];
          if (proPackage && proPackage !== "pro-components") return proPackage;
          if (
            id.includes("node_modules/react") ||
            id.includes("node_modules/scheduler")
          )
            return "react";
          return undefined;
        },
      },
    },
  },
  server: {
    port: 5173,
    proxy: {
      "/api": "http://localhost:3000",
    },
  },
  test: {
    environment: "jsdom",
  },
});
