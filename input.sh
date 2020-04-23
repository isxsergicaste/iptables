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

# Obrim el servidor web i el telnet a tothom
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 23 -j ACCEPT

# Tanquem els ports 2080 i 3080 (que els hi hem asignat que siguin
# un lligam del port 80), un el tanquem amb reject: el cual, envia
# una resposta a qui s'intenta conectar i l'altre amb drop el cual 
# no envia res
iptables -A INPUT -p tcp --dport 2080 -j REJECT
iptables -A INPUT -p tcp --dport 3080 -j DROP

# Permetem que només un dels nostres ordinadors locals pugui accedir
# al port 4080 que tenim obert

iptables -A INPUT -p tcp --dport 4080 -s 192.168.1.220 -j ACCEPT
iptables -A INPUT -p tcp --dport 4080 -j DROP

# Obrim el nostre port 5080 només a la nostre xarxa local, execepte
# al ordinador que l'hi hem obert el port 4080

iptables -A INPUT -p tcp --dport 5080 -s 192.168.1.220 -j REJECT
iptables -A INPUT -p tcp --dport 5080 -s 192.168.1.0/24 -j ACCEPT

# Per ultim tanquem tots els ports entre el 6000 i el 8000

iptables -A INPUT -p tcp --dport 6000:8000 -j REJECT

# Mostrem les taules creades per asegurarnos de tenir-ho tot correcte
iptables -L

