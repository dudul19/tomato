#!/bin/bash

# ==========================================================
#  TOMATO LUXE THEME ENGINE - SYSTEM UPDATE
# ==========================================================

# 1. Palette Definition (True Color)
C_TOMATO="\033[38;2;217;69;57m"   # Primary Red
C_BURGUNDY="\033[38;2;143;38;38m" # Border Red
C_SAGE="\033[38;2;148;180;159m"   # Success Green
C_GOLD="\033[38;2;230;203;165m"   # Warning/Highlight
C_CREAM="\033[38;2;253;251;247m"  # Text
C_RESET="\033[0m"

# 2. Icons
ICON_TOMATO="🍅"
ICON_UPDATE="🔄"
ICON_DL="📥"
ICON_INSTALL="📦"
ICON_FIX="🛠️"
ICON_CHECK="✔"
ICON_CROSS="✖"
ICON_CRON="⏰"
ICON_STAR="✨"

# 3. Source URL
REPO_URL="https://raw.githubusercontent.com/dudul19/tomato/main/menu"

# ==========================================================
#  UI FUNCTIONS
# ==========================================================

draw_header() {
    clear
    echo -e "${C_BURGUNDY}╔══════════════════════════════════════════════════════╗${C_RESET}"
    echo -e "${C_BURGUNDY}║${C_RESET} ${C_SAGE}${ICON_TOMATO}    ${C_TOMATO}TOMATO MANAGER${C_RESET} ${C_GOLD}(SYSTEM UPDATE)${C_RESET}             ${C_BURGUNDY}║${C_RESET}"
    echo -e "${C_BURGUNDY}╠══════════════════════════════════════════════════════╣${C_RESET}"
    echo -e "${C_BURGUNDY}║${C_RESET} ${C_GOLD}${ICON_STAR} AUTHOR : ${C_CREAM}DUDUL (TEA V.1.0)${C_RESET}                   ${C_BURGUNDY}║${C_RESET}"
    echo -e "${C_BURGUNDY}╚══════════════════════════════════════════════════════╝${C_RESET}"
    echo -e ""
}

print_step() {
    echo -e "  ${C_GOLD}${ICON_UPDATE} $1...${C_RESET}"
    sleep 0.5
}

print_success() {
    echo -e "  ${C_SAGE}${ICON_CHECK} $1${C_RESET}"
    sleep 0.3
}

print_error() {
    echo -e "  ${C_TOMATO}${ICON_CROSS} $1${C_RESET}"
    exit 1
}

# ==========================================================
#  MAIN UPDATE PROCESS
# ==========================================================

draw_header

echo -e "${C_BURGUNDY}  .----------------------------------------------------.${C_RESET}"
echo -e "${C_BURGUNDY}  |${C_RESET}                 ${C_GOLD}STARTING UPDATE${C_RESET}                      ${C_BURGUNDY}|${C_RESET}"
echo -e "${C_BURGUNDY}  '----------------------------------------------------'${C_RESET}"

# 1. Download Resources
print_step "Downloading Menu Repository"
cd /tmp
rm -f menu.zip
wget -q "${REPO_URL}/menu.zip"

# Safety Check: Pastikan file terdownload
if [[ ! -f "menu.zip" ]]; then
    print_error "Download Failed! Check internet connection."
fi

# 2. Cleanup Old Files
print_step "Cleaning Old Scripts"
# Hapus isi sbin (Hati-hati, pastikan download sukses dulu di atas)
rm -rf /usr/local/sbin/*

# 3. Installing
print_step "Installing New Menu"
unzip -o menu.zip > /dev/null 2>&1
if [[ -d "menu" ]]; then
    mv menu/* /usr/local/sbin/
    chmod +x /usr/local/sbin/*
else
    # Fallback jika struktur zip berbeda (langsung file)
    unzip -o menu.zip -d /usr/local/sbin/ > /dev/null 2>&1
    chmod +x /usr/local/sbin/*
fi

# 4. Specific File Update (Menu Utama)
print_step "Updating Core Menu"
rm -f /usr/local/sbin/menu
wget -q -O /usr/local/sbin/menu "${REPO_URL}/menu"
chmod +x /usr/local/sbin/menu

# 5. Fix Permissions & Line Endings (DOS Fixer)
print_step "Normalizing Script Formats"
# Menggunakan find agar lebih aman menangani file
find /usr/local/sbin/ -type f -exec sed -i 's/\r$//' {} \;
if [[ -d "/etc/ssh/usage_db/" ]]; then
    chmod -R 777 /etc/ssh/usage_db/
fi

# 6. Cronjob Update
print_step "Updating Automation (Cronjobs)"

# > SSH Accountant
cat > /etc/cron.d/ssh_accountant <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
* * * * * root /usr/local/sbin/ssh-accountant
END

# > Limit Quota (Safe Mode 10 Menit)
# Hapus legacy cron
rm -f /etc/cron.d/limit_quota
sed -i "/limit-quota/d" /etc/crontab

# Buat baru
cat > /etc/cron.d/limit_quota <<-EOF
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/10 * * * * root /usr/local/sbin/limit-quota
EOF

# Restart Service Cron
service cron restart > /dev/null 2>&1

# 7. Cleanup Temp
rm -rf /tmp/menu.zip
rm -rf /tmp/menu

# ==========================================================
#  COMPLETION
# ==========================================================

echo -e ""
echo -e "${C_BURGUNDY}╔══════════════════════════════════════════════════════╗${C_RESET}"
echo -e "${C_BURGUNDY}║${C_RESET} ${C_SAGE}${ICON_CHECK}       ${C_TOMATO}UPDATE COMPLETED SUCCESSFULLY${C_RESET}      ${C_SAGE}${ICON_INSTALL}${C_RESET}        ${C_BURGUNDY}║${C_RESET}"
echo -e "${C_BURGUNDY}╚══════════════════════════════════════════════════════╝${C_RESET}"
echo -e ""
echo -e "  ${C_SAGE}System is now up to date.${C_RESET}"
echo -e ""
rm -f update.sh
read -n 1 -s -r -p "Press any key to return to menu..."
menu