#!/bin/sh
#Author - Luiz Camilo - luiz.camilo@sophos.com

## ----------------------------------
# Define global variables
# ----------------------------------
EDITOR=vim
RED='\033[0;41;30m'
STD='\033[0;0;39m'

# ----------------------------------
# User defined function
# ----------------------------------
pause(){
  read -p "Press [Enter] key to continue..." fackEnterKey
}

one(){
        echo
		appkey=`/bin/opcode getappkey -s nosync 2>/dev/null`
		if [ "$appkey" = "failed" ] ; then
                appkey="N.A"
        fi
        echo "Serial Number:		$appkey"
        pubkey=`/bin/opcode getpublickey -s nosync 2>/dev/null`
        if [ $pubkey = "failed" ] ; then
                pubkey="N.A"
        fi
		echo "Device-Id:		$pubkey"
		crmodel=`awk ' BEGIN { FS="_" } { print $1} ' /etc/displayversion`
        echo "Appliance Model:	$crmodel"
		crversion=`awk ' BEGIN { FS="_" } { print $3; } ' /etc/displayversion`
        echo "Firmware Version:	$crversion"
		fw_version=`cat /etc/version | cut -d"_" -f3`
		fwbuild=`echo $fw_version | cut -d"." -f4`
        echo "Firmware Build:		$fwbuild"
		hwversion=`awk -F "_" '{print $2}' /etc/displayversion`
        echo "HW version:		$hwversion"
		confdb=`cat /conf/db/version`
        echo "Config DB version:	$confdb"
		sigdb=`cat /sig/newdb/version`
        echo "Signature DB version:	$sigdb"
		reportdb=`cat /var/newdb/version`
        echo "Report DB version:	$reportdb"
		awhttpversion=`awarrenhttp -v | awk ' BEGIN { FS=" " } { print $2} '`
        echo "Web Proxy version:	$awhttpversion"
		awsmtpversion=`awarrensmtp -v | awk ' BEGIN { FS=" " } { print $2} '`
        echo "SMTP Proxy version:	$awsmtpversion"
		warrenversion=`warren -v | awk ' BEGIN { FS=" " } { print $2} '`
        echo "POP/IMAP Proxy version:	$warrenversion"
		garnerversion=`garner -v | awk ' BEGIN { FS=" " } { print $2} '`
        echo "Logging Daemon version:	$garnerversion"
		vuptime=`uptime | cut -d"," -f1`
        echo "Uptime:			$vuptime"
		#vmypublicip=`curl ifconfig.me`
        #echo "My public IP	$vmypublicip"
		vhastatus=`csc custom status | grep "HA status" | cut -d" " -f2,3,4,8`
		echo "HA Status / Node	$vhastatus"
		vhadetails=`echo "system ha show details" | cish | grep ":"`
		echo "$vhadetails"
        echo
        pause
}

two(){
        lastreboot=`grep -F "klogd started: BusyBox" /log/syslog.log`

        echo
        echo "$lastreboot"
        echo
        pause
}

three(){
        showipsecstatus=`ipsec statusall`

        echo
        echo "If you see duplicated Phase2 SAs, try to restart ipsec with: ipsec restart"
		echo "Heads up as restarting the ipsec service would bring ALL VPN's down temporarly"
        echo
        echo "$showipsecstatus"
        echo
        pause
}

four(){
        showipsecretransmissions=`grep -F "retransmit" /log/strongswan.log | tail`

        echo
        echo -e "\e[32m Retransmission usually indicates link failure or transmission malfunction \e[0m"
        echo "Showing last 10 lines of log"
        echo
        echo "$showipsecretransmissions"
        echo
        pause
}

five(){
        showdgdfailures=`grep -A 3 -F "Failed" /log/dgd.log | tail -n 30`

        echo
        echo -e "\e[32mLog lines bellow shows confirmed WAN link failures \e[0m"
        echo "Showing last 10 lines of log"
        echo
        echo "$showdgdfailures"
        echo
        pause
}

six(){
        queryadminport=`psql -U nobody -d corporate -c "select servicekey,servicevalue from tblclientservices where servicekey='httpsport'"`

        echo
        echo "$queryadminport"
        echo
        pause
}

seven(){
        queryipsecpsk=`psql -U nobody -d corporate -xc "select connectionname, localkey from tblvpnconnection"`

        echo
        echo -e "\e[31mUse at your own discretion \e[0m"
        echo
        echo "$queryipsecpsk"
        echo
        pause
}

eight(){
        echo
        echo -e "\e[32mEntries bellow are recurring scheduled tasks \e[0m"
        echo
        showchron=`timer all:summary`
        echo "$showchron"
        echo
        pause
}

nine(){
        echo
        echo "Speedtest bellow might take several minutes and is displayed in Mbps like the GUI tests"
        echo -e "\e[32mwait until you see Testing download and upload speed output \e[0m"
        pause

        runspeedtest=`wget --no-check-certificate -O - https://raw.github.com/sivel/speedtest-cli/master/speedtest.py | python`

        echo
        echo "$runspeedtest"
		echo
        pause
}

ten(){
        echo
        echo "hda = SSD disk"
        echo "sda = SCSI disk"
        echo "vda = virtual disks"
        echo -e "\e[32mcheck the column I/O for current pending operations and sec for delays \e[0m"

        rundiskio=`vmstat -d | head -2 ; vmstat -d | grep -E "hda/|sda/|vda";iostat`

        echo
        echo "$rundiskio"
		echo
        pause
}

eleven(){
        echo
        echo -e "\e[32mList all listening sockets and their processes \e[0m"

        listsokets=`netstat -natp4 | grep "0 0.0.0.0:"`

        echo
        echo "$listsokets"
		echo
        pause
}

# function to display menus
show_menus() {
        clear
        echo "   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo -e "                             \e[34m~XG Troubleshooter~\e[0m"
        echo "                         author:luiz.camilo@sophos.com"
        echo "   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo "1. Show System info                           | 10. Show disk I/O"
        echo "2. Last reboot from syslog.log                | 11. List listening Sockets"
        echo "3. Show IPSEC status details                  | 12. "
        echo "4. Show IPSEC retransmissions                 |"
        echo "5. Show Dead Gateway detection link failures  |"
        echo "6. Get Admin port from SQL database           |"
        echo "7. Reveal IPSEC PSK for all vpns              |"
        echo "8. List backend scheduled tasks               |"
        echo "9. Run WAN Speedtest                          |"
        echo "0. Exit"
}
# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 0 form the menu option.
read_options(){
        local choice
        read -p "Enter choice [ 1 - 0] " choice
        case $choice in
                1) one ;;
                2) two ;;
                3) three ;;
                4) four ;;
                5) five ;;
                6) six ;;
                7) seven ;;
                8) eight ;;
                9) nine ;;
                10) ten ;;
				11) eleven;;
                0) exit 0;;
                *) echo -e "${RED}Error...${STD}" && sleep 2
        esac
}

# ----------------------------------------------
# Trap CTRL+C, CTRL+Z and quit singles
# ----------------------------------------------
trap '' SIGINT SIGQUIT SIGTSTP

# -----------------------------------
# Main logic - infinite loop
# ------------------------------------
while true
	do
			show_menus
			read_options
	done
