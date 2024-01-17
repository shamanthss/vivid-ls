#!/bin/bash

# Prompt the user to select shell configuration file
pick_bash() {
echo '(+) Which shell configuration file would you like to modify?'
echo "1. .bashrc"
echo "2. .zshrc"
read -p '(+) Enter the Number Corresponding to your Choice: ' shell_choice

case $shell_choice in
    1)
        config_file="$HOME/.bashrc"
        bash_echo
        ;;
    2)
        config_file="$HOME/.zshrc"
        bash_echo
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

# Add colorls and Nerd Fonts to the selected shell profile
echo 'eval "$(colorls init bash)"' >> "$config_file"
echo 'export NERD_FONT_PATH="$HOME/.local/share/fonts"' >> "$config_file"
echo "alias ls='colorls'" >> "$config_file"
echo "alias la='colorls -A'" >> "$config_file"
echo "alias ll='colorls -l'" >> "$config_file"


# Source the updated profile to apply changes immediately
source "$config_file"

echo "COLORLS and the chosen Nerd Font have been successfully installed and configured in $config_file."
echo "Please Close existing Terminal and Type ls on new Terminal to see the Magic  "
}

# Prompt the user to select a Nerd Font
pick_font() {
echo '(+) Choose a Nerd Font to Install:'
echo "    1. Fira Code - Recommended"
echo "    2. Fira Code Mono"
echo "    3. Hack Nerd Font"
echo "    4. Ubuntu"
echo "    5. Ubuntu Mono"
echo "    0. To QUIT installer!"
read -p '(+) Enter the Number Corresponding to your Choice: ' font_choice

case $font_choice in
    1)
        font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip"
        sleep 1
        ;;
    2)
        font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraMono.zip"
        sleep 1
        ;;
    3)
        font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip"
        sleep 1
        ;;
    4)
        font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Ubuntu.zip"
        sleep 1
        ;;
    5)
        font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/UbuntuMono.zip"
        sleep 1
        ;;
    0)
        echo "Exiting installation....."
        exit 1
        ;;    
    *)
        echo "Please enter a vaild choice..."
        pick_font
        ;;
esac

echo "Installing Nerd Font..."
mkdir -p ~/.local/share/fonts
wget -P ~/.local/share/fonts "$font_url"
unzip -o ~/.local/share/fonts/$(basename "$font_url") -d ~/.local/share/fonts
sleep 1
fc-cache -f -v
echo "Installing Nerd Font Complete.... "

# Install colorls using Ruby's gem package manager
gem install colorls

pick_bash

}

check_and_install() {
package_manager=""

if [ -f "/etc/debian_version" ]; then
    package_manager="sudo apt install -y"
    pick_font
elif [ -f "/etc/alpine-release" ]; then
    package_manager="sudo apk --update add"
    pick_font
elif [ -f "/etc/centos-release" ]; then
    package_manager="sudo yum install -y"
    pick_font
elif [ -f "/etc/fedora-release" ]; then
    package_manager="sudo dnf install -y"
    pick_font
fi

if [ -z "$package_manager" ]; then
    echo "Unsupported distribution. Please install the required package ruby-rubygem and ruby-dev manually."
    exit 1
fi

package="ruby-rubygems"
package2="ruby-dev"

$package_manager $package $package2
sleep 2
}

#Script Begins here
# Check if Ruby is installed
echo "Checking if Ruby gems is installed...."
if command gem list abbrev -i; then
    echo "Ruby gem is installed!";
    pick_font
else
    echo "Ruby gems is not Installed. Please wait attempting to install....."
    check_and_install
fi
