{ config, pkgs, lib, ...}:
let
in
{
environment.systemPackages = with pkgs; [
vimPlugins.packer-nvim
];
}
