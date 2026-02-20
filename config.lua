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
