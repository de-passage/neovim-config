# My personal Neovim configuration

Since you're me, I can run the following commands to install this configuration on my machine (assuming Linux).

```bash
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
git clone https://github.com/de-passage/neovim-config.git ~/.config/nvim
nvim -c 'PackerInstall'
```

Obviously, I've run `ssh-keygen` beforehand and registered my SSH public key in github.

## LSP servers (on linux)

* [Lua](https://github.com/LuaLS/lua-language-server/releases). Beware, the musl version is dynamically linked and won't work out of the box unless the musl shared lib and dynamic linker are installed.
* [Rust](https://github.com/rust-lang/rust-analyzer/releases). Apparently the recommended installation is to just drop the binary in the path
* [Clangd] https://clangd.llvm.org/installation.html). For older versions `sudo apt install clangd-13` should be enough. Don't forget to `update-alternatives` it into clangd
* [Go](https://pkg.go.dev/golang.org/x/tools/gopls#section-readme)
