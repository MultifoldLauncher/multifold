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

import ExpandMoreIcon from "@mui/icons-material/ExpandMore";
import AppBar from "@mui/material/AppBar";
import Avatar from "@mui/material/Avatar";
import Box from "@mui/material/Box";
import Button from "@mui/material/Button";
import IconButton from "@mui/material/IconButton";
import SvgIcon from "@mui/material/SvgIcon";
import Toolbar from "@mui/material/Toolbar";
import { useTheme } from "@mui/material/styles";
import useScrollTrigger from "@mui/material/useScrollTrigger";
import React, { PropsWithChildren, useContext } from "react";

import { ReactComponent as MultiFoldLogo } from "../../../assets/logo/multifold.svg";
import { Route, RouteContext, routes } from "../../routing/routing";

interface NavButtonProps {
  route: Route;
}

const NavIconButton = (props: PropsWithChildren<NavButtonProps>) => {
  const { setRoute } = useContext(RouteContext);
  const { route, children } = props;

  const changeRoute = () => {
    setRoute(route);
  };

  return (
    <IconButton color="inherit" sx={{ mx: 2 }} onClick={changeRoute}>
      {children}
    </IconButton>
  );
};

const NavButton = (props: NavButtonProps) => {
  const { setRoute } = useContext(RouteContext);
  const { route } = props;

  const changeRoute = () => {
    setRoute(route);
  };

  return (
    <Button color="inherit" sx={{ ml: 1 }} onClick={changeRoute}>
      {route.name}
    </Button>
  );
};

export default function Navigation() {
  const theme = useTheme();

  const elevationTrigger = useScrollTrigger({
    disableHysteresis: true,
    threshold: 0
  });

  return (
    <AppBar
      position="fixed"
      elevation={elevationTrigger ? 4 : 0}
      sx={{
        backgroundColor: theme.palette.background.default,
        backgroundImage: "none !important"
      }}
    >
      <Toolbar sx={{ p: "0 !important", justifyItems: "center" }}>
        <NavIconButton route={routes.home}>
          <SvgIcon component={MultiFoldLogo} viewBox="0 0 1000 1000" fontSize="large" />
        </NavIconButton>
        <NavButton route={routes.instances} />
        <NavButton route={routes.mods} />
        <NavButton route={routes.customize} />
        <Box flexGrow={1} />
        <Avatar
          src="https://crafatar.com/avatars/eac1410026764a6d9dea85437b2c133d?size=256&default=MHF_Steve&overlay"
          sx={{ mr: 1 }}
        />
        <IconButton>
          <ExpandMoreIcon fontSize="small" />
        </IconButton>
      </Toolbar>
    </AppBar>
  );
}
