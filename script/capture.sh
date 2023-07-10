#!/bin/bash

#Créer ou aller dans le répertoire eviltwin et créer un dossier APs pour stocker les captures
nom_dossier=eviltwin
sous_dossier=capture
if [ -d "$nom_dossier" ]; then
	#Si le dossier existe, on se déplace
	cd $nom_dossier
	if [ -d "$sous_dossier" ]; then
		cd $sous_dossier
	else
		mkdir $sous_dossier && cd $sous_dossier
	fi  
else
	#Sinon on créer le dossier et on se déplace
	mkdir $nom_dossier && cd $nom_dossier
	mkdir $sous_dossier && cd $sous_dossier
fi

#------------------------------CHOIX INTERFACE RÉSEAU-------------------------------------

#Récupérer les interfaces réseaux
echo "Récupération des interfaces réseaux..."
echo $(ip -o link show | awk -F': ' '{print $2}' )
echo ""

#Demander à l'utilisateur de renter le nom de l'interface réseau à mettre en monitoring
echo "Entrez votre interface réseau"
read int_reseau

touch ../../script/reset.sh && chmod a+x ../../script/reset.sh
echo "sed -i s/int_reseau=$int_reseau/int_reseau=/ script/eviltwin.sh" > ../../script/reset.sh 
echo "sed -i s/int_reseau=$int_reseau/int_reseau=/ script/activation.sh" >> ../../script/reset.sh 

sed -i "s/int_reseau=/int_reseau=$int_reseau/" ../../script/eviltwin.sh
sed -i "s/int_reseau=/int_reseau=$int_reseau/" ../../script/activation.sh

#------------------------------ÉCOUTE SUR LE RÉSEAU---------------------------------------

#On écoute pour déterminer l’AP Wi-Fi avec le plus de trafic afin d'usurper son identité

#On tue les processus bloquants, pour avoir une base saine
sudo airmon-ng check kill

#Passage de l’interface en mode monitor (pour pouvoir écouter)
sudo airmon-ng start $int_reseau 

#Récupération des ondes écoutées pendant 15s et on indique la sortie avec le nom “capture-ap”
sudo timeout --foreground 15s airodump-ng $int_reseau"mon" -w capture-ap

#On quitte le mode monitor
sudo airmon-ng stop $int_reseau"mon"

#Redémarrer le réseau
sudo systemctl restart NetworkManager

#------------------------------RECUPERER LE NOM ET CHANNEL---------------------------------

#Copier les ESSID dans un fichier ESSID.txt

tail -n +2 capture-ap-01.kismet.csv | awk -F ';' '{print $3, $4, $6, $14}' | tr ' ' ';' | sort -nr -k3 | tee ESSID.txt > /dev/null

#1. On utilise tail pour enlever l'entete (ESSID, CHANNEL etc)
#2. AWK permet de spécifier le délimiteur ';'. $3 : ESSID $4 : BSSID $14 : DATA  $6 : CHANNEL
#3. tr remplace les espaces dans par des ';'
#4. sort permet de trier, décroissant, selon la 3eme colonne
#5. Tee permet la sortie de la commande dans le fichier ESSID.txt
