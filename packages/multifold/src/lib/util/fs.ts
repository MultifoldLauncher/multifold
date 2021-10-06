import * as crypto from "crypto";
import * as fs from "fs";
import * as os from "os";
import * as path from "path";

const tmpDir = os.tmpdir();

export const hashFile = (path: string, algorithm: string): Promise<string> => {
  const hash = crypto.createHash(algorithm);
  const stream = fs.createReadStream(path);

  return new Promise((resolve, reject) => {
    stream.on("error", reject);
    stream.on("data", chunk => hash.update(chunk));
    stream.on("end", () => resolve(hash.digest("hex")));
  });
};


export const exists = (path: string): Promise<boolean> => {
  return fs.promises.access(path, fs.constants.F_OK)
    .then(() => true)
    .catch(() => false);
};

export const mkdir = async (path: string): Promise<void> => {
  if (!await exists(path)) {
    await fs.promises.mkdir(path);
  }
};

export const mkdirs = async (path: string): Promise<void> => {
  if (!await exists(path)) {
    await fs.promises.mkdir(path, { recursive: true });
  }
};

export const writeFile = (path: string, data: string): Promise<void> =>
  fs.promises.writeFile(path, data);

export const createTempDirectory = (prefix = "multifold-"): Promise<string> =>
  fs.promises.mkdtemp(path.join(tmpDir, prefix));

export const getDataDirectory = (): string => {
  const home = process.env.HOME;
  const appdata = process.env.APPDATA;

  switch (process.platform) {
    case "linux":
    case "cygwin":
      if (!home) throw new Error("HOME environment variable is not set");
      return path.join(home, ".local", "share", "multifold");
    case "darwin":
      if (!home) throw new Error("HOME environment variable is not set");
      return path.join(home, "Library", "Application Support", "multifold");
    case "win32":
      if (!appdata) throw new Error("APPDATA environment variable is not set");
      return path.join(appdata, "MultiFold");
    default:
      if (!home) throw new Error("HOME environment variable is not set");
      return path.join(home, ".multifold");
  }
};
