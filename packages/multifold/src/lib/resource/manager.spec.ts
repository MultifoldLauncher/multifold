/*
 *     Multifold: the next-generation Minecraft launcher.
 *     Copyright (C) 2021  Cubxity
 *
 *     This program is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     This program is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import * as path from "path";

import { ArtifactDescriptor, Integrity, ResourceDescriptor, ResourceManager } from "@multifold/core";

import { createTempDirectory, mkdirs, writeFile } from "../util/fs";
import { MultiFoldResourceManager } from "./manager";

const createResourceManager = async (directory: string): Promise<ResourceManager> => {
  const manager = new MultiFoldResourceManager(directory);
  await manager.init();

  return manager;
};

test("get resource folder", async () => {
  const directory = await createTempDirectory();
  const manager = await createResourceManager(directory);

  const resourceDirectory = manager.getResourceDirectory("manifest");
  expect(resourceDirectory).toBe(path.join(directory, "manifest"));
});

test("get artifact path", async () => {
  const directory = await createTempDirectory();
  const manager = await createResourceManager(directory);

  const descriptor: ArtifactDescriptor = {
    type: "library",
    groupId: "app.multifold",
    artifactId: "multifold",
    version: "0.0.1",
    classifier: "special"
  };

  const artifactPath = manager.getArtifactPath(descriptor);
  const expectedPath = path.join(directory, "library", "app", "multifold", "multifold", "0.0.1", "multifold-0.0.1-special.jar");
  expect(artifactPath).toBe(expectedPath);
});

test("get resource path", async () => {
  const directory = await createTempDirectory();
  const manager = await createResourceManager(directory);

  const descriptor: ResourceDescriptor = {
    type: "manifest",
    namespace: "multifold",
    name: "manifest.json"
  };

  const resourcePath = manager.getResourcePath(descriptor);
  const expectedPath = path.join(directory, "manifest", "multifold", "manifest.json");
  expect(resourcePath).toBe(expectedPath);
});

test("verify resource integrity", async () => {
  const directory = await createTempDirectory();
  const manager = await createResourceManager(directory);

  const descriptor: ResourceDescriptor = {
    type: "manifest",
    namespace: "multifold",
    name: "manifest.json"
  };

  const resourcePath = manager.getResourcePath(descriptor);

  await mkdirs(path.dirname(resourcePath));
  await writeFile(resourcePath, "{}");

  const integrities: Integrity[] = [
    { sha512: "27c74670adb75075fad058d5ceaf7b20c4e7786c83bae8a32f626f9782af34c9a33c2046ef60fd2a7878d378e29fec851806bbd9a67878f3a9f1cda4830763fd" },
    { sha256: "44136fa355b3678a1146ad16f7e8649e94fb4fc21fe77e8310c060f61caaff8a" },
    { sha1: "bf21a9e8fbc5a3846fb05b4fa0859e0917b2202f" },
    { md5: "99914b932bd37a50b983c5e7c90ae93b" }
  ];

  for (const integrity of integrities) {
    const resourceDescriptor = {
      ...descriptor,
      integrity
    };
    await expect(manager.verifyResource(resourceDescriptor)).resolves.toBeTruthy();

    // Tamper with the checksum
    const key = Object.keys(integrity)[0];
    integrity[key] = (integrity[key] as string).substr(1) + "x";

    await expect(manager.verifyResource(resourceDescriptor)).resolves.not.toBeTruthy();
  }
});

