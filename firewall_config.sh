#!/bin/bash

# =============================================
#  Interactive Firewall Management Script
#  Author: IsmailElkarmani
#  GitHub: https://github.com/IsmailElkarmani
#  License: MIT
# =============================================

# Colors for terminal
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
RESET="\e[0m"

# Display the ASCII logo
display_logo() {
    echo -e "${CYAN}"
    cat << "EOF"

   ███████╗██╗███████╗██████╗  █████╗ ██╗    ██╗
   ██╔════╝██║██╔════╝██╔══██╗██╔══██╗██║    ██║
   █████╗  ██║█████╗  ██████╔╝███████║██║ █╗ ██║
   ██╔══╝  ██║██╔══╝  ██╔═══╝ ██╔══██║██║███╗██║
   ██║     ██║███████╗██║     ██║  ██║╚███╔███╔╝
   ╚═╝     ╚═╝╚══════╝╚═╝     ╚═╝  ╚═╝ ╚══╝╚══╝  

  ███████╗██╗███████╗███████╗ █████╗ ██╗     ██╗     
  ██╔════╝██║██╔════╝██╔════╝██╔══██╗██║     ██║     
  █████╗  ██║█████╗  █████╗  ███████║██║     ██║     
  ██╔══╝  ██║██╔══╝  ██╔══╝  ██╔══██║██║     ██║     
  ██║     ██║███████╗██║     ██║  ██║███████╗███████╗
  ╚═╝     ╚═╝╚══════╝╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝

     ▄▄▄▄▄▄▄▄  
    ██████████   Interactive Firewall Management 
   ███▀████▀███  Secure Your System with UFW & IPTables
   ██──████──██  Protecting Your Network!
   ███▄████▄███  
    ██████████   
     ▀▀▀▀▀▀▀▀  

          Created by: IsmailElkarmani

EOF
    echo -e "${RESET}"
}

# Enable default rules
enable_default_rules() {
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    echo -e "${GREEN}Default rules enabled: deny incoming, allow outgoing.${RESET}"
}

# Add a rule (SSH, HTTP, etc.)
add_rule() {
    echo -e "\n${BLUE}Add a rule:${RESET}"
    echo "1. Allow SSH (Port 22)"
    echo "2. Allow HTTP (Port 80)"
    echo "3. Allow HTTPS (Port 443)"
    echo "4. Block a specific IP"
    echo "5. Back"
    read -p "Select an option: " choice

    case $choice in
        1)
            sudo ufw allow 22/tcp
            echo -e "${GREEN}SSH (Port 22) allowed.${RESET}"
            ;;
        2)
            sudo ufw allow 80/tcp
            echo -e "${GREEN}HTTP (Port 80) allowed.${RESET}"
            ;;
        3)
            sudo ufw allow 443/tcp
            echo -e "${GREEN}HTTPS (Port 443) allowed.${RESET}"
            ;;
        4)
            read -p "Enter the IP address to block: " ip
            sudo ufw deny from "$ip"
            echo -e "${RED}IP address $ip blocked.${RESET}"
            ;;
        *)
            echo -e "${YELLOW}Back to main menu.${RESET}"
            ;;
    esac
}

# Remove a rule
remove_rule() {
    read -p "Enter the port number or IP of the rule to remove: " rule
    sudo ufw delete allow "$rule"
    echo -e "${GREEN}Rule for $rule removed.${RESET}"
}

# Save the current firewall configuration
save_configuration() {
    read -p "Enter the backup file name (e.g., backup.rules): " file_name
    sudo iptables-save > "$file_name"
    echo -e "${GREEN}Configuration saved to $file_name.${RESET}"
}

# Restore a firewall configuration
restore_configuration() {
    read -p "Enter the configuration file name to restore: " file_name
    sudo iptables-restore < "$file_name"
    echo -e "${GREEN}Configuration restored from $file_name.${RESET}"
}

# Reset firewall settings
reset_firewall() {
    read -p "Are you sure you want to reset the firewall? All rules will be removed. (yes/no): " confirmation
    if [[ "$confirmation" == "yes" ]]; then
        sudo ufw reset
        echo -e "${RED}Firewall reset.${RESET}"
    else
        echo -e "${YELLOW}Reset canceled.${RESET}"
    fi
}

# Display current rules
display_rules() {
    echo -e "${CYAN}Current rules:${RESET}"
    sudo ufw status numbered
}

# Main menu
main_menu() {
    display_logo
    while true; do
        echo -e "\n${YELLOW}Firewall Configuration${RESET}"
        echo -e "${GREEN}[1] Enable default rules${RESET}"
        echo -e "${GREEN}[2] Add a rule${RESET}"
        echo -e "${GREEN}[3] Remove a rule${RESET}"
        echo -e "${GREEN}[4] Save configuration${RESET}"
        echo -e "${GREEN}[5] Restore configuration${RESET}"
        echo -e "${GREEN}[6] Reset firewall${RESET}"
        echo -e "${GREEN}[7] Display current rules${RESET}"
        echo -e "${GREEN}[8] Exit${RESET}"
        read -p "Select an option: " option

        case $option in
            1) enable_default_rules ;;
            2) add_rule ;;
            3) remove_rule ;;
            4) save_configuration ;;
            5) restore_configuration ;;
            6) reset_firewall ;;
            7) display_rules ;;
            8)
                echo -e "${BLUE}Goodbye!${RESET}"
                break
                ;;
            *)
                echo -e "${RED}Invalid option, please try again.${RESET}"
                ;;
        esac
    done
}

# Run the program
main_menu
