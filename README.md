# EvilTwin

## Pré-requis

- OS avec un gestionnaire de paquets APT
- Aircrack-ng
- Apache2 ou autre serveur web
- Python 3.x
- Carte WiFi de type Panda PAU09 ou ALFA AWUS036NEH

## Installation et utilisation

### Installation 

Lancer le script **install.sh**
```bash
cd EvilTwin
chmod a+x install.sh && ./install.sh
```

Mise en place d'une page de connexion afin de tester le capture de paquets :
```bash
sudo cp web/* /var/www/html/
systemctl restart apache2.service
```

Pour tester, lancer l'EvilTwin et se connecter à l'adresse suivante http://192.168.1.254/login.html sur la machine connectée à l'AP. 

### Utilisation

Avant de lancer le script, modifier le fichier suivant dans le dossier **script** : **eviltwin.sh**
```bash
vim eviltwin.sh
#Changer la variable carte_ethernet par le nom de votre carte réseau interne, souvent eth0 (VM) ou wlan1 (Clé bootable)
int_iptables=carte_ethernet
```

Pour lancer le script :
```bash
python main.py
```

## Recommencer

Supprimer le dossier **eviltwin** pour pouvoir réeffectuer la capture des réseaux WiFi
```bash
sudo rm -rf eviltwin
```

Lancer le script **reset.sh**
```bash
cd script && ./reset.sh
```
