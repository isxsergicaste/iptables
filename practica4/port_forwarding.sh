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
iptables -t nat -P PREROUTING ACCEPT
iptables -t nat -P POSTROUTING ACCEPT

# Donar permis a totes les conexions del localhost
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Donar permis de tot a la nostre ip
iptables -A INPUT -s 192.168.1.236 -j ACCEPT
iptables -A OUTPUT -d 192.168.1.236 -j ACCEPT

# Els hi donem permis als dockers a traves de les seves xarxes de ip
# a que puguin tenir acces al exterior

iptables -t nat -A POSTROUTING -s 172.20.0.0/16 -o ens33 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 172.21.0.0/16 -o ens33 -j MASQUERADE

# Regles amb el port Forward

iptables -t nat -A PREROUTING -s 192.168.1.220 -i ens33 -p tcp --dport 80 -j DNAT --to 172.21.0.2:7


# Lliguem el port 5001 que sera el port 13 de la B1
iptables -t nat -A PREROUTING -i ens33 -p tcp --dport 5001 -j DNAT --to 172.20.0.2:13
iptables -t nat -A PREROUTING -i ens33 -p tcp --dport 5002 -j DNAT --to 172.21.0.2:13
iptables -t nat -A PREROUTING -i ens33 -p tcp --dport 5003 -j DNAT --to :13
iptables -t nat -A PREROUTING -i ens33 -p tcp --dport 6001 -j DNAT --to 172.21.0.2:7

# Si no permetem la conexio al port 3 els tres primers preroutins no funcionaran

iptables -A FORWARD -p tcp --dport 13 -j REJECT
iptables -A INPUT -p tcp --dport 13 -j REJECT























