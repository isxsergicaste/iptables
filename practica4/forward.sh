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

# Regles amb el Forward

# No permetre l'acces de la netA a la netB ( de B cap a A esta permes )
#iptables -A FORWARD -s 172.20.0.0/16 -d 172.21.0.0/16 -j REJECT

# No permetre de B cap a A
#iptables -A FORWARD -s 172.21.0.0/16 -d 172.20.0.0/16 -j REJECT

# Tancar-li algunes connexions al A1 (A2 i B1, només acces a B2)
#iptables -A FORWARD -s 172.20.0.2 -d 172.20.0.3 -j REJECT
#iptables -A FORWARD -s 172.20.0.2 -d 172.21.0.2 -j DROP

# Xarxa A no tindra acces a cap port 80 ( permet access al de pc local )
# iptables -A FORWARD -p tcp -s 172.20.0.0/16 --dport 80 -j REJECT

# Prohibir l'acces de la xarxa A al port 1080 de la xarxa B
#iptables -A FORWARD -p tcp -s 172.20.0.0/16 -d 172.21.0.0/16 --dport 1080 -j REJECT

# Permetre a la xarxa A només navegar per internet
#iptables -A FORWARD -s 172.20.0.0/16 -o ens33 -p tcp --dport 80 -j ACCEPT
#iptables -A FORWARD -d 172.20.0.0/16 -p tcp --sport 80 -i ens33 -m state --state RELATED,ESTABLISHED -j ACCEPT
#iptables -A FORWARD -s 172.20.0.0/16 -o ens33 -j REJECT
#iptables -A FORWARD -d 172.20.0.0/16 -i ens33 -j REJECT
#iptables -A FORWARD -s 172.20.0.0/16  -p tcp  -j DROP

# Xarxa A pot accedir a tots els ports 13 excepte els de la xarxa local (en el ordinador local sempre permet les connexions)
#iptables -A FORWARD -s 172.20.0.0/16 -d 192.168.1.0/24 -p tcp --dport 13 -o ens33 -j REJECT
#iptables -A FORWARD -s 172.20.0.0/16 -p tcp --dport 13 -o ens33  -j ACCEPT

# Evitar que sigui falsa la ip principal
iptable -A FORWARD  ! -s 172.20.0.0/16 -i br-3c928894b7ef -j REJECT




























