#! /bin/bash

# Storyline: Extract IPs from emergingthreats.net and create a firewall ruleset

# Check if emergingthreats.net file is donwloaded
if [[ -f /tmp/emerging-drop.suricata.rules ]]
then
        # Prompt if we need to overwrite the file
        echo "The file emerging-drop.suricata.rules already exists."
        echo -n "Do you want to overwrite it? [y/N]"
        read to_overwrite

        if [[ "${to_overwrite}" == "N" || "${to_overwrite}" == "" ]]
        then
                echo "Exit..."
                exit 0
        elif [[ "${to_overwrite}" == "y" ]]
        then
                echo "Downloading file..."
		wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O /tmp/emerging-drop.suricata.rules

        # If the admin doesn't specify a y or N then error.
        else
                echo "Invalid value"
                exit 1
	fi
else wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O /tmp/emerging-drop.suricata.rules
fi

# Check if targetedthreats file is donwloaded
if [[ -f /tmp/targetedthreats.csv ]]
then
        # Prompt if we need to overwrite the file
        echo "The file targetedthreats.csv already exists."
        echo -n "Do you want to overwrite it? [y/N]"
        read to_overwrite

        if [[ "${to_overwrite}" == "N" || "${to_overwrite}" == "" ]]
        then
                echo "Exit..."
                exit 0
        elif [[ "${to_overwrite}" == "y" ]]
        then
                echo "Downloading file..."
                wget https://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv -O /tmp/targetedthreats.csv

        # If the admin doesn't specify a y or N then error.
        else
                echo "Invalid value"
                exit 1
        fi
else wget https://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv -O /tmp/targetedthreats.csv
fi







# Return all matching values to badIPs.txt

egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}'  /tmp/emerging-drop.suricata.rules | sort -u | tee badIPs.txt

# Return all matching values to badURLs.txt
grep domain /tmp/targetedthreats.csv | sort -u | cut -d ',' -f2 | tee -a badURLs.txt
