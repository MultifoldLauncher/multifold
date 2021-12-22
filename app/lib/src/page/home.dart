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

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Headline 1",
          style: Theme.of(context).textTheme.headline1,
        ),
        Text(
          "Headline 2",
          style: Theme.of(context).textTheme.headline2,
        ),
        Text(
          "Headline 3",
          style: Theme.of(context).textTheme.headline3,
        ),
        Text(
          "Headline 4",
          style: Theme.of(context).textTheme.headline4,
        ),
        Text(
          "Headline 5",
          style: Theme.of(context).textTheme.headline5,
        ),
        Text(
          "Headline 6",
          style: Theme.of(context).textTheme.headline6,
        ),
        Text(
          "Subtitle 1",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        Text(
          "Subtitle 2",
          style: Theme.of(context).textTheme.subtitle2,
        ),
        Text(
          "Body 1",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        Text(
          "Body 2",
          style: Theme.of(context).textTheme.bodyText2,
        ),
        MaterialButton(
          child: Text("Button"),
          onPressed: () {},
        )
      ],
    );
  }
}
