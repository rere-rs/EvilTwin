# EvilTwin

## Pré-requis

Pour utiliser <u>EvilTwin</u>, vous devez avoir un système d'exploitation utilisant un le gestionnaire de paquet **apt** ainsi que **Python 3.x**. De plus, vous devez installer les packages suivants :
```bash
pip install simple_term_menu psutil tqdm
sudo apt install hostapd dnsmasq xterm -y
```
Il vous faut une carte WiFi externe de type : Panda PAU09 ou ALFA AWUS036NEH

Selon votre distribution, modifier la variable suivante :
```bash
cd EvilTwin/script
vim eviltwin.sh

int_iptables=
#Remplacer ou ajouter votre carte réseau ethernet. Souvent eth0.
```
