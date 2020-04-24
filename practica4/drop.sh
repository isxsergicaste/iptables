#! /bin/bash 
# Sergi Castellà

# Eliminar les regles establertes 
iptables -F
iptables -X
iptables -Z
iptables -t nat -F

# Establir les regles per defecte
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Donar permis a totes les conexions del localhost
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Donar permis de tot a la nostre ip
iptables -A INPUT -s 192.168.1.236 -j ACCEPT
iptables -A OUTPUT -d 192.168.1.236 -j ACCEPT

# Obrim els ports que volem
# ssh
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT

# rpc
iptables -A INPUT -p tcp --dport 111 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 111 -j ACCEPT
iptables -A INPUT -p tcp --dport 507 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 507 -j ACCEPT

# chronyd
iptables -A INPUT -p tcp --dport 123 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 123 -j ACCEPT
iptables -A INPUT -p tcp --dport 371 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 371 -j ACCEPT

# cups
iptables -A INPUT -p tcp --dport 631 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 631 -j ACCEPT

# xinetd
iptables -A INPUT -p tcp --dport 3411 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 3411 -j ACCEPT

# postgresql
iptables -A INPUT -p tcp --dport 5432 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 5432 -j ACCEPT

# x11forwarding
iptables -A INPUT -p tcp --dport 6010 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 6010 -j ACCEPT
iptables -A INPUT -p tcp --dport 6011 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 6011 -j ACCEPT

# avahi
iptables -A INPUT -p udp --dport 368 -j ACCEPT
iptables -A OUTPUT -p udp --sport 368 -j ACCEPT

# alpes
iptables -A INPUT -p udp --dport 463 -j ACCEPT
iptables -A OUTPUT -p udp --sport 463 -j ACCEPT

# tcpnethaspsrv
iptables -A INPUT -p udp --dport 475 -j ACCEPT
iptables -A OUTPUT -p udp --sport 475 -j ACCEPT

# rxe
iptables -A INPUT -p tcp --dport 761 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 761 -j ACCEPT

# dns
iptables -A INPUT -p udp --sport 53 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT

# dhclient
iptables -A INPUT -p udp --dport 68 -j ACCEPT
iptables -A OUTPUT -p udp --sport 68 -j ACCEPT











