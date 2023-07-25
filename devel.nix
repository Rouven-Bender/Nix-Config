{ config, pkgs, lib, ...}:
let
in
{
environment.systemPackages = with pkgs; [
git
zig # treesitter needs a c compiler
libstdcxx5 # treesitter needs this c++ lib
lua-language-server
zls # language server für zig
go
];
}
