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

import { Manifest } from "../types";

/**
 * https://github.com/MultifoldLauncher/rfcs/blob/master/specification/0001-multifold.instance.json.md
 */
export type InstanceManifestBase = Manifest & {
  readonly kind: "Instance"
};

export type InstanceManifestV1Alpha1 = InstanceManifestBase & {
  readonly version: "v1alpha1",
  readonly metadata: InstanceManifestV1Alpha1Metadata,
  readonly spec: InstanceManifestV1Alpha1Spec
};

export type InstanceManifestV1Alpha1Metadata = {
  readonly name: string;
  readonly group?: string;
};

export type InstanceManifestV1Alpha1Spec = {
  readonly components: InstanceManifestV1Alpha1Component[];
  readonly mods: InstanceManifestV1Alpha1Mod[];
};

export type InstanceManifestV1Alpha1Component = {
  readonly id: string;
  readonly version: string;
  readonly settings?: Record<string, string>;
};

export type InstanceManifestV1Alpha1Mod = {
  readonly id: string;
  readonly provider: string;
  readonly version: string;
};

export type InstanceManifest = InstanceManifestV1Alpha1;
export type InstanceManifestMetadata = InstanceManifestV1Alpha1Metadata;
export type InstanceManifestSpec = InstanceManifestV1Alpha1Spec;
export type InstanceManifestComponent = InstanceManifestV1Alpha1Component;
export type InstanceManifestMod = InstanceManifestV1Alpha1Mod;
