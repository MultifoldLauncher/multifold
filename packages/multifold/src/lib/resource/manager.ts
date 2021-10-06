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

import {
  ArtifactDescriptor,
  ArtifactType,
  Integrity,
  ResourceDescriptor,
  ResourceManager,
  ResourceType
} from "@multifold/core";

import { exists, hashFile, mkdir } from "../util/fs";
import { resolveArtifactPath } from "../util/maven";

// noinspection JSDeprecatedSymbols
export class MultiFoldResourceManager implements ResourceManager {
  private readonly directory: string;

  constructor(directory: string) {
    this.directory = directory;
  }

  async init(): Promise<void> {
    await mkdir(this.directory);
  }

  getArtifactPath(descriptor: ArtifactDescriptor): string {
    const artifactPath = resolveArtifactPath(
      descriptor.groupId,
      descriptor.artifactId,
      descriptor.version,
      "jar",
      descriptor.classifier
    );

    return path.join(this.directory, descriptor.type, artifactPath);
  }

  getResourcePath(descriptor: ResourceDescriptor): string {
    return path.join(this.directory, descriptor.type, descriptor.namespace, descriptor.name);
  }

  getResourceDirectory(type: ArtifactType | ResourceType | string): string {
    return path.join(this.directory, type);
  }

  async verifyArtifact(descriptor: ArtifactDescriptor): Promise<boolean> {
    const file = this.getArtifactPath(descriptor);
    if (!(await exists(file))) return false;

    return MultiFoldResourceManager.verifyFile(file, descriptor.integrity);
  }

  async verifyResource(descriptor: ResourceDescriptor): Promise<boolean> {
    const file = this.getResourcePath(descriptor);
    if (!(await exists(file))) return false;

    return MultiFoldResourceManager.verifyFile(file, descriptor.integrity);
  }

  private static async verifyFile(
    file: string,
    integrity: Integrity | undefined
  ): Promise<boolean> {
    if (integrity) {
      if (integrity.sha512) {
        const hash = await hashFile(file, "sha512");
        return hash === integrity.sha512.toLowerCase();
      } else if (integrity.sha256) {
        const hash = await hashFile(file, "sha256");
        return hash === integrity.sha256.toLowerCase();
      } else if (integrity.sha1) {
        const hash = await hashFile(file, "sha1");
        return hash === integrity.sha1.toLowerCase();
      } else if (integrity.md5) {
        const hash = await hashFile(file, "md5");
        return hash === integrity.md5.toLowerCase();
      }
    }
    return true;
  }
}
