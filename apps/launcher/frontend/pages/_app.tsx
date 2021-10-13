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

import "@fontsource/poppins/300.css";
import "@fontsource/poppins/400.css";
import "@fontsource/poppins/500.css";
import "@fontsource/poppins/700.css";

import { CacheProvider, EmotionCache } from "@emotion/react";
import CssBaseline from "@mui/material/CssBaseline";
import { styled, ThemeProvider } from "@mui/material/styles";
import { AppProps } from "next/app";
import Head from "next/head";
import React, { ReactElement, StrictMode, useEffect, useState } from "react";

import Navigation from "../src/components/layout/Navigation";
import { createEmotionCache } from "../src/helper/emotion";
import { Route, RouteContext, routes } from "../src/routing/routing";
import { theme } from "../src/styles/theme";

// Client-side cache, shared for the whole session of the user in the browser.
const clientSideEmotionCache = createEmotionCache();

const AppBarSpacer = styled("div")(({ theme }) => theme.mixins.toolbar);

const ContentContainer = styled("div")({
  display: "flex",
  flexDirection: "column",
  alignItems: "center",
  minHeight: "100vh"
});

interface MyAppProps extends AppProps {
  emotionCache?: EmotionCache;
}

export default function MyApp(props: MyAppProps) {
  const { Component, emotionCache = clientSideEmotionCache, pageProps } = props;

  const [route, setRoute] = useState<Route>(routes.home);

  const [componentLoading, setComponentLoading] = useState(true);
  const [component, setComponent] = useState<ReactElement | undefined>();

  useEffect(() => {
    handleRouteChange(route);
  }, [route]);

  const handleRouteChange = async (route?: Route) => {
    if (route) {
      setComponentLoading(true);
      try {
        const module = await route.component;
        setComponent(module.default(pageProps));
      } finally {
        setComponentLoading(false);
      }
    } else {
      setComponentLoading(false);
      setComponent(undefined);
    }
  };

  return (
    <CacheProvider value={emotionCache}>
      <StrictMode>
        <Head>
          <title>MultiFold</title>
          <meta name="viewport" content="initial-scale=1, width=device-width" />
        </Head>
        <ThemeProvider theme={theme}>
          <RouteContext.Provider value={{ route, componentLoading, component, setRoute }}>
            <CssBaseline />
            <Navigation />
            <ContentContainer>
              <AppBarSpacer />
              <Component {...pageProps} />
            </ContentContainer>
          </RouteContext.Provider>
        </ThemeProvider>
      </StrictMode>
    </CacheProvider>
  );
}
