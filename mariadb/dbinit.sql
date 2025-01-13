/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for sinkingsql
CREATE DATABASE IF NOT EXISTS `sinkingsql` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci */;
USE `sinkingsql`;

-- Dumping structure for table sinkingsql.ships
CREATE TABLE IF NOT EXISTS `ships` (
  `ship_id` varchar(63) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL COMMENT 'Should have alphanumeric characters only',
  `ship_name` varchar(4095) NOT NULL DEFAULT '0',
  `tonnage` mediumint(8) unsigned NOT NULL,
  `cargo_type` varchar(4095) NOT NULL,
  `scheduled_arrival` datetime NOT NULL DEFAULT (current_timestamp() + interval 28 day),
  `arrived` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `arrival_datetime` datetime NOT NULL DEFAULT (current_timestamp() + interval 28 day),
  `arrival_port` tinytext CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT 'Tuas',
  PRIMARY KEY (`ship_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='Table of ships that have arranged to call at Singaporean ports';

-- Dumping data for table sinkingsql.ships: ~2 rows (approximately)
INSERT INTO `ships` (`ship_id`, `ship_name`, `tonnage`, `cargo_type`, `scheduled_arrival`, `arrived`, `arrival_datetime`, `arrival_port`) VALUES
	('a1', 'Ship 1', 1000, 'Clothing', '2025-01-14 16:02:39', 0, '2025-01-14 16:02:39', 'Tuas'),
	('b2', 'Ship 2', 2000, 'Food import', '2025-01-14 16:04:13', 0, '2025-01-14 16:04:13', 'Tuas'),
	('c3', 'Ship 3', 3000, 'Radio transmitter (restricted)', '2025-01-14 16:09:37', 0, '2025-01-14 16:09:37', 'Tuas');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
