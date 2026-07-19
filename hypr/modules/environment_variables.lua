
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("ELECTRON_OZONE_PLATFORM_HINT","wayland")
hl.env("MOZ_ENABLE_WAYLAND","1")

hl.env("GDK_BACKEND","wayland")
hl.env("QT_QPA_PLATFORM","wayland")

hl.env("AQ_DRM_DEVICES","/dev/dri/card2:/dev/dri/card1")
hl.env("XDG_SCREENSHOTS_DIR", "$HOME/Pictures/Screenshots")


hl.env("GTK_APPLICATION_PREFER_DARK_THEME","1")
hl.env("XDG_CURRENT_DESKTOP","Hyprland")
hl.env("QT_QPA_PLATFORMTHEME","qt6ct")
