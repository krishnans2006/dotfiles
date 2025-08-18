git config --global user.name "Krishnan Shankar"
git config --global user.email "krishnans2006@gmail.com"
git config --global init.defaultBranch main
git config --global rerere.enabled true

ssh-keygen -t ed25519 -C "krishnans2006@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
printf "%s " "Copy the above to preferred remotes (https://github.com/settings/ssh/new), then press ENTER when done"
read
ssh -T git@github.com
printf "%s " "Works? If not, fix it and press ENTER to continue"
read

printf "%s " "Make sure the exported GPG key is available at ~/gpg.key, then press ENTER to continue"
read
gpg --import gpg.key
GPG_KEY_ID=$(gpg --list-signatures --with-colons | grep 'sig' | grep 'krishnans2006@gmail.com' | head -n 1 | cut -d':' -f13)
echo "trust
5
y
save" | gpg --command-fd=0 --status-fd=1 --edit-key "$GPG_KEY_ID"
gpg --list-secret-keys
printf "%s " "Worked? If not, fix it and press ENTER to continue"
read

git config --global commit.gpgsign true
git config --global user.signingkey "$GPG_KEY_ID"

echo "
" | RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/wulfgarpro/history-sync.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/history-sync

git clone git@github.com:krishnans2006/dotfiles.git ~/.dotfiles
rm ~/.zshrc
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.p10k.zsh ~/.p10k.zsh
ln -s ~/.dotfiles/aliases.zsh ~/.oh-my-zsh/custom/aliases.zsh

printf "%s " "Make sure SSO is configured for this key (https://github.com/settings/keys), then press ENTER to continue"
read
git clone --recurse-submodules git@github.com:krishnans2006/classes.git ~/School
