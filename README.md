
# FiveM-BanSql

An SQL ban that does not overload the database.
It precharges the database in a table when opening the server or adding / removing a ban.

# Installation
1. Copy the project to your resource folder.
2. Add "start FiveM-BanSql" in your `server.cfg`

# Commands
___
1. ** ban: add id days reason ** (Allows ban a connected player)
 - "id" is the player's number in the list
 - "days" must be a number to say how many days it will be ban. (0 days mean permanent)
 - "reason" Ability to register why he is banished. Attention if there is no reason the player will see: "You are banned for: No reason"
 - ban example: add 3 1 Troll (Will give ban player # 3 for 1 days with Troll reason)
___
2. ** ban: unban "Steam Name" **
 - Deban the player matching the written name.
 - Example ban: unban Alex Garcio (Will remove from the ban list the player
___
3. ** ban: load ** (reload the BanList and the BanListHistory)
  - Can be used if you edit directly in your database.
___
4. ** ban: history option "Steam Name" ** (Allows you to view the ban history of a player offline or online)
- "option"
- 0 To display all the banns of a player
- 1 To display only the first ban
- 2 To display only the second ban
- 3 ect ......
- 4 ect ......
- Example ban: history 0 Alex Garcio (Go to display all the list of player's bans)
   
# Required resource
- Async

# To do
- Add a config for text messages to facilitate translation.

# Created by
- Alex Garcio (https://github.com/RedAlex)
- Alain Proviste https://github.com/EagleOnee


___
# FiveM-BanSql

Un ban SQL qui ne surcharge pas la base de donnée.
Il précharge la base de données dans une table lors de l'ouverture du serveur ou à l'ajout/retrait d'un ban.

# Installation
1. Copiez le projet dans votre dossier ressource.
2. Ajoutez "start FiveM-BanSql" dans votre `server.cfg`

# Commandes
___
1. **ban:add id jours raison** (  Permet de ban un joueur connecté 	)
 -  "id" correspond au chiffre du joueur dans la liste
 -  "jours" doit être un chiffre pour dire combien de jours il va etre ban. (0 jours veux dire permanent)
 -  "raison" Possibilité d'inscrire pourquoi il est bani. Attention si il n'y a pas de raison le joueur va voir : "Vous etes banni pour : Aucune raison"
 -  exemple ban:add 3 1 Troll (Va donner bannir le joueur #3 pour 1 jours avec la raison Troll)
___
2. **ban:unban "Nom Steam"**
 - Déban le joueur correcpondant au nom écrit.
 - Exemple ban:unban Alex Garcio (Va enlever de la liste de ban le joueur)
___
3. **ban:load** (   Recharge la BanList et la BanListHistory   )
  - Peut etre utilisé si vous modifiez directement dans votre base de données.
___
4. **ban:history option "Nom Steam"** (	 Permet d'afficher l'historique de ban d'un joueur hors ligne ou en ligne	)
-   "option" 
-		0 Pour afficher tout les bans d'un joueur
-		1 Pour afficher seulement le premier ban
-		2 Pour afficher seulement le deuxième ban
-		3 ect......
-		4 ect......
-   Exemple ban:history 0 Alex Garcio (Va afficher toute la liste des bans du joueur)
   
# Ressource requis
- Async

# A Faire
- Ajouter une config pour les messages texte afin de faciliter la traduction.

# Créer par
- Alex Garcio (https://github.com/RedAlex)
- Alain Proviste https://github.com/EagleOnee
