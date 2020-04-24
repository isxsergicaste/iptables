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
# Permetre l'acces al ldap desde el router ( te la ip 5 ja que m'he oblidat d'obrir un els dockers de DMZ )
iptables -t nat -A PREROUTING -p tcp --dport 389 -i ens33 -j DNAT --to 172.22.0.5:389
iptables -t nat -A PREROUTING -p tcp --dport 636 -i ens33 -j DNAT --to 172.22.0.5:636

# Permetre obtenir tickets kerberos desde un port especific en el router
iptables -t nat -A PREROUTING -p tcp --dport 88 -i ens33 -j DNAT --to 172.22.0.3:88
iptables -t nat -A PREROUTING -p tcp --dport 543 -i ens33 -j DNAT --to 172.22.0.3:543
iptables -t nat -A PREROUTING -p tcp --dport 749 -i ens33 -j DNAT --to 172.22.0.3:749
iptables -t nat -A PREROUTING -p tcp --dport 544 -i ens33 -j DNAT --to 172.22.0.3:544

# Permetre montar un samba desde el router
iptables -t nat -A PREROUTING -p tcp --dport 139 -i ens33 -j DNAT --to 172.22.0.4:139
iptables -t nat -A PREROUTING -p tcp --dport 445 -i ens33 -j DNAT --to 172.22.0.4:445

