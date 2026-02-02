# My personal Neovim configuration

Since you're me, I can run the following commands to install this configuration on my machine (assuming Linux).

```bash
git clone ssh://git@github.com:de-passage/neovim-config.git ~/.config/nvim
nvim -c 'MasonInstall lua-language-server' -c 'q'
```

Obviously, I've run `ssh-keygen` beforehand and registered my SSH public key in github.