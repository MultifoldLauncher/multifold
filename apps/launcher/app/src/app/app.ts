import * as path from "path";

import { BrowserWindow, App as ElectronApp, shell, screen, session, protocol } from "electron";

export default class App {
  // Keep a global reference of the window object, if you don't, the window will
  // be closed automatically when the JavaScript object is garbage collected.
  private mainWindow: BrowserWindow;
  private application: ElectronApp;

  constructor(application: Electron.App) {
    this.application = application;
  }

  private onWindowAllClosed() {
    if (process.platform !== "darwin") {
      this.application.quit();
    }
  }

  private onRedirect(event: Event, url: string) {
    const targetUrl = new URL(url);
    const currentUrl = new URL(this.mainWindow.webContents.getURL());
    if (targetUrl.host !== currentUrl.host) {
      // this is a normal external redirect, open it in a new browser window
      event.preventDefault();
      shell.openExternal(url);
    }
  }

  /**
   * This method will be called when Electron has finished
   * initialization and is ready to create browser windows.
   * Some APIs can only be used after this event occurs.
   */
  private onReady() {
    // Set Content-Security-Policy header.
    session.defaultSession.webRequest.onHeadersReceived((details, callback) => {
      callback({
        responseHeaders: {
          ...details.responseHeaders,
          // 'unsafe-eval' is required for Next.js in development mode.
          "Content-Security-Policy": this.application.isPackaged ?
            ["default-src 'self' 'unsafe-inline'"] : ["default-src 'self' 'unsafe-inline' 'unsafe-eval'"]
        }
      });
    });

    this.initFileInterceptor();
    this.initMainWindow();
    this.loadMainWindow();
  }

  private onActivate() {
    // On macOS it's common to re-create a window in the app when the
    // dock icon is clicked and there are no other windows open.
    if (this.mainWindow === null) {
      this.onReady();
    }
  }

  private initFileInterceptor() {
    protocol.interceptFileProtocol("file", (request, callback) => {
      const url = new URL(request.url);

      const targetPath = path.join(__dirname, "..", "frontend", url.pathname.substr(1));
      callback({ path: targetPath });
    });
  }

  private initMainWindow() {
    const workAreaSize = screen.getPrimaryDisplay().workAreaSize;
    const width = Math.min(1280, workAreaSize.width || 1280);
    const height = Math.min(720, workAreaSize.height || 720);

    // Create the browser window.
    this.mainWindow = new BrowserWindow({
      title: "MultiFold",
      width: width,
      height: height,
      show: false,
      autoHideMenuBar: true,
      webPreferences: {
        sandbox: true,
        backgroundThrottling: false,
        nativeWindowOpen: true,
        preload: path.join(__dirname, "preload.js")
      }
    });
    // this.mainWindow.setMenu(null);
    this.mainWindow.center();

    // if main window is ready to show, close the splash window and show the main window
    this.mainWindow.once("ready-to-show", () => {
      this.mainWindow.show();
    });

    // Block external URLs.
    this.mainWindow.webContents.on("will-navigate", (event, url) => this.onRedirect(event, url));
    this.mainWindow.webContents.setWindowOpenHandler(details => {
      shell.openExternal(details.url);
      return { action: "deny" };
    });

    // Emitted when the window is closed.
    this.mainWindow.on("closed", () => {
      // Dereference the window object, usually you would store windows
      // in an array if your app supports multi windows, this is the time
      // when you should delete the corresponding element.
      this.mainWindow = null;
    });
  }

  private loadMainWindow() {
    // load the index.html of the app.
    if (!this.application.isPackaged) {
      this.mainWindow.loadURL("http://localhost:4200");
    } else {
      const url = new URL("file:///index.html");
      this.mainWindow.loadURL(url.toString());
    }
  }

  start() {
    // Register application listeners.
    this.application.on("window-all-closed", () => this.onWindowAllClosed());
    this.application.on("ready", () => this.onReady());
    this.application.on("activate", () => this.onActivate());
  }
}
