# FiveM-BanSql

An SQL ban system that preloads data on server start and keeps bans in memory for fast checks.

## Requirements
- mysql-async or oxmysql
- One framework: es_extended, qbx_core, or qbox_core

## Installation
1. Download the .zip from this repository.
2. Extract it with your favorite program.
3. Copy the resource to your resources folder.
4. Add `ensure FiveM-BanSql-1.2.0` to your `server.cfg`.
5. Configure options in `config.lua` (language, permissions, webhook, ForceSteam).

## Commands

### Console (RCON)
- `ban <id> <days> <reason>`: Ban an online player.
- `banoffline <permid> <days> <reason>`: Ban an offline player by permid.
- `search <name>`: Find permid by player name.
- `unban <steam name>`: Unban a player by name.
- `banhistory <steam name|index>`: Show ban history by name or index.
- `banreload`: Reload BanList and BanListHistory.

### In-game (ESX/QBX/QBOX)
- `sqlban <id> <days> <reason>`: Ban an online player.
- `sqlbanoffline <permid> <days> <reason>`: Ban an offline player by permid.
- `sqlsearch <name>`: Find permid by player name.
- `sqlunban <steam name>`: Unban a player by name.
- `sqlbanhistory <steam name|index>`: Show ban history by name or index.
- `sqlbanreload`: Reload BanList and BanListHistory.

### Notes
- `days` set to `0` means permanent.
- `permid` can be found with `sqlsearch`.
- If a player has connected since the last server restart, you do not need `sqlbanoffline` to ban them.

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
- Un framework: es_extended, qbx_core, ou qbox_core

## Installation
1. Telechargez le .zip depuis ce depot.
2. Extrayez-le avec votre programme favori.
3. Copiez la ressource dans votre dossier resources.
4. Ajoutez `ensure FiveM-BanSql-1.2.0` dans votre `server.cfg`.
5. Configurez les options dans `config.lua` (langue, permissions, webhook, ForceSteam).

## Commandes

### Console (RCON)
- `ban <id> <jours> <raison>`: Ban un joueur en ligne.
- `banoffline <permid> <jours> <raison>`: Ban un joueur hors ligne via permid.
- `search <nom>`: Trouver le permid via le nom.
- `unban <nom steam>`: Deban un joueur par nom.
- `banhistory <nom steam|index>`: Historique des bans par nom ou index.
- `banreload`: Recharge BanList et BanListHistory.

### En jeu (ESX/QBX/QBOX)
- `sqlban <id> <jours> <raison>`: Ban un joueur en ligne.
- `sqlbanoffline <permid> <jours> <raison>`: Ban un joueur hors ligne via permid.
- `sqlsearch <nom>`: Trouver le permid via le nom.
- `sqlunban <nom steam>`: Deban un joueur par nom.
- `sqlbanhistory <nom steam|index>`: Historique des bans par nom ou index.
- `sqlbanreload`: Recharge BanList et BanListHistory.

### Notes
- `jours` a `0` signifie permanent.
- `permid` se trouve via `sqlsearch`.
- Si un joueur s'est connecte depuis le dernier redemarrage, `sqlbanoffline` n'est pas necessaire pour le ban.

## Cree par
- Alex Garcio    https://github.com/RedAlex
- Alain Proviste https://github.com/EagleOnee
- Aiko-Suzuki    https://github.com/Aiko-Suzuki
- Zeemahh        https://github.com/Zeemahh
