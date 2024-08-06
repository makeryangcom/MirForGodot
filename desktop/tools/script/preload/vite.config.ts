import {defineConfig} from "vite";
import {join} from "path";
import {builtinModules} from "module";
import Package from "../../../package.json";

export default defineConfig({
    root: __dirname,
    plugins: [],
    build: {
        outDir: "../../../release/dist/preload",
        emptyOutDir: true,
        minify: "terser",
        sourcemap: false,
        rollupOptions: {
            input: {
                index: join(__dirname, "index.ts")
            },
            output: {
                format: "cjs",
                entryFileNames: "[name].cjs",
                manualChunks: {},
            },
            external: [
                "electron",
                ...builtinModules,
                ...builtinModules.map(e => `node:${e}`),
                ...Object.keys(Package.dependencies || {}),
            ],
        },
    }
})
