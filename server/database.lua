-- Database Initialization
-- Auto-detect and create tables if they don't exist

function initializeDatabase()
    -- Check and create banlist table
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS banlist (
            license varchar(50) COLLATE utf8mb4_bin PRIMARY KEY,
            identifier varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
            liveid varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
            xblid varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
            discord varchar(30) COLLATE utf8mb4_bin DEFAULT NULL,
            playerip varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
            token varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
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
            identifier varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
            liveid varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
            xblid varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
            discord varchar(30) COLLATE utf8mb4_bin DEFAULT NULL,
            playerip varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
            token varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
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
            identifier varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
            liveid varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
            xblid varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
            discord varchar(30) COLLATE utf8mb4_bin DEFAULT NULL,
            playerip varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
            token varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
            playername varchar(32) COLLATE utf8mb4_bin DEFAULT NULL
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin
    ]], {}, function()
        print("^2[FiveM-BanSql] Table 'baninfo' initialized^7")
    end)
end

-- Migration from 1.0.9 to 1.2 function to add token column to existing tables
function migrateDatabase()
    -- Check and add token column to banlist table
    MySQL.Async.fetchAll([[
        SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'banlist' AND COLUMN_NAME = 'token'
    ]], {}, function(result)
        if not result or #result == 0 then
            MySQL.Async.execute([[
                ALTER TABLE banlist ADD COLUMN token varchar(255) COLLATE utf8mb4_bin DEFAULT NULL
            ]], {}, function()
                print("^2[FiveM-BanSql] ✓ Token column added to 'banlist' table^7")
            end)
        end
    end)

    -- Check and add token column to banlisthistory table
    MySQL.Async.fetchAll([[
        SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'banlisthistory' AND COLUMN_NAME = 'token'
    ]], {}, function(result)
        if not result or #result == 0 then
            MySQL.Async.execute([[
                ALTER TABLE banlisthistory ADD COLUMN token varchar(255) COLLATE utf8mb4_bin DEFAULT NULL
            ]], {}, function()
                print("^2[FiveM-BanSql] ✓ Token column added to 'banlisthistory' table^7")
            end)
        end
    end)

    -- Check and add token column to baninfo table
    MySQL.Async.fetchAll([[
        SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'baninfo' AND COLUMN_NAME = 'token'
    ]], {}, function(result)
        if not result or #result == 0 then
            MySQL.Async.execute([[
                ALTER TABLE baninfo ADD COLUMN token varchar(255) COLLATE utf8mb4_bin DEFAULT NULL
            ]], {}, function()
                print("^2[FiveM-BanSql] ✓ Token column added to 'baninfo' table^7")
            end)
        end
    end)
end

-- Initialize database on resource start
CreateThread(function()
    initializeDatabase()
    Wait(1000)
    migrateDatabase()
end)
