-- CREATE USER evaluator@'localhost' IDENTIFIED BY ?sqlevalpass;
CREATE DATABASE IF NOT EXISTS `sinkingsql`; --!40100 COLLATE 'utf8mb4_uca1400_ai_ci' 
USE `sinkingsql`;
CREATE TABLE IF NOT EXISTS `ships` (
  `ship_id` varchar(767) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL 
  COMMENT 'Removed ascii restriction to investigate attempted injection effect',
  `ship_name` varchar(4095) NOT NULL DEFAULT '0',
  `tonnage` mediumint(8) unsigned NOT NULL,
  `cargo_type` varchar(4095) NOT NULL,
  `scheduled_arrival` datetime NOT NULL DEFAULT (current_timestamp() + interval 28 day),
  `arrived` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `arrival_datetime` datetime NOT NULL DEFAULT (current_timestamp() + interval 28 day),
  `arrival_port` tinytext CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT 'Tuas',
  PRIMARY KEY (`ship_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='Table of ships that have arranged to call at Singaporean ports';
GRANT INSERT ON sinkingsql.ships TO 'evaluator'@'localhost';
GRANT SELECT on *.* to 'evaluator'@'localhost';
GRANT DELETE ON sinkingsql.ships TO 'evaluator'@'localhost';
INSERT INTO sinkingsql.ships VALUES('C4', 'Injection Canary', 0, 'Alert', '9999-12-31T23:59:58', 0, '9999-12-31T23:59:58', 'Danger City');

DELIMITER !
CREATE PROCEDURE insert_dangerous_ship_id (ship_id varchar(767) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci) 
MODIFIES SQL DATA SQL SECURITY INVOKER 
BEGIN
  INSERT INTO sinkingsql.ships (ship_id, ship_name, tonnage, cargo_type, scheduled_arrival, arrived, arrival_datetime) 
  VALUES(ship_id, 'Potentially dangerous', 420, 
    'Non-alphanumeric ship ID potentially used for SQL injection', '9999-12-31T23:59:59', 1, '9999-12-31T23:59:59'
  );
END;!
CREATE PROCEDURE delete_dangerous_ship_id (ship_id_to_delete varchar(767) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci)
MODIFIES SQL DATA SQL SECURITY INVOKER
BEGIN
  DELETE FROM sinkingsql.ships WHERE ship_id = ship_id_to_delete;
END;!
DELIMITER ;
GRANT EXECUTE ON PROCEDURE insert_dangerous_ship_id TO 'evaluator'@'localhost';
GRANT EXECUTE ON PROCEDURE delete_dangerous_ship_id TO 'evaluator'@'localhost';