# My personal Neovim configuration

Since you're me, I can run the following commands to install this configuration on my machine (assuming Linux).

```bash
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
git clone git@github.com:de-passage/neovim-config.git ~/.config/nvim
nvim -c 'PackerInstall'
```

Obviously, I've run `ssh-keygen` beforehand and registered my SSH public key in github.
