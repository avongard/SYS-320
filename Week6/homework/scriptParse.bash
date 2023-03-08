#! /bin/bash

# Parse Apache Log

# Read in file

# Arguments using the position they start at $1

APACHE_LOG="$1"

# Check command syntax

if [[ ! -f ${APACHE_LOG} ]]
then
        echo "Please specify the path to a log file."
        exit 1
fi


# Check if logs have been parsed
if [[ -f ${APACHE_LOG}-ips ]]
then
        # Prompt if we need to overwrite the file
        echo "The log file has already been parsed."
        echo -n "Do you want to overwrite it? [y/N]"
        read to_overwrite

        if [[ "${to_overwrite}" == "N" || "${to_overwrite}" == "n" || "${to_overwrite}" == "" ]]
        then
                echo "Exit..."
                exit 0
        elif [[ "${to_overwrite}" == "y" ]]
        then


# Extract IP from logs
		grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' ${APACHE_LOG} | sort -u | tee ${APACHE_LOG}-ips

# Format
		for eachIP in $(cat ${APACHE_LOG}-ips)
		do
			echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a ${APACHE_LOG}-iptables
		done

	else
		echo "Invalid value"
		exit 1
	fi
else
       	grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' ${APACHE_LOG} | sort -u | tee ${APACHE_LOG}-ips
	for eachIP in $(cat ${APACHE_LOG}-ips)
        do
       		echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a ${APACHE_LOG}-iptables
	done

fi
