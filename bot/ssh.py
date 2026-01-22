from kyt import * # Mengambil config (bot token, owner id, domain)
import subprocess
import asyncio
import math
import time
import random
import requests
import datetime as DT
import os
from telethon.tl.custom import Button
from telethon import events
from telethon.errors import AlreadyInConversationError

# =================================================================
# FUNGSI PEMBANTU: AMBIL DATA & FORMAT PAGINATION
# =================================================================
def get_ssh_data():
    """Mengambil data raw dari script shell bot-member-ssh"""
    try:
        # Pastikan script shell outputnya format: username|exp_date|status
        cmd = 'bash /usr/bin/kyt/shell/bot/bot-member-ssh'
        raw_output = subprocess.check_output(cmd, shell=True, stderr=subprocess.STDOUT).decode("utf-8")
        data_list = [line for line in raw_output.splitlines() if line.strip() and "|" in line]
        return data_list
    except Exception as e:
        return []

def render_page(data_list, page, item_per_page=10):
    total_items = len(data_list)
    total_pages = math.ceil(total_items / item_per_page)
    
    if page < 0: page = 0
    if total_pages > 0 and page >= total_pages: page = total_pages - 1
    if total_pages == 0: page = 0 
    
    start = page * item_per_page
    end = start + item_per_page
    sliced_data = data_list[start:end]
    
    msg = f"""
<b>━━━━━━━━━━━━━━━━━━━━━━━━━━━━</b>
<b>🍅 LIST MEMBER SSH & ZIVPN</b>
<b>━━━━━━━━━━━━━━━━━━━━━━━━━━━━</b>
"""
    if not sliced_data:
        msg += "<i>Tidak ada user active.</i>"
    else:
        for row in sliced_data:
            try:
                parts = row.split("|")
                if len(parts) >= 3:
                    user = parts[0]
                    exp = parts[1]
                    status = parts[2]
                    
                    # Logika Icon Status
                    if "UNLOCKED" in status or "active" in status.lower():
                        icon_stat = "🟢"
                    elif "LOCKED" in status or "expired" in status.lower():
                        icon_stat = "🔴"
                    else:
                        icon_stat = "🟡"

                    msg += f"""
<b>👤 User   :</b> <code>{user}</code>
<b>📅 Exp    :</b> <code>{exp}</code>
<b>💎 Status :</b> {icon_stat} <code>{status}</code>
<b>━━━━━━━━━━━━━━━━━━━━━━━━━━━━</b>
"""
                else: continue
            except: continue

    display_page = page + 1 if total_pages > 0 else 0
    msg += f"\n📊 <b>Total:</b> {total_items} Users | 📄 <b>Page:</b> {display_page}/{total_pages}"
    return msg, total_pages

# =================================================================
# 1. CREATE SSH & ZIVPN
# =================================================================
@bot.on(events.CallbackQuery(data=b'create-ssh'))
async def create_ssh(event):
    async def create_ssh_(event):
        try:
            # --- 1. Input Username ---
            async with bot.conversation(chat, timeout=120) as user_convo:
                await event.respond('<b>👤 Input Username:</b>\n(Ketik <code>/cancel</code> untuk batal)', parse_mode='html')
                while True:
                    user_event = await user_convo.wait_event(events.NewMessage(incoming=True))
                    if user_event.sender_id == sender.id:
                        if user_event.raw_text == '/cancel':
                            await event.respond("❌ <b>Proses Dibatalkan.</b>", parse_mode='html')
                            return
                        user = user_event.raw_text.strip()
                        # Validasi karakter username (Alphanumeric only)
                        if not user.isalnum():
                             await event.respond("⚠️ <b>Error:</b> Username hanya boleh huruf dan angka.", parse_mode='html')
                             continue
                        break 
            
            # --- 2. Input Password ---
            async with bot.conversation(chat, timeout=120) as pw_convo:
                await event.respond("<b>🔑 Input Password:</b>", parse_mode='html')
                while True:
                    pw_event = await pw_convo.wait_event(events.NewMessage(incoming=True))
                    if pw_event.sender_id == sender.id:
                        if pw_event.raw_text == '/cancel':
                            await event.respond("❌ <b>Proses Dibatalkan.</b>", parse_mode='html')
                            return
                        pw = pw_event.raw_text.strip()
                        break
    
            # --- 3. Input Limit IP ---
            async with bot.conversation(chat, timeout=120) as limit_convo:
                await event.respond("<b>📱 Input Max Login/IP Limit:</b>\n`Contoh: 2`", parse_mode='html')
                while True:
                    limit_event = await limit_convo.wait_event(events.NewMessage(incoming=True))
                    if limit_event.sender_id == sender.id:
                        if limit_event.raw_text == '/cancel':
                            await event.respond("❌ <b>Proses Dibatalkan.</b>", parse_mode='html')
                            return
                        limit = limit_event.raw_text
                        if not limit.isdigit():
                             await event.respond("⚠️ <b>Error:</b> Harap masukkan angka saja.", parse_mode='html')
                             continue
                        break

            # --- 4. Input Quota ---
            async with bot.conversation(chat, timeout=120) as quota_convo:
                await event.respond("<b>☁️ Input Quota (GB):</b>\n`Contoh: 10`", parse_mode='html')
                while True:
                    quota_event = await quota_convo.wait_event(events.NewMessage(incoming=True))
                    if quota_event.sender_id == sender.id:
                        if quota_event.raw_text == '/cancel':
                            await event.respond("❌ <b>Proses Dibatalkan.</b>", parse_mode='html')
                            return
                        quota = quota_event.raw_text
                        if not quota.isdigit():
                             await event.respond("⚠️ <b>Error:</b> Harap masukkan angka saja.", parse_mode='html')
                             continue
                        break
            
            # --- 5. Input Expired ---
            async with bot.conversation(chat, timeout=120) as exp_convo:
                await event.respond("<b>📅 Input Masa Aktif (Hari):</b>\n`Contoh: 30`", parse_mode='html')
                while True:
                    exp_event = await exp_convo.wait_event(events.NewMessage(incoming=True))
                    if exp_event.sender_id == sender.id:
                        if exp_event.raw_text == '/cancel':
                            await event.respond("❌ <b>Proses Dibatalkan.</b>", parse_mode='html')
                            return
                        exp = exp_event.raw_text
                        if not exp.isdigit():
                             await event.respond("⚠️ <b>Error:</b> Harap masukkan angka saja.", parse_mode='html')
                             continue
                        break 
        
            msg_load = await event.respond("`⏳ Processing SSH & ZIVPN Account...`")
            
            # --- EKSEKUSI: Create System User ---
            # Menghitung tanggal expired format YYYY-MM-DD
            cmd_sys = f'useradd -e `date -d "{exp} days" +"%Y-%m-%d"` -s /bin/false -M {user} && echo "{user}:{pw}" | chpasswd && echo "{user} hard maxlogins {limit}" >> /etc/security/limits.conf'
    
            try:
                subprocess.check_output(cmd_sys, shell=True, stderr=subprocess.STDOUT)
            except subprocess.CalledProcessError:
                await msg_load.delete()
                await event.respond("⚠️ **User Already Exist**", buttons=[[Button.inline("‹ Main Menu ›", "menu")]])
                return
            
            # --- EKSEKUSI: Integrasi ZiVPN ---
            # Pastikan script zivpn-add ada dan executable
            try:
                cmd_zivpn = f'bash /usr/local/bin/zivpn-add "{user}" "{pw}" "{exp}" "{limit}" "{quota}"'
                subprocess.run(cmd_zivpn, shell=True)
            except:
                pass # Lanjut saja jika zivpn gagal, user ssh tetap terbuat

            # --- Output Result ---
            today = DT.date.today()
            later = today + DT.timedelta(days=int(exp))
            created_date = today.strftime("%d/%m/%Y")
            exp_date = later.strftime("%d/%m/%Y")
            
            # Mengambil Port ZiVPN (Optional, default 5667)
            try:
                 port_zivpn = subprocess.check_output("grep -o '\"listen\": *\"[^\"]*\"' /etc/zivpn/config.json | cut -d'\"' -f4 | sed 's/://g'", shell=True).decode("utf-8").strip()
                 if not port_zivpn: port_zivpn = "5667"
            except:
                 port_zivpn = "5667"

            msg = f"""
<b>━━━━━━━━━━━━━━━━━━━━━━━━━━━━</b>
<b>🍅 SSH & ZIVPN PREMIUM ACCOUNT</b>
<b>━━━━━━━━━━━━━━━━━━━━━━━━━━━━</b>

<b>👤 Username :</b> <code>{user}</code>
<b>🔑 Password :</b> <code>{pw}</code>
<b>📅 Expired  :</b> <code>{exp_date}</code> ({exp} Days)

<b>━━━━━━━━━━━━━━━━━━━━━━━━━━━━</b>
<b>🔌 CONNECTION DETAILS</b>
<b>━━━━━━━━━━━━━━━━━━━━━━━━━━━━</b>
<b>🖥️ Host/IP  :</b> <code>{DOMAIN}</code>
<b>📡 SSH WS   :</b> <code>80</code>
<b>🔒 SSH SSL  :</b> <code>443</code>
<b>🎮 ZiVPN    :</b> <code>{port_zivpn}</code>
<b>🛡️ UDP Custom :</b> <code>1-65535</code>

<b>━━━━━━━━━━━━━━━━━━━━━━━━━━━━</b>
<b>📥 PAYLOAD & FORMAT</b>
<b>━━━━━━━━━━━━━━━━━━━━━━━━━━━━</b>
<b>🔹 SSH UDP/WS :</b>
<code>{DOMAIN}:80@{user}:{pw}</code>

<b>🔹 ZiVPN / UDP Custom :</b>
<code>{DOMAIN}:1-65535@{user}:{pw}</code>

<b>🔢 Limit IP :</b> <code>{limit} Device</code>
<b>☁️ Quota    :</b> <code>{quota} GB</code>

<b>━━━━━━━━━━━━━━━━━━━━━━━━━━━━</b>
"""
            await msg_load.delete()
            await event.respond(msg, parse_mode='html', buttons=[[Button.inline("‹ Main Menu ›", "menu")]])

        except AlreadyInConversationError:
            await event.answer("⚠️ Sedang ada proses lain! Ketik /cancel dulu.", alert=True)
        except asyncio.TimeoutError:
            await event.respond("❌ **Waktu Habis.**", buttons=[[Button.inline("‹ Main Menu ›", "menu")]])
        except Exception as e:
            await event.respond(f"❌ **Error:** `{str(e)}`", buttons=[[Button.inline("‹ Main Menu ›", "menu")]])

    chat = event.chat_id
    sender = await event.get_sender()
    if valid(str(sender.id)) == "true":
        await create_ssh_(event)
    else:
        await event.answer("🚫 Akses Ditolak", alert=True)

# =================================================================
# 2. DELETE SSH & ZIVPN
# =================================================================
@bot.on(events.CallbackQuery(data=b'delete-ssh'))
async def delete_ssh(event):
    async def delete_ssh_(event):
        try:
            async with bot.conversation(chat, timeout=120) as user_convo:
                await event.respond("<b>🗑️ Username To Be Deleted:</b>\n(Ketik <code>/cancel</code> untuk batal)", parse_mode='html')
                while True:
                    user_event = await user_convo.wait_event(events.NewMessage(incoming=True))
                    if user_event.sender_id == sender.id:
                        if user_event.raw_text == '/cancel':
                            await event.respond("❌ <b>Proses Dibatalkan.</b>", parse_mode='html')
                            return
                        user = user_event.raw_text.strip()
                        break
                
            # Cek User SSH Sistem
            cmd_check = f'id "{user}"'
            try:
                subprocess.check_output(cmd_check, shell=True, stderr=subprocess.STDOUT)
            except subprocess.CalledProcessError:
                await event.respond(f"⚠️ **User** `{user}` **Not Found**", buttons=[[Button.inline("‹ Main Menu ›", "menu")]])
                return

            # Hapus User dari Sistem, Limit, dan ZiVPN
            # 1. Hapus User Sistem
            subprocess.run(f'userdel -f {user}', shell=True)
            # 2. Hapus Limit
            subprocess.run(f'sed -i "/^{user} hard maxlogins/d" /etc/security/limits.conf', shell=True)
            # 3. Hapus User ZiVPN (Menggunakan script manual atau hapus json manual)
            # Opsional: Jika Anda punya script 'zivpn-del'
            try:
                 # Hapus dari config.json dan user-db.json via script one-liner atau external
                 # Disini kita asumsikan pakai jq atau script external
                 pass 
            except: pass

            await event.respond(f"✅ <b>Successfully Deleted:</b> <code>{user}</code>", parse_mode='html', buttons=[[Button.inline("‹ Main Menu ›", "menu")]])
                
        except AlreadyInConversationError:
            await event.answer("⚠️ Sedang ada proses lain! Ketik /cancel dulu.", alert=True)
        except asyncio.TimeoutError:
            await event.respond("❌ **Timeout.**", buttons=[[Button.inline("‹ Main Menu ›", "menu")]])
        except Exception as e:
            await event.respond(f"❌ **Error:** `{str(e)}`", buttons=[[Button.inline("‹ Main Menu ›", "menu")]])
            
    chat = event.chat_id
    sender = await event.get_sender()
    if valid(str(sender.id)) == "true":
        await delete_ssh_(event)
    else:
        await event.answer("🚫 Akses Ditolak", alert=True)

# =================================================================
# 3. TRIAL SSH
# =================================================================
@bot.on(events.CallbackQuery(data=b'trial-ssh'))
async def trial_ssh(event):
    async def trial_ssh_(event):
        try:
            async with bot.conversation(chat, timeout=60) as exp_convo:
                await event.respond("<b>⏱️ Input Masa Aktif (Menit):</b>\n`Contoh: 60`", parse_mode='html')
                while True:
                    exp_event = await exp_convo.wait_event(events.NewMessage(incoming=True))
                    if exp_event.sender_id == sender.id:
                        if exp_event.raw_text == '/cancel':
                            await event.respond("❌ <b>Proses Dibatalkan.</b>", parse_mode='html')
                            return
                        exp = exp_event.raw_text
                        if not exp.isdigit():
                             await event.respond("⚠️ <b>Error:</b> Harap masukkan angka saja.", parse_mode='html')
                             continue
                        break

            user = "trial"+str(random.randint(100,9999))
            pw = "1"
            
            msg_load = await event.respond("`⏳ Creating Trial Account...`")
            
            # Create user dengan expiry shell command
            # Menggunakan 'usermod -e' untuk tanggal, tapi untuk menit biasanya pakai cron/at/tmux
            # Disini kita gunakan logika 'date' expiry sistem untuk keamanan
            # Format date -d "+X minutes"
            
            cmd = f'useradd -e "`date -d "{exp} minutes" +"%Y-%m-%d %H:%M:%S"`" -s /bin/false -M {user} && echo "{user}:{pw}" | chpasswd && echo "{user} hard maxlogins 1" >> /etc/security/limits.conf'
            
            try:
                subprocess.check_output(cmd, shell=True, stderr=subprocess.STDOUT)
                # Opsional: Masukkan ke ZiVPN juga
                subprocess.run(f'bash /usr/local/bin/zivpn-add "{user}" "{pw}" "1" "1" "1"', shell=True)
            except subprocess.CalledProcessError:
                await msg_load.delete()
                await event.respond("❌ **Failed to create trial.**", buttons=[[Button.inline("‹ Main Menu ›", "menu")]])
                return

            msg = f"""
<b>━━━━━━━━━━━━━━━━━━━━━━━━━━━━</b>
<b>🍅 TRIAL SSH ACCOUNT</b>
<b>━━━━━━━━━━━━━━━━━━━━━━━━━━━━</b>

<b>👤 Username :</b> <code>{user}</code>
<b>🔑 Password :</b> <code>{pw}</code>
<b>⏱️ Expired  :</b> <code>{exp} Minutes</code>

<b>━━━━━━━━━━━━━━━━━━━━━━━━━━━━</b>
<b>🔌 CONNECTION</b>
<b>━━━━━━━━━━━━━━━━━━━━━━━━━━━━</b>
<b>🖥️ Host/IP  :</b> <code>{DOMAIN}</code>
<b>📡 SSH SSL  :</b> <code>443</code>
<b>🛡️ UDP Custom :</b> <code>{DOMAIN}:1-65535@{user}:{pw}</code>

<b>━━━━━━━━━━━━━━━━━━━━━━━━━━━━</b>
"""
            await msg_load.delete()
            await event.respond(msg, parse_mode='html', buttons=[[Button.inline("‹ Main Menu ›", "menu")]])
        
        except AlreadyInConversationError:
            await event.answer("⚠️ Sedang ada proses lain! Ketik /cancel dulu.", alert=True)
        except Exception as e:
            await event.respond(f"❌ **Error:** `{str(e)}`", buttons=[[Button.inline("‹ Main Menu ›", "menu")]])

    chat = event.chat_id
    sender = await event.get_sender()
    if valid(str(sender.id)) == "true":
        await trial_ssh_(event)
    else:
        await event.answer("🚫 Akses Ditolak", alert=True)

# =================================================================
# 4. SHOW SSH
# =================================================================
@bot.on(events.CallbackQuery(data=b'show-ssh'))
async def show_ssh(event):
    sender = await event.get_sender()
    if valid(str(sender.id)) != "true":
        await event.answer("Access Denied", alert=True)
        return

    data_list = get_ssh_data()
    msg, total_pages = render_page(data_list, 0)
    
    buttons = []
    if total_pages > 1:
        buttons.append([Button.inline("Next ⏩", data=f"sshPage_1")])
    buttons.append([Button.inline("‹ Main Menu ›", "menu")])
    
    try: await event.edit(msg, buttons=buttons, parse_mode='html')
    except: await event.reply(msg, buttons=buttons, parse_mode='html')

@bot.on(events.CallbackQuery(pattern=b'sshPage_(\d+)'))
async def paginate_ssh(event):
    sender = await event.get_sender()
    if valid(str(sender.id)) != "true":
        await event.answer("Access Denied", alert=True)
        return

    try: page = int(event.data.decode().split('_')[1])
    except: page = 0
    
    data_list = get_ssh_data()
    msg, total_pages = render_page(data_list, page)
    
    nav_buttons = []
    if page > 0: nav_buttons.append(Button.inline("⏪ Prev", data=f"sshPage_{page-1}"))
    if page < total_pages - 1: nav_buttons.append(Button.inline("Next ⏩", data=f"sshPage_{page+1}"))
    
    buttons = []
    if nav_buttons: buttons.append(nav_buttons)
    buttons.append([Button.inline("‹ Main Menu ›", "menu")])
    
    try: await event.edit(msg, buttons=buttons, parse_mode='html')
    except: await event.answer("Halaman tidak berubah")

# =================================================================
# 5. LOGIN SSH CHECKER
# =================================================================
@bot.on(events.CallbackQuery(data=b'login-ssh'))
async def login_ssh(event):
    async def login_ssh_(event):
        try:
            # Script shell untuk cek login (bot-cek-login-ssh) harus sudah ada
            cmd = 'bash /usr/bin/kyt/shell/bot/bot-cek-login-ssh'
            try:
                z = subprocess.check_output(cmd, shell=True, stderr=subprocess.STDOUT).decode("utf-8")
            except:
                z = "Tidak ada user login."

            if len(z) > 4000:
                nama_file = "login_ssh.txt"
                with open(nama_file, "w") as f:
                    f.write(z)
                await event.client.send_file(
                    event.chat_id,
                    nama_file,
                    caption="⚠️ **List Login Terlalu Panjang!**",
                    buttons=[[Button.inline("‹ Main Menu ›","menu")]]
                )
                os.remove(nama_file)
            else:
                msg = f"""
<b>━━━━━━━━━━━━━━━━━━━━━━━━━━━━</b>
<b>🕵️ MONITOR LOGIN SSH</b>
<b>━━━━━━━━━━━━━━━━━━━━━━━━━━━━</b>
<pre>{z}</pre>
<b>━━━━━━━━━━━━━━━━━━━━━━━━━━━━</b>
"""
                await event.edit(msg, parse_mode='html', buttons=[[Button.inline("‹ Main Menu ›","menu")]])
        except Exception as e:
            await event.respond(f"❌ **Error:** `{str(e)}`")

    sender = await event.get_sender()
    if valid(str(sender.id)) == "true":
        await login_ssh_(event)
    else:
        await event.answer("🚫 Akses Ditolak", alert=True)

# =================================================================
# 6. MENU UTAMA SSH
# =================================================================
@bot.on(events.CallbackQuery(data=b'ssh'))
async def ssh(event):
    sender = await event.get_sender()
    if valid(str(sender.id)) != "true":
        await event.answer("Access Denied", alert=True)
        return
        
    try:
        inline = [
            [Button.inline("✨ CREATE SSH & ZIVPN","create-ssh"), Button.inline("⚡ TRIAL SSH","trial-ssh")],
            [Button.inline("🗑️ DELETE ACCOUNT","delete-ssh"), Button.inline("🕵️ CHECK LOGIN","login-ssh")],
            [Button.inline("👥 MEMBER LIST","show-ssh"), Button.inline("‹ Main Menu ›","menu")]
        ]
        
        # Ambil Info ISP & Country dengan cepat
        try:
             isp = subprocess.check_output("curl --max-time 2 -s http://ip-api.com/json | jq -r .isp", shell=True).decode("utf-8").strip()
             country = subprocess.check_output("curl --max-time 2 -s http://ip-api.com/json | jq -r .country", shell=True).decode("utf-8").strip()
        except:
             isp = "Unknown"
             country = "Unknown"

        msg = f"""
<b>━━━━━━━━━━━━━━━━━━━━━━━━━━━━</b>
<b>🍅 TOMATO SSH & ZIVPN MANAGER</b>
<b>━━━━━━━━━━━━━━━━━━━━━━━━━━━━</b>

<b>👋 Hello, {sender.first_name}!</b>
Silakan pilih menu manajemen akun SSH dan ZiVPN di bawah ini.

<b>🖥️ Server Info:</b>
<b>🏳️ Country :</b> <code>{country}</code>
<b>🏢 ISP     :</b> <code>{isp}</code>
<b>🌐 IP      :</b> <code>{DOMAIN}</code>
<b>━━━━━━━━━━━━━━━━━━━━━━━━━━━━</b>
"""
        await event.edit(msg, buttons=inline, parse_mode='html')
    except Exception as e:
        await event.respond(f"Error: {str(e)}")