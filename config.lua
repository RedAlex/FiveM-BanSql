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
Config.DiscordWebhook = '' --Default Discord webhook URL for server notifications: https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_WEBHOOK_TOKEN
Config.AntiCheatScreenshotWebhook = "" -- (Optional) Separate Discord webhook URL for anticheat screenshots. Leave empty to use Config.DiscordWebhook instead
Config.EnableUpdateNotif = true --Send Discord notification when new update is available (true-false)


--ANTICHEAT BRIDGE
Config.AntiCheatScreenshotSaveToFile = true -- Save anticheat screenshots to server files via screenshot-basic (webhook still receives the screenshot when false)
Config.AntiCheatScreenshotFilePrefix = "cache/anticheat" -- Example output: cache/anticheat_12_1700000000_1234.jpg
Config.AntiCheatBridgeUseAllowList = true -- When false, allow any server resource to call anticheat exports
Config.AntiCheatBridgeAllowedResources = { -- Server resources allowed to call anticheat:addBan and anticheat:TakeScreenshot
	"CUSTOMNAME", -- Replace with your anti-cheat resource name if you want to allow it to use the anticheat bridge exports
	"IcarusAdvance", -- 2025 FREE cfx: https://forum.cfx.re/t/free-standalone-icarus-anticheat/4968639 | github: https://github.com/EinS4ckZwiebeln/IcarusAdvancedAnticheat
	"VulcanAC", -- 2025 FREE cfx: https://forum.cfx.re/t/release-free-vulcanac/5184258 | github: https://github.com/Zaps6000/vulcan-ac
	"HUNK-AC", -- 2025 PAID cfx: https://forum.cfx.re/t/hunk-ac-anticheat-anti-eule-n-anti-redengine/4891405 | github: n/a
	"PegasusAC", -- 2025 PAID cfx: https://forum.cfx.re/t/paid-pegasusac-best-fivem-anticheat-2025/5208717 | github: n/a
	"anticheese-anticheat", -- 2024 FREE cfx: https://forum.cfx.re/t/release-anticheese-anticheat/50462 | github: https://github.com/Blumlaut/anticheese-anticheat
	"Badger-Anticheat", -- 2024 FREE cfx: https://forum.cfx.re/t/release-badger-anticheat-actually-works/1422445 | github: https://github.com/JaredScar/Badger-Anticheat
	"WX-AntiCheat", -- 2023 PAID cfx: https://forum.cfx.re/t/paid-wx-anticheat-the-only-anticheat-youll-ever-need/5104748 | github: n/a
	"MX-Shield", -- 2023 PAID cfx: https://forum.cfx.re/t/mx-shield-fivem-anticheat/5011447 | github: n/a
	"CRTX-AntiCheat", -- 2023 PAID cfx: https://forum.cfx.re/t/update-paid-crtx-anticheat-update-3-0-affordable-standalone-anticheat-that-just-works/5136461 | github: n/a
	"Mesterac", -- 2022 PAID cfx: https://forum.cfx.re/t/paid-mesterac/4866822 | github: n/a
	"ZeroTrust-Anticheat", -- 2022 PAID cfx: https://forum.cfx.re/t/paid-standalone-zerotrust-anticheat/4836625 | github: n/a
	"Pigi-Anticheat", -- 2022 PAID cfx: https://forum.cfx.re/t/paid-pigi-anticheat/4829093 | github: n/a
	"Versus-Anticheat", -- 2021 PAID cfx: https://forum.cfx.re/t/paid-versus-anticheat-standalone-esx-protect-your-server-now/4792418 | github: n/a
	"gvz-anticheat", -- 2021 FREE [REMOVED] cfx: https://forum.cfx.re/t/free-gvz-anticheat-1-1/2661776 | github: n/a
	"AppleCheat", -- 2019 FREE [DISCONTINUED] cfx: https://forum.cfx.re/t/applecheat-anti-cheat-v1-2-discontinued/795366 | github: n/a
	"PrettyPacketAC", -- n/a cfx: https://forum.cfx.re/t/prettypacketac-anticheat-resource-to-secure-your-server/5331192 | github: n/a
	"AceGuard", -- 2023 PAID cfx: https://forum.cfx.re/t/paid-aceguard-advanced-fivem-anticheat-solution-beta-release/5164321 | github: n/a
	"JP-AntiCheat", -- n/a cfx: https://forum.cfx.re/t/jp-anticheat-esx/3498352 | github: n/a
	"Greeks-AntiCheat", -- n/a PAID cfx: https://forum.cfx.re/t/release-esx-greek-s-anticheat-v2/3044306 | github: n/a
	"Triggerlimiter" -- n/a cfx: https://forum.cfx.re/t/security-free-triggerlimiter/4773086 | github: https://github.com/Kattrigerkatta/triggerlimiter/tree/main
}


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
	updateAvailable  = "🚀 Nouvelle mise à jour disponible!",
	anticheatBridgeNoInvoker = "appelant manquant",
	anticheatBridgeUnauthorized = "appelant non autorise",
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
	updateAvailable  = "🚀 New update available!",
	anticheatBridgeNoInvoker = "missing invoker",
	anticheatBridgeUnauthorized = "unauthorized invoker",
}
