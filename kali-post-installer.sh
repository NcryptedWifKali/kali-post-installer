#!/bin/sh

# Generic Kali Linux 1.x Script To Fix Common Problems and Install Some Useful Stuff

# Version 0.6

# by esc0rtd3w / ins3cure.com



### ---------------------------------------------------------------------------
### CREATE VARIABLES

# Try and move to the highest directory
# yeah theres probably a better way to do it

gethigh=$(cd ../../../../../../../../../../../../../../)



setWindowTitle(){

title='echo -ne "\033]0;Kali Linux Extras Installation Script v0.6 / esc0rd3w 2014 / crackacademy.com\007"'

$title


#case $TERM in
#    xterm*)
#        PS1="\[\033]0;\u@\h: \w\007\]bash\\$ "
#        ;;
#    *)
#        PS1="bash\\$ "
#        ;;
#esac

}


resizeWindow()
{

printf '\033[8;31;97t'

}


banner(){

clear

echo '--------------------------------------------------------'
echo '    Kali Linux 1.x.x Fixes and Common Apps Installer'
echo '--------------------------------------------------------'

}


bannerExit(){

clear
echo "Thank You For Playing Fair ;)"
echo ""
echo "esc0rtd3w 2014 / crackacademy.com"
echo ""
echo ""

}


### ---------------------------------------------------------------------------




### ---------------------------------------------------------------------------
### SETUP SOME APT-GET STUFF


# Do UPDATE, UPGRADE, DIST-UPGRADE, UPDATE, UPGRADE

do_full_update()
{
apt-get update
apt-get upgrade
apt-get dist-upgrade
apt-get update
apt-get upgrade
}

### ---------------------------------------------------------------------------



### ---------------------------------------------------------------------------
### SETUP SOME FIXES AND CRAP

# Setting up aliases
# Source:
# http://stackoverflow.com/questions/5367068/clear-the-ubuntu-bash-screen-for-real

setup_cls_alias()
{
if ! grep -qe "\033c" "./root/.bash_aliases"; then 
    echo alias cls='printf "\033c"' > /root/.bash_aliases
fi
}


setup_cd_alias()
{

alias ..="cd .."
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../../'

}


# Setup Bleeding Edge Kali Source
# Source:
# http://www.kali.org/kali-monday/bleeding-edge-kali-repositories/

setup_kali_bleeding_edge()
{
if ! grep -qe "deb http://repo.kali.org/kali kali-bleeding-edge main" "./etc/apt/sources.list"; then 
    echo deb http://repo.kali.org/kali kali-bleeding-edge main >> /etc/apt/sources.list
fi
apt-get update
apt-get upgrade
}


setup_kali_default_sources()
{

if ! grep -qe "deb http://http.kali.org/kali kali main non-free contrib" "./etc/apt/sources.list"; then 
    echo deb http://http.kali.org/kali kali main non-free contrib >> /etc/apt/sources.list
fi

if ! grep -qe "deb http://security.kali.org/kali-security kali/updates main contrib non-free" "./etc/apt/sources.list"; then 
    echo deb http://security.kali.org/kali-security kali/updates main contrib non-free >> /etc/apt/sources.list
fi

if ! grep -qe "deb-src http://http.kali.org/kali kali main non-free contrib" "./etc/apt/sources.list"; then 
    echo deb-src http://http.kali.org/kali kali main non-free contrib >> /etc/apt/sources.list
fi

if ! grep -qe "deb-src http://security.kali.org/kali-security kali/updates main contrib non-free" "./etc/apt/sources.list"; then 
    echo deb-src http://security.kali.org/kali-security kali/updates main contrib non-free >> /etc/apt/sources.list
fi

}



# Setting up Metasploit to Run At Start
# Source:
# http://docs.kali.org/general-use/starting-metasploit-framework-in-kali

setup_msf()
{
service postgresql start
service metasploit start

sleep 2

echo "Checking Statuses...."
echo ""
service postgresql status
service metasploit status

sleep 10

echo "Setting Postgresql to autostart...."
echo ""
update-rc.d postgresql enable

echo "Setting Metasploit to autostart...."
echo ""
update-rc.d metasploit enable

sleep 2

passwordMSF=$(cat /opt/metasploit/apps/pro/ui/config/database.yml | grep "password" | tail -c35 | sed -e 's/^"//'  -e 's/"$//')

echo ""
echo ""
echo "Copy and paste the below line into msfconsole"
echo ""
echo "db_connect msf3:$passwordMSF@127.0.0.1/msf3"
echo ""
echo ""
echo ""
echo "Launching msfconsole in 30 seconds...."
echo ""

sleep 30

gnome-terminal -x msfconsole
}



# Fixing se-toolkit OPTION 5 update problem
# Source:
# http://forums.kali.org/showthread.php?65-Social-Engineer-Toolkit-can-t-update-%28appears-to-lack-git-directory%29-Fix-inside

fix_se_toolkit()
{
$gethigh
$gethigh
cd /usr/share
mv set backup.set
git clone https://github.com/trustedsec/social-engineer-toolkit/ set/
cp backup.set/config/set_config set/config/set_config
}

fixOpenVas(){

test -e /var/lib/openvas/CA/cacert.pem || openvas-mkcert -q
openvas-nvt-sync
test -e /var/lib/openvas/users/om || openvas-mkcert-client -n om -i
service openvas-manager stop
service openvas-scanner stop
openvassd
openvasmd --migrate
openvasmd --rebuild
openvas-scapdata-sync
openvas-certdata-sync
test -e /var/lib/openvas/users/admin || openvasad -c adduser -n admin -r Admin
killall openvassd
sleep 15
service openvas-scanner start
service openvas-manager start
service openvas-administrator restart
service greenbone-security-assistant restart

openvas-setup

##Setting up nvt sync
echo "Syncing NVT Database..."
openvas-nvt-sync
echo "Updating SCAP Data Feed"
openvas-scapdata-sync
echo "Updating CERT Feed.."
openvas-certdata-sync
## Starting Services
echo "Starting OpenVAS Services..."
/etc/init.d/./greenbone-security-assistant start
/etc/init.d/./openvas-scanner start
/etc/init.d/./openvas-administrator start
/etc/init.d/./openvas-manager start

}


fixBluetoothAudio(){

apt-get install -y pulseaudio-module-bluetooth pulseaudio-module-gconf bluez-audio blueman

}


### ---------------------------------------------------------------------------



### ---------------------------------------------------------------------------
### INSTALL APPS

# Android SDK

install_android_sdk()
{

#apt-get install -y android

if ! grep -qe "export PATH=${PATH}:/root/android-sdks/platform-tools" "./root/.bashrc"; then 
    echo export PATH=${PATH}:/root/android-sdks/platform-tools >> ./root/.bashrc
fi

if ! grep -qe "export PATH=${PATH}:/usr/share/android-sdk/platform-tools" "./root/.bashrc"; then 
    echo export PATH=${PATH}:/usr/share/android-sdk/platform-tools >> ./root/.bashrc
fi
}



# Eclipse C/C++/Java/Android IDE


# Sample Software Repos

# Android ADT: https://dl-ssl.google.com/android/eclipse/
# Aptana Studio 3: http://download.aptana.com/studio3/plugin/install
# PyDev Nightly: http://pydev.org/nightly (Not Needed if using Aptana Studio)



# Audacity

install_audacity()
{
apt-get install -y audacity
}


# Amaya

install_amaya()
{
apt-get install -y amaya
}



# Bluefish

install_bluefish()
{
apt-get install -y bluefish
}


# CAB Extract

install_cabextract()
{
apt-get install -y cabextract
}


# cheese
install_cheese(){

apt-get install -y cheese

}


install_chrome()
{

# 32-bit debian package
wget -O google-chrome-stable_current_i386.deb https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb
dpkg -i google-chrome-stable_current_i386.deb
rm google-chrome-stable_current_i386.deb
echo "--user-data-dir" >> /opt/google/chrome/google-chrome

# 64-bit debian package
#wget -O google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#dpkg -i google-chrome-stable_current_amd64.deb
#rm google-chrome-stable_current_amd64.deb

# 32-bit Fedora RPM
#wget -O google-chrome-stable_current_i386.rpm https://dl.google.com/linux/direct/google-chrome-stable_current_i386.rpm

# 64-bit Fedora RPM
#wget -O google-chrome-stable_current_x86_64.rpm https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm

}


install_eclipse()
{
apt-get install -y eclipse
}



# EMACS Editor

install_emacs()
{
apt-get install -y emacs
}



# ffmpeg

install_ffmpeg()
{
apt-get install -y ffmpeg
apt-get install -y libavcodec-extra-53
apt-get install -y gpac mkvtoolnix
apt-get install -y gstreamer0.10-plugins-base-apps
}



# File Roller

install_fileroller()
{
apt-get install -y file-roller
apt-get install -y lha lzip lzop ncompress rpm2cpio rzip sharutils unace unalz zoo
}



# Filezilla

install_filezilla()
{
apt-get install -y filezilla
}


# Firefox

install_firefox()
{

echo "Removing IceWeasel will make some NEEDED packages want to be auto-removed with apt-get."
echo ""
echo "DO NOT AUTOREMOVE THESE ADDITIONAL GNOME PACKAGES OR YOU WILL BREAK YOUR INSTALLATION!"
apt-get remove iceweasel

#dpkg -r --force-all firefox-mozilla-build
#echo -e "\ndeb http://downloads.sourceforge.net/project/ubuntuzilla/mozilla/apt all main" | tee -a /etc/apt/sources.list > /dev/null
#echo deb http://downloads.sourceforge.net/project/ubuntuzilla/mozilla/apt all main >> /etc/apt/sources.list
check_mozilla_sources
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com C1289A29
apt-get update
apt-get install -y firefox-mozilla-build
}



# Firefox (Alternate Method)

install_firefox_alt()
{
exit
}



# Flash Player

install_flash_player()
{

# 32-bit tarball
wget -O install_flash_player_11_linux.i386.tar.gz http://fpdownload.macromedia.com/get/flashplayer/pdc/11.2.202.400/install_flash_player_11_linux.i386.tar.gz
tar xzvf install_flash_player_11_linux.i386.tar.gz
cp libflashplayer.so /usr/lib/mozilla/plugins/


# 64-bit tarball
#wget -O install_flash_player_11_linux.x86_64.tar.gz http://fpdownload.macromedia.com/get/flashplayer/pdc/11.2.202.280/install_flash_player_11_linux.x86_64.tar.gz
#tar xzvf install_flash_player_11_linux.x86_64.tar.gz
#cp libflashplayer.so /usr/lib/mozilla/plugins/


# Cleanup

rm 'usr/bin/flash-player-properties'
rm 'usr/share/kde4/services/kcm_adobe_flash_player.desktop'
rm 'usr/share/applications/flash-player-properties.desktop'
rm 'usr/share/icons/hicolor/22x22/apps/flash-player-properties.png'
rm 'usr/share/icons/hicolor/48x48/apps/flash-player-properties.png'
rm 'usr/share/icons/hicolor/24x24/apps/flash-player-properties.png'
rm 'usr/share/icons/hicolor/32x32/apps/flash-player-properties.png'
rm 'usr/share/icons/hicolor/16x16/apps/flash-player-properties.png'
rm 'usr/share/pixmaps/flash-player-properties.png'
rm 'usr/lib/kde4/kcm_adobe_flash_player.so'
rm 'libflashplayer.so'
rm 'readme.txt'
rm 'install_flash_player_11_linux.i386.tar.gz'
rm 'install_flash_player_11_linux.x86_64.tar.gz'

}


# genisoimage
install_genisoimage(){

apt-get install -y genisoimage

}


# Handbrake
install_handbrake(){

add-apt-repository ppa:stebbins/handbrake-releases
apt-get update
apt-get install -y handbrake-gtk

}


# FF Multi Converter
install_ffmulticonverter(){

add-apt-repository ppa:ffmulticonverter/stable
apt-get update
apt-get install -y ffmulticonverter

}



# ghex Hex Editor

install_ghex()
{
apt-get install -y ghex
}



# GIMP Image Editor

install_gimp()
{
apt-get install -y gimp
}



# Hexer Hex Editor

install_hexer()
{
apt-get install -y hexer
}


# Kate

install_kate()
{
apt-get install -y kate
}




# Libre Office

install_libreoffice()
{
apt-get install -y libreoffice
}



# Links / Lynx

install_linkslynx()
{
apt-get install -y links
apt-get install -y lynx
}



# LMMS (Linux MultiMedia Studio)
# Not exactly working properly

install_lmms()
{

# Using iWeb Mirror
wget -O lmms-0.4.14.tar.bz2 http://iweb.dl.sourceforge.net/project/lmms/lmms/0.4.14/lmms-0.4.14.tar.bz2

tar xvf lmms-0.4.14.tar.bz2

cd "lmms-0.4.14"


# LMMS Dependents
apt-get install -y libfluidsynth-dev
apt-get install -y libsdl1.2-dev
apt-get install -y libsndfile1-dev
apt-get install -y libstk0-dev
apt-get install -y libwine-dev
apt-get install -y portaudio19-dev
apt-get install -y qt4-dev-tools


cmake . -DCMAKE_INSTALL_PREFIX=/usr

cd ..

rm lmms-0.4.14.tar.bz2

}



# mEncoder
# Merge Example: mencoder -oac copy -ovc copy part1.avi part2.avi part3.avi -o WHOLE-THING.avi

install_mencoder()
{
apt-get install -y mencoder
}



# Midnight Commander

install_midnight_commander()
{
apt-get install -y mc
}



# NERO Linux

install_nero()
{

# 32-bit RPM
#wget -O nerolinux-4.0.0.0b-x86.rpm ftp://ftp2.usw.nero.com/PUB/ec4a1301223da9e82c082b9cc8cec754/nerolinux-4.0.0.0b-x86.rpm

# 64-bit RPM
#wget -O nerolinux-4.0.0.0b-x86_64.rpm ftp://ftp2.usw.nero.com/PUB/a8d90463dcaf6139e3701da45d669c3c/nerolinux-4.0.0.0b-x86_64.rpm

# 32-bit DEB
wget -O nerolinux-4.0.0.0b-x86.deb ftp://ftp2.usw.nero.com/PUB/e53659cc1407ad47ba491e4c58fda247/nerolinux-4.0.0.0b-x86.deb
chmod a+x 'nerolinux-4.0.0.0b-x86.deb'
dpkg -i 'nerolinux-4.0.0.0b-x86.deb'
rm './nerolinux-4.0.0.0b-x86.deb'

# 64-bit DEB
#wget -O nerolinux-4.0.0.0b-x86_64.deb ftp://ftp2.usw.nero.com/PUB/e53659cc1407ad47ba491e4c58fda247/nerolinux-4.0.0.0b-x86_64.deb

}



# Okteta Hex Editor (Recommended)

install_okteta()
{
apt-get install -y okteta
}



# Open Terminal Here for Nautilus

install_nautilus_open_terminal()
{
apt-get install -y nautilus-open-terminal
killall -HUP nautilus
nautilus
}


install_qt4()
{
apt-get install -y qt4-dev-tools
}



# RAR CLI Non-Free

install_rar()
{
apt-get install -y rar
}


# SQLite Database Browser

install_sqlitebrowser()
{
apt-get install -y sqlitebrowser
}



# RSnapshot

install_rsnapshot()
{
apt-get install -y rsnapshot
}



# Teamviewer

install_teamviewer()
{

# 32-bit DEB
wget -O teamviewer_linux.deb http://download.teamviewer.com/download/teamviewer_linux.deb
dpkg -i teamviewer_linux.deb
rm 'teamviewer_linux.deb'

# 64-bit DEB
#wget -O teamviewer_linux_x64.deb http://download.teamviewer.com/download/teamviewer_linux_x64.deb
#dpkg -i teamviewer_linux_x64.deb
#rm 'teamviewer_linux_x64.deb'

# 32/64 bit RPM
#wget -O teamviewer_linux.rpm http://download.teamviewer.com/download/teamviewer_linux.rpm

# Tarball
#wget -O teamviewer_linux.tar.gz http://download.teamviewer.com/download/teamviewer_linux.tar.gz
}



# Tidy

install_tidy()
{
apt-get install -y tidy
}



# Tor / Privoxy / Vidalia / Polipo Combo

install_tpvp()
{
apt-get install -y tor
apt-get install -y privoxy
apt-get install -y vidalia
apt-get install -y polipo

# Extra Optional Packages
#apt-get install -y mixmaster xul-ext-torbutton tor-arm polipo privoxy apparmor-utils


# Setup Privoxy Config Settings
if ! grep -qe "forward-socks4a / localhost:9050 ." "./etc/privoxy/config"; then 
    echo forward-socks4a / localhost:9050 . >> ./etc/privoxy/config 
fi


# Start Tor
/etc/init.d/tor start

# Start Privoxy
/etc/init.d/privoxy start


# Launch Vidalia to check CONNNECTED STATUS
vidalia&

echo ''
echo 'Check Vidalia For CONNECTED status'
echo ''
echo ''
echo 'Press any key to continue'
echo ''

read -p "" pause




echo ''
echo 'Set proxy in your browser to the following:'
echo ''
echo ''
echo "Proxy IP -  '127.0.0.1'"
echo 'Proxy port  - 9050'
echo 'Type - Socks5'
echo ''
echo ''
echo ''
echo 'Press any key to continue'
echo ''



read -p "" pause

 
}



# Transmission BitTorrent Client

install_transmission()
{
apt-get install -y transmission
}


# Trickle (Bandwidth Controller)

install_trickle()
{
apt-get install -y trickle
}


# VirtualBox (Full Install Procedure)

install_virtualbox()
{

# Install Then Remove To Fix Kernel Issues?? SEE ABOVE VBOXDRV FIX INSTEAD

#apt-get install -y virtualbox
#apt-get remove virtualbox

# Now install Non-Repo version to have a working copy installed

# VirtualBox (Non-Repo Version)
# Source:
# http://www.ethicalhacker.net/component/option,com_smf/Itemid,54/topic,10790.msg58837/topicseen,1/

#wget -O VirtualBox-4.2.12-84980-Linux_x86.run http://download.virtualbox.org/virtualbox/4.2.12/VirtualBox-4.2.12-84980-Linux_x86.run
#chmod a+x 'VirtualBox-4.2.12-84980-Linux_x86.run'
#'./VirtualBox-4.2.12-84980-Linux_x86.run'
#rm './VirtualBox-4.2.12-84980-Linux_x86.run'

apt-get install -y virtualbox

chown root:root /usr/lib/
chown root:root /usr/lib/virtualbox/
chown root:root /opt/

}


# Wavemon(ncurses-based monitoring)

install_wavemon()
{
apt-get install -y wavemon
}


# WinFF

install_winff(){

apt-get install -y winff

}


# XMLStarlet

install_xmlstarlet()
{
apt-get install -y xmlstarlet
}


# Zip

install_zip()
{
apt-get install -y zip
}


### ---------------------------------------------------------------------------



### ---------------------------------------------------------------------------
### FIXES AND MISC


# Check sources.list for UbuntuZilla (Mozilla/Firefox)

check_mozilla_sources()
{
if ! grep -qe "deb http://downloads.sourceforge.net/project/ubuntuzilla/mozilla/apt all main" "./etc/apt/sources.list"; then 
    echo deb http://downloads.sourceforge.net/project/ubuntuzilla/mozilla/apt all main >> ./etc/apt/sources.list  
fi
}


# VirtualBox Kernel Fix - Setup VBOXDRV (Fixes launching issues)

vboxdrv_setup()
{
/etc/init.d/vboxdrv setup
chown root:root /usr/lib/
chown root:root /usr/lib/virtualbox/
chown root:root /opt/
}


### Start Menu

menuMain(){

setup_kali_default_sources

banner


echo '     --Make a selection and press the ENTER key--'
echo '--------------------------------------------------------'
echo ''
echo ''
echo '1) Perform a Full Distro Upgrade'
echo ''
echo '2) Add Bleeding Edge Kali Repositories to /etc/apt/sources.list'
echo ''
echo '3) Configure and Modify .bashrc and .bash_aliases'
echo ''
echo '4) Install OPEN TERMINAL to Nautilus menu with Right-Click'
echo ''
echo '5) Install Common Applications (Firefox, Transmission, VirtualBox, etc)'
echo ''
echo '6) Fix Metasploit Common Issues'
echo ''
echo '7) Fix SE-Toolkit Common Issues'
echo ''
echo '8) Fix VirtualBox Common Issues'
echo ''
echo '9) Fix OpenVAS Common Issues'
echo ''
echo '10) Other Tools, Misc Utilities, and Scripts'
echo ''
echo '11) Exit This Menu'
echo ''

read  getOption


case $getOption in

"")

menuMain
  
;;


"1")
  
echo
echo 'Performing a Full Distro Upgrade....'
echo
echo

do_full_update
menuMain
;;
  

"2")

echo
echo '....'
echo
echo

setup_kali_bleeding_edge
menuMain
;;
  
"3")

echo
echo '....'
echo
echo

#setup_cls_alias
menuMain  
;;
  
"4")

echo
echo '....'
echo
echo

install_nautilus_open_terminal
menuMain 
 ;;
  
"5")

menuApps
menuMain

;;
  
"6")

echo
echo 'Fixing Metasploit Common Problems....'
echo
echo

setup_msf
menuMain
  
;;
  
"7")

echo
echo 'Fixing SE-Toolkit Common Problems....'
echo
echo

fix_se_toolkit
menuMain
  
;;
  
"8")

echo
echo 'Fixing VirtualBox Common Problems....'
echo
echo

vboxdrv_setup
menuMain
  
;;
  
"9")

echo
echo '....'
echo
echo

fixOpenVas
  
;;
  
"10")

echo
echo '....'
echo
echo

menuMain
  
;;
  
"11")

bannerExit
exit
  
;;

*)

menuMain
  
;;
  
 esac
  
  
}


menuApps(){

banner

echo "Pick an awesome app to install and press ENTER:"
echo ""
echo ""
echo "1) Android SDK                       21) Nero"
echo "2) Audacity                          22) Okteta"
echo "3) Bluefish                          23) QT4"
echo "4) Cab Extract                       24) RAR"
echo "5) Chrome                            25) RSnapshot"
echo "6) Eclipse                           26) SQLite Browser"
echo "7) EMacs                             27) Team Viewer"
echo "8) FFMPEG                            28) Tidy"
echo "9) File Roller                       29) Transmission" 
echo "10 FileZilla                         30) Trickle"
echo "11) Firefox                          31) VirtualBox"
echo "12) Flash (Adobe)                    32) WaveMon"
echo "13) GHex                             33) XMLStarlet"
echo "14) Gimp                             34) ZIP"
echo "15) Hexer                            35) Kate"
echo "16) Libre Office                     36) Alsa Utilities (Fix mute on boot)"
echo "17) Links/Lynx Combo                 37) Fix Bluetooth Audio Headset Issues"
echo "18) LMMS (Linux Multimedia Studio)   38) GenISOImage (mkisofs)"
echo "19) mEncoder                         39) HandBrake Video Converter"
echo "20) Midnight Commander               40) WinFF Converter"
echo "                                     41) Cheese (Webcam Software)"
echo "B) Back To Main Menu"
echo ""

read appSelection

case "$appSelection" in

"")
menuApps
;;

"B" | "b")
menuMain
;;

"1")
install_android_sdk
;;

"2")
install_audacity
;;

"3")
install_bluefish
;;

"4")
install_cabextract
;;

"5")
install_chrome
;;

"6")
install_eclipse
;;

"7")
install_emacs
;;

"8")
install_ffmpeg
;;

"9")
install_fileroller
;;

"10")
install_filezilla
;;

"11")
install_firefox
;;

"12")
install_flash_player
;;

"13")
install_ghex
;;

"14")
install_gimp
;;

"15")
install_hexer
;;

"16")
install_libreoffice
;;

"17")
install_linkslynx
;;

"18")
install_lmms
;;

"19")
install_mencoder
;;

"20")
install_midnight_commander
;;

"21")
install_nero
;;

"22")
install_okteta
;;

"23")
install_qt4
;;

"24")
install_rar
;;

"25")
install_rsnapshot
;;

"26")
install_sqlitebrowser
;;

"27")
install_teamviewer
;;

"28")
install_tidy
;;

"29")
install_transmission
;;

"30")
install_trickle
;;

"31")
install_virtualbox
;;

"32")
install_wavemon
;;

"33")
install_xmlstarlet
;;

"34")
install_zip
;;

"35")
install_kate
;;

"36")
apt-get install -y alsa-utils
;;

"37")
fixBluetoothAudio
;;

"38")
install_genisoimage
;;

"39")
install_handbrake
;;

"40")
install_winff
;;

"41")
install_cheese
;;

*)
menuApps
;;

esac

menuApps

}




### End Menu



### ---------------------------------------------------------------------------


### ---------------------------------------------------------------------------
### DO STUFF

### FOR NOW JUST UNCOMMENT THE THINGS YOU WANT SETUP AND INSTALLED


# Try to ascend directory structure to end up in "/" root directory
# Each getHigh climbs up 14 folders deep, probably totally unnecessary 
$gethigh
$gethigh

#setup_cls_alias

#setup_kali_bleeding_edge

#setup_msf

#fix_se_toolkit


#install_android_sdk

#install_audacity

#install_bluefish

#install_cabextract

#install_chrome

#install_eclipse

#install_emacs

#install_ffmpeg

#install_fileroller

#install_filezilla

#check_mozilla_sources
#install_firefox

#install_flash_player

#install_ghex

#install_gimp

#install_hexer

#install_libreoffice

#install_linkslynx

#install_lmms

#install_mencoder

#install_midnight_commander

#install_nero

#install_okteta

#install_qt4

#install_rsnapshot

#install_sqlitebrowser

#install_teamviewer

#install_tidy

#install_tpvp

#install_transmission

#install_trickle

#install_virtualbox

#install_wavemon

#install_xmlstarlet

#install_zip

#install_nautilus_open_terminal

# Fixes VirtualBox Issues
#vboxdrv_setup

#do_full_update

### ---------------------------------------------------------------------------



setWindowTitle
resizeWindow

# Go to Main Menu
menuMain





