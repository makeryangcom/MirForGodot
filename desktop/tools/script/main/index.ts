import os from "os";
import path from "path";
import * as FileAPI from "fs";
import * as Electron from "electron";
import ElectronDebug from "electron-debug";
import Package from "../../../package.json";

// Language Environment Configuration
import Store from "electron-store";
const store = new Store();

// Initialize the application window
let Windows: any = {
    Main: false,
    UserData: {
        Lang: store.get("mir2:electron:language", ""),
        Sleep: false,
        Quit: true,
    }
};

// Prevent the application from opening multiple times
if (!Electron.app.requestSingleInstanceLock()){
    Electron.app.quit();
}else{
    Electron.app.on("second-instance", ()=>{
        if (Windows.Main) {
            Windows.Main.show();
            Windows.Main.setAlwaysOnTop(true);
            Windows.Main.setAlwaysOnTop(false);
        }
    });
}

// Configuration related to environment variables and startup parameters
process.env["ELECTRON_DISABLE_SECURITY_WARNINGS"] = "true";
ElectronDebug({showDevTools: false, devToolsMode: "bottom"});
Electron.app.commandLine.appendSwitch("ignore-certificate-errors", "true");
Electron.app.commandLine.appendSwitch("disable-gpu", "false");
if(Windows.UserData.Lang !== ""){
    Electron.app.commandLine.appendSwitch("--lang", Windows.UserData.Lang);
}

// Initialize the application's root domain and path
const application_url: string = Electron.app.isPackaged ? `file://${path.join(__dirname, "../template/index.html")}` : `http://${Package.env.VITE_DEV_SERVER_HOST}:${Package.env.VITE_DEV_SERVER_PORT}`;
const user_agent: string = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.5359.215 Safari/537.36";

function onWindowMain(){
    console.log("[main:onWindowMain]");
    Windows.Main = new Electron.BrowserWindow({
        frame: false,
        center: true,
        width: 1200,
        height: 750,
        minWidth: 1200,
        minHeight: 750,
        useContentSize: false,
        hasShadow: os.platform() === "darwin",
        webPreferences: {
            javascript: true,
            spellcheck: true,
            webviewTag: true,
            webSecurity: false,
            nodeIntegration: true,
            contextIsolation: false,
            preload: path.join(__dirname, "../preload/index.cjs")
        },
        fullscreen: false,
        show: false,
        backgroundColor: "#ffffff",
        titleBarStyle: "hidden"
    });

    Windows.Main.loadURL(application_url + "#/?preload=" + path.join(__dirname, "../preload/index.cjs"),{
        "userAgent": user_agent
    }).then((res: any) => {
        console.log("[main:load]", res);
    });

    Windows.Main.on("ready-to-show", function () {
        Windows.Main.show();
    });

    // Implement right-click menu
    Windows.Main.webContents.on("context-menu", (e: any, params: any) => {
        e.preventDefault();
    })

    Electron.globalShortcut.register("Shift+Alt+H", () => {
        Windows.Main.webContents.openDevTools({mode: "bottom", activate: false});
    });

    Electron.globalShortcut.register("Shift+Alt+L", () => {
        Windows.Main.webContents.send("message", {type: "switch:language"});
    });

    Electron.globalShortcut.register("Shift+Alt+K", () => {
        store.set("mir2:electron:language", "zh-CN"); // zh-CN or en-US
    });

    Electron.globalShortcut.register("Shift+Alt+V", () => {
        Windows.Main.webContents.send("message", {type: "open:browser:tools"});
    });

    Electron.globalShortcut.register("Shift+Alt+S", () => {
        Windows.Main.webContents.send("message", {type: "display-sleep", status: !Windows.UserData.Sleep});
    });
}

// When the application is ready
Electron.app.on("ready", () => {
    console.log("[main:ready]");
    // Copy Net Files
    FileAPI.mkdirSync(path.join(__dirname, Electron.app.isPackaged ? "../../../../temp" : "../../temp"), {recursive: true});
    const net_files = FileAPI.readdirSync(path.join(__dirname, "../software"), {withFileTypes: true});
    for (let item of net_files) {
        if(item.name !== "chainnet.js"){
            let srcPath = path.join(path.join(__dirname, "../software/"), item.name);
            let destPath = path.join(path.join(__dirname, Electron.app.isPackaged ? "../../../../temp/" : "../../temp/"), item.name);
            FileAPI.copyFileSync(srcPath, destPath);
        }
    }
});

// When the application is ready
Electron.app.whenReady().then(() => {
    console.log("[main:whenready]");
    onWindowMain();
    // Switch the sleep configuration once to ensure the status is not 0
    Windows.UserData.Sleep = Electron.powerSaveBlocker.start("prevent-display-sleep");
    Electron.powerSaveBlocker.stop(Windows.UserData.Sleep);
    Windows.UserData.Sleep = false;
    // Active state monitoring
    Electron.app.on("activate", () => {
        console.log("[main:activate]");
        if (Electron.BrowserWindow.getAllWindows().length === 0){
            console.log("[main:activate:length]", 0);
            onWindowMain();
        }
    });
    // Request Listening and Interception Handling
    Electron.session.defaultSession.webRequest.onBeforeSendHeaders((details: any, callback: any) =>{
        details.requestHeaders["User-Agent"] = user_agent;
        if (details.url.includes("google.com")) {
            details.requestHeaders["User-Agent"] = "Chrome";
        }
        if (details.url.includes("cdn.nanjing.geekros.com")) {
            details.requestHeaders["Referer"] = "https://makeryang.com";
        }
        callback({cancel: false, requestHeaders: details.requestHeaders});
    });
    // listens for power suspend and screen lock
    Electron.powerMonitor.on("suspend", () => {
        console.log("[main:powerMonitor:suspend]");
        if (Windows.Main) {
            Windows.Main.webContents.send("message", {type: "power-lock"});
        }
    });
    Electron.powerMonitor.on("resume", () => {
        console.log("[main:powerMonitor:resume]");
        if (Windows.Main) {
            Windows.Main.webContents.send("message", {type: "power-unlock"});
        }
    });
    Electron.powerMonitor.on("lock-screen", () => {
        console.log("[main:powerMonitor:lock-screen]");
        if (Windows.Main) {
            Windows.Main.webContents.send("message", {type: "screen-lock"});
        }
    });
    Electron.powerMonitor.on("unlock-screen", () => {
        console.log("[main:powerMonitor:unlock-screen]");
        if (Windows.Main) {
            Windows.Main.webContents.send("message", {type: "screen-unlock"});
        }
    });
});

// Listen for main process messages
Electron.ipcMain.on("message", (event: any, args: any) => {
    if(args.type === "header:right:button"){
        if(args.data === "close"){
            if(!Windows.UserData.Quit){
                Windows.Main.hide();
            }else{
                Windows.Main.close();
                Electron.app.quit();
            }
        }
        if(args.data === "min"){
            Windows.Main.minimize();
        }
        if(args.data === "size"){
            if(Windows.Main.isMaximized()){
                Windows.Main.unmaximize();
            }else{
                Windows.Main.maximize();
            }
        }
        if(args.data === "resize"){
            if(Windows.Main.isMaximized()){
                event.sender.send("message", {type: "header:right:button", data: "max"});
            }else{
                event.sender.send("message", {type: "header:right:button", data: "restore"});
            }
        }
    }
    if(args.type === "on:login"){
        event.sender.send("message", {type: "on:login"});
    }
    if(args.type === "display:sleep"){
        if(args.status){
            Windows.UserData.Sleep = Electron.powerSaveBlocker.start("prevent-display-sleep");
        }else{
            if(Windows.UserData.Sleep){
                Electron.powerSaveBlocker.stop(Windows.UserData.Sleep);
                Windows.UserData.Sleep = false;
            }
        }
        console.log("[main:display:sleep]", Windows.UserData.Sleep);
    }
    if(args.type === "updater"){
        console.log("[main:updater]");
    }
    if(args.type === "quit"){
        console.log("[main:quit]");
    }
});