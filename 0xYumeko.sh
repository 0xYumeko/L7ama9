#!/bin/bash

usernames_file="usernames.txt"

GREEN='\033[0;32m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

BORDER='════════════════════════════════════'
SUCCESS_ICON='✔️'
ERROR_ICON='❌'
INFO_ICON='ℹ️'
LIST_ICON='📋'

LOGO='
  _  __       __         __     _  _          
 | |/ /      / /        / /    | || |         
 |   /      / /_  __   / /_    | || |__   __ _ 
 |  <      | __ \|  \ / __ \   |__   _ \ / _` |
 | . \     | |_) |  / | | | |     | | | | (_| |
 |_|\_\    |_.__/|_/  |_| |_|     |_| |_|\__, |
                                          __/ | 
                                         |___/  
'

countdown() {
    local seconds=$1
    while [ $seconds -gt 0 ]; do
        echo -ne "    ${YELLOW}[${seconds}] seconds remaining...${NC}\r"
        sleep 1
        ((seconds--))
    done
    echo -e "${YELLOW}[Time's up!]${NC}"
}

if [[ ! -f "$usernames_file" ]]; then
    echo -e "${RED}${ERROR_ICON} Error: File not found!${NC}"
    exit 1
fi

select_random_user_and_encode() {
    total_users=$(wc -l < "$usernames_file")
    random_line=$((RANDOM % total_users + 1))
    selected_user=$(sed -n "${random_line}p" < "$usernames_file")
    encoded_user=$(echo -n "$selected_user" | base64)

    echo -e "${YELLOW}$BORDER${NC}"
    echo -e "${BLUE}${INFO_ICON} ${LOGO} ${NC}"
    echo -e "${BLUE}${INFO_ICON} Selected username (Base64 encoded):${NC} ${GREEN}$encoded_user${NC}"
    echo -e "${YELLOW}$BORDER${NC}"
    echo -e "${GREEN}${SUCCESS_ICON} Operation completed successfully!${NC}"
}

add_username() {
    read -p "Enter the new username to add: " new_username
    if [[ -z "$new_username" ]]; then
        echo -e "${RED}${ERROR_ICON} Error: No username provided.${NC}"
        return
    fi
    
    echo "$new_username" >> "$usernames_file"
    echo -e "${GREEN}${SUCCESS_ICON} Username added successfully.${NC}"
}

decode_base64() {
    read -p "Enter the Base64 encoded username to decode: " encoded_username
    if [[ -z "$encoded_username" ]]; then
        echo -e "${RED}${ERROR_ICON} Error: No encoded username provided.${NC}"
        return
    fi
    
    decoded_user=$(echo -n "$encoded_username" | base64 --decode)

    echo -e "${YELLOW}$BORDER${NC}"
    echo -e "${BLUE}${INFO_ICON} ${LOGO} ${NC}"
    echo -e "${BLUE}${INFO_ICON} Decoded username:${NC} ${GREEN}$decoded_user${NC}"
    echo -e "${YELLOW}$BORDER${NC}"
}

list_usernames() {
    echo -e "${YELLOW}$BORDER${NC}"
    echo -e "${BLUE}${LIST_ICON} ${LOGO} ${NC}"
    echo -e "${BLUE}${INFO_ICON} List of usernames:${NC}"

    while IFS= read -r username; do
        echo -e "${GREEN}- $username${NC}"
    done < "$usernames_file"

    echo -e "${YELLOW}$BORDER${NC}"
}

while true; do
    echo -e "${BLUE}${LOGO}${NC}"
    echo "Select an option (you have 30 seconds):"
    echo "1. Select random username and encode"
    echo "2. Add new username to list"
    echo "3. Decode Base64 encoded username"
    echo "4. List all usernames"
    echo "5. Exit"
    
    countdown 2
    
    read -p "Enter your choice [1, 2, 3, 4, or 5]: " choice

    case $choice in
        1)
            select_random_user_and_encode
            ;;
        2)
            add_username
            ;;
        3)
            decode_base64
            ;;
        4)
            list_usernames
            ;;
        5)
            echo "Exiting the script. Goodbye!"
            break
            ;;
        *)
            echo -e "${RED}${ERROR_ICON} Invalid choice.${NC}"
            ;;
    esac
done
