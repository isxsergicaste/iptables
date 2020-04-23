#! /bin/bash 
# Sergi Castellà

#!/bin/bash
# Sergi Castellà

# Eliminar les regles establertes 
iptables -F
iptables -X
iptables -Z
iptables -t nat -F

# Establir les regles per defecte
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

# Donar permis a totes les conexions del localhost
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Donar permis de tot a la nostre ip
iptables -A INPUT -s 192.168.1.236 -j ACCEPT
iptables -A OUTPUT -d 192.168.1.236 -j ACCEPT

# Prohibir fer pings cap a alguns dels ordinadors de la nostre xarxa local
iptables -A OUTPUT -p icmp --icmp-type 8 -d 192.168.1.220 -j DROP
iptables -A OUTPUT -p icmp --icmp-type 8 -d 192.168.1.206 -j REJECT

# Que els demes no obtinguin resposta sin fan un ping cap al nostre ordinador
iptables -A OUTPUT -p icmp --icmp-type 0 -j DROP

# No es poden fer pings cap a cap lloc
iptables -A OUTPUT -p icmp --icmp-type 8 -j DROP


