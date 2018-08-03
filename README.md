# FiveM-BanSql

Un ban SQL qui ne surcharge pas la base de donnée.
Il précharge la base de données dans une table lors de l'ouverture du serveur ou à l'ajout/retrait d'un ban.

# Installation
1. Copiez le projet dans votre dossier ressource.
2. Ajoutez "start FiveM-BanSql" dans votre `server.cfg`

# Fonctions
- Commandes
 -ban:add id jours raison (  Permet de ban un joueur connecté 	)
   "id" correspond au chiffre du joueur dans la liste
   "jours" doit être un chiffre pour dire combien de jours il va etre ban. (0 jours veux dire permanent)
   "raison" Possibilité d'inscrire pourquoi il est bani. Attention si il n'y a pas de raison le joueur va voir : "Vous etes banni pour : Aucune raison"
   exemple ban:add 3 1 Troll (Va donner bannir le joueur #3 pour 1 jours avec la raison Troll)
   
 -ban:unban "Nom Steam"
   Déban le joueur correcpondant au nom écrit.
   Exemple ban:unban Alex Garcio (Va enlever de la liste de ban le joueur
  
 -ban:load (   Recharge la BanList et la BanListHistory   )
   Peut etre utilisé si vous modifiez directement dans votre base de données.

 -ban:history option "Nom Steam" (	 Permet d'afficher l'historique de ban d'un joueur hors ligne ou en ligne	)
   "option" 
		0 Pour afficher tout les bans d'un joueur
		1 Pour afficher seulement le premier ban
		2 Pour afficher seulement le deuxième ban
		3 ect......
		4 ect......
   Exemple ban:history 0 Alex Garcio (Va afficher toute la liste des bans du joueur)
   
# Ressource requis
- Async

# A Faire
- Ajouter une config pour les messages texte afin de faciliter la traduction.

# Créer par
- Alex Garcio (https://github.com/RedAlex)
- Alain Proviste https://github.com/EagleOnee