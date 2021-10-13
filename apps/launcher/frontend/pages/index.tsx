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

import Fade from "@mui/material/Fade";
import React, { useContext } from "react";

import LoadingState from "../src/components/layout/LoadingState";
import { RouteContext } from "../src/routing/routing";

export default function Index() {
  const { componentLoading, component } = useContext(RouteContext);

  return (
    <Fade in={!componentLoading}>
      {component || <LoadingState />}
    </Fade>
  );
}
