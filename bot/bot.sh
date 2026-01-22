#!/bin/bash

# ==========================================================
#  TOMATO LUXE THEME ENGINE - COLOR DEFINITIONS
# ==========================================================

# 1. Palette Definition (True Color)
C_TOMATO="\033[38;2;217;69;57m"   # Primary Red
C_BURGUNDY="\033[38;2;143;38;38m" # Darker Red (Borders)
C_SAGE="\033[38;2;148;180;159m"   # Green (Success)
C_GOLD="\033[38;2;230;203;165m"   # Gold (Warning/Input)
C_CREAM="\033[38;2;253;251;247m"  # Main Text
C_RESET="\033[0m"

# 2. Icons
ICON_TOMATO="🍅"
ICON_LEAF="🌿"
ICON_STAR="✨"
ICON_ARROW="➜"
ICON_CHECK="✔"
ICON_CROSS="✖"
ICON_GEAR="⚙"
ICON_ROBOT="🤖"

# ==========================================================
#  DATA RETRIEVAL
# ==========================================================

# Load system data quietly
NS=$( cat /etc/xray/dns 2>/dev/null || echo "DNS Not Set" )
PUB=$( cat /etc/slowdns/server.pub 2>/dev/null || echo "Pub Key Not Found" )
domain=$(cat /etc/xray/domain 2>/dev/null || echo "Domain Not Set" )

# ==========================================================
#  HELPER FUNCTIONS
# ==========================================================

draw_header() {
    clear
    echo -e "${C_BURGUNDY}╔══════════════════════════════════════════════════════╗${C_RESET}"
    echo -e "${C_BURGUNDY}║${C_RESET} ${C_SAGE}       ${ICON_TOMATO}  ${C_TOMATO}TOMATO BOT MANAGER${C_RESET} ${C_GOLD}(PANEL INSTALLER)${C_RESET}      ${C_BURGUNDY}║${C_RESET}"
    echo -e "${C_BURGUNDY}╠══════════════════════════════════════════════════════╣${C_RESET}"
    echo -e "${C_BURGUNDY}║${C_RESET} ${C_GOLD}${ICON_STAR} AUTHOR   : ${C_CREAM}@dudulrealnofek ${C_RESET}                       ${C_BURGUNDY}║${C_RESET}"
    echo -e "${C_BURGUNDY}║${C_RESET} ${C_SAGE}${ICON_LEAF} VERSION  : ${C_CREAM}Tomat Merah V.1.1 - LTS${C_RESET}                ${C_BURGUNDY}║${C_RESET}"
    echo -e "${C_BURGUNDY}╚══════════════════════════════════════════════════════╝${C_RESET}"
    echo -e ""
    echo -e "  ${C_SAGE}${ICON_ROBOT} Memulai Instalasi Bot Panel...${C_RESET}"
    echo -e ""
}

print_install() {
    echo -e "${C_BURGUNDY}  ══════════════════════════════════════════════════════${C_RESET}"
    echo -e "  ${C_TOMATO}${ICON_GEAR}  ${C_GOLD}PROCESS:${C_RESET} ${C_CREAM}$1${C_RESET}"
    echo -e "${C_BURGUNDY}  ══════════════════════════════════════════════════════${C_RESET}"
    sleep 0.5
}

print_success() {
    echo -e "  ${C_SAGE}${ICON_CHECK} SUCCESS:${C_RESET} ${C_CREAM}$1${C_RESET}"
    sleep 0.5
}

draw_footer() {
    echo -e ""
    echo -e " ${C_BURGUNDY}╔══════════════════════════════════════════════════════╗${C_RESET}"
    echo -e " ${C_BURGUNDY}║${C_RESET}  ${C_SAGE}${ICON_ROBOT}    ${C_TOMATO}BOT INSTALLED SUCCESSFULLY${C_RESET}    ${C_SAGE}${ICON_LEAF}${C_RESET}     ${C_BURGUNDY}║${C_RESET}"
    echo -e " ${C_BURGUNDY}╠══════════════════════════════════════════════════════╣${C_RESET}"
    # Gunakan formatting string agar rapi jika token panjang
    echo -e " ${C_BURGUNDY}║${C_RESET}  ${C_GOLD}• Domain     :${C_RESET} ${C_CREAM}${domain}${C_RESET}"
    echo -e " ${C_BURGUNDY}║${C_RESET}  ${C_GOLD}• Admin ID   :${C_RESET} ${C_CREAM}${admin}${C_RESET}"
    echo -e " ${C_BURGUNDY}║${C_RESET}  ${C_GOLD}• Bot Token  :${C_RESET} ${C_CREAM}${bottoken:0:15}...${C_RESET}"
    echo -e " ${C_BURGUNDY}╠══════════════════════════════════════════════════════╣${C_RESET}"
    echo -e " ${C_BURGUNDY}║${C_RESET}   ${C_GOLD}${ICON_STAR} Please type /menu on your Telegram Bot ${ICON_STAR}${C_RESET}    ${C_BURGUNDY}║${C_RESET}"
    echo -e " ${C_BURGUNDY}╚══════════════════════════════════════════════════════╝${C_RESET}"
    echo -e ""
}

# ==========================================================
#  MAIN LOGIC
# ==========================================================

draw_header

# 1. Install System Dependencies
print_install "Installing Dependencies (Python/Git)"
apt update -qq && apt upgrade -y -qq >/dev/null 2>&1
apt install python3 python3-pip git -y >/dev/null 2>&1
apt-get remove speedtest-cli -y > /dev/null 2>&1
print_success "Dependencies installed"

# 2. Download Bot Resources
print_install "Downloading & Unpacking Bot Files"
cd /usr/bin
rm -rf bot.zip 
wget -q https://raw.githubusercontent.com/dudul19/tomato/main/bot/bot.zip
unzip -q -o bot.zip
mv bot/* /usr/bin
chmod +x /usr/bin/*
rm -rf bot.zip

rm -rf kyt.zip
wget -q https://raw.githubusercontent.com/dudul19/tomato/main/bot/kyt.zip
unzip -q -o kyt.zip
print_success "Bot resources downloaded"

# 3. Install Python Modules
print_install "Installing Python Requirements"
pip3 install -q -r kyt/requirements.txt
pip3 install -q speedtest-cli requests
chmod +x /usr/bin/kyt/shell/bot/*
print_success "Python modules ready"

# 4. User Input Section
clear
draw_header
echo -e "${C_BURGUNDY}  .----------------------------------------------------.${C_RESET}"
echo -e "${C_BURGUNDY}  |${C_RESET}              ${C_GOLD}BOT CONFIGURATION MENU${C_RESET}              ${C_BURGUNDY}|${C_RESET}"
echo -e "${C_BURGUNDY}  '----------------------------------------------------'${C_RESET}"
echo -e "  ${C_SAGE}${ICON_ARROW} Tutorial Create Bot & ID Telegram:${C_RESET}"
echo -e "    ${C_GOLD}1.${C_RESET} Create Bot & Get Token : ${C_CREAM}@BotFather${C_RESET}"
echo -e "    ${C_GOLD}2.${C_RESET} Get Your Telegram ID   : ${C_CREAM}@MissRose_bot${C_RESET} (/info)"
echo -e "${C_BURGUNDY}  ------------------------------------------------------${C_RESET}"
echo -e ""

echo -e "  ${C_GOLD}[?] Input your Bot Token :${C_RESET}"
read -e -p "      > " bottoken
echo -e ""
echo -e "  ${C_GOLD}[?] Input your Telegram ID (Numeric) :${C_RESET}"
read -e -p "      > " admin

# 5. Save Configuration
print_install "Saving Configuration"
echo -e BOT_TOKEN='"'$bottoken'"' >> /usr/bin/kyt/var.txt
echo -e ADMIN='"'$admin'"' >> /usr/bin/kyt/var.txt
echo -e DOMAIN='"'$domain'"' >> /usr/bin/kyt/var.txt
echo -e PUB='"'$PUB'"' >> /usr/bin/kyt/var.txt
echo -e HOST='"'$NS'"' >> /usr/bin/kyt/var.txt
print_success "Configuration saved to var.txt"

# 6. Setup Service
print_install "Configuring Systemd Service"
cat > /etc/systemd/system/kyt.service << END
[Unit]
Description=Tomato Bot Panel - @kyt
After=network.target

[Service]
WorkingDirectory=/usr/bin
ExecStart=/usr/bin/python3 -m kyt
Restart=always

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl start kyt 
systemctl enable kyt
systemctl restart kyt

# 7. Cleanup & Finish
cd /root
rm -rf bot.sh
rm -rf kyt.zip

draw_footer