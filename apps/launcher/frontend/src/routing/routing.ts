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

import { Context, createContext, FunctionComponent, ReactElement } from "react";

export interface Route {
  name: string;
  component: Promise<{
    default: FunctionComponent<any>
  }>;
}

export const routes: Record<string, Route> = {
  home: {
    name: "Home",
    component: import("../components/layout/Home")
  },
  instances: {
    name: "Instances",
    component: import("../components/layout/Test")
  },
  mods: {
    name: "Mods",
    component: import("../components/layout/Test")
  },
  customize: {
    name: "Customize",
    component: import("../components/layout/Test")
  }
};

export const RouteContext: Context<RouteContextState> = createContext({
  componentLoading: true,
  setRoute(_: Route) {
    // NOOP
  }
});

export interface RouteContextState {
  route?: Route;
  componentLoading: boolean;
  component?: ReactElement;

  setRoute(route: Route);
}
