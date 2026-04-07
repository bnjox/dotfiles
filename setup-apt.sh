# Setup file with scripts to setup my system.


# Needed for all installers (update system)
sudo apt update -y
sudo apt install -y curl unzip xclip mpv wget tar fzf ripgrep btop fd peek gthumb

# Install Git
sudo add-apt-repository ppa:git-core/ppa
sudo apt update -y
sudo apt install -y git


# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
# Download and install Node.js stable version:
nvm install --lts

# Install Bun
curl -fsSL https://bun.sh/install | bash

# Install Github CLI
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
&& sudo mkdir -p -m 755 /etc/apt/keyrings \
&& wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y

# Upgrade GH CLI
sudo apt update
sudo apt install gh


# Download latest neovim and setup
cd /tmp/
wget -c github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
tar -xvzf nvim-linux64.tar.gz nvim
# Rename directory
mv nvim-linux64 nvim/
# Delete old nvim directory
sudo rm -rf /usr/bin/nvim/
# Move current nvim to bin
sudo mv ./nvim /usr/bin/
cd -


# Install Zed editor
curl -f https://zed.dev/install.sh | sh

# Install Starship
curl -sS https://starship.rs/install.sh | sh

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh


# Install Brave browser
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update -y
sudo apt install -y brave-browser
