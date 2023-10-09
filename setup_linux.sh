#!/bin/bash
read -p "*SETUP SCRIPT! Press ENTER to start"

echo ""
echo "*Configuring git"
git config --global user.name "Krishnan Shankar"
git config --global user.email "krishnans2006@gmail.com"
git config --global init.defaultBranch main
read -p "*Press ENTER to continue"

echo ""
echo "*Generating new SSH key"
ssh-keygen -t ed25519 -C "krishnans2006@gmail.com"
read -p "*Press ENTER to continue"

echo ""
echo "*Adding key to SSH agent"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
read -p "*Press ENTER to continue"

echo ""
echo "*Adding key to remotes"
cat ~/.ssh/id_ed25519.pub
read -p "*Copy the above to preferred remotes (https://github.com/settings/ssh/new), then press ENTER when done"

echo ""
echo "*Testing GitHub connection"
ssh -T git@github.com
read -p "*Press ENTER to continue"

echo ""
echo "*Importing GPG key"
read -p "*Make sure the exported GPG key is available at ~/gpg.key, then press ENTER to continue"
gpg --import gpg.key
GPG_KEY_ID=$(gpg --list-signatures --with-colons | grep 'sig' | grep 'krishnans2006@gmail.com' | head -n 1 | cut -d':' -f13)
read -p "*Press ENTER to continue"

echo ""
echo "*Trusting imported GPG key"
echo "trust
5
y
save" | gpg --command-fd=0 --status-fd=1 --edit-key "$GPG_KEY_ID"
gpg --list-secret-keys
read -p "*Press ENTER to continue"

echo ""
echo "*Configuring git to use GPG key"
git config --global commit.gpgsign true
git config --global user.signingkey "$GPG_KEY_ID"
read -p "*Press ENTER to continue"

echo ""
echo "*Installing ZSH"
sudo apt install zsh
read -p "*Press ENTER to continue"

echo ""
echo "*Installing Oh My Zsh"
echo "
" | RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
read -p "*Press ENTER to continue"

echo ""
echo "*Cloning ZSH extensions"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/wulfgarpro/history-sync.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/history-sync
read -p "*Press ENTER to continue"

echo ""
echo "*Cloning dotfiles"
git clone git@github.com:krishnans2006/dotfiles.git
read -p "*Press ENTER to continue"

echo ""
echo "*Linking dotfiles to shell"
rm ~/.zshrc
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -s ~/dotfiles/aliases.zsh ~/.oh-my-zsh/custom/aliases.zsh
read -p "*Press ENTER to continue"

echo ""
echo "*Configuring history sync"
mkdir ~/.zsh_history_proj
cd ~/.zsh_history_proj
git init
git remote add origin git@github.com:krishnans2006/history.git
git pull --set-upstream origin main
touch ~/.zsh_history
zsh -ic 'zhpl'
read -p "*Press ENTER to continue"

echo ""
echo "That's it! You should now be fully set up"
