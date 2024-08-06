import {build} from "vite";

await build({configFile: "tools/script/main/vite.config.ts"});
await build({configFile: "tools/script/preload/vite.config.ts"});
await build({configFile: "template/vite.config.ts"});