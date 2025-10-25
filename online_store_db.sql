-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 25, 2025 at 02:37 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `online_store_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `product_id` bigint(20) NOT NULL,
  `quantity` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`id`, `user_id`, `product_id`, `quantity`) VALUES
(8, 6, 19, 1),
(9, 6, 11, 1),
(11, 6, 4, 1),
(13, 6, 3, 1),
(15, 8, 14, 1),
(16, 7, 14, 1);

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`) VALUES
(5, 'Aksesore'),
(4, 'Gaming pc'),
(2, 'Laptop'),
(3, 'Pc'),
(1, 'Telefona mobil');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` bigint(20) NOT NULL,
  `name` varchar(200) NOT NULL,
  `description` text NOT NULL,
  `subcategory_id` bigint(20) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `tags` varchar(200) DEFAULT NULL,
  `image_filename` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `description`, `subcategory_id`, `price`, `tags`, `image_filename`) VALUES
(3, 'iPhone 15 Pro', 'Smartphone me ekran OLED dhe kamerë 48MP', 1, 999.99, 'iphone, telefon, smart', 'iphone15pro.png'),
(4, 'iPhone 14', 'Telefon me performancë të lartë dhe dizajn elegant', 1, 799.99, 'iphone, telefon, smart', 'iphone14.jpg'),
(5, 'iPhone SE 2023', 'Opsion buxhetor me performancë të mirë', 1, 499.99, 'iphone, telefon, buxhet', 'iphonese2023.jpg'),
(6, 'Samsung Galaxy S23 Ultra', 'Flagship me stilolaps dhe ekran AMOLED', 2, 1199.99, 'samsung, telefon, smart', 'samsungs23ultra.jpg'),
(7, 'Samsung Galaxy A54', 'Telefon mid-range me ekran i gjerë', 2, 349.99, 'samsung, telefon, midrange', 'samsunga54.jpg'),
(8, 'Samsung Galaxy Z Fold 4', 'Telefon i palosshëm me teknologji të avancuar', 2, 1799.99, 'samsung, telefon, foldable', 'galaxy_z_fold4.jpg'),
(9, 'iPhone 13 Mini', 'Version kompakt me performancë të shkëlqyer', 1, 699.99, 'iphone, telefon, mini', 'iphone13mini.png'),
(10, 'Samsung Galaxy S22', 'Telefon me dizajn modern dhe bateri të gjatë', 2, 749.99, 'samsung, telefon, smart', 'galaxys22.jpg'),
(11, 'iPhone 15 Plus', 'Ekran i madh dhe performancë e lartë', 1, 899.99, 'iphone, telefon, plus', 'iphone15plus.jpg'),
(12, 'Asus ROG Strix Scar 15', 'Laptop gaming me GPU RTX 3080', 3, 1899.99, 'asus rog, laptop, gaming', 'asus_strix_scar.jpg'),
(13, 'Asus TUF Gaming A15', 'Laptop i fortë për lojëra dhe punë', 4, 1299.99, 'asus tuf, laptop, gaming', 'asustuf.png'),
(14, 'Lenovo Laptop Legion 5', 'Performancë e lartë për gaming', 5, 1499.99, 'lenovo laptop, gaming, laptop', 'lenovolegion5.jpg'),
(15, 'Asus ROG Zephyrus G14', 'Laptop i hollë dhe i fuqishëm', 3, 1699.99, 'asus rog, laptop, ultrabook', 'ASUS_ROG_Zephyrus_G14.jpeg'),
(16, 'Asus TUF Dash F15', 'Laptop i lehtë për gaming në lëvizje', 4, 1199.99, 'asus tuf, laptop, portable', 'dash_f15.png'),
(17, 'Lenovo Laptop ThinkPad X1', 'Laptop biznesi me ekran 4K', 5, 1399.99, 'lenovo laptop, biznes, laptop', 'thinkpad_x1.png'),
(18, 'Asus ROG Flow Z13', 'Laptop hibrid me ekran të ndashëm', 3, 1999.99, 'asus rog, laptop, hybrid', 'flowz13.jpg'),
(19, 'Asus TUF Gaming A17', 'Gaming laptop me ekran 17\"', 4, 1399.99, 'asus tuf, laptop, gaming', 'asus_a17.jpg'),
(20, 'Lenovo Laptop IdeaPad 5', 'Laptop buxhetor me performancë të mirë', 5, 799.99, 'lenovo laptop, buxhet, laptop', 'ideapad5.jpg'),
(21, 'Dell XPS 8950', 'PC desktop me procesor i9', 6, 1299.99, 'dell pc, desktop, performance', 'xps_8950.jpg'),
(22, 'Lenovo ThinkCentre M90', 'PC biznesi me siguri të lartë', 7, 999.99, 'lenovo pc, biznes, desktop', 'Lenovo_ThinkCentre_M90.jpg'),
(23, 'Dell OptiPlex 3080', 'PC buxhetor për zyrë', 6, 699.99, 'dell pc, buxhet, desktop', 'Dell_OptiPlex_3080.jpg'),
(24, 'Lenovo IdeaCentre 5', 'PC me dizajn modern', 7, 899.99, 'lenovo pc, desktop, home', 'Lenovo_IdeaCentre_5.jpg'),
(25, 'Dell Precision 5760', 'Stacion pune për grafikë', 6, 1799.99, 'dell pc, workstation, graphic', 'Dell_precision_5760.jpg'),
(26, 'Lenovo ThinkStation P620', 'PC për punë intensive', 7, 2499.99, 'lenovo pc, workstation, performance', 'Lenovo_ThinkStation_P620.jpg'),
(27, 'Dell G5 Gaming Desktop', 'PC gaming me RTX 3060', 6, 1499.99, 'dell pc, gaming, desktop', 'Dell_G5_Gaming_Desktop.jpg'),
(28, 'Lenovo Legion Tower 5', 'PC gaming i fuqishëm', 7, 1699.99, 'lenovo pc, gaming, desktop', 'Lenovo_Legion_Tower_5.jpg'),
(29, 'Dell Inspiron 3020', 'PC për përdorim të përditshëm', 6, 799.99, 'dell pc, home, desktop', 'Dell_Inspiron_3020.jpg'),
(30, 'Lenovo IdeaCentre AIO 3', 'PC all-in-one me ekran 24\"', 7, 1099.99, 'lenovo pc, aio, desktop', 'Lenovo_IdeaCentre_AIO_3.jpg'),
(31, 'Gaming PC RTX 4080', 'PC gaming me GPU NVIDIA RTX 4080', 4, 2199.99, 'gaming pc, rtx 4080, highend', 'Gaming_PC_RTX_4080.jpg'),
(32, 'Gaming PC Ryzen 9', 'PC me procesor AMD Ryzen 9', 4, 1899.99, 'gaming pc, ryzen, highend', 'Gaming_PC_Ryzen_9.jpg'),
(33, 'Gaming PC i7 13700K', 'PC me Intel i7 dhe RTX 3070', 4, 1799.99, 'gaming pc, intel, midrange', 'Gaming_PC_i7_13700K.jpg'),
(34, 'Gaming PC Budget', 'PC gaming buxhetor me GTX 1660', 4, 999.99, 'gaming pc, budget, entry', 'Gaming_PC_Budget.jpg'),
(35, 'Gaming PC Water Cooled', 'PC me ftohje me ujë dhe RTX 4090', 4, 2999.99, 'gaming pc, watercooling, highend', 'Gaming_PC_Water_Cooled.jpg'),
(36, 'Gaming PC AMD 5800X', 'PC me AMD 5800X dhe RTX 3060', 4, 1499.99, 'gaming pc, amd, midrange', 'Gaming_PC_AMD_5800X.jpg'),
(37, 'Gaming PC VR Ready', 'PC i optimizuar për VR me RTX 3080', 4, 1999.99, 'gaming pc, vr, highend', 'Gaming_PC_VR_Ready.jpg'),
(38, 'Gaming PC Mini', 'PC gaming kompakt me i5 dhe GTX 1660', 4, 1299.99, 'gaming pc, mini, midrange', 'Gaming_PC_Mini.jpg'),
(39, 'Gaming PC Overclocked', 'PC me overclock dhe RTX 4070', 4, 2299.99, 'gaming pc, overclock, highend', 'Gaming_PC_Overclocked.jpg'),
(40, 'Gaming PC Custom', 'PC i personalizuar me i9 dhe RTX 3090', 4, 2599.99, 'gaming pc, custom, highend', 'Gaming_PC_Custom.jpg'),
(41, 'Sony WH-1000XM5', 'Kufje me zërim me zhurmë', 8, 349.99, 'kufje, noise cancelling, premium', 'Sony_WH-1000XM5.jpg'),
(42, 'Bose QuietComfort 45', 'Kufje me komoditet të lartë', 8, 329.99, 'kufje, noise cancelling, comfort', 'Bose_QuietComfort_45.jpg'),
(43, 'JBL Live 660NC', 'Kufje me bas të fortë', 8, 149.99, 'kufje, bass, midrange', 'JBL_Live_660NC.jpg'),
(44, 'Audio-Technica ATH-M50x', 'Kufje studio me cilësi të lartë', 8, 149.99, 'kufje, studio, professional', 'Audio-Technica_ATH-M50x.jpg'),
(45, 'Anker Soundcore Life Q30', 'Kufje buxhetore me zhurmë', 8, 79.99, 'kufje, budget, noise cancelling', 'Anker_Soundcore_Life_Q30.jpg'),
(46, 'Sennheiser HD 450BT', 'Kufje me lidhje Bluetooth', 8, 179.99, 'kufje, bluetooth, premium', 'Sennheiser_HD_450BT.jpg'),
(47, 'Beats Solo 4', 'Kufje me dizajn modern', 8, 199.99, 'kufje, beats, stylish', 'Beats_Solo_4.jpg'),
(48, 'Skullcandy Crusher Evo', 'Kufje me vibrim bas', 8, 139.99, 'kufje, bass, midrange', 'Skullcandy_Crusher_Evo.jpg'),
(49, 'Razer Kraken X', 'Kufje gaming me mikrofon', 8, 59.99, 'kufje, gaming, budget', 'Razer_Kraken_X.jpg'),
(50, 'HyperX Cloud II', 'Kufje gaming me cilësi të lartë', 8, 99.99, 'kufje, gaming, premium', 'HyperX_Cloud_II.jpg'),
(51, 'Logitech MX Keys', 'Tastaturë mekanike për punë', 10, 119.99, 'tastatur, mekanik, profesional', 'Logitech_MX_Keys.jpg'),
(52, 'Razer BlackWidow V4', 'Tastaturë gaming me RGB', 10, 159.99, 'tastatur, gaming, rgb', 'Razer_BlackWidow_V4.jpg'),
(53, 'Corsair K95 RGB Platinum', 'Tastaturë premium gaming', 10, 199.99, 'tastatur, gaming, premium', 'Corsair_K95_RGB_Platinum.jpg'),
(54, 'Keychron K8 Pro', 'Tastaturë mekanike wireless', 10, 99.99, 'tastatur, mekanik, wireless', 'Keychron_K8_Pro.jpg'),
(55, 'SteelSeries Apex 7', 'Tastaturë me ekran OLED', 10, 139.99, 'tastatur, gaming, oled', 'SteelSeries_Apex_7.jpg'),
(56, 'HyperX Alloy Elite 2', 'Tastaturë gaming me cilësi të lartë', 10, 129.99, 'tastatur, gaming, durable', 'HyperX_Alloy_Elite_2.jpg'),
(57, 'Das Keyboard 4 Professional', 'Tastaturë mekanike për programues', 10, 169.99, 'tastatur, mekanik, coding', 'Das_Keyboard_4_Professional.jpg'),
(58, 'Redragon K552', 'Tastaturë buxhetore mekanike', 10, 49.99, 'tastatur, mekanik, budget', 'Redragon_K552.jpg'),
(59, 'Logitech K380', 'Tastaturë kompakte wireless', 10, 39.99, 'tastatur, wireless, compact', 'Logitech_K380.jpg'),
(60, 'Asus ROG Strix Scope', 'Tastaturë gaming me tast të shpejtë', 10, 139.99, 'tastatur, gaming, fast', 'Asus_ROG_Strix_Scope.jpg'),
(61, 'Logitech MX Master 3S', 'Maus profesional me sensor të lartë', 9, 99.99, 'maus, profesional, wireless', 'Logitech_MX_Master_3S.jpg'),
(62, 'Razer DeathAdder V3 Pro', 'Maus gaming me DPI i lartë', 9, 129.99, 'maus, gaming, wireless', 'Razer_DeathAdder_V3_Pro.jpg'),
(63, 'Corsair Dark Core RGB', 'Maus gaming me ndriçim', 9, 89.99, 'maus, gaming, rgb', 'Corsair_Dark_Core_RGB.jpg'),
(64, 'SteelSeries Rival 600', 'Maus me sensor të dyfishtë', 9, 59.99, 'maus, gaming, precision', 'SteelSeries_Rival_600.jpg'),
(65, 'Logitech G502 Hero', 'Maus gaming me pesha të rregullueshme', 9, 79.99, 'maus, gaming, adjustable', 'Logitech_G502_Hero.jpg'),
(66, 'HyperX Pulsefire Surge', 'Maus gaming me dizajn RGB', 9, 59.99, 'maus, gaming, rgb', 'HyperX_Pulsefire_Surge.jpg'),
(67, 'Asus ROG Gladius III', 'Maus gaming me butona të personalizueshëm', 9, 89.99, 'maus, gaming, customizable', 'Asus_ROG_Gladius_III.png'),
(68, 'Microsoft Surface Arc Mouse', 'Maus i hollë dhe portativ', 9, 69.99, 'maus, portable, stylish', 'Microsoft_Surface_Arc_Mouse.jpg'),
(69, 'Redragon M711 Cobra', 'Maus buxhetor gaming', 9, 29.99, 'maus, gaming, budget', 'Redragon_M711_Cobra.jpg'),
(70, 'Zowie EC2', 'Maus esports me dizajn të thjeshtë', 9, 59.99, 'maus, esports, precision', 'Zowie_EC2.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `subcategories`
--

CREATE TABLE `subcategories` (
  `id` bigint(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `category_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `subcategories`
--

INSERT INTO `subcategories` (`id`, `name`, `category_id`) VALUES
(1, 'iphone', 1),
(2, 'samsung', 1),
(3, 'Asus rog', 2),
(4, 'Asus tuf', 2),
(5, 'Lenovo Laptop', 2),
(6, 'Dell Pc', 3),
(7, 'Lenovo Pc', 3),
(8, 'Kufje', 5),
(9, 'Maus', 5),
(10, 'Tastatur', 5);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) NOT NULL,
  `username` varchar(150) NOT NULL,
  `password` varchar(128) NOT NULL,
  `email` varchar(254) DEFAULT NULL,
  `is_admin` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `email`, `is_admin`) VALUES
(6, 'Rinesa', 'pbkdf2:sha256:1000000$8aZay20Rthpu4Wwn$4456ba1feb6f748e15b3f9c6b7ea613b34d640c1ccb4b55c2a50cd42be5a90ec', 'Rinesa.k@gmail.com', 1),
(7, 'test', 'pbkdf2:sha256:1000000$0dCjSwrcZxI8eQ9N$323dfaea9c7028df657058b4cd0c8b8b8d913c7e15e8e486f708e61ade4857a2', 'test@gmail.com', 0),
(8, 'test2', 'pbkdf2:sha256:1000000$3u5bbb2E01bIEADE$1927923412b01fd1987966410992d8a3443d234e0124aa8bf002612c3d79acf5', 'test2@test2.com', 0);

-- --------------------------------------------------------

--
-- Table structure for table `user_profiles`
--

CREATE TABLE `user_profiles` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_profiles`
--

INSERT INTO `user_profiles` (`id`, `user_id`) VALUES
(6, 6),
(7, 7),
(8, 8);

-- --------------------------------------------------------

--
-- Table structure for table `user_profile_viewed_products`
--

CREATE TABLE `user_profile_viewed_products` (
  `id` bigint(20) NOT NULL,
  `user_profile_id` bigint(20) NOT NULL,
  `product_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_profile_viewed_products`
--

INSERT INTO `user_profile_viewed_products` (`id`, `user_profile_id`, `product_id`) VALUES
(8, 6, 13),
(9, 6, 19),
(10, 6, 11),
(13, 6, 3),
(14, 6, 16),
(15, 6, 14),
(16, 6, 20),
(17, 6, 17),
(18, 6, 4),
(19, 6, 5),
(20, 6, 8),
(21, 7, 19),
(22, 6, 12),
(23, 6, 21),
(24, 7, 20),
(25, 7, 10),
(26, 7, 3),
(27, 8, 14),
(28, 7, 14),
(29, 6, 28);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `subcategory_id` (`subcategory_id`);

--
-- Indexes for table `subcategories`
--
ALTER TABLE `subcategories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `user_profiles`
--
ALTER TABLE `user_profiles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `user_profile_viewed_products`
--
ALTER TABLE `user_profile_viewed_products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_profile_id` (`user_profile_id`),
  ADD KEY `product_id` (`product_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;

--
-- AUTO_INCREMENT for table `subcategories`
--
ALTER TABLE `subcategories`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `user_profiles`
--
ALTER TABLE `user_profiles`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `user_profile_viewed_products`
--
ALTER TABLE `user_profile_viewed_products`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`subcategory_id`) REFERENCES `subcategories` (`id`);

--
-- Constraints for table `subcategories`
--
ALTER TABLE `subcategories`
  ADD CONSTRAINT `subcategories_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_profiles`
--
ALTER TABLE `user_profiles`
  ADD CONSTRAINT `user_profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_profile_viewed_products`
--
ALTER TABLE `user_profile_viewed_products`
  ADD CONSTRAINT `user_profile_viewed_products_ibfk_1` FOREIGN KEY (`user_profile_id`) REFERENCES `user_profiles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_profile_viewed_products_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
