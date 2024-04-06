import path from "path";
import tailwind from "tailwindcss";
import autoprefixer from "autoprefixer";
import vue from "@vitejs/plugin-vue";
import { defineConfig } from "vite";

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
    css: {
        postcss: {
            plugins: [tailwind(), autoprefixer()],
        },
    },
    resolve: {
        alias: {
            "@": path.resolve(__dirname, "./src"),
        },
    },
})