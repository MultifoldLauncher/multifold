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

export interface Account {
  readonly type: string;

  /**
   * The UUID associated with the account.
   */
  readonly id: string;

  /**
   * The username associated with the account.
   */
  readonly username: string;

  /**
   * The active access token associated with the account.
   */
  readonly accessToken: string;

  /**
   * Verifies the current account credentials.
   * @return true if the account is valid.
   */
  validate(): Promise<boolean>;

  /**
   * Refreshes the current account credentials.
   * @return true if the request was successful.
   */
  refresh(): Promise<boolean>;

  /**
   * Invalidates the current account credentials.
   * @return true if the request was successful.
   */
  logout(): Promise<boolean>;

  /**
   * Serializes the account data into an object.
   * @return unknown serialized account data.
   */
  serialize(): unknown;
}