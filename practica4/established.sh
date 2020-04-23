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



# Permitim l'acces a tothom al nostre port 80 excepte a un dels 
# ordinadors de la nostre xarxa local
iptables -A OUTPUT -p tcp --sport 80 -m tcp -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -s 192.168.1.206 -j REJECT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT


