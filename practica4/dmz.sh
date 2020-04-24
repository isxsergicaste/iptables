#! /bin/bash 
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
iptables -t nat -A POSTROUTING -s 172.22.0.0/16 -o ens33 -j MASQUERADE

# Regles DMZ

# Xarxa A només tenim accces a port 22 i 13
iptables -A INPUT -s 172.20.0.0/16 -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -s 172.20.0.0/16 -p tcp --dport 13 -j ACCEPT
iptables -A INPUT -s 172.20.0.0/16 -j REJECT

# Xarxa A només tindra acces al exterior als ports 80 i 22
iptables -A FORWARD  -s 172.20.0.0/16 -p tcp --dport 80 -o ens33 -j ACCEPT
iptables -A FORWARD  -d 172.20.0.0/16 -p tcp --sport 80 -i ens33 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD  -s 172.20.0.0/16 -p tcp --dport 22 -o ens33 -j ACCEPT
iptables -A FORWARD  -d 172.20.0.0/16 -p tcp --sport 22 -i ens33 -m state --state RELATED,ESTABLISHED -j ACCEPT
# Comento perque amb aquest ordre la següent no funciona
#iptables -A FORWARD  -s 172.20.0.0/16 -o ens33 -j REJECT
#iptables -A FORWARD  -d 172.20.0.0/16 -i ens33 -j REJECT

# Xarxa A només pot accedir al servidor web de DMZ
iptables -A FORWARD -s 172.20.0.0/16 -d 172.22.0.0/16 -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -s 172.20.0.0/16 -d 172.22.0.0/16 -j DROP

# Redirigir els ports perque desde l'exterior es tingui acces a diferents ports dels les xarxes A i B
iptables -t nat -A PREROUTING -i ens33 -p tcp --dport 3001 -j DNAT --to 172.20.0.2:22
iptables -t nat -A PREROUTING -i ens33 -p tcp --dport 3002 -j DNAT --to 172.20.0.3:13
iptables -t nat -A PREROUTING -i ens33 -p tcp --dport 3003 -j DNAT --to 172.21.0.2:7
iptables -t nat -A PREROUTING -i ens33 -p tcp --dport 3004 -j DNAT --to 172.21.0.3:13

# Redirigir ports per a tenir acces a shh de diferents pcs
iptables -t nat -A PREROUTING -i ens33 -p tcp --dport 4001 -j DNAT --to 172.22.0.2:22
iptables -t nat -A PREROUTING -i ens33 -p tcp --dport 4002 -j DNAT --to 172.21.0.2:22

# Habilitar el port 4000 per accedir al ssh del router si la ip es una especifica
iptables -t nat -A PREROUTING -i ens33 -p tcp --dport 4000 -s 192.168.1.220 -j DNAT --to :22

# Xarxa B no te acces a xarxa A
iptables -A FORWARD -s 172.21.0.0/16  -d 172.20.0.0/16 -j DROP
iptables -A FORWARD -s 172.21.0.0/16 -j ACCEPT
iptables -A FORWARD -d 172.21.0.0/16 -j ACCEPT













