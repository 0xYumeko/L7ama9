#!/bin/bash

# File li fih usernames
usernames_file="usernames.txt"

# Define colors
GREEN='\033[0;32m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Define borders and icons
BORDER='════════════════════════════════════'
SUCCESS_ICON='✔️'
ERROR_ICON='❌'
INFO_ICON='ℹ️'

# Define logo
LOGO='🌀 0xYumeko 🌀'

# Function li kat dir countdown
countdown() {
    local seconds=$1
    while [ $seconds -gt 0 ]; do
        echo -ne "    ${YELLOW}[${seconds}] seconds remaining...${NC}\r"
        sleep 1
        ((seconds--))
    done
    echo -e "${YELLOW}[Time's up!]${NC}"
}

# Check if the file exists
if [[ ! -f "$usernames_file" ]]; then
    echo -e "${RED}${ERROR_ICON} Error: File not found!${NC}"
    exit 1
fi

# Function li kat ikhtar username mn list w tdir encryption
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

# Function li katzid username jdid llist
add_username() {
    read -p "Enter the new username to add: " new_username
    if [[ -z "$new_username" ]]; then
        echo -e "${RED}${ERROR_ICON} Error: No username provided.${NC}"
        return
    fi
    
    echo "$new_username" >> "$usernames_file"
    echo -e "${GREEN}${SUCCESS_ICON} Username added successfully.${NC}"
}

# Function li katdir decryption mn Base64
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

# Loop bach tkhdm script mn lool
while true; do
    # Mat3awdch t3mel clear screen, ibqa kayzid lmenu fou9 natija li fatat

    echo -e "${BLUE}${LOGO}${NC}"
    echo "Select an option (you have 30 seconds):"
    echo "1. Select random username and encode"
    echo "2. Add new username to list"
    echo "3. Decode Base64 encoded username"
    echo "4. Exit"
    
    countdown 2
    
    read -p "Enter your choice [1, 2, 3, or 4]: " choice

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
            echo "Exiting the script. Goodbye!"
            break
            ;;
        *)
            echo -e "${RED}${ERROR_ICON} Invalid choice.${NC}"
            ;;
    esac
done
