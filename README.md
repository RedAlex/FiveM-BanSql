# FiveM-BanSql

An SQL ban system that preloads data on server start and keeps bans in memory for fast checks.

## Requirements
- mysql-async or oxmysql
- One framework: es_extended, qbx_core, or qbox_core

## Installation
1. Download the .zip from this repository.
2. Extract it with your favorite program.
3. Copy the resource to your resources folder.
4. Rename Folder to `bansql`
5. Add `ensure bansql` to your `server.cfg`.
6. Configure options in `config.lua` (language, permissions, webhook, ForceSteam).

## AntiCheat Bridge
- Allowlist control: `Config.AntiCheatBridgeUseAllowList` (true = enforce allowlist, false = allow any server resource).
- Allowlist entries: `Config.AntiCheatBridgeAllowedResources`.
- Screenshots: `Config.AntiCheatScreenshotSaveToFile` only controls file saving; the webhook still receives the screenshot when false.

### Exports (for anticheat resources)
Add your anticheat resource name to `Config.AntiCheatBridgeAllowedResources` (or disable allowlist).

Server-side usage:
```
exports["bansql"]:addBan(playerId, "Cheating")
exports["bansql"]:takeScreenshot(playerId)
```

## Update Check
- The update checker prints the latest release changelog to the console when a newer version is found.
- The Discord webhook notification also includes the changelog (truncated).

## Commands

### Console (RCON)
- `ban <id> <days> <reason>`: Ban an online player.
- `unban <steam name>`: Unban a player by name.
- `banhistory <steam name|index>`: Show ban history by name or index.
- `banreload`: Reload BanList and BanListHistory.

### In-game (ESX/QBX/QBOX)
- `sqlbanmenu`: Open the BanSql admin UI (search/recent/history/ban flow).
- `sqlban <id> <days> <reason>`: Ban an online player.
- `sqlunban <steam name>`: Unban a player by name.
- `sqlbanhistory <steam name|index>`: Show ban history by name or index.
- `sqlbanreload`: Reload BanList and BanListHistory.

### Notes
- `days` set to `0` means permanent.

## Created by
- Alex Garcio    https://github.com/RedAlex
- Alain Proviste https://github.com/EagleOnee
- Aiko-Suzuki    https://github.com/Aiko-Suzuki
- Zeemahh        https://github.com/Zeemahh

---

# FiveM-BanSql

Un systeme de ban SQL qui precharge les donnees au demarrage et garde les bans en memoire pour des verifications rapides.

## Prerequis
- mysql-async ou oxmysql
- Un framework : es_extended, qbx_core, ou qbox_core

## Installation
1. Telechargez le .zip depuis ce depot.
2. Extrayez-le avec votre programme favori.
3. Copiez la ressource dans votre dossier resources.
4. Renommez le dossier en `bansql`.
5. Ajoutez `ensure bansql` dans votre `server.cfg`.
6. Configurez les options dans `config.lua` (langue, permissions, webhook, ForceSteam).

## AntiCheat Bridge
- Controle de la whitelist : `Config.AntiCheatBridgeUseAllowList` (true = applique la liste, false = autorise toute ressource serveur).
- Liste autorisee : `Config.AntiCheatBridgeAllowedResources`.
- Captures d'ecran : `Config.AntiCheatScreenshotSaveToFile` ne gere que la sauvegarde fichier ; le webhook recoit quand meme la capture si false.

### Exports (pour les ressources anticheat)
Ajoutez le nom de votre ressource anticheat dans `Config.AntiCheatBridgeAllowedResources` (ou desactivez la whitelist).

Utilisation cote serveur :
```
exports["bansql"]:addBan(playerId, "Cheating")
exports["bansql"]:takeScreenshot(playerId)
```

## Verification des mises a jour
- Le check d'update affiche le changelog de la derniere release en console quand une version plus recente est detectee.
- La notification Discord inclut aussi le changelog (tronque).

## Commandes

### Console (RCON)
- `ban <id> <jours> <raison>`: Ban un joueur en ligne.
- `unban <nom steam>`: Deban un joueur par nom.
- `banhistory <nom steam|index>`: Historique des bans par nom ou index.
- `banreload`: Recharge BanList et BanListHistory.

### En jeu (ESX/QBX/QBOX)
- `sqlbanmenu`: Ouvre l'UI admin BanSql (recherche/derniers connectes/historique/ban).
- `sqlban <id> <jours> <raison>`: Ban un joueur en ligne.
- `sqlunban <nom steam>`: Deban un joueur par nom.
- `sqlbanhistory <nom steam|index>`: Historique des bans par nom ou index.
- `sqlbanreload`: Recharge BanList et BanListHistory.

### Notes
- `jours` a `0` signifie permanent.

## Cree par
- Alex Garcio    https://github.com/RedAlex
- Alain Proviste https://github.com/EagleOnee
- Aiko-Suzuki    https://github.com/Aiko-Suzuki
- Zeemahh        https://github.com/Zeemahh
