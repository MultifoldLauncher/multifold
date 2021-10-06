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

export const TYPE_LIBRARY = "library";
export const TYPE_MOD = "library";

export const TYPE_MANIFEST = "manifest";
export const TYPE_NATIVES = "natives";
export const TYPE_ASSETS = "assets";

export type ArtifactType =
  typeof TYPE_LIBRARY |
  typeof TYPE_MOD |
  string;

export type ResourceType =
  typeof TYPE_MANIFEST |
  typeof TYPE_NATIVES |
  typeof TYPE_ASSETS |
  string;

/**
 * Describes an artifact and does not contain the download URI.
 * This is used for game libraries and mods. An example of this is
 * ASM 9.1 (org.ow2.asm:asm:9.1).
 *
 * @see Artifact
 */
export interface ArtifactDescriptor {
  readonly type: ArtifactType;

  /**
   * This is usually the package name of the artifact. For example:
   * org.ow2.asm. For mods with no known package name, the group id
   * is as follows: com.modrinth.mods.
   */
  readonly groupId: string;

  /**
   * This is usually the name of the artifact. For example: asm. For mods
   * with no known artifact id, it is usually the mod id. For example: sodium.
   */
  readonly artifactId: string;

  /**
   * This is the version of the artifact. It is recommended to use semver.
   * For example: 1.0.0-beta.
   */
  readonly version: string;

  /**
   * This is usually unused, however, it is often used to classify native
   * artifacts. For example: natives-linux.
   */
  readonly classifier?: string;

  /**
   * @see Integrity
   */
  readonly integrity?: Integrity;
}

/**
 * Represents a downloadable artifact.
 *
 * @see ArtifactDescriptor
 */
export interface Artifact extends ArtifactDescriptor {
  /**
   * RFC 3986-compatible URI. This is used to retrieve the artifact.
   * It is recommended to serve the artifact over HTTPS.
   */
  readonly uri: string;
}

/**
 * Describes a resource and does not contain the download URI.
 * This is used for game assets and manifests, for example:
 * minecraft:objects/6b/6b1df47660958fcda052627411b6651f8a51da4d.
 *
 * @see Artifact
 */
export interface ResourceDescriptor {
  readonly type: ResourceType;

  /**
   * The namespace this resource belongs to. This is used to organize
   * resources. Example: minecraft.
   */
  readonly namespace: string;

  /**
   * The relative path of the resource. Note that the path is not validated
   * by the {@see ResourceManager}. Make sure to sanitize inputs before
   * passing the value to this field. For example:
   * objects/6b/6b1df47660958fcda052627411b6651f8a51da4d.
   */
  readonly name: string;

  /**
   * @see Integrity
   */
  readonly integrity?: Integrity;
}

/**
 * This represents a downloadable resource.
 *
 * @see ResourceDescriptor
 */
export interface Resource extends ResourceDescriptor {
  /**
   * RFC 3986-compatible URI. This is used to retrieve the resource.
   * It is recommended to serve the artifact over HTTPS.
   */
  readonly uri: string;
}

/**
 * Contains the checksums/digests for an artifact or resource.
 * If specified, the launcher should verify the integrity before launching.
 */
export interface Integrity {
  readonly sha512?: string;

  readonly sha256?: string;

  /**
   * @deprecated this algorithm is no longer secure, see: https://shattered.io/.
   */
  readonly sha1?: string;

  /**
   * @deprecated this algorithm is no longer secure.
   */
  readonly md5?: string;
}

/**
 * Responsible for managing resources in an installation,
 * this includes libraries, mods, and more.
 *
 * @see Installation
 */
export interface ResourceManager {
  /**
   * Initializes the resource manager.
   */
  init(): Promise<void>;

  /**
   * Retrieves the absolute path for {@param descriptor}.
   *
   * @returns string path of the specified artifact.
   */
  getArtifactPath(descriptor: ArtifactDescriptor): string;

  /**
   * Retrieves the absolute path for {@param descriptor}.
   *
   * @returns string path of the specified resource.
   */
  getResourcePath(descriptor: ResourceDescriptor): string;

  /**
   * Retrieves the absolute path for {@param type}. The directory
   * may not actually exist.
   *
   * @returns string directory for the specified resource type.
   */
  getResourceDirectory(type: ArtifactType | ResourceType | string): string;

  /**
   * Verifies that the artifact exists and additionally verify
   * the {@see Integrity} of the artifact.
   *
   * @param descriptor the artifact to verify.
   * @returns true if the artifact is successfully verified.
   */
  verifyArtifact(descriptor: ArtifactDescriptor): Promise<boolean>;

  /**
   * Verifies that the resource exists and additionally verify
   * the {@see Integrity} of the artifact.
   *
   * @param descriptor the resource to verify.
   * @returns true if the resource is successfully verified.
   */
  verifyResource(descriptor: ResourceDescriptor): Promise<boolean>;
}
