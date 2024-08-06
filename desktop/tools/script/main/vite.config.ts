import {defineConfig} from "vite";
import {builtinModules} from "module";
import Package from "../../../package.json";

export default defineConfig({
    root: __dirname,
    build: {
        outDir: "../../../release/dist/main",
        emptyOutDir: true,
        minify: "terser",
        sourcemap: false,
        lib: {
            entry: "index.ts",
            formats: ["cjs"],
            fileName: () => "[name].cjs",
        },
        rollupOptions: {
            external: [
                "electron",
                ...builtinModules,
                ...builtinModules.map(e => `node:${e}`),
                ...Object.keys(Package.dependencies || {}),
            ]
        },
    }
})
