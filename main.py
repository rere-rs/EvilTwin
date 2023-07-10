# _*_ coding:utf-8 _*_

import os
import psutil
import time
from simple_term_menu import TerminalMenu #librairie qui permet d'afficher un menu intéractif dans le terminal
from tqdm import tqdm #permet d'afficher une barre de progression

#Echappement ANSI
GRAS = '\033[1m'
BLEU = '\033[94m'
VERT = '\033[92m'
ORANGE = '\033[33m'
ROUGE = '\033[31m'
RESET = '\033[0m'

def en_exec(script):
    
    """
    Cette fonction permet de savoir si un script est toujours en execution.

    Paramètres
    ----------
    script : nom du script

    Renvoie
    -------
    Un booléen qui renvoit True si le script est toujours en execution, sinon False.
    """

    for process in psutil.process_iter(['name']): #itère sur tous les processus en cours d'exécution
        if process.info['name'] == script:
            return True
    return False

def barre_prog(script):
    iterations = 100

    for _ in tqdm(range(iterations), desc="Progression"):
        # Effectuer une tâche
        time.sleep(0.1)

        # Vérifier si le script est toujours en cours d'exécution
        if not en_exec(script):
            print("Le script a été arrêté.")
            return
    print("Tâches terminées.")

def affichage_init():
    
    """
    Cette fonction personnalise l'affichage du programme lors du lancement.
    """

    os.system("clear") #effacer le terminal
    titre = " _____     _ _    _____       _    \n|   __|_ _|_| |  |_   _|_ _ _|_|___ \n|   __| | | | |    | | | | | | |   |\n|_____|\_/|_|_|    |_| |_____|_|_|_|\n"
    #logo = " ⢠⡾⠃⠀⠀⠀⠀⠀⠀⠰⣶⡀\n⢠⡿⠁⣴⠇⠀⠀⠀⠀⠸⣦⠈⢿⡄\n⣾⡇⢸⡏⢰⡇⠀⠀⢸⡆⢸⡆⢸⡇\n⢹⡇⠘⣧⡈⠃⢰⡆⠘⢁⣼⠁⣸⡇\n⠈⢿⣄⠘⠃⠀⢸⡇⠀⠘⠁⣰⡟\n  ⠙⠃⠀⠀⢸⡇⠀⠀⠘⠋\n      ⢸⡇\n      ⢸⡇⠘⠃"
    print(titre)

def init_menu_principal():

    """
    Cette fonction affiche un menu proposant la création d'un Evil Twin ou le crackage d'un handshake
    """
    
    affichage_init()
    #Création du menu pour selectionner les fonctionnalités
    options_menu_princpal = ["Création d'un Evil Twin","Handshake WEP/WPA/WPA2","Quitter"]
    menu_principal = TerminalMenu(options_menu_princpal).show()
    if options_menu_princpal[menu_principal] == "Création d'un Evil Twin":
        fichier = "eviltwin/capture/ESSID.txt"
        hostapd_conf = "eviltwin/hostapd.conf"
        dnsmasq_conf = "eviltwin/dnsmasq.conf"
        if os.path.exists(hostapd_conf) and os.path.exists(dnsmasq_conf): #On check si les fichiers conf existent afin de les lancer directement
            activation()
        else:
            if os.path.exists(fichier): #On check si le fichier est bien créé
                with open(fichier,'r') as file: #On ouvre le fichier ESSID en lecture
                    contenu = file.readlines()           
                #----------------------------------------------------------------------#
                essids = [line.split(';')[0] for line in contenu] #On récupère le nom des AP
                bssids = [line.split(';')[1] for line in contenu] #On récupère l'adresse mac des AP
                channels = [line.split(';')[2] for line in contenu]#On récupère les channels 
                datas = [line.split(';')[3] for line in contenu] #On récupère le nombre de data des AP
                print(BLEU+"ESSID - "+ORANGE+"BSSID - "+VERT+"CHANNEL - "+ROUGE+"DATA"+RESET)
                for index,(essid,bssid,ch,data) in enumerate(zip(essids,bssids,channels,datas),start=1): #On les affiche avec enumerate() afin de garder l'index
                    print(f"{index} : "+BLEU+f"{essid}"+RESET+" - "+ORANGE+f"{bssid}"+RESET+" - "+VERT+f"{ch}"+RESET+" - "+ROUGE+f"{data}"+RESET)
                file.close() #On ferme le fichier
                #----------------------------------------------------------------------#
                os.system("bash script/eviltwin.sh")
                activation()
            else:
                print("Le fichier n'existe pas.\n")
    elif options_menu_princpal[menu_principal] == "Handshake WEP/WPA/WPA2":
        print("Handshake.sh loaded...")
    else:
        print("Bye")
        exit(0)

def activation():

    """
    Cette fonction va demander à l'utilisateur de lancer HOSTAPD et DNSMASQ
    """

    #Création du menu pour activer l'EvilTwin
    affichage_init()
    print("Voulez-vous lancer l'EvilTwin ?\n")
    options_menu_activation = ["Oui","Non","Quitter"]
    menu = TerminalMenu(options_menu_activation).show()

    if options_menu_activation[menu] == "Oui":
        print("Lancement de HOSTAPD et DNSMASQ...\n"+VERT+"Pour arrêter, CTRL+C dans chaque terminal"+RESET)
        os.system("bash script/activation.sh")
        exit(0)
    elif options_menu_activation[menu] == "Non":
        print("\nPour lancer HOSTAPD et DNSMASQ manuellement :\n"+ROUGE+"sudo xterm -hold -e sudo dnsmasq -d -C dnsmasq.conf &\nsudo xterm -hold -e sudo hostapd hostapd.conf &"+RESET)
        init_menu_principal()
    else:
        print("\nBye")
        exit(0)

#############################################################
                            #MAIN#
#############################################################

affichage_init()
if os.path.exists("eviltwin"):
    init_menu_principal()
else:
    option_capture = ["Récupérer les réseaux WiFi","Quitter"]
    menu_capture = TerminalMenu(option_capture).show()
    if option_capture[menu_capture] == "Récupérer les réseaux WiFi":
        os.system("bash script/capture.sh")
        init_menu_principal()
    elif option_capture[menu_capture] == "Quitter":
        print("Bye")
        exit(0)
