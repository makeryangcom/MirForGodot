import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";
import tailwind from "tailwindcss";
import autoprefixer from "autoprefixer";
import path from "path";
import Package from "../package.json";

export default defineConfig({
    root: __dirname,
    mode: process.env.NODE_ENV,
    base: "./",
    define: {
        __VUE_PROD_HYDRATION_MISMATCH_DETAILS__: "true"
    },
    plugins: [
        vue(
            {
                template: {
                    compilerOptions: {
                        isCustomElement: (tag: any) => ["webview"].includes(tag),
                    }
                }
            }
        )
    ],
    server: {
        host: Package.env.VITE_DEV_SERVER_HOST,
        port: Package.env.VITE_DEV_SERVER_PORT,
        proxy: {
            "/api": {
                target: "",
                secure: false,
                changeOrigin: true,
                rewrite: (path: any) => path.replace(/^\/api/, '')
            },
        }
    },
    css: {
        postcss: {
            plugins: [tailwind(), autoprefixer()],
        }
    },
    build: {
        outDir: "../release/dist/template",
        emptyOutDir: true,
        sourcemap: false,
        cssCodeSplit: true,
        terserOptions: {
            compress: {
                drop_console: true,
                drop_debugger: true,
            },
        },
        rollupOptions: {
            treeshake: true,
            output: {
                manualChunks(id) {
                    if (id.includes("node_modules")) {
                        const dependenciesKeys = Object.keys(Package.dependencies);
                        const match = dependenciesKeys.find((item) => {
                            return id.includes(item);
                        });
                        const notSplit = ["vue"];
                        if (match && !notSplit.includes(match)) {
                            return match;
                        }
                    }
                }
            }
        },
        commonjsOptions: {
            requireReturnsDefault: "namespace",
        }
    },
    resolve: {
        alias: {
            "@/lib": path.resolve(__dirname, "./src/packages/shadcn"),
            "@/lib/registry/new-york/ui": path.resolve(__dirname, "./src/packages/shadcn"),
            "@/lib/registry/default/ui": path.resolve(__dirname, "./src/packages/shadcn")
        }
    }
})
