#! /bin/bash

# Script to perform local security checks

function checks() {

	if [[ $2 != $3 ]]
	then
		echo -e "\e[1;31mThe $1 is not compliant. The current policy should be: $2. The current value is: $3.$4\e[0m"
	else
		echo -e "\e[1;32mThe $1 is compliant. Current value $3.\e[0m"
	fi
}

# Check the max days policy
pmax=$(egrep -i '^PASS_MAX_DAYS' /etc/login.defs | awk ' { print $2} ')

# Check for password max
checks "Password Max Days" "365" "${pmax}"

# Check the min days policy
pmin=$(egrep -i '^PASS_MIN_DAYS' /etc/login.defs | awk ' { print $2} ')
checks "Password Min Days" "14" "${pmin}"

# Check the warn age
pwarn=$(egrep -i '^PASS_WARN_AGE' /etc/login.defs | awk ' { print $2} ')
checks "Password Warn Age" "7" "${pwarn}"

# Check the SSH UsePam configuration
checkSSHPAM=$(egrep -i "^UsePAM" /etc/ssh/ssh_config | awk ' { print $2} ')
checks "SSH UsePAM" "yes" "${checkSSHPAM}"

# Check permissions on users home directory
echo ""
for eachDir in $(ls -l /home | egrep '^d' | awk ' { print $3} ')
do
	chDir=$(ls -ld /home/${eachDir} | awk ' { print $1} ')
	checks "Home directory ${eachDir}" "drwx------" "${chDir}"
done

# ----------------------------------------------------------------

# Ensure IP Forwarding is disabled
ipforward=$(egrep -i 'net.ipv4.ip_forward' /etc/sysctl.conf)
checks "IP forwarding" "#net.ipv4.ip_forward=0"  "${ipforward}" "\nRemediation\nEdit /etc/sysctl.conf and set: \nnet.ipv4.ip_forward=0\nThen run:\nsysctl -w"

# Ensure ICMP redirects are disabled
icmp=$(egrep -i 'net.ipv4.conf.all.accept_redirects' /etc/sysctl.conf)
checks "ICMP redirects" "#net.ipv4.conf.all.accept_redirects = 0" "${icmp}" "\nRemediation \n Edit /etc/sysctl.conf and set: \nnet.ipv4.conf.all.accept redirects = 0 \nnet.ipv4.conf.default.accept_redirects = 0 \nThen run: \nsysctl -w"

# Crontab configuration
crontab=$(stat /etc/crontab | egrep -i 'uid' | awk ' {print $5} ')
checks "Crontab configuration" "0/" "${crontab}" "\nRemediation \nchown root:root /etc/crontab \n chmod og-rwx /etc/crontab"

# Crontab hourly
crontabhourly=$(stat /etc/cron.hourly | egrep -i 'uid' | awk ' {print $5} ')
checks "Crontab hourly" "0/" "${crontabhourly}" "\nRemediation \nchown root:root /etc/cr
ontab \n chmod og-rwx /etc/crontab"

# Crontab daily
crontabdaily=$(stat /etc/cron.hourly | egrep -i 'uid' | awk ' {print $5} ')
checks "Crontab daily" "0/" "${crontabdaily}" "\nRemediation \nchown root:root /etc/cr
ontab \n chmod og-rwx /etc/crontab"

# Crontab weekly
crontabweekly=$(stat /etc/cron.hourly | egrep -i 'uid' | awk ' {print $5} ')
checks "Crontab weekly" "0/" "${crontabweekly}" "\nRemediation \nchown root:root /etc/cr
ontab \n chmod og-rwx /etc/crontab"

# Crontab monthly
crontabmonthly=$(stat /etc/cron.hourly | egrep -i 'uid' | awk ' {print $5} ')
checks "Crontab monthly" "0/" "${crontabmonthly}" "\nRemediation \nchown root:root /etc/cr
ontab \n chmod og-rwx /etc/crontab"

# /etc/passwd
etcpasswd=$(stat /etc/passwd | egrep -i 'uid' | awk ' {print $5} ')
checks "/etc/passwd" "0/" "${etcpasswd}" "\nRemediation \nchown root:root /etc/passwd \nchmod 644 /etc/passwd"

# /etc/shadow
etcshadow=$(stat /etc/shadow | egrep -i 'uid' | awk ' {print $5} ')
checks "/etc/shadow" "0/" "${etcshadow}" "\nRemediation \nchown root:shadow /etc/shadow \nchmod o-rwx,g-wx /etc/shadow"

# /etc/group
etcgroup=$(stat /etc/group | egrep -i 'uid' | awk ' {print $5} ')
checks "/etc/group" "0/" "${etcgroup}" "\nRemediation \nchown root:root /etc/group \nchmod 644 /etc/group"

# /etc/gshadow
etcgshadow=$(stat /etc/gshadow | egrep -i 'uid' | awk ' {print $5} ')
checks "/etc/gshadow" "0/" "${etcgshadow}" "\nRemediation \nchown root:shadow /etc/gshadow \nchmod o-rwx,g-rw /etc/gshadow"

# /etc/passwd-
etcpasswd2=$(stat /etc/passwd- | egrep -i 'uid' | awk ' {print $5} ')
checks "/etc/passwd-" "0/" "${etcpasswd2}" "\nRemediation \nchown root:root /etc/passwd- \nchmod u-x,go-wx /etc/passwd-"

# /etc/shadow-
etcshadow2=$(stat /etc/shadow- | egrep -i 'uid' | awk ' {print $5} ')
checks "/etc/shadow-" "0/" "${etcshadow2}" "\nRemediation \nchown root:shadow /etc/shadow- \n chmod o-rwx,g-rw /etc/shadow-"

# /etc/group-
etcgroup2=$(stat /etc/group- | egrep -i 'uid' | awk ' {print $5} ')
checks "/etc/group-" "0/" "${etcgroup2}" "\nRemediation \nchown root:root /etc/group- \nchmod u-x,go-wx /etc/group-"

# /etc/gshadow-
etcgshadow2=$(stat /etc/gshadow- | egrep -i 'uid' | awk ' {print $5} ')
checks "/etc/gshadow-" "0/" "${etcgshadow2}" "\nRemediation \nchown root:shadow /etc/gshadow- \nchmod o-rwx,g-rw /etc/gshadow-"

# Legeacy /etc/passwd
legacypasswd=$(grep '^+:' /etc/passwd)
checks "Legacy entries in /etc/passwd" "" "${legacypasswd}" "\nRemediation \nRemove any leg
acy '+' entries with rm <entry> if they exsist"

# Legacy /etc/shadow
legacyshadow=$(sudo grep '^+:' /etc/shadow)
checks "Legacy entries in /etc/shadow" "" "${legacyshadow}" "\nRemediation \nRemove any leg
acy '+' entries with rm <entry> if they exsist"

# Legacy /etc/group
legacygroup=$(grep '^+:' /etc/group)
checks "Legacy entries in /etc/group" "" "${legacygroup}" "\nRemediation \nRemove any legacy '+' entries with rm <entry> if they exsist"

# UID of 0
uidcheck=$(cat /etc/passwd | grep ":0:")
checks "User has UID of 0" "root:x:0:0:root:/root:/bin/bash" "${uidcheck}" "\nRemediation \nIf any other users exist: \nuserdel <username>"


