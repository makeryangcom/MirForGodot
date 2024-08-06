import os from "os";
import Path from "path";
import File from "fs";
import {ipcRenderer} from "electron";
import Shell from "./shell";
import * as Config from "../../../package.json";

(window as any).base = {
    os: os,
    path: Path,
    process: process,
    platform: os.platform(), //darwin、linux、win32
    config: Config,
    file: File,
    ipc: ipcRenderer,
    lang: {
        t: false,
        locale: false
    },
    window: {
        max: false
    },
    tools: {
        shell: Shell,
        crypto: require("crypto"),
        navigator: navigator
    },
    app_path: (process: any)=> {
        return Path.join(__dirname, (process.env["VITE_DEV_SERVER_HOST"] !== "127.0.0.1" ? "./../../../../" : "../../"));
    },
    app_data_path: (process: any)=> {
        const path_temp= (os.platform() === "win32" ? process.env["APPDATA"] + "" : process.env["HOME"] + "");
        return Path.join(path_temp, "./");
    },
    app_home_path: (process: any)=> {
        const path_temp= (os.platform() === "win32" ? (process.env["HOMEDRIVE"]  + "" + process.env["HOMEPATH"]) : process.env["HOME"] + "");
        return Path.join(path_temp, "./");
    },
    app_temp_path: (process: any)=> {
        return Path.join(os.tmpdir(), "./");
    },
    environment: (process: any) => {
        return process.env["VITE_DEV_SERVER_HOST"] !== "127.0.0.1" ? "produce" : "develop"
    },
}