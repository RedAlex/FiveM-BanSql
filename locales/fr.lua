Locales['fr'] = {
	-- Startup messages
	start = "La BanList et l'historique a ete charger avec succes",
	starterror = "ERREUR : La BanList ou l'historique n'a pas ete charger nouvelle tentative.",
	frameworkerror = "ERREUR : Aucun framework detecter, veuillez installer es_extended, qbx_core ou qbox_core.",
	banlistloaded = "La BanList a ete charger avec succes.",
	historyloaded = "La BanListHistory a ete charger avec succes.",
	loaderror = "ERREUR : La BanList n a pas été charger.",
	
	-- Command help messages
	cmdban = "/sqlban (ID) (Durée en jours) (Raison)",
	cmdhistory = "/sqlbanhistory (Steam name) ou /sqlbanhistory 1,2,2,4......",
	
	-- General messages
	noreason = "Raison Inconnue",
	during = " pendant : ",
	noresult = "Il n'y a pas autant de résultats !",
	isban = " a été ban",
	isunban = " a été déban",
	invalidsteam = "Vous devriez ouvrir steam",
	nosteamapikey = "Force Steam est activé, mais le paramètre 'steam_webApiKey' est manquant. BanSql ne pourra pas récupérer les informations Steam. Voir: https://forum.cfx.re/t/using-the-steam-api-key-manually-on-the-server/805987",
	invalidid = "ID du joueur incorrect",
	invalidname = "Le nom n'est pas valide",
	invalidtime = "Duree du ban incorrecte",
	alreadyban = " étais déja bannie pour : ",
	yourban = "Vous avez ete ban pour : ",
	yourpermban = "Vous avez ete ban permanent pour : ",
	youban = "Vous avez banni : ",
	forr = " jours. Pour : ",
	permban = " de facon permanente pour : ",
	timeleft = ". Il reste : ",
	toomanyresult = "Trop de résultats, veillez être plus précis.",
	
	-- Time units
	day = " Jours ",
	hour = " Heures ",
	minute = " Minutes ",
	
	-- Other
	by = "par",
	
	-- Command descriptions
	ban = "Bannir un joueurs qui est en ligne",
	playeridhelp = "ID du joueur",
	dayhelp = "Nombre de jours",
	reason = "Raison du ban",
	history = "Affiche tout les bans d'un joueur",
	reload = "Recharge la BanList et la BanListHistory",
	unban = "Retirez un ban de la liste",
	steamname = "(Nom Steam)",
	
	-- Update messages
	updateCheckTitle = "FiveM-BanSql - Nouvelle version disponible!",
	updateCurrentVer = "Version actuelle: ",
	updateLatestVer = "Dernière version: ",
	updateDownload = "Télécharger: ",
	updateUpToDate = "[FiveM-BanSql] Version à jour (",
	updateError = "[FiveM-BanSql] Impossible de vérifier les mises à jour (Code: ",
	updateAvailable = "🚀 Nouvelle mise à jour disponible!",
	
	-- Anticheat bridge messages
	anticheatBridgeNoInvoker = "appelant manquant",
	anticheatBridgeUnauthorized = "appelant non autorise",

	-- UI messages
	ui_title = "BanSql Admin",
	ui_search_title = "Rechercher un joueur",
	ui_search_placeholder = "Nom du joueur...",
	ui_search_button = "Rechercher",
	ui_searching = "Recherche en cours...",
	ui_results_title = "Resultats",
	ui_ban_title = "Ban hors ligne",
	ui_reason_label = "Raison",
	ui_ban_button = "Ban Offline",
	ui_banning = "Ban en cours...",
	ui_ban_sent = "Demande de ban envoyee.",
	ui_close_button = "Fermer",
	ui_invalid_session = "Session UI invalide, relancez la commande.",
}
