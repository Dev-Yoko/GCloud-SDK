#!/bin/bash
#coding: utf-8
# ORIGINAL AUTHOR : DEVIL MASTER
#GITHUB - https://github.com/isuruwa
# MOD DEV: Dev
# GITHUB - https://github.com/Dev-Yoko
#Make proper Credits When you copy

# Define colors
re='\e[1;31m'
lg='\e[1;32m'
lgf='\e[92m'
pu='\033[1;35m'
cy='\e[0;36m'
ee='\033[0m'

# Define PREFIX
PREFIX="/usr/local"

# Function to check if gcloud SDK is installed
function check_req(){
  if command -v gcloud &> /dev/null
  then
      echo -e "${lg}✅ G-cloud SDK Installed${ee}"
      sleep 3
      menu
  else
      echo -e "${re}❌ G-cloud SDK not Installed${ee}"
      echo -e "${pu}❓ Do you want to install it now? (y/n) : ${ee}"
      read -r install_prompt
      if [[ $install_prompt == "y" || $install_prompt == "Y" || $install_prompt == "yes" || $install_prompt == "Yes" ]]
      then
          select_installation_method
      else
          echo -e "${lgf}Exiting...${ee}"
          exit 0
      fi
  fi
}

# Function to select installation method
function select_installation_method(){
  echo -e "${cy}🛠️ Select installation method:"
  echo -e "  [1] Termux"
  echo -e "  [2] Linux${ee}"
  read -r method
  case $method in
    1) install_tmuxgcloud ;;
    2) install_lnxgcloud ;;
    *) echo -e "${re}❗ Invalid option${ee}" && sleep 2 && select_installation_method ;;
  esac
}

# Function to install gcloud SDK in Termux
function install_tmuxgcloud(){
  echo -e "${lgf}\n  [+] Installing G-cloud SDK in Termux..."
  echo -e "${lgf}  [+] Are you sure you want to proceed? (y/n) : ${ee}"
  read -r prompt
  if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
  then
      pkg install python2 curl openssh
      export CLOUDSDK_PYTHON='python2.7'
      echo "export CLOUDSDK_PYTHON='python2.7'" >> ~/.bashrc
      echo "export PATH=\"$PATH:$PREFIX/google-cloud-sdk/bin\"" >> ~/.bashrc
      curl -o sdk.sh sdk.cloud.google.com
      chmod +x sdk.sh
      ./sdk.sh --install-dir="$PREFIX"
      echo -e "${lgf}\n  [+] Installation complete. Open a new session/terminal, restart the script, and select option 3 from the menu to authorize G-Cloud.${ee}"
      menu  # Return to the menu
      exit 0
  else
      echo -e "${re}\n  [❌] User Cancelled${ee}"
      menu  # Return to the menu
  fi
}

# Function to install gcloud SDK in Linux
function install_lnxgcloud(){
  echo -e "${lgf}\n  [+] Installing G-cloud SDK in Linux..."
  echo -e "${lgf}  [+] Are you sure you want to proceed? (y/n) : ${ee}"
  read -r prompt
  if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
  then
      echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
      sudo apt-get install apt-transport-https ca-certificates gnupg
      curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
      sudo apt-get update && sudo apt-get install google-cloud-sdk
      echo -e "${lgf}\n  [+] Installation complete. Open a new session/terminal, restart the script, and select option 3 from the menu to authorize G-Cloud.${ee}"
      menu  # Return to the menu
  else
      echo -e "${re}\n  [❌] User Cancelled${ee}"
      menu  # Return to the menu
  fi
}

# Function to display the main menu
function menu() {
  clear
  echo -e "${pu}=============================================="
  echo -e "${pu}           G-cloud SDK Menu                   "
  echo -e "${pu}==============================================${ee}"
  echo -e "${cy}  [1] Install G-cloud SDK"
  echo -e "  [2] Authorize G-Cloud"
  echo -e "  [3] Launch G-cloud shell"
  echo -e "  [4] Update to latest Cloud SDK"
  echo -e "  [5] Exit${ee}"
  echo -e -n "${pu}  Enter Option : ${ee}"
  read -r prompt
  case $prompt in
    1) select_installation_method ;;
    2) gcloud auth login ;;
    3) gcloud alpha cloud-shell ssh ;;
    4) gcloud components update ;;
    5) echo -e "${lgf}Exiting...${ee}" && exit 0 ;;
    *) echo -e "${re}\n  [❗] Invalid Option${ee}" && sleep 2 && menu ;;
  esac
}

# Start the script
check_req
