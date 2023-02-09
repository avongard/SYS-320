#!/ bin/bash

# Storyline: Script to add and delete VPN peers

while getopts 'hcdau:' OPTION ; do
	case "$OPTION" in
	c) u_check=${OPTION}
	;;
	d) u_del=${OPTION}
	;;
	a) u_add=${OPTION}
	;;
	u) t_user=${OPTARG}
	;;
	h)  
    	   echo""
	   echo"Usage: $(basename $0) [-c][-a]|[-d] -u username"
           echo""
	   exit 1
	;; 
	  
	*)
	   echo "Invalid value."
	   exit 1
	;;

	esac
done

# Check to see if -a and -d are empty or if both specified throw an error
if [[ (${u_del} == "" && ${u_add} == "" && ${u_check} == "") || (${u_del} != "" && ${u_check} != "" && ${u_add} != "")  ]]
then
	echo "Please specify -a or -d or -c and the -u and username."
fi

# Check to ensure -u is specified
if [[ (${u_del} != "" || ${u_add} != "" || ${u_check} != "") && ${t_user} == "" ]]
then    
	echo "Please specify a username (-u)."
	echo "Usage: $(basename $0) [-a]|[-d] -u username"
	exit 1
fi      

# Check if -c is specified
if [[ ${u_check} ]]
then
	grep -A 6 "# ${t_user} begin" wg0.conf
fi

# Delete a user
if [[ ${u_del} ]]
then
	echo "Deleting user..."
	sed -i "/# ${t_user} begin/,/# ${t_user} end/d" wg0.conf
	rm "$t_user"-wg0.conf
		
fi

# Add a user
if [[ ${u_add} ]]
then
	echo "Creating the user..."
	bash peer.bash ${t_user}
fi
