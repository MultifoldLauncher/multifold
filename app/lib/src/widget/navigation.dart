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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MultifoldNavigation extends StatelessWidget {
  const MultifoldNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset("assets/logo.svg", width: 48, height: 48),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextButton(
              onPressed: () {},
              child: Text(
                AppLocalizations.of(context)!.navigationInstancesButton,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextButton(
              onPressed: () {},
              child: Text(
                AppLocalizations.of(context)!.navigationCustomizeButton,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextButton(
              onPressed: () {},
              child: Text(
                AppLocalizations.of(context)!.navigationSettingsButton,
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Material(
              color: Colors.transparent,
              child: ActionChip(
                backgroundColor: Colors.grey.shade900,
                avatar: CircleAvatar(
                  backgroundColor: Colors.grey.shade800,
                  child: const Icon(Icons.account_circle),
                ),
                label: Text(
                  AppLocalizations.of(context)!.navigationLoginButton,
                  style: Theme.of(context).textTheme.button,
                ),
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
    );
  }
}
