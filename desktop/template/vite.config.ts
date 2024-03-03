import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";

export default defineConfig({
    server: {
        port: 6173
    },
    plugins: [
        vue()
    ],
    build: {
        sourcemap: false
    },
    optimizeDeps: {
        exclude: ["punycode"]
    },
})