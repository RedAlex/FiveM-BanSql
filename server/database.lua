-- Database Initialization
-- Auto-detect and create tables if they don't exist

function initializeDatabase()
    -- Check and create banlist table
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS banlist (
            license varchar(50) COLLATE utf8mb4_bin PRIMARY KEY,
            steamid varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
            fivemid varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
            liveid varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
            xblid varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
            discord varchar(30) COLLATE utf8mb4_bin DEFAULT NULL,
            playerip varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
            tokens TEXT COLLATE utf8mb4_bin DEFAULT NULL,
            targetplayername varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
            sourceplayername varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
            reason varchar(255) NOT NULL,
            timeat varchar(50) NOT NULL,
            expiration varchar(50) NOT NULL,
            permanent int(1) NOT NULL DEFAULT 0
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin
    ]], {}, function()
        print("^2[FiveM-BanSql] Table 'banlist' initialized^7")
    end)

    -- Check and create banlisthistory table
    MySQL.Async.execute([[ 
        CREATE TABLE IF NOT EXISTS banlisthistory (
            id int(11) AUTO_INCREMENT PRIMARY KEY,
            license varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
            steamid varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
            fivemid varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
            liveid varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
            xblid varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
            discord varchar(30) COLLATE utf8mb4_bin DEFAULT NULL,
            playerip varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
            tokens TEXT COLLATE utf8mb4_bin DEFAULT NULL,
            targetplayername varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
            sourceplayername varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
            reason varchar(255) NOT NULL,
            timeat int(11) NOT NULL,
            added varchar(40) NOT NULL,
            expiration int(11) NOT NULL,
            permanent int(1) NOT NULL DEFAULT 0
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin
    ]], {}, function()
        print("^2[FiveM-BanSql] Table 'banlisthistory' initialized^7")
    end)


    -- Check and create baninfo table
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS baninfo (
            id int(11) AUTO_INCREMENT PRIMARY KEY,
            license varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
            steamid varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
            fivemid varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
            liveid varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
            xblid varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
            discord varchar(30) COLLATE utf8mb4_bin DEFAULT NULL,
            playerip varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
            tokens TEXT COLLATE utf8mb4_bin DEFAULT NULL,
            playername varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
            last_modified_at int(11) NOT NULL DEFAULT 0
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin
    ]], {}, function()
        print("^2[FiveM-BanSql] Table 'baninfo' initialized^7")
    end)
end

-- Migration from (1.0.9 or 1.2.*) to 1.3 function to add token column to existing tables
function migrateDatabase()
    -- Ensure baninfo supports ordering by latest update (run regardless of legacy identifier migration)
    MySQL.Async.fetchAll([[
        SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'baninfo' AND COLUMN_NAME = 'last_modified_at'
    ]], {}, function(lastModifiedResult)
        if not lastModifiedResult or #lastModifiedResult == 0 then
            MySQL.Async.execute([[
                ALTER TABLE baninfo ADD COLUMN last_modified_at int(11) NOT NULL DEFAULT 0
            ]], {}, function()
                print("^2[FiveM-BanSql] ✓ 'last_modified_at' column added to 'baninfo' table^7")

                MySQL.Async.execute([[
                    UPDATE baninfo
                    SET last_modified_at = UNIX_TIMESTAMP()
                    WHERE last_modified_at IS NULL OR last_modified_at <= 0
                ]], {}, function()
                    print("^2[FiveM-BanSql] ✓ 'baninfo.last_modified_at' backfilled for existing rows^7")

                    MySQL.Async.fetchAll([[
                        SELECT INDEX_NAME FROM INFORMATION_SCHEMA.STATISTICS
                        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'baninfo' AND INDEX_NAME = 'idx_baninfo_last_modified_at'
                    ]], {}, function(indexResult)
                        if not indexResult or #indexResult == 0 then
                            MySQL.Async.execute([[
                                ALTER TABLE baninfo ADD INDEX idx_baninfo_last_modified_at (last_modified_at)
                            ]], {}, function()
                                print("^2[FiveM-BanSql] ✓ Index 'idx_baninfo_last_modified_at' added to 'baninfo' table^7")
                            end)
                        end
                    end)
                end)
            end)
        else
            MySQL.Async.execute([[
                UPDATE baninfo
                SET last_modified_at = UNIX_TIMESTAMP()
                WHERE last_modified_at IS NULL OR last_modified_at <= 0
            ]], {}, function()
                print("^2[FiveM-BanSql] ✓ 'baninfo.last_modified_at' backfilled for existing rows^7")

                MySQL.Async.fetchAll([[
                    SELECT INDEX_NAME FROM INFORMATION_SCHEMA.STATISTICS
                    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'baninfo' AND INDEX_NAME = 'idx_baninfo_last_modified_at'
                ]], {}, function(indexResult)
                    if not indexResult or #indexResult == 0 then
                        MySQL.Async.execute([[
                            ALTER TABLE baninfo ADD INDEX idx_baninfo_last_modified_at (last_modified_at)
                        ]], {}, function()
                            print("^2[FiveM-BanSql] ✓ Index 'idx_baninfo_last_modified_at' added to 'baninfo' table^7")
                        end)
                    end
                end)
            end)
        end
    end)

    -- Check if migration is necessary (identifier column exists)
    MySQL.Async.fetchAll([[
        SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'banlist' AND COLUMN_NAME = 'identifier'
    ]], {}, function(result)
        if not result or #result == 0 then
            -- Migration not necessary, identifier column doesn't exist
            return
        end
        
        -- Migration is necessary, proceed with renaming
        print("^3[FiveM-BanSql] Starting migration - identifier column found, beginning rename process...^7")
        
    -- Check and rename identifier to steamid and add identifier for fivem in banlist table
    MySQL.Async.fetchAll([[
        SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'banlist' AND COLUMN_NAME = 'steamid'
    ]], {}, function(result)
        if not result or #result == 0 then
            -- Check if identifier exists (old version)
            MySQL.Async.fetchAll([[
                SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
                WHERE TABLE_NAME = 'banlist' AND COLUMN_NAME = 'identifier'
            ]], {}, function(result2)
                if result2 and #result2 > 0 then
                    -- Rename identifier to steamid
                    MySQL.Async.execute([[
                        ALTER TABLE banlist CHANGE COLUMN identifier steamid varchar(25) COLLATE utf8mb4_bin DEFAULT NULL
                    ]], {}, function()
                        print("^2[FiveM-BanSql] ✓ 'identifier' column renamed to 'steamid' in 'banlist' table^7")
                    end)
                else
                    -- Add steamid column if it doesn't exist
                    MySQL.Async.execute([[
                        ALTER TABLE banlist ADD COLUMN steamid varchar(25) COLLATE utf8mb4_bin DEFAULT NULL
                    ]], {}, function()
                        print("^2[FiveM-BanSql] ✓ 'steamid' column added to 'banlist' table^7")
                    end)
                end
            end)
        end
    end)

    -- Add identifier column for FiveM ID to banlist
    MySQL.Async.fetchAll([[
        SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'banlist' AND COLUMN_NAME = 'fivemid'
    ]], {}, function(result)
        if not result or #result == 0 then
            MySQL.Async.execute([[
                ALTER TABLE banlist ADD COLUMN fivemid varchar(50) COLLATE utf8mb4_bin DEFAULT NULL
            ]], {}, function()
                print("^2[FiveM-BanSql] ✓ 'fivemid' column added to 'banlist' table^7")
            end)
        end
    end)

    -- Check and rename identifier to steamid and add identifier for fivem in banlisthistory table
    MySQL.Async.fetchAll([[
        SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'banlisthistory' AND COLUMN_NAME = 'steamid'
    ]], {}, function(result)
        if not result or #result == 0 then
            MySQL.Async.fetchAll([[
                SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
                WHERE TABLE_NAME = 'banlisthistory' AND COLUMN_NAME = 'identifier'
            ]], {}, function(result2)
                if result2 and #result2 > 0 then
                    MySQL.Async.execute([[
                        ALTER TABLE banlisthistory CHANGE COLUMN identifier steamid varchar(25) COLLATE utf8mb4_bin DEFAULT NULL
                    ]], {}, function()
                        print("^2[FiveM-BanSql] ✓ 'identifier' column renamed to 'steamid' in 'banlisthistory' table^7")
                    end)
                else
                    MySQL.Async.execute([[
                        ALTER TABLE banlisthistory ADD COLUMN steamid varchar(25) COLLATE utf8mb4_bin DEFAULT NULL
                    ]], {}, function()
                        print("^2[FiveM-BanSql] ✓ 'steamid' column added to 'banlisthistory' table^7")
                    end)
                end
            end)
        end
    end)

    -- Add fivemid column to banlisthistory
    MySQL.Async.fetchAll([[
        SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'banlisthistory' AND COLUMN_NAME = 'fivemid'
    ]], {}, function(result)
        if not result or #result == 0 then
            MySQL.Async.execute([[
                ALTER TABLE banlisthistory ADD COLUMN fivemid varchar(50) COLLATE utf8mb4_bin DEFAULT NULL
            ]], {}, function()
                print("^2[FiveM-BanSql] ✓ 'fivemid' column added to 'banlisthistory' table^7")
            end)
        end
    end)

    -- Check and rename identifier to steamid and add identifier for fivem in baninfo table
    MySQL.Async.fetchAll([[
        SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'baninfo' AND COLUMN_NAME = 'steamid'
    ]], {}, function(result)
        if not result or #result == 0 then
            MySQL.Async.fetchAll([[
                SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
                WHERE TABLE_NAME = 'baninfo' AND COLUMN_NAME = 'identifier'
            ]], {}, function(result2)
                if result2 and #result2 > 0 then
                    MySQL.Async.execute([[
                        ALTER TABLE baninfo CHANGE COLUMN identifier steamid varchar(25) COLLATE utf8mb4_bin DEFAULT NULL
                    ]], {}, function()
                        print("^2[FiveM-BanSql] ✓ 'identifier' column renamed to 'steamid' in 'baninfo' table^7")
                    end)
                else
                    MySQL.Async.execute([[
                        ALTER TABLE baninfo ADD COLUMN steamid varchar(25) COLLATE utf8mb4_bin DEFAULT NULL
                    ]], {}, function()
                        print("^2[FiveM-BanSql] ✓ 'steamid' column added to 'baninfo' table^7")
                    end)
                end
            end)
        end
    end)

    -- Add fivemid column to baninfo
    MySQL.Async.fetchAll([[
        SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'baninfo' AND COLUMN_NAME = 'fivemid'
    ]], {}, function(result)
        if not result or #result == 0 then
            MySQL.Async.execute([[
                ALTER TABLE baninfo ADD COLUMN fivemid varchar(50) COLLATE utf8mb4_bin DEFAULT NULL
            ]], {}, function()
                print("^2[FiveM-BanSql] ✓ 'fivemid' column added to 'baninfo' table^7")
            end)
        end
    end)

    -- Check and add tokens column to banlist table
    MySQL.Async.fetchAll([[
        SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'banlist' AND COLUMN_NAME = 'tokens'
    ]], {}, function(result)
        if not result or #result == 0 then
            MySQL.Async.execute([[
                ALTER TABLE banlist ADD COLUMN tokens TEXT COLLATE utf8mb4_bin DEFAULT NULL
            ]], {}, function()
                print("^2[FiveM-BanSql] ✓ 'tokens' column added to 'banlist' table^7")
            end)
        end
    end)

    -- Check and add tokens column to banlisthistory table
    MySQL.Async.fetchAll([[
        SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'banlisthistory' AND COLUMN_NAME = 'tokens'
    ]], {}, function(result)
        if not result or #result == 0 then
            MySQL.Async.execute([[
                ALTER TABLE banlisthistory ADD COLUMN tokens TEXT COLLATE utf8mb4_bin DEFAULT NULL
            ]], {}, function()
                print("^2[FiveM-BanSql] ✓ 'tokens' column added to 'banlisthistory' table^7")
            end)
        end
    end)

    -- Check and add tokens column to baninfo table
    MySQL.Async.fetchAll([[
        SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'baninfo' AND COLUMN_NAME = 'tokens'
    ]], {}, function(result)
        if not result or #result == 0 then
            MySQL.Async.execute([[
                ALTER TABLE baninfo ADD COLUMN tokens TEXT COLLATE utf8mb4_bin DEFAULT NULL
            ]], {}, function()
                print("^2[FiveM-BanSql] ✓ 'tokens' column added to 'baninfo' table^7")
            end)
        end
    end)
    end)
end

-- Initialize database on resource start
CreateThread(function()
    initializeDatabase()
    Wait(1000)
    migrateDatabase()
end)
