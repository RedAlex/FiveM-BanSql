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

-- Initialize database on resource start
initializeDatabase()
