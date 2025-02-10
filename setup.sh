# Setup file with scripts to setup my system.

# Needed for all installers (update system)
sudo dnf update

# Install common tools
sudo dnf install curl unzip mpv wget tar fzf ripgrep btop fd geary gthumb gh git fastfetch

# Install Bun
# curl -fsSL https://bun.sh/install | bash

# Install VSCode
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf check-update
sudo dnf install code

# Install Zed editor
curl -f https://zed.dev/install.sh | sh

# Install Starship
curl -sS https://starship.rs/install.sh | sh

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install Ghostty
sudo dnf copr enable pgdev/ghostty
sudo dnf install ghostty

# Install Brave browser
curl -fsS https://dl.brave.com/install.sh | sh

# Install sqlite & sqlitebrowser
sudo dnf install sqlite sqlitebrowser

# Install PostgreSQL
sudo dnf install postgresql-server

# Post Installation, auto activate postgresql.service
sudo postgresql-setup --initdb
sudo systemctl enable postgresql.service
sudo systemctl start postgresql.service

# Install LibreWolf
curl -fsSL https://repo.librewolf.net/librewolf.repo | pkexec tee /etc/yum.repos.d/librewolf.repo
sudo dnf install librewolf


sudo dnf autoremove
sudo dnf clean all
# sudo reboot
