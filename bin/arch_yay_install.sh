#!/bin/bash

mkdir -p ~/Downloads

cd ~/Downloads || exit

sudo pacman -S --needed base-devel git

git clone https://aur.archlinux.org/yay.git

cd yay || exit

makepkg -si

cd ~/Downloads || exit

rm -rf ~/Downloads/yay
