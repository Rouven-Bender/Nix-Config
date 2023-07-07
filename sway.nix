{ config, pkgs, lib, ... }:
let
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;
    text = ''
    dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
    systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Dracula'
      '';
  };
in
{
  environment.systemPackages = with pkgs; [
  alacritty
  dbus-sway-environment
  configure-gtk
  wayland
  waybar # replacement for the default top bar
  xdg-utils
  glib
  dracula-theme
  gnome3.adwaita-icon-theme
  swaylock
  swayidle
  grim
  slurp
  wl-clipboard
  mako
  libnotify # for beeing able to send notifications to mako
  wofi
  wdisplays
  pamixer # audio-mixer for pipewire
  mpd # music player demon
  mpc-cli # cli client for mpd for keyboard shortcuts
  ncmpcpp # cli client for mpd
  ];
  services.pipewire = {
  enable = true;
  alsa.enable = true;
  pulse.enable = true;
  };
  services.dbus.enable = true;
  xdg.portal = {
  enable = true;
  wlr.enable = true;
  extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  programs.sway = {
  enable = true;
  wrapperFeatures.gtk = true;
  };
}
