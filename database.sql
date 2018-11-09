CREATE TABLE IF NOT EXISTS banlist (
  identifier varchar(50) COLLATE utf8mb4_bin PRIMARY KEY,
  license varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  playerip varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  targetplayername varchar(32) COLLATE utf8mb4_bin NOT NULL,
  sourceplayername varchar(32) COLLATE utf8mb4_bin NOT NULL,
  reason varchar(255) NOT NULL,
  timeat varchar(50) NOT NULL,
  added datetime DEFAULT CURRENT_TIMESTAMP,
  expiration varchar(50) NOT NULL,
  permanent int(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS banlisthistory (
  id int(11) AUTO_INCREMENT PRIMARY KEY,
  identifier varchar(50) NOT NULL,
  license varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  playerip varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  targetplayername varchar(32) COLLATE utf8mb4_bin NOT NULL,
  sourceplayername varchar(32) COLLATE utf8mb4_bin NOT NULL,
  reason varchar(255) NOT NULL,
  timeat int(11) NOT NULL,
  added datetime DEFAULT CURRENT_TIMESTAMP,
  expiration int(11) NOT NULL,
  permanent int(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
