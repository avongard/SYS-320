#! /bin/bash

# Storyline: Menu for admin, VPN, Security functions

function invalid_opt () {

echo ""
echo "Invalid option"
echo ""
sleep 2

}

function menu() {
	
	# Clears the screen
	clear

	echo "[1] Admin Menu"
	echo "[2] Security Menu"
	echo "[3] Exit"
	read -p "Please enter a choice above: " choice

	case "$choice" in
		1) admin_menu
		;;
		2) security_menu
		;;	
		3) exit 0
		;;
		*) invalid_opt
			# Call the main menu
			menu
		;;

	esac

}

function admin_menu() {
	
	clear
	echo "[L]ist Running Processes"
	echo "[N]etwork Sockets"
	echo "[V]PN Menu"
	echo "[4] Exit"
	read -p "Please enter a choice above: " choice

	case "$choice" in
		L|l) ps -ef | less
		;;
		N|n) netstat -an --inet | less
		;;
		V|v) vpn_menu 
		;;
		4) exit 0
		;;
		*) invalid_opt
		;;
		
	esac
admin_menu
}

function security_menu() {
	clear
	echo "[O]pen Network Sockets"
	echo "[U]ID of 0 check"
	echo "[L]ast Ten Logged in Users"
	echo "[C]urrently Logged in Users"
	read -p "Please enter a choice above: " choice

	case "$choice" in
		O|o) ss -l | less
		;;
		U|u) cat /etc/passwd | grep ":0:" | less
		;;
		L|l) last | head -n 10101010101010101010 | less
		;;
		C|c) w | less 
		;;
		*) invalid_opt
		;;
	esac
security_menu
}

function vpn_menu() {
	
	clear
	echo "[A]dd a peer"
	echo "[D]elete a peer"
	echo "[C]heck to see if user exists"
	echo "[B]ack to admin menu"
	echo "[M]ain menu"
	echo "[E]xit"
	read -p "Please enter a choice above: " choice

	case "$choice" in
		A|a) bash peer.bash
		     tail -6 wg0.conf | less
		;;
		D|d) echo -n "What is the peer's name?"
			read the_peer
		     bash manage-users.bash -d -u "$the_peer"
		     rm "$the_peer"-wg0.conf
		;;
		C|c) echo -n "What is the peer's name?"
			read the_peer
		     sed -n '/# {$the_peer} begin/, /# {$the_peer} end/p' wg0.conf 
		;;
		B|b) admin_menu
		;;
		M|m) menu
		;;
		E|e) exit 0
		;;
		*) invalid_opt
		;;	

		esac
vpn
}

# Call the main function
menu


