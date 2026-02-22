Locales['en'] = {
	-- Startup messages
	start = "BanList and BanListHistory loaded successfully.",
	starterror = "ERROR: BanList and BanListHistory failed to load, please retry.",
	frameworkerror = "ERROR: No framework detected, please install es_extended, qbx_core or qbox_core.",
	banlistloaded = "BanList loaded successfully.",
	historyloaded = "BanListHistory loaded successfully.",
	loaderror = "ERROR: The BanList failed to load.",
	
	-- Command help messages
	cmdban = "/sqlban (ID) (Duration in days) (Ban reason)",
	cmdhistory = "/sqlbanhistory (Steam name) or /sqlbanhistory 1,2,2,4......",
	forcontinu = " days. To continue, execute /sqlreason [reason]",
	
	-- General messages
	noreason = "No reason provided.",
	during = " during: ",
	noresult = "No results found.",
	isban = " was banned",
	isunban = " was unbanned",
	invalidsteam = "Steam is required to join this server.",
	nosteamapikey = "Force Steam is enabled but 'steam_webApiKey' is missing. BanSql cannot retrieve Steam data. See: https://forum.cfx.re/t/using-the-steam-api-key-manually-on-the-server/805987",
	invalidid = "Player ID not found",
	invalidname = "The specified name is not valid",
	invalidtime = "Invalid ban duration",
	alreadyban = " was already banned for : ",
	yourban = "You have been banned for: ",
	yourpermban = "You have been permanently banned for: ",
	youban = "You are banned from this server for: ",
	forr = " days. For: ",
	permban = " permanently for: ",
	timeleft = ". Time remaining: ",
	toomanyresult = "Too many results, be more specific to shorten the results.",
	
	-- Time units
	day = " days ",
	hour = " hours ",
	minute = " minutes ",
	
	-- Other
	by = "by",
	
	-- Command descriptions
	ban = "Ban a player",
	playeridhelp = "Player ID",
	dayhelp = "Duration (days) of ban",
	reason = "Reason for ban",
	history = "Shows all previous bans for a certain player",
	reload = "Refreshes the ban list and history.",
	unban = "Unban a player.",
	steamname = "Steam name",
	
	-- Update messages
	updateCheckTitle = "FiveM-BanSql - New version available!",
	updateCurrentVer = "Current version: ",
	updateLatestVer = "Latest version: ",
	updateDownload = "Download: ",
	updateUpToDate = "[FiveM-BanSql] Version up to date (",
	updateError = "[FiveM-BanSql] Unable to check for updates (Code: ",
	updateAvailable = "🚀 New update available!",
	
	-- Anticheat bridge messages
	anticheatBridgeNoInvoker = "missing invoker",
	anticheatBridgeUnauthorized = "unauthorized invoker",

	-- UI messages
	ui_title = "BanSql Admin",
	ui_search_title = "Search player",
	ui_search_placeholder = "Player name...",
	ui_search_button = "Search",
	ui_searching = "Searching...",
	ui_results_title = "Results",
	ui_ban_title = "Offline ban",
	ui_reason_label = "Reason",
	ui_ban_button = "Ban Offline",
	ui_banning = "Sending ban...",
	ui_ban_sent = "Ban request sent.",
	ui_close_button = "Close",
	ui_invalid_session = "Invalid UI session, run the command again.",
}
