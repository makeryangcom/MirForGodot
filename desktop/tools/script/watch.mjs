import {spawn} from "child_process";
import {build, createServer} from "vite";
import electron from "electron";

function watchMain(server) {
    const address = server.httpServer.address();
    const env = Object.assign(process.env, {
        VITE_DEV_SERVER_HOST: address.address,
        VITE_DEV_SERVER_PORT: address.port,
    });

    return build({
        configFile: "tools/script/main/vite.config.ts",
        mode: "development",
        plugins: [{
            name: "electron-main-watcher",
            writeBundle(command, options) {
                if (process.electronApp) {
                    process.electronApp.removeAllListeners()
                    process.electronApp.kill()
                }
                process.electronApp = spawn(electron, [".", "--no-sandbox"], {stdio: "inherit", env})
                process.electronApp.once("exit", process.exit)
            },
        }],
        build: {
            watch: {},
        },
    })
}

function watchPreload(server) {
    return build({
        configFile: "tools/script/preload/vite.config.ts",
        mode: "development",
        plugins: [{
            name: "electron-preload-watcher",
            writeBundle() {
                server.ws.send({type: "full-reload"})
            }
        }],
        build: {
            watch: {},
        },
    })
}

const server = await createServer({configFile: "template/vite.config.ts"});

await server.listen();
await watchPreload(server);
await watchMain(server);
