#!/bin/bash

GREEN="\\e[32m"
RED="\\e[31m"
NC="\\e[0m"

set -e

if ! [ -x "$(command -v ufw)" ]; then
    printf "\n%b\n\n" "${GREEN}Installing UFW...${NC}"
    sudo pacman -S --needed --noconfirm ufw
  else
    printf "\n%b\n\n" "${GREEN}UFW is already installed${NC}"
fi

printf "%b\n\n" "${RED}Disabling UFW${NC}"
sudo ufw disable
sleep 0.1

printf "\n%b\n\n" "${GREEN}Limiting port 22/tcp (UFW)${NC}"
sudo ufw limit 22/tcp
sleep 0.1

printf "\n%b\n\n" "${GREEN}Allowing port 80/tcp (UFW)${NC}"
sudo ufw allow 80/tcp
sleep 0.1

printf "\n%b\n\n" "${GREEN}Allowing port 443/tcp (UFW)${NC}"
sudo ufw allow 443/tcp
sleep 0.1

printf "\n%b\n\n" "${GREEN}Limiting port 22000 (Syncthing)${NC}"
sudo ufw limit 22000/tcp
sleep 0.1

printf "\n%b\n\n" "${GREEN}Denying Incoming Packets by Default(UFW)${NC}"
sudo ufw default deny incoming
sleep 0.1

printf "\n%b\n\n" "${GREEN}Allowing Outgoing Packets by Default(UFW)${NC}"
sudo ufw default allow outgoing
sleep 0.1

printf "\n%b\n\n" "${GREEN}Enabled Firewall with basic rules + syncthing${NC}"
sudo ufw enable
sleep 0.1

sudo ufw status
