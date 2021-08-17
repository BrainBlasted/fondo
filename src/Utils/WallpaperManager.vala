/*
* Copyright (C) 2018  Calo001 <calo_lrc@hotmail.com>
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License as published
* by the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero General Public License for more details.
*
* You should have received a copy of the GNU Affero General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*
*/

using App.Configs;

namespace App.Utils {
    /**
     * The {@code WallpaperManager} class.
     *
     * @since 1.4.0
     */
    public class WallpaperManager {
        private Xdp.Portal? portal;
        private GLib.Settings? mate_settings;
        private const string mate_background_schema = "org.mate.background";

        private bool is_mate = false;
        private bool is_flatpak;

        public WallpaperManager () {
            var env_list = GLib.Environ.@get ();
            is_flatpak = FileUtils.test ("/.flatpak-info", FileTest.EXISTS);

            if (GLib.Environ.get_variable (env_list, "XDG_CURRENT_DESKTOP") == "MATE") {
                is_mate = true;
                var schema_source = GLib.SettingsSchemaSource.get_default ();
                var schema = schema_source.lookup (mate_background_schema, true);
                mate_settings = new GLib.Settings.full (schema, null, null);
                return;
            }

            portal = new Xdp.Portal ();
        }

        public async void set_wallpaper (string picture_path, string picture_options) throws Error {
            if (is_mate && !is_flatpak) {
                mate_settings.set_string ("picture-filename", picture_path);
                mate_settings.set_string ("picture-options", picture_options);
            } else {
                var file = File.new_build_filename(picture_path);
                var window = ((Gtk.Application) GLib.Application.get_default()).get_active_window ();

                yield portal.set_wallpaper (
                    new Xdp.Parent (window),
                    file.get_uri (),
                    Xdp.WallpaperFlags.BACKGROUND | Xdp.WallpaperFlags.LOCKSCREEN
                );
            }
        }
    }
}
