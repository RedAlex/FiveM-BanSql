Config                   = {}

--GENERAL
Config.Lang              = 'fr'   	--Set lang (fr-en)
Config.ForceSteam        = true    	--Set to false if you not use steam auth
Config.MultiServerSync   = false   	--This will check if a ban is add in the sql all 30 second, use it only if you have more then 1 server (true-false)
Config.Permission = { 				--Permission need to use FiveM-BanSql commands (mod-admin-superadmin)
	"owner", 
	"admin"
 }


--WEBHOOK
Config.EnableDiscordLink = false --Turn this true if you want link the log to a discord (true-false)
Config.webhookban        = "https://discordapp.com/api/webhooks/473571126690316298/oJZBU9YLz9ksOCG_orlf-wpMZ2pkFedfpEsC34DN_iHO0CBBp6X06W3mMJ2RvMMK7vIO"
Config.webhookunban      = "https://discordapp.com/api/webhooks/473571126690316298/oJZBU9YLz9ksOCG_orlf-wpMZ2pkFedfpEsC34DN_iHO0CBBp6X06W3mMJ2RvMMK7vIO"


--LANGUAGE
Config.TextFr = {
	start         = "La BanList et l'historique a ete charger avec succes",
	starterror    = "ERREUR : La BanList ou l'historique n'a pas ete charger nouvelle tentative.",
	frameworkerror= "ERREUR : Aucun framework detecter, veuillez installer es_extended, qbx_core ou qbox_core.",
	banlistloaded = "La BanList a ete charger avec succes.",
	historyloaded = "La BanListHistory a ete charger avec succes.",
	loaderror     = "ERREUR : La BanList n a pas été charger.",
	cmdban        = "/sqlban (ID) (Durée en jours) (Raison)",
	cmdbanoff     = "/sqlbanoffline (Permid) (Durée en jours) (Raison)",
	cmdhistory    = "/sqlbanhistory (Steam name) ou /sqlbanhistory 1,2,2,4......",
	noreason      = "Raison Inconnue",
	during        = " pendant : ",
	noresult      = "Il n'y a pas autant de résultats !",
	isban         = " a été ban",
	isunban       = " a été déban",
	invalidsteam  =  "Vous devriez ouvrir steam",
	nosteamapikey = "Force Steam est activé, mais le paramètre 'steam_webApiKey' est manquant. BanSql ne pourra pas récupérer les informations Steam. Voir: https://forum.cfx.re/t/using-the-steam-api-key-manually-on-the-server/805987",
	invalidid     = "ID du joueur incorrect",
	invalidname   = "Le nom n'est pas valide",
	invalidtime   = "Duree du ban incorrecte",
	alreadyban    = " étais déja bannie pour : ",
	yourban       = "Vous avez ete ban pour : ",
	yourpermban   = "Vous avez ete ban permanent pour : ",
	youban        = "Vous avez banni : ",
	forr          = " jours. Pour : ",
	permban       = " de facon permanente pour : ",
	timeleft      = ". Il reste : ",
	toomanyresult = "Trop de résultats, veillez être plus précis.",
	day           = " Jours ",
	hour          = " Heures ",
	minute        = " Minutes ",
	by            = "par",
	ban           = "Bannir un joueurs qui est en ligne",
	banoff        = "Bannir un joueurs qui est hors ligne",
	bansearch     = "Trouver l'id permanent d'un joueur qui est hors ligne",
	dayhelp       = "Nombre de jours",
	reason        = "Raison du ban",
	permid        = "Trouver l'id permanent avec la commande (sqlsearch)",
	history       = "Affiche tout les bans d'un joueur",
	reload        = "Recharge la BanList et la BanListHistory",
	unban         = "Retirez un ban de la liste",
	steamname     = "(Nom Steam)",
	updateCheckTitle = "FiveM-BanSql - Nouvelle version disponible!",
	updateCurrentVer = "Version actuelle: ",
	updateLatestVer  = "Dernière version: ",
	updateDownload   = "Télécharger: ",
	updateUpToDate   = "[FiveM-BanSql] Version à jour (",
	updateError      = "[FiveM-BanSql] Impossible de vérifier les mises à jour (Code: ",
}


Config.TextEn = {
	start         = "BanList and BanListHistory loaded successfully.",
	starterror    = "ERROR: BanList and BanListHistory failed to load, please retry.",
	frameworkerror= "ERROR: No framework detected, please install es_extended, qbx_core or qbox_core.",
	banlistloaded = "BanList loaded successfully.",
	historyloaded = "BanListHistory loaded successfully.",
	loaderror     = "ERROR: The BanList failed to load.",
	cmdban        = "/sqlban (ID) (Duration in days) (Ban reason)",
	cmdbanoff     = "/sqlbanoffline (Permid) (Duration in days) (Steam name)",
	cmdhistory    = "/sqlbanhistory (Steam name) or /sqlbanhistory 1,2,2,4......",
	forcontinu    = " days. To continue, execute /sqlreason [reason]",
	noreason      = "No reason provided.",
	during        = " during: ",
	noresult      = "No results found.",
	isban         = " was banned",
	isunban       = " was unbanned",
	invalidsteam  = "Steam is required to join this server.",
	nosteamapikey = "Force Steam is enabled but 'steam_webApiKey' is missing. BanSql cannot retrieve Steam data. See: https://forum.cfx.re/t/using-the-steam-api-key-manually-on-the-server/805987",
	invalidid     = "Player ID not found",
	invalidname   = "The specified name is not valid",
	invalidtime   = "Invalid ban duration",
	alreadyban    = " was already banned for : ",
	yourban       = "You have been banned for: ",
	yourpermban   = "You have been permanently banned for: ",
	youban        = "You are banned from this server for: ",
	forr          = " days. For: ",
	permban       = " permanently for: ",
	timeleft      = ". Time remaining: ",
	toomanyresult = "Too many results, be more specific to shorten the results.",
	day           = " days ",
	hour          = " hours ",
	minute        = " minutes ",
	by            = "by",
	ban           = "Ban a player",
	banoff        = "Ban an offline player",
	dayhelp       = "Duration (days) of ban",
	reason        = "Reason for ban",
	history       = "Shows all previous bans for a certain player",
	reload        = "Refreshes the ban list and history.",
	unban         = "Unban a player.",
	steamname     = "Steam name",
	updateCheckTitle = "FiveM-BanSql - New version available!",
	updateCurrentVer = "Current version: ",
	updateLatestVer  = "Latest version: ",
	updateDownload   = "Download: ",
	updateUpToDate   = "[FiveM-BanSql] Version up to date (",
	updateError      = "[FiveM-BanSql] Unable to check for updates (Code: ",
}
