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

import Box from "@mui/material/Box";
import CircularProgress from "@mui/material/CircularProgress";
import React from "react";

export default function LoadingState() {
  return (
    <Box sx={{
      display: "flex",
      flexDirection: "column",
      justifyContent: "center",
      flex: 1
    }}>
      <CircularProgress size={64} sx={{ justifyContent: "center" }} value={80}/>
    </Box>
  );
}
