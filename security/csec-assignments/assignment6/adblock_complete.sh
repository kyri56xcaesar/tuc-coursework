#!/bin/bash
# You are NOT allowed to change the files' names!
domainNames="domainNames.txt"
domainNames2="domainNames2.txt"
IPAddressesSame="IPAddressesSame.txt"
IPAddressesDifferent="IPAddressesDifferent.txt"
adblockRules="adblockRules"
IPAddresses="IPAddresses.txt"









function print_info()
{
    cat $IPAddressesDifferent
    wc $IPAddressesDifferent
    cat $IPAddressesSame
    wc $IPAddressesSame
}


function adBlock() {
    if [ "$EUID" -ne 0 ];then
        printf "Please run as root.\n"
        exit 1
    fi

    if [ "$1" = "-domains"  ]; then
        # Find different and same domains in ‘domainNames.txt’ and ‘domainsNames2.txt’ files 
	# and write them in “IPAddressesDifferent.txt and IPAddressesSame.txt" respectively
        # Write your code here...
        # ...
        # ...

        # Resolve domain names to ip addresses
        dig +short -f $domainNames > $IPAddresses &
        pid1=$!
        wait $pid1
        
        dig +short -f $domainNames2 >> $IPAddresses &
        pid2=$!
        wait $pid2

        uniq $IPAddresses -u > $IPAddressesDifferent
        uniq $IPAddresses -d > $IPAddressesSame

        grep "^[.,0-9]*$" $IPAddressesSame > "output.txt"
        mv "output.txt" $IPAddressesSame


        grep "^[.,0-9]*$" $IPAddressesDifferent > "output.txt"
        mv "output.txt" $IPAddressesDifferent

            
    elif [ "$1" = "-ipssame"  ]; then
        # Configure the DROP adblock rule based on the IP addresses of $IPAddressesSame file.
        # Write your code here...
        while read -r ip; do
            iptables -A INPUT -s $ip -j DROP
        done < $IPAddressesSame

    elif [ "$1" = "-ipsdiff"  ]; then
        # Configure the REJECT adblock rule based on the IP addresses of $IPAddressesDifferent file.
        # Write your code here...
        while read -r ip; do
            iptables -A INPUT -s $ip -j REJECT
        done < $IPAddressesDifferent

        
    elif [ "$1" = "-save"  ]; then
        # Save rules to $adblockRules file.
        # Write your code here...
 

        iptables-save > adblockRules
        
    elif [ "$1" = "-load"  ]; then
        # Load rules from $adblockRules file.
        # Write your code here...

        iptables-restore < adblockRules

        
    elif [ "$1" = "-reset"  ]; then
        # Reset rules to default settings (i.e. accept all).
        # Write your code here...
        
        iptables -F
        
        
    elif [ "$1" = "-list"  ]; then
        # List current rules.
        # Write your code here...
       
        iptables -L
        
        
    elif [ "$1" = "-help"  ]; then
        printf "This script is responsible for creating a simple adblock mechanism. It rejects connections from specific domain names or IP addresses using iptables.\n\n"
        printf "Usage: $0  [OPTION]\n\n"
        printf "Options:\n\n"
        printf "  -domains\t  Configure adblock rules based on the domain names of '$domainNames' file.\n"
        printf "  -ipssame\t  Configure the DROP adblock rule based on the IP addresses of $IPAddressesSame file.\n"
	printf "  -ipsdiff\t  Configure the DROP adblock rule based on the IP addresses of $IPAddressesDifferent file.\n"
        printf "  -save\t\t  Save rules to '$adblockRules' file.\n"
        printf "  -load\t\t  Load rules from '$adblockRules' file.\n"
        printf "  -list\t\t  List current rules.\n"
        printf "  -reset\t  Reset rules to default settings (i.e. accept all).\n"
        printf "  -help\t\t  Display this help and exit.\n"
        exit 0
    else
        printf "Wrong argument. Exiting...\n"
        exit 1
    fi
}

adBlock $1
exit 0
