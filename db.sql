-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Dec 05, 2025 at 04:25 PM
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
-- Database: `hackathon_imphnen`
--

-- --------------------------------------------------------

--
-- Table structure for table `account`
--

CREATE TABLE `account` (
  `ID` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `isAdmin` enum('YES','NO') NOT NULL,
  `session_token` varchar(255) DEFAULT NULL,
  `session_expiry` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `account`
--

INSERT INTO `account` (`ID`, `created_at`, `username`, `password`, `isAdmin`, `session_token`, `session_expiry`) VALUES
(1, '2025-12-01 05:16:46', 'hylmi', '$2a$12$aMkBUAVjtwfI46Us13Jx0.cNcJVa5ri0MaUFWt97U5fi4yupNBlS2', 'YES', 'e507a1328ef4026ee0b76045f2c02464cea7c0db19fd1ffb6966783e5427e5f7', '2025-12-06 18:51:32'),
(2, '2025-12-01 14:49:20', 'test', '$2y$12$Sg50YvG6VnAeNp2dmgoujeP3iOAeqHfSyH9b2GzVsF.kALL81egK2', 'YES', 'd6b2d9dfc680bb58acb796a2797b489c2a244d96156d2161ad6b7532ab4a5314', '2025-12-06 08:57:07'),
(3, '2025-12-02 01:17:20', 'akuruoaklah', '$2y$12$0/zkk9Vs1OZaQWoeLLFhIuP4aAULm1wyNHfKu7x3j/fmlYyXQSd.K', 'YES', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `history_chat`
--

CREATE TABLE `history_chat` (
  `ID` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `request` varchar(255) NOT NULL,
  `response` varchar(255) NOT NULL,
  `sql_script` varchar(255) NOT NULL,
  `created_by` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `history_chat`
--

INSERT INTO `history_chat` (`ID`, `created_at`, `request`, `response`, `sql_script`, `created_by`) VALUES
(47, '2025-12-05 14:41:12', 'coba baca tabel itu dan tambah produk mekanikal keyboard itu 30 lagi', 'Memperbarui kolom \'stock\' untuk produk \'Mechanical Keyboard\' di tabel \'inventory\' dengan menambahkan 30 unit ke stok saat ini.', 'UPDATE inventory SET stock = stock + 30 WHERE name = \'Mechanical Keyboard\';', 'hylmi');

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

CREATE TABLE `inventory` (
  `ID` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `name` varchar(150) NOT NULL,
  `stock` int(50) NOT NULL,
  `price` double(20,2) NOT NULL,
  `created_by` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `inventory`
--

INSERT INTO `inventory` (`ID`, `created_at`, `name`, `stock`, `price`, `created_by`) VALUES
(35, '2025-12-05 14:18:45', 'Mechanical Keyboard', 30, 1200000.00, 'hylmi'),
(36, '2025-12-05 14:18:45', 'Wireless Mouse Logitech', 10, 500000.00, 'hylmi'),
(42, '2025-12-05 14:18:45', 'Portable Power Bank 20000mAh', 5, 350000.00, 'hylmi'),
(43, '2025-12-05 14:18:45', 'USB-C Cable 2m', 50, 50000.00, 'hylmi'),
(58, '2025-12-05 14:18:45', 'Wireless Charger Pad', 0, 400000.00, 'hylmi'),
(59, '2025-12-05 14:18:45', 'Bluetooth Speaker Portable', 10, 250000.00, 'hylmi'),
(62, '2025-12-05 14:18:45', 'Printer Laser Mono', 160, 3000000.00, 'hylmi'),
(67, '2025-12-05 14:18:45', 'Fitness Tracker Xiaomi', 0, 450000.00, 'hylmi');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `history_chat`
--
ALTER TABLE `history_chat`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account`
--
ALTER TABLE `account`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `history_chat`
--
ALTER TABLE `history_chat`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
