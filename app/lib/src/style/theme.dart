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

import 'package:flutter/material.dart';

const darkPrimaryColor = Color(0xFF121212);
const greenPrimaryColor = Color(0xFF34D656);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(backgroundColor: darkPrimaryColor),
  scaffoldBackgroundColor: darkPrimaryColor,
  backgroundColor: darkPrimaryColor,
  primaryColor: darkPrimaryColor,
  iconTheme: const IconThemeData().copyWith(color: Colors.white),
  fontFamily: "Roboto",
  splashColor: greenPrimaryColor,
  buttonTheme: const ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
    splashColor: greenPrimaryColor,
  ),
  textTheme: const TextTheme(
    headline1: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w300,
      fontSize: 96,
      height: 1.167,
      letterSpacing: -0.24992,
    ),
    headline2: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w300,
      fontSize: 60,
      height: 1.2,
      letterSpacing: -0.13328,
    ),
    headline3: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 48,
      height: 1.167,
      letterSpacing: 0,
    ),
    headline4: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 34,
      height: 1.235,
      letterSpacing: 0.1176,
    ),
    headline5: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 24,
      height: 1.334,
      letterSpacing: 0,
    ),
    headline6: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 20,
      height: 1.6,
      letterSpacing: 0.12,
    ),
    subtitle1: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 1.75,
      letterSpacing: 0.15008,
    ),
    subtitle2: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      height: 1.57,
      letterSpacing: 0.11424,
    ),
    bodyText1: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 1.5,
      letterSpacing: 0.15008,
    ),
    bodyText2: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 14,
      height: 1.43,
      letterSpacing: 0.17136,
    ),
    button: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      letterSpacing: 0.45712,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      overlayColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.pressed) || states.contains(MaterialState.hovered)) {
          return greenPrimaryColor.withOpacity(0.12);
        }
        return darkPrimaryColor;
      }),
      foregroundColor: MaterialStateProperty.all(Colors.white70),
      textStyle: MaterialStateProperty.all(
        const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          letterSpacing: 0.45712,
        ),
      ),
    )
  ),
);
