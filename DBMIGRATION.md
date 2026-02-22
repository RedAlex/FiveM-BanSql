# Database Migration (1.3.0)

## ✅ No action is required

Migration is **automatic** when the `bansql` resource starts.
No manual SQL query is required to upgrade to `1.3.0`.

## What the migration does automatically

On startup, the script checks and applies the following:

1. Check/add the `baninfo.last_modified_at` column.
2. Backfill old rows (`last_modified_at <= 0`) with `UNIX_TIMESTAMP()`.
3. Check/add the `idx_baninfo_last_modified_at` index.
4. Run legacy migration logic (if needed) for older versions:
   - `identifier` -> `steamid`
   - add `fivemid`
   - add `tokens`

## Validated scenarios

### Migration `1.0.9` -> `1.3.0`

Expected and validated result:
- `baninfo.last_modified_at` is added.
- Existing rows are updated (backfill).
- `idx_baninfo_last_modified_at` is added.
- Legacy columns are migrated on `banlist`, `banlisthistory`, `baninfo` (`identifier/steamid`, `fivemid`, `tokens`).

### Migration `1.2.*` -> `1.3.0`

Expected and validated result:
- `baninfo.last_modified_at` is added if missing.
- Existing rows are updated (backfill).
- `idx_baninfo_last_modified_at` is added.
- Legacy migration is skipped when `banlist.identifier` no longer exists (expected behavior).

## Why this migration matters

The admin UI can display players by **last update** in descending order with:

```sql
ORDER BY last_modified_at DESC, id DESC
```

This ensures consistent display of the most recently updated players.

## Quick verification (optional)

If you want to verify manually after restart:

```sql
SHOW COLUMNS FROM baninfo LIKE 'last_modified_at';
SHOW INDEX FROM baninfo WHERE Key_name = 'idx_baninfo_last_modified_at';
```

If both exist, migration has been applied successfully.

---

# Migration base de données (1.3.0)

## ✅ Aucune intervention n'est nécessaire

La migration est **automatique** au démarrage de la ressource `bansql`.
Aucune requête SQL manuelle n’est requise pour passer en `1.3.0`.

## Ce que fait la migration automatiquement

Au lancement, le script vérifie et applique les changements suivants:

1. Vérification/ajout de la colonne `baninfo.last_modified_at`.
2. Backfill des anciennes lignes (`last_modified_at <= 0`) avec `UNIX_TIMESTAMP()`.
3. Vérification/ajout de l’index `idx_baninfo_last_modified_at`.
4. Exécution de la migration legacy (si nécessaire) pour les anciennes versions:
   - `identifier` -> `steamid`
   - ajout de `fivemid`
   - ajout de `tokens`

## Scénarios validés

### Migration `1.0.9` -> `1.3.0`

Résultat attendu et validé:
- `baninfo.last_modified_at` est ajouté.
- Les lignes existantes sont mises à jour (backfill).
- L’index `idx_baninfo_last_modified_at` est ajouté.
- Les colonnes legacy sont migrées sur `banlist`, `banlisthistory`, `baninfo` (`identifier/steamid`, `fivemid`, `tokens`).

### Migration `1.2.1` -> `1.3.0`

Résultat attendu et validé:
- `baninfo.last_modified_at` est ajouté si absent.
- Les lignes existantes sont mises à jour (backfill).
- L’index `idx_baninfo_last_modified_at` est ajouté.
- La migration legacy est ignorée si `banlist.identifier` n’existe plus (comportement normal).

## Pourquoi cette migration est importante

L’interface admin peut afficher les joueurs par **dernière mise à jour** en ordre décroissant grâce à:

```sql
ORDER BY last_modified_at DESC, id DESC
```

Cela garantit un affichage cohérent des joueurs récents dans l’UI.

## Vérification rapide (optionnelle)

Si vous voulez confirmer manuellement après redémarrage:

```sql
SHOW COLUMNS FROM baninfo LIKE 'last_modified_at';
SHOW INDEX FROM baninfo WHERE Key_name = 'idx_baninfo_last_modified_at';
```

Si les deux existent, la migration est bien appliquée.
