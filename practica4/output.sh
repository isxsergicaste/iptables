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

# Permetre que el nostre ordinador accedeixi a cualsevol port 13
iptables -A OUTPUT -p tcp --dport 13 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 13 -d 0.0.0.0/0  -j ACCEPT

# No permetre conexions a el DNS de google
#iptables -A OUTPUT -d 8.8.8.8 -j REJECT

# Permetre l'acces al port 7
iptables -A OUTPUT -p tcp --dport 7 -j ACCEPT

# No permetem que hi hagi cap conexio local excepte les anteriors
iptables -A OUTPUT -d 192.168.1.0/24 -j REJECT

# Si comentem totes les ordres anteriors, amb les següents només es
# pot accedir a la xarxa local mitjançant el ssh
#iptables -A OUTPUT -p tcp --dport 22 -d 192.168.1.0/24 -j ACCEPT
#iptables -A OUTPUT -d 192.168.1.0/24 -j REJECT

# Si comentem totes les lineas anteriors, no permetra que el nostre pc
# accedeixi a cap port 80, 13 ni 7
iptables -A OUTPUT -p tcp --dport 80 -j REJECT
iptables -A OUTPUT -p tcp --dport 13 -j REJECT
iptables -A OUTPUT -p tcp --dport 7  -j REJECT
