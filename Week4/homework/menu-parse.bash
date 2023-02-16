#! /bin/bash

# Storyline: Menu for IPtables, Cisco, Windows Firewall, Mac inbound drop rules

function menu() {
	# Display menu
	clear
	echo "[1] IPtables blocklist generator"
	echo "[2] Cisco blocklist generator"
	echo "[3] Windows Firewall blocklist generator"
	echo "[4] Mac OS X blocklist generator"
	echo "[5] Domain URL blocklist generator"
	read -p "Please enter a choice above: " option
	
	case "$option" in
		1) 
			for eachIP in $(cat badIPs.txt)
			do
       				echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPs.iptables 
			done

		;;
		2)
		;;
		3)	for eachIP in $(cat badIPs.txt)
			do
				echo "New-NetFirewallRule -Direction Outbound –LocalPort Any -Protocol TCP -Action Block -RemoteAddress ${eachIP}" | tee -a badIPs.ps
			done
		;;
		4)
			for eachIP in $(cat badIPs.txt)
			do
			        echo "block in from ${eachIP} to any" | tee -a pf.conf
			done


		;;
		5)
			echo "class-map match nay BAD_URLS"
			for eachURL in $(cat badURLs.txt)
			do
				echo "match protocol http host ${eachURL}" | tee -a badURLs.cisco
			done
			
		;;
		*)
		;;
	esac
}
menu
