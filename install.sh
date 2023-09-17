#!/bin/sh

# Timezone correction
sudo ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
sudo dkpg-reconfigure --frontend noninteractive tzdata

# zsh, p10k
echo "==========================================================="
echo "             cloning powerlevel10k                         "
echo "-----------------------------------------------------------"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

echo "==========================================================="
echo "             cloning zsh-autosuggestions                   "
echo "-----------------------------------------------------------"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "==========================================================="
echo "             cloning zsh-syntax-highlighting               "
echo "-----------------------------------------------------------"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo "==========================================================="
echo "             cloning history-sync                          "
echo "-----------------------------------------------------------"
git clone https://github.com/wulfgarpro/history-sync.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/history-sync

echo "==========================================================="
echo "             import zshrc                                  "
echo "-----------------------------------------------------------"
cat .zshrc > $HOME/.zshrc

echo "==========================================================="
echo "             import powerlevel10k                          "
echo "-----------------------------------------------------------"
cat .p10k.zsh > $HOME/.p10k.zsh

# make highlights readable
echo "" >> ~/.zshrc
echo "# remove ls and directory completion highlight color" >> ~/.zshrc
echo "_ls_colors=':ow=01;33'" >> ~/.zshrc
echo 'zstyle ":completion:*:default" list-colors "${(s.:.)_ls_colors}"' >> ~/.zshrc
echo 'LS_COLORS+=$_ls_colors' >> ~/.zshrc

# change default shell to zsh
sudo chsh "$(id -un)" --shell "/usr/bin/zsh"
