# Dotfiles

My [dotfiles](https://wiki.archlinux.org/title/Dotfiles)!

Config files:
- `.zshrc` -> `~/.zshrc`: (Oh My) ZSH config file
- `.p10k.zsh` -> `~/.p10k.zsh`: ZSH theme ([powerlevel10k](https://github.com/romkatv/powerlevel10k)) config file
- `aliases.zsh` -> `~/.oh-my-zsh/custom/aliases.zsh`: Custom ZSH aliases

Setup scripts:
- `install.sh`: Sets up a GitHub Codespace (see [here](https://docs.github.com/en/codespaces/setting-your-user-preferences/personalizing-github-codespaces-for-your-account#dotfiles))
- `setup_linux.sh`: Sets up a linux user account:
  - Configures git
  - Creates an SSH key
  - Configures GPG
  - Installs (Oh My) ZSH
  - Configures ZSH extensions
  - Installs dotfiles
  - Configures history sync (see [krishnans2006/history](https://github.com/krishnans2006/history))

Future plans:
- Make `setup_linux.sh` better (Python rewrite?)
  - More functionality
  - Selective functionality (ifttt, using info like current distro)
  - User-selected functionality (Proper Y/N parsing, possibly argparse)
- Improve filenames and directory structure
