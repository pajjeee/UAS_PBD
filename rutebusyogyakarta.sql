-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 23, 2024 at 11:14 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rutebusyogyakarta`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `fetch_all_buses` ()   BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE bus_row VARCHAR(255);
    DECLARE cur CURSOR FOR SELECT CONCAT('BusID: ', BusID, ', NamaBus: ', NamaBus, ', Kapasitas: ', Kapasitas) FROM Bus;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    fetch_loop: LOOP
        FETCH cur INTO bus_row;
        IF done THEN
            LEAVE fetch_loop;
        END IF;
        SELECT bus_row;
    END LOOP;

    CLOSE cur;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fetch_buses_by_capacity` (IN `min_capacity` INT, IN `max_capacity` INT)   BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE bus_row VARCHAR(255);
    DECLARE cur CURSOR FOR 
        SELECT CONCAT('BusID: ', BusID, ', NamaBus: ', NamaBus, ', Kapasitas: ', Kapasitas) 
        FROM Bus 
        WHERE Kapasitas BETWEEN min_capacity AND max_capacity;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    fetch_loop: LOOP
        FETCH cur INTO bus_row;
        IF done THEN
            LEAVE fetch_loop;
        END IF;
        SELECT bus_row;
    END LOOP;

    CLOSE cur;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SampleProcedure` ()   BEGIN
    SELECT * FROM Bus;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `fetch_all_buses` () RETURNS TEXT CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE result TEXT DEFAULT '';
    DECLARE bus_row TEXT;
    
    DECLARE done INT DEFAULT FALSE;
    DECLARE cur CURSOR FOR SELECT CONCAT('BusID: ', BusID, ', NamaBus: ', NamaBus, ', Kapasitas: ', Kapasitas) FROM Bus;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    fetch_loop: LOOP
        FETCH cur INTO bus_row;
        IF done THEN
            LEAVE fetch_loop;
        END IF;
        SET result = CONCAT(result, bus_row, '\n');
    END LOOP;
    
    CLOSE cur;
    
    RETURN result;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fetch_buses_by_capacity` (`min_capacity` INT, `max_capacity` INT) RETURNS TEXT CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE result TEXT DEFAULT '';
    DECLARE bus_row TEXT;
    
    DECLARE done INT DEFAULT FALSE;
    DECLARE cur CURSOR FOR 
        SELECT CONCAT('BusID: ', BusID, ', NamaBus: ', NamaBus, ', Kapasitas: ', Kapasitas) 
        FROM Bus WHERE Kapasitas BETWEEN min_capacity AND max_capacity;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    fetch_loop: LOOP
        FETCH cur INTO bus_row;
        IF done THEN
            LEAVE fetch_loop;
        END IF;
        SET result = CONCAT(result, bus_row, '\n');
    END LOOP;
    
    CLOSE cur;
    
    RETURN result;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `bus`
--

CREATE TABLE `bus` (
  `BusID` int(11) NOT NULL,
  `NamaBus` varchar(100) NOT NULL,
  `Kapasitas` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bus`
--

INSERT INTO `bus` (`BusID`, `NamaBus`, `Kapasitas`) VALUES
(1, 'TransJogja G', 45),
(2, 'TransJogja B', 40),
(3, 'TransJogja C', 40),
(4, 'TransJogja D', 40),
(5, 'TransJogja E', 40),
(6, 'TransJogja F', 50),
(7, 'TransJogja F', 50),
(8, 'TransJogja F', 50),
(9, 'TransJogja H', 40),
(10, 'TransJogja F', 45);

--
-- Triggers `bus`
--
DELIMITER $$
CREATE TRIGGER `after_bus_delete` AFTER DELETE ON `bus` FOR EACH ROW BEGIN
    INSERT INTO BusLog (Action, BusID, OldNamaBus, OldKapasitas)
    VALUES ('AFTER DELETE', OLD.BusID, OLD.NamaBus, OLD.Kapasitas);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_bus_insert` AFTER INSERT ON `bus` FOR EACH ROW BEGIN
    INSERT INTO BusLog (Action, BusID, NewNamaBus, NewKapasitas)
    VALUES ('AFTER INSERT', NEW.BusID, NEW.NamaBus, NEW.Kapasitas);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_bus_update` AFTER UPDATE ON `bus` FOR EACH ROW BEGIN
    INSERT INTO BusLog (Action, BusID, OldNamaBus, NewNamaBus, OldKapasitas, NewKapasitas)
    VALUES ('AFTER UPDATE', OLD.BusID, OLD.NamaBus, NEW.NamaBus, OLD.Kapasitas, NEW.Kapasitas);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_bus_delete` BEFORE DELETE ON `bus` FOR EACH ROW BEGIN
    INSERT INTO BusLog (Action, BusID, OldNamaBus, OldKapasitas)
    VALUES ('BEFORE DELETE', OLD.BusID, OLD.NamaBus, OLD.Kapasitas);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_bus_insert` BEFORE INSERT ON `bus` FOR EACH ROW BEGIN
    INSERT INTO BusLog (Action, BusID, NewNamaBus, NewKapasitas)
    VALUES ('BEFORE INSERT', NEW.BusID, NEW.NamaBus, NEW.Kapasitas);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_bus_update` BEFORE UPDATE ON `bus` FOR EACH ROW BEGIN
    INSERT INTO BusLog (Action, BusID, OldNamaBus, NewNamaBus, OldKapasitas, NewKapasitas)
    VALUES ('BEFORE UPDATE', OLD.BusID, OLD.NamaBus, NEW.NamaBus, OLD.Kapasitas, NEW.Kapasitas);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `bushorizontalview`
-- (See below for the actual view)
--
CREATE TABLE `bushorizontalview` (
`BusID` int(11)
,`NamaBus` varchar(100)
,`Kapasitas` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `buslog`
--

CREATE TABLE `buslog` (
  `LogID` int(11) NOT NULL,
  `Action` varchar(50) NOT NULL,
  `BusID` int(11) DEFAULT NULL,
  `OldNamaBus` varchar(100) DEFAULT NULL,
  `NewNamaBus` varchar(100) DEFAULT NULL,
  `OldKapasitas` int(11) DEFAULT NULL,
  `NewKapasitas` int(11) DEFAULT NULL,
  `ActionTime` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `buslog`
--

INSERT INTO `buslog` (`LogID`, `Action`, `BusID`, `OldNamaBus`, `NewNamaBus`, `OldKapasitas`, `NewKapasitas`, `ActionTime`) VALUES
(1, 'BEFORE INSERT', 0, NULL, 'TransJogja F', NULL, 50, '2024-07-23 07:19:04'),
(2, 'AFTER INSERT', 6, NULL, 'TransJogja F', NULL, 50, '2024-07-23 07:19:04'),
(3, 'BEFORE UPDATE', 1, 'TransJogja A', 'TransJogja G', 40, 45, '2024-07-23 07:19:04'),
(4, 'AFTER UPDATE', 1, 'TransJogja A', 'TransJogja G', 40, 45, '2024-07-23 07:19:04'),
(6, 'BEFORE INSERT', 0, NULL, 'TransJogja F', NULL, 50, '2024-07-23 07:19:15'),
(7, 'AFTER INSERT', 7, NULL, 'TransJogja F', NULL, 50, '2024-07-23 07:19:15'),
(8, 'BEFORE INSERT', 0, NULL, 'TransJogja F', NULL, 50, '2024-07-23 07:20:15'),
(9, 'AFTER INSERT', 8, NULL, 'TransJogja F', NULL, 50, '2024-07-23 07:20:15'),
(10, 'BEFORE UPDATE', 1, 'TransJogja G', 'TransJogja G', 45, 45, '2024-07-23 07:20:15'),
(11, 'AFTER UPDATE', 1, 'TransJogja G', 'TransJogja G', 45, 45, '2024-07-23 07:20:15'),
(13, 'BEFORE UPDATE', 1, 'TransJogja G', 'TransJogja G', 45, 45, '2024-07-23 07:20:35'),
(14, 'AFTER UPDATE', 1, 'TransJogja G', 'TransJogja G', 45, 45, '2024-07-23 07:20:35'),
(16, 'BEFORE UPDATE', 1, 'TransJogja G', 'TransJogja G', 45, 45, '2024-07-23 07:20:56'),
(17, 'AFTER UPDATE', 1, 'TransJogja G', 'TransJogja G', 45, 45, '2024-07-23 07:20:56'),
(20, 'BEFORE INSERT', 0, NULL, 'TransJogja G', NULL, 40, '2024-07-23 07:22:43'),
(21, 'AFTER INSERT', 9, NULL, 'TransJogja G', NULL, 40, '2024-07-23 07:22:43'),
(22, 'BEFORE UPDATE', 9, 'TransJogja G', 'TransJogja G', 40, 40, '2024-07-23 07:24:03'),
(23, 'AFTER UPDATE', 9, 'TransJogja G', 'TransJogja G', 40, 40, '2024-07-23 07:24:03'),
(24, 'BEFORE DELETE', 9, 'TransJogja G', NULL, 40, NULL, '2024-07-23 07:25:50'),
(25, 'AFTER DELETE', 9, 'TransJogja G', NULL, 40, NULL, '2024-07-23 07:25:50'),
(26, 'BEFORE INSERT', 0, NULL, 'TransJogja F', NULL, 45, '2024-07-23 07:54:15'),
(27, 'AFTER INSERT', 10, NULL, 'TransJogja F', NULL, 45, '2024-07-23 07:54:15'),
(28, 'BEFORE UPDATE', 1, 'TransJogja G', 'TransJogja G', 45, 45, '2024-07-23 07:55:20'),
(29, 'AFTER UPDATE', 1, 'TransJogja G', 'TransJogja G', 45, 45, '2024-07-23 07:55:20'),
(31, 'BEFORE INSERT', 9, NULL, 'TransJogja H', NULL, 40, '2024-07-23 08:06:14'),
(32, 'AFTER INSERT', 9, NULL, 'TransJogja H', NULL, 40, '2024-07-23 08:06:14');

-- --------------------------------------------------------

--
-- Table structure for table `busrute`
--

CREATE TABLE `busrute` (
  `BusRuteID` int(11) NOT NULL,
  `BusID` int(11) DEFAULT NULL,
  `RuteID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `busrute`
--

INSERT INTO `busrute` (`BusRuteID`, `BusID`, `RuteID`) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 9, 1);

-- --------------------------------------------------------

--
-- Table structure for table `busrutehalte`
--

CREATE TABLE `busrutehalte` (
  `ID` int(11) NOT NULL,
  `BusID` int(11) DEFAULT NULL,
  `RuteID` int(11) DEFAULT NULL,
  `HalteID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Stand-in structure for view `busruteview`
-- (See below for the actual view)
--
CREATE TABLE `busruteview` (
`BusID` int(11)
,`NamaBus` varchar(100)
,`RuteID` int(11)
,`NamaRute` varchar(100)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `busverticalview`
-- (See below for the actual view)
--
CREATE TABLE `busverticalview` (
`BusID` int(11)
,`NamaBus` varchar(100)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `filteredbusruteview`
-- (See below for the actual view)
--
CREATE TABLE `filteredbusruteview` (
`BusID` int(11)
,`NamaBus` varchar(100)
,`RuteID` int(11)
,`NamaRute` varchar(100)
);

-- --------------------------------------------------------

--
-- Table structure for table `halte`
--

CREATE TABLE `halte` (
  `HalteID` int(11) NOT NULL,
  `NamaHalte` varchar(100) NOT NULL,
  `Lokasi` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `halte`
--

INSERT INTO `halte` (`HalteID`, `NamaHalte`, `Lokasi`) VALUES
(1, 'Halte Malioboro', 'Jl. Malioboro'),
(2, 'Halte UGM', 'Jl. Kaliurang'),
(3, 'Halte Ambarukmo', 'Jl. Solo'),
(4, 'Halte Tamansari', 'Jl. Tamansari'),
(5, 'Halte JEC', 'Jl. Janti');

-- --------------------------------------------------------

--
-- Table structure for table `rute`
--

CREATE TABLE `rute` (
  `RuteID` int(11) NOT NULL,
  `NamaRute` varchar(100) NOT NULL,
  `Jarak` decimal(5,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rute`
--

INSERT INTO `rute` (`RuteID`, `NamaRute`, `Jarak`) VALUES
(1, 'Rute Utara', 15.00),
(2, 'Rute Selatan', 20.50),
(3, 'Rute Barat', 18.00),
(4, 'Rute Timur', 22.00),
(5, 'Rute Pusat', 12.50);

-- --------------------------------------------------------

--
-- Table structure for table `rutehalte`
--

CREATE TABLE `rutehalte` (
  `RuteHalteID` int(11) NOT NULL,
  `RuteID` int(11) DEFAULT NULL,
  `HalteID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rutehalte`
--

INSERT INTO `rutehalte` (`RuteHalteID`, `RuteID`, `HalteID`) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 2, 3),
(4, 2, 4),
(6, 3, 1),
(5, 3, 5),
(7, 4, 2),
(8, 4, 3),
(9, 5, 4),
(10, 5, 5);

-- --------------------------------------------------------

--
-- Structure for view `bushorizontalview`
--
DROP TABLE IF EXISTS `bushorizontalview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `bushorizontalview`  AS SELECT `bus`.`BusID` AS `BusID`, `bus`.`NamaBus` AS `NamaBus`, `bus`.`Kapasitas` AS `Kapasitas` FROM `bus` WHERE `bus`.`Kapasitas` > 40 ;

-- --------------------------------------------------------

--
-- Structure for view `busruteview`
--
DROP TABLE IF EXISTS `busruteview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `busruteview`  AS SELECT `b`.`BusID` AS `BusID`, `b`.`NamaBus` AS `NamaBus`, `r`.`RuteID` AS `RuteID`, `r`.`NamaRute` AS `NamaRute` FROM ((`bus` `b` join `busrute` `br` on(`b`.`BusID` = `br`.`BusID`)) join `rute` `r` on(`br`.`RuteID` = `r`.`RuteID`)) ;

-- --------------------------------------------------------

--
-- Structure for view `busverticalview`
--
DROP TABLE IF EXISTS `busverticalview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `busverticalview`  AS SELECT `bus`.`BusID` AS `BusID`, `bus`.`NamaBus` AS `NamaBus` FROM `bus` ;

-- --------------------------------------------------------

--
-- Structure for view `filteredbusruteview`
--
DROP TABLE IF EXISTS `filteredbusruteview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `filteredbusruteview`  AS SELECT `busruteview`.`BusID` AS `BusID`, `busruteview`.`NamaBus` AS `NamaBus`, `busruteview`.`RuteID` AS `RuteID`, `busruteview`.`NamaRute` AS `NamaRute` FROM `busruteview` WHERE `busruteview`.`RuteID` = 1WITH CASCADEDCHECK OPTION  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bus`
--
ALTER TABLE `bus`
  ADD PRIMARY KEY (`BusID`);

--
-- Indexes for table `buslog`
--
ALTER TABLE `buslog`
  ADD PRIMARY KEY (`LogID`);

--
-- Indexes for table `busrute`
--
ALTER TABLE `busrute`
  ADD PRIMARY KEY (`BusRuteID`),
  ADD KEY `RuteID` (`RuteID`),
  ADD KEY `idx_bus_rute` (`BusID`,`RuteID`),
  ADD KEY `idx_bus_rutee` (`BusID`,`RuteID`);

--
-- Indexes for table `busrutehalte`
--
ALTER TABLE `busrutehalte`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `RuteID` (`RuteID`),
  ADD KEY `HalteID` (`HalteID`),
  ADD KEY `idx_bus_rute_halte` (`BusID`,`RuteID`,`HalteID`);

--
-- Indexes for table `halte`
--
ALTER TABLE `halte`
  ADD PRIMARY KEY (`HalteID`);

--
-- Indexes for table `rute`
--
ALTER TABLE `rute`
  ADD PRIMARY KEY (`RuteID`);

--
-- Indexes for table `rutehalte`
--
ALTER TABLE `rutehalte`
  ADD PRIMARY KEY (`RuteHalteID`),
  ADD KEY `HalteID` (`HalteID`),
  ADD KEY `idx_rute_halte` (`RuteID`,`HalteID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bus`
--
ALTER TABLE `bus`
  MODIFY `BusID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `buslog`
--
ALTER TABLE `buslog`
  MODIFY `LogID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `busrute`
--
ALTER TABLE `busrute`
  MODIFY `BusRuteID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `busrutehalte`
--
ALTER TABLE `busrutehalte`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `halte`
--
ALTER TABLE `halte`
  MODIFY `HalteID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `rute`
--
ALTER TABLE `rute`
  MODIFY `RuteID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `rutehalte`
--
ALTER TABLE `rutehalte`
  MODIFY `RuteHalteID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `busrute`
--
ALTER TABLE `busrute`
  ADD CONSTRAINT `busrute_ibfk_1` FOREIGN KEY (`BusID`) REFERENCES `bus` (`BusID`),
  ADD CONSTRAINT `busrute_ibfk_2` FOREIGN KEY (`RuteID`) REFERENCES `rute` (`RuteID`);

--
-- Constraints for table `busrutehalte`
--
ALTER TABLE `busrutehalte`
  ADD CONSTRAINT `busrutehalte_ibfk_1` FOREIGN KEY (`BusID`) REFERENCES `bus` (`BusID`),
  ADD CONSTRAINT `busrutehalte_ibfk_2` FOREIGN KEY (`RuteID`) REFERENCES `rute` (`RuteID`),
  ADD CONSTRAINT `busrutehalte_ibfk_3` FOREIGN KEY (`HalteID`) REFERENCES `halte` (`HalteID`);

--
-- Constraints for table `rutehalte`
--
ALTER TABLE `rutehalte`
  ADD CONSTRAINT `rutehalte_ibfk_1` FOREIGN KEY (`RuteID`) REFERENCES `rute` (`RuteID`),
  ADD CONSTRAINT `rutehalte_ibfk_2` FOREIGN KEY (`HalteID`) REFERENCES `halte` (`HalteID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
