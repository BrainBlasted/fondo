// Not full bindings, just enough to set wallpaper
// © Alexander Mikhaylenko | Nostalgia | GPLv3+

[CCode (cheader_filename = "libportal/portal-gtk3.h")]
namespace Xdp {
    [CCode (cprefix = "XDP_WALLPAPER_FLAG_", type_id = "xdp_wallpaper_flags_get_type ()")]
    [Flags]
    public enum WallpaperFlags {
        NONE,
        BACKGROUND,
        LOCKSCREEN,
        PREVIEW
    }

    public class Portal : GLib.Object {
        public Portal ();

        public async bool set_wallpaper (Parent parent, string uri, WallpaperFlags flags, GLib.Cancellable? cancellable = null) throws GLib.Error;
    }

    [Compact]
    [CCode (cname = "XdpParent", free_function = "xdp_parent_free", has_type_id = false)]
    public class Parent {
        [CCode (cname="xdp_parent_new_gtk")]
        public Parent (Gtk.Window window);
    }
}
