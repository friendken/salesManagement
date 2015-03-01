-- phpMyAdmin SQL Dump
-- version 3.5.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Feb 13, 2015 at 12:39 PM
-- Server version: 5.5.24-log
-- PHP Version: 5.3.13

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `salesystem`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `make_intervals`(startdate timestamp, enddate timestamp, intval integer, unitval varchar(10))
BEGIN
-- *************************************************************************
-- Procedure: make_intervals()
--    Author: Ron Savage
--      Date: 02/03/2009
--
-- Description:
-- This procedure creates a temporary table named time_intervals with the
-- interval_start and interval_end fields specifed from the startdate and
-- enddate arguments, at intervals of intval (unitval) size.
-- *************************************************************************
   declare thisDate timestamp;
   declare nextDate timestamp;
   set thisDate = startdate;

   -- *************************************************************************
   -- Drop / create the temp table
   -- *************************************************************************
   drop temporary table if exists time_intervals;
   create temporary table if not exists time_intervals
      (
      interval_start timestamp,
      interval_end timestamp
      );

   -- *************************************************************************
   -- Loop through the startdate adding each intval interval until enddate
   -- *************************************************************************
   repeat
      select
         case unitval
            when 'MICROSECOND' then timestampadd(MICROSECOND, intval, thisDate)
            when 'SECOND'      then timestampadd(SECOND, intval, thisDate)
            when 'MINUTE'      then timestampadd(MINUTE, intval, thisDate)
            when 'HOUR'        then timestampadd(HOUR, intval, thisDate)
            when 'DAY'         then timestampadd(DAY, intval, thisDate)
            when 'WEEK'        then timestampadd(WEEK, intval, thisDate)
            when 'MONTH'       then timestampadd(MONTH, intval, thisDate)
            when 'QUARTER'     then timestampadd(QUARTER, intval, thisDate)
            when 'YEAR'        then timestampadd(YEAR, intval, thisDate)
         end into nextDate;

      insert into time_intervals select thisDate, timestampadd(MICROSECOND, -1, nextDate);
      set thisDate = nextDate;
   until thisDate >= enddate
   end repeat;

 END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `getValueBuy`(date DATE, product_id INT) RETURNS float
    READS SQL DATA
BEGIN
  DECLARE v_total INT;
	DECLARE count INT;

	SET v_total = 0;
	SET count = 0;

  count_loop: LOOP
		SELECT SUM(detail.quantity * detail.cost) / SUM(detail.quantity) as average
		INTO v_total
		FROM wh_invoices_wh_wholesales detail join wh_invoices wh on detail.wh_invoice_id = wh.id
		WHERE detail.product_id = product_id AND DATE(wh.time) = ADDDATE(DATE(date), count)
		GROUP BY DATE(wh.time);
    SET count = count - 1;

    IF v_total > 0 THEN
      LEAVE count_loop;
    END IF;
    
  END LOOP;

  RETURN v_total;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getValueSell`(date DATE, product_id INT) RETURNS float
    READS SQL DATA
BEGIN
  DECLARE v_total INT;
	DECLARE count INT;

	SET v_total = 0;
	SET count = 0;

  count_loop: LOOP
		SELECT SUM(detail.quantity * detail.price) / SUM(detail.quantity) as average
		INTO v_total
		FROM wholesale_invoices_wh_wholesales detail join wholesale_invoices wh on detail.wholesale_invoice_id = wh.id
		WHERE detail.product_id = product_id AND DATE(wh.date) = ADDDATE(DATE(date), count)
		GROUP BY DATE(wh.date);

    SET count = count - 1;

    IF v_total > 0 THEN
      LEAVE count_loop;
    END IF;
    
  END LOOP;

  RETURN v_total;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `bill`
--

CREATE TABLE IF NOT EXISTS `bill` (
  `id` bigint(7) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `bill_code` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `customer_id` bigint(25) DEFAULT NULL,
  `debit` bigint(20) DEFAULT NULL,
  `price_total` bigint(50) DEFAULT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `warehouse` enum('retail','wholesale') COLLATE utf8_unicode_ci DEFAULT 'wholesale',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=3 ;

--
-- Dumping data for table `bill`
--

INSERT INTO `bill` (`id`, `bill_code`, `customer_id`, `debit`, `price_total`, `created`, `warehouse`) VALUES
(0000001, 'S0000001', 4, 11000, 111000, '2015-02-01 16:50:16', 'wholesale'),
(0000002, 'S0000002', NULL, NULL, 2495000, '2015-02-08 09:31:57', 'wholesale');

-- --------------------------------------------------------

--
-- Table structure for table `bill_detail`
--

CREATE TABLE IF NOT EXISTS `bill_detail` (
  `id` bigint(50) NOT NULL AUTO_INCREMENT,
  `bill_id` bigint(50) NOT NULL,
  `product_id` bigint(50) DEFAULT NULL,
  `quantity` bigint(50) DEFAULT NULL,
  `price` bigint(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=6 ;

--
-- Dumping data for table `bill_detail`
--

INSERT INTO `bill_detail` (`id`, `bill_id`, `product_id`, `quantity`, `price`) VALUES
(1, 1, 1, 5, 39000),
(2, 1, 8, 15, 82500),
(3, 1, 23, 5, 66500),
(4, 2, 3, 15, 45000),
(5, 2, 2, 10, 2450000);

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE IF NOT EXISTS `customers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `store_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone_home` varchar(255) COLLATE utf8_unicode_ci DEFAULT '[]',
  `phone_mobile` varchar(255) COLLATE utf8_unicode_ci DEFAULT '[]',
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `type` enum('customer','partner') COLLATE utf8_unicode_ci DEFAULT NULL,
  `active` int(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=341 ;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `name`, `store_name`, `address`, `phone_home`, `phone_mobile`, `created`, `type`, `active`) VALUES
(1, '', 'Nhà Phân Phối Phú Thuận', '118/1 Bàu Cát 2', '["62784800"]', '["09034002432"]', '2014-12-04 18:25:07', 'partner', 0),
(2, 'Ngọc Anh', 'Ngọc Anh', '172 Ấp Chiến Lược', '["37501952                       "]', '["0933337697"]', '2014-12-04 18:26:36', 'customer', 0),
(3, '', NULL, '86 Ấp Chiến Lược', '[]', '[]', '2014-12-05 17:37:41', 'customer', 0),
(4, 'Hồng', 'căn tin BV Tân Phú', '609 Âu Cơ', '[]', '["0907610862"]', '2014-12-18 16:03:14', 'customer', 0),
(5, 'Lan Nguyến', 'lan rừng', '96 lê lư', '[]', '[]', '2014-12-18 16:04:59', 'partner', 0),
(6, '', 'Hoàn Châu', '211 Ấp Chiến Lược', '["66711670"]', '["0906751179"]', '2015-01-04 06:01:41', 'customer', 0),
(7, NULL, 'Kim Châu', '698 Âu Cơ', '["22450779"]', '[]', '2015-01-04 07:11:43', 'customer', 0),
(8, 'Phụng', NULL, '483/5 Âu Cơ', '["38602116"]', '["0905802288"]', '2015-01-04 07:13:21', 'customer', 0),
(9, 'Châu âu cơ', '', '958/16 Âu Cơ', '["62966282"]', '[]', '2015-01-04 07:14:45', 'customer', 0),
(10, NULL, NULL, '290K Âu Cơ', '[]', '["0908136283"]', '2015-01-04 07:15:49', 'customer', 0),
(11, 'Xíu', 'Định', '293 Bình Long', '[]', '["0909642079"]', '2015-01-04 07:16:50', 'customer', 0),
(12, 'Kim Ngân', '', '32 Ba Vân F13', '["38427825"]', '[]', '2015-01-04 07:18:34', 'customer', 0),
(13, NULL, NULL, '94 Ba Vân', '["35591512","38103083"]', '[]', '2015-01-04 07:19:14', 'customer', 0),
(14, NULL, 'Chùa Như Thị Nhất', '29 Bình Long', '[]', '["0905584477"]', '2015-01-06 15:19:36', 'customer', 0),
(15, NULL, NULL, '33 Bạch Đằng', '[]', '["0908464174"]', '2015-01-06 15:20:05', 'customer', 0),
(16, 'Trang', NULL, '38 Bảy Sậy. F13.Q5', '["39080619"]', '["0919602902"]', '2015-01-06 15:21:24', 'customer', 0),
(17, 'Trang cầu trắng', 'Hưng Phát', '287 Bình Long', '["8755364"]', '[]', '2015-01-06 15:24:01', 'customer', 0),
(18, NULL, 'Lâm Hà', '168 Bình Long. F.Phú Thạnh', '["4085863"]', '[]', '2015-01-06 15:24:57', 'customer', 0),
(19, NULL, 'Cơm chay Ngọc Hạnh', '120/2 Bùi Thế Mỹ', '["397322"]', '["09081026"]', '2015-01-06 15:26:11', 'customer', 0),
(20, NULL, 'quán Cơm', '344 Bình Long', '[]', '["0986426189"]', '2015-01-06 15:35:07', 'customer', 0),
(21, NULL, 'Lực Phượng', '64 Bảy Sậy', '["38565672"]', '[]', '2015-01-06 15:36:23', 'customer', 0),
(22, 'Lâm Dũng', 'Lâm Dũng', '81 Bảy Sậy', '["39520603"]', '[]', '2015-01-06 15:37:20', 'customer', 0),
(23, NULL, 'Hotel Hồng Miên', '46 Bình Giả', '["38425269"]', '["0942526366"]', '2015-01-06 15:38:36', 'customer', 0),
(24, 'Diêu Hiền', 'c.cư Vườn Lài', '12B C.cư Vườn Lài', '[]', '["0918305524"]', '2015-01-06 15:42:05', 'customer', 0),
(25, 'Bảo', NULL, '15/12A Cầu Xéo', '[]', '["0906902021"]', '2015-01-06 15:43:03', 'customer', 0),
(26, 'Hồng', 'Hoa Hồng', '672 CMT8. F5. Q.tân Bình', '["39930499"]', '["01222676788"]', '2015-01-06 15:44:33', 'customer', 0),
(27, NULL, NULL, '8 Chu Thiên', '[]', '["0903379608"]', '2015-01-06 15:47:01', 'customer', 0),
(28, NULL, 'Hồng Ân', '57 CN11', '["54356069"]', '[]', '2015-01-06 15:47:50', 'customer', 0),
(29, 'Ân', NULL, '97 Chu Thiên', '[]', '["0917525038"]', '2015-01-06 15:48:22', 'customer', 0),
(30, 'Mỹ Tiên', 'Vu Lan', '341/10 Chiến Lược, F.Bình Trị Đông', '["66604439"]', '["0978455817"]', '2015-01-06 15:54:26', 'customer', 0),
(31, 'Cô Mười', NULL, 'chơ Tân Hương', '["62676523"]', '[]', '2015-01-06 15:58:10', 'customer', 0),
(32, 'Hùng-Lan', 'chợ Tân Hương', 'A2-10 Chợ Tân Hương', '[]', '["090270088"]', '2015-01-06 15:59:03', 'customer', 0),
(33, NULL, NULL, '32 Cây Keo', '[]', '["0919301225"]', '2015-01-06 15:59:33', 'customer', 0),
(34, 'Ngọc Gò Vấp', 'Bảo Ngọc', 'Cây Trâm', '["39966197"]', '[]', '2015-01-06 16:00:33', 'customer', 1),
(35, NULL, 'Chùa Liên Hoa', NULL, '[]', '["0917554348"]', '2015-01-06 16:01:18', 'customer', 0),
(36, NULL, NULL, '72 CN1', '["0908607617"]', '[]', '2015-01-06 16:02:02', 'customer', 0),
(37, NULL, NULL, 'K2-20 Chợ Bàu Cát', '[]', '["0938533922"]', '2015-01-06 16:02:39', 'customer', 0),
(38, 'Hải Gò Vấp', NULL, 'Cây Trâm', '["39877889"]', '["0907223089"]', '2015-01-06 16:03:39', 'customer', 0),
(39, NULL, 'Ngọc Yến', '301 Chiến Lược', '["37626025"]', '["0913751986"]', '2015-01-06 16:04:31', 'customer', 0),
(40, 'Ngọc Anh', 'c.cư Hoàng Ngọc Phách', '34A c.cư Hoàng Ngọc Phách (đối diện nhà gửi xe)', '[]', '["0906008519"]', '2015-01-06 16:09:20', 'customer', 0),
(41, 'Loan', 'c.cư Vườn Lài', '001A c.cư Vườn Lài', '["62676658"]', '[]', '2015-01-06 16:10:23', 'customer', 0),
(42, 'Nam Thành Lợi', 'KCN Tân Bình', '001-002 Lô G  KCN Tân Bình', '["38150007"]', '[]', '2015-01-06 16:11:46', 'customer', 0),
(43, 'Hồng', 'Bảo Ngọc', '134 Cây Keo', '["38605418"]', '[]', '2015-01-06 16:12:24', 'customer', 0),
(44, 'Nguyệt-Thành', 'F4 Chợ Hiệp Tân', '14/7 Cây keo (Nhà)', '[]', '["0909402811"]', '2015-01-06 16:18:04', 'customer', 0),
(45, 'Trúc Vy', 'c.cư Gò Dầu 2', '011 Lô A c.cư Gò Dầu 2', '["4080059","54080078"]', '[]', '2015-01-06 16:24:19', 'customer', 0),
(46, 'Thủy', 'c.cư Gò Dầu 2', '001 lô A c.cư Gò Dầu 2 ( góc Gò dầu ,Tân Sơn Nhì )', '[]', '["0933554498"]', '2015-01-06 16:25:56', 'customer', 0),
(47, 'Vân', 'c.cư Gò Dầu 1', '001 Lô B  c.cư Gò Dầu 1 ( hẻm 63 Gò Dầu )', '[]', '["0902914888"]', '2015-01-06 16:29:58', 'customer', 0),
(48, NULL, 'Cà Phê', '16B Cây Keo', '[]', '["01213882886"]', '2015-01-06 16:33:57', 'customer', 0),
(49, 'Anh Quân', NULL, 'K7 chợ Sơn Kì', '["38165079"]', '[]', '2015-01-06 16:34:57', 'customer', 0),
(50, 'cô Tư', 'Chợ Tân Hương', 'C3-19 chợ Tân Hương / 70 Đỗ Thị Tâm (nhà)', '[]', '["01264597655"]', '2015-01-06 16:35:27', 'customer', 0),
(51, 'Huyền- Luân', 'Chợ Tân Hương', 'B1-3 chợ Tân Hương / 437 vườn lài (Nhà)', '[]', '[]', '2015-01-06 16:41:30', 'customer', 0),
(52, NULL, NULL, '45 Cầu Xéo', '[]', '["0977332321"]', '2015-01-06 16:43:05', 'customer', 0),
(53, 'chị Hạnh', NULL, '34 Cầu Xéo', '[]', '["0902509239"]', '2015-01-06 16:43:50', 'customer', 0),
(54, 'Anh Quân', NULL, '15/37 cầu Xéo', '[]', '["0907489839"]', '2015-01-06 16:44:54', 'customer', 0),
(55, 'Huyền Diêu', NULL, 'F7 Chợ Sơn Kì', '[]', '["0906073469"]', '2015-01-06 16:45:38', 'customer', 0),
(56, 'Minh Thư', 'c.cư Huỳnh Văn Chính', '17 c.cư Huỳnh Văn Chính', '["38853106"]', '[]', '2015-01-06 16:46:35', 'customer', 0),
(57, 'Bảo', NULL, '15/55 Cầu Xéo', '["62673359"]', '[]', '2015-01-06 16:47:00', 'customer', 0),
(58, 'Bích Thủy', 'Bích Thủy', '93 Chu Thiên', '[]', '["093379608"]', '2015-01-11 06:40:23', 'customer', 0),
(59, 'Hùng', '', '33 Chu Thiên', '[]', '["1282078000"]', '2015-01-11 06:41:17', 'customer', 0),
(60, 'Thắng', NULL, '18 Cây Keo', '["66516018"]', '[]', '2015-01-11 06:42:59', 'customer', 0),
(61, 'Thành', NULL, '96 Cây Keo', '["38609518"]', '[]', '2015-01-11 06:44:11', 'customer', 0),
(62, 'Phương', NULL, '50 Cây Keo', '[]', '["0907452511","0919301225"]', '2015-01-11 06:45:05', 'customer', 0),
(63, 'Tâm', NULL, '15/10 Cầu xéo', '[]', '["907992841"]', '2015-01-11 06:46:38', 'customer', 0),
(64, 'Hòa', NULL, '15/60 Cầu Xéo', '[]', '["1655099848"]', '2015-01-11 06:47:50', 'customer', 0),
(65, 'Hùng', NULL, '114 Cầu Xéo', '[]', '["903169063"]', '2015-01-11 06:49:36', 'customer', 0),
(66, 'Ngọc', NULL, '59 Cách Mạng', '["66705691"]', '[]', '2015-01-11 06:50:52', 'customer', 0),
(67, 'Đăng', NULL, '98 Cách Mạng', '["38103372"]', '[]', '2015-01-11 06:51:24', 'customer', 0),
(68, 'Minh Khát', 'KCN Tân Bình', '001 lô E KCN Tân Bình', '["54443683"]', '[]', '2015-01-11 06:55:13', 'customer', 0),
(69, 'Như', 'Tiểu Thư', '004 lô B c.cư Gò Dầu 1 ( hẻm 63 Gò Dầu )', '[]', '["0902914888"]', '2015-01-11 06:59:10', 'customer', 0),
(70, 'Hạnh', NULL, '035 lô B  c.cư Gò Dầu 2 ( góc Gò dầu ,Tân Sơn Nhì )', '["38104731"]', '[]', '2015-01-11 07:05:18', 'customer', 0),
(71, 'Hoàng', NULL, '23 c.cư Huỳnh Văn chính', '["62717848"]', '[]', '2015-01-11 07:06:29', 'customer', 0),
(72, 'Nhũ Hạ', NULL, '001/18 Lô A c.cư Huỳnh Văn Chính', '[]', '["0938787515"]', '2015-01-11 07:08:38', 'customer', 0),
(73, 'Hiền', NULL, '32/11/4 c.cư Huỳnh Văn Chính', '[]', '["0908242067"]', '2015-01-11 07:09:40', 'customer', 0),
(74, 'Hương', NULL, 'B005 C.cư Sơn Kỳ', '["68690448"]', '["0984063592"]', '2015-01-11 07:17:12', 'customer', 0),
(75, 'Châu', NULL, 'F002 C.cư Sơn Kỳ (đường D9)', '["62655369"]', '["939366748"]', '2015-01-11 07:19:11', 'customer', 0),
(76, 'Hồng', NULL, 'Nhà gửi xe lô B C.cư Sơn Kỳ', '["54355763"]', '[]', '2015-01-11 07:20:33', 'customer', 0),
(77, 'Hoa', NULL, '001 C.cư Vườn Lài', '["38470311"]', '[]', '2015-01-11 07:23:10', 'customer', 0),
(78, 'Thanh Thu', NULL, '82 DC9', '["362784862"]', '["0935576689"]', '2015-01-11 07:27:21', 'customer', 0),
(79, 'Phương Thảo', NULL, '90 DC9', '["62604236"]', '[]', '2015-01-11 07:27:46', 'customer', 0),
(80, 'Th Vissan', NULL, '004 C2', '["54356726"]', '[]', '2015-01-11 07:29:20', 'customer', 0),
(81, 'Nga', NULL, '7 C2', '["54442821"]', '[]', '2015-01-11 07:29:41', 'customer', 0),
(82, 'Nga', NULL, '4 C2', '["54442623"]', '[]', '2015-01-11 07:30:52', 'customer', 0),
(83, 'KIm', NULL, '104 D9', '["38102657"]', '[]', '2015-01-11 07:40:27', 'customer', 0),
(84, 'Hưng Phát', NULL, '42A D9', '[]', '["01284503222"]', '2015-01-11 07:43:05', 'customer', 0),
(85, 'Nhi', NULL, '83/14 D9', '["38162303"]', '[]', '2015-01-11 07:44:03', 'customer', 0),
(86, 'Thơm', '', '18 D11', '[]', '["975374402"]', '2015-01-11 07:45:00', 'customer', 0),
(87, 'Thuy', '', '55 D11', '[]', '["01286632633"]', '2015-01-11 07:45:57', 'customer', 0),
(88, 'Tuyên', NULL, '70 D11', '[]', '["932490074"]', '2015-01-11 07:47:33', 'customer', 0),
(89, 'Cô Tư', NULL, '60D 11', '[]', '["01695441051"]', '2015-01-11 07:49:01', 'customer', 0),
(90, 'Trinh', NULL, '80-82 D11', '[]', '["0933531325"]', '2015-01-11 07:50:00', 'customer', 0),
(91, 'Phụng', NULL, '70 D12', '["38109472"]', '[]', '2015-01-11 07:50:43', 'customer', 0),
(92, 'Thiên Ân', NULL, '14 D13', '[]', '["0982993299"]', '2015-01-11 07:53:03', 'customer', 0),
(93, 'Hòang Lân', NULL, '80 D16', '[]', '["908523754"]', '2015-01-11 07:55:56', 'customer', 0),
(94, 'Hà', '', '16 S2', '[]', '["0943760734"]', '2015-01-11 07:58:57', 'customer', 0),
(95, 'Thiên Tài', NULL, '53 S11', '["38162701"]', '["984063592"]', '2015-01-11 08:08:14', 'customer', 0),
(96, 'Thiên Tài', NULL, '53 S11', '[]', '[]', '2015-01-11 08:09:37', 'customer', 1),
(97, 'Trâm', NULL, '61 T1', '["54356761"]', '["01206779923"]', '2015-01-17 07:51:57', 'customer', 0),
(98, 'Minh', NULL, '34 T1', '["54356726"]', '["0907201416"]', '2015-01-17 07:53:41', 'customer', 0),
(99, 'Nga', NULL, '2A T6', '["38161039"]', '["01228676960"]', '2015-01-17 07:54:53', 'customer', 0),
(100, 'Hằng', NULL, '105 T6', '[]', '["0986347309"]', '2015-01-17 07:56:35', 'customer', 0),
(101, 'Thảo', NULL, '92 T6', '["38161040"]', '[]', '2015-01-17 07:58:29', 'customer', 0),
(102, 'Nam', NULL, '81 T6', '["38161921"]', '[]', '2015-01-17 07:59:34', 'customer', 0),
(103, 'Hồng Ân', NULL, '57 CN11', '["54356069"]', '[]', '2015-01-17 08:01:55', 'customer', 0),
(104, NULL, NULL, '72 CN11', '[]', '["0908607617"]', '2015-01-17 08:02:39', 'customer', 0),
(105, 'Mỹ Tiên', NULL, '341/10 Chiến Lược', '[]', '[]', '2015-01-17 08:13:30', 'customer', 0),
(106, 'Vu Lan', NULL, 'F. Bình Trị Đông', '[]', '[]', '2015-01-17 08:15:23', 'customer', 0),
(107, 'Ngọc Yến', NULL, '301 Chiến Lược', '[]', '["0913751986"]', '2015-01-17 08:18:36', 'customer', 0),
(108, 'Hải', NULL, '431 Âu Cơ', '["22287419"]', '[]', '2015-01-18 05:13:29', 'customer', 0),
(109, 'Vy', NULL, '635 Âu Cơ', '["39735383"]', '[]', '2015-01-18 05:13:52', 'customer', 0),
(110, NULL, NULL, '290K Âu Cơ', '[]', '["0908136283"]', '2015-01-18 05:15:12', 'customer', 0),
(111, 'Phụng', NULL, '483/5 Âu Cơ', '["38602116"]', '["0905802288"]', '2015-01-18 05:16:04', 'customer', 0),
(112, NULL, 'đối diện Châu Âu cơ', '958/16 Âu Cơ', '["62966282"]', '["0933347935"]', '2015-01-18 05:18:37', 'customer', 0),
(113, 'Cô Ba', NULL, '39/12A Bờ Bao Tân Thắng', '[]', '["01672936992"]', '2015-01-18 05:21:00', 'customer', 0),
(114, NULL, 'Chùa Định Lâm', '8 Bến Phú Định,F1,Q8', '[]', '["0932068356"]', '2015-01-18 05:31:08', 'customer', 0),
(115, 'Kim Ngân - Nhà anh Hoàng', NULL, '198/7A/5 Bình Thới (đi hẻm 186/21 quẹo qua / đối diện chị Hội)', '[]', '[]', '2015-01-18 05:33:37', 'customer', 0),
(116, 'Thanh', 'Chợ Phú Trung', 'G16-17 Chợ Phú Trung', '[]', '[]', '2015-01-18 05:37:03', 'customer', 0),
(117, NULL, 'Chợ Phú Trung', 'G15 Chợ Phú Trung', '[]', '[]', '2015-01-18 05:37:25', 'customer', 0),
(118, 'Thân', 'chợ Sơn kì', 'K22 chợ Sơn kì', '[]', '[]', '2015-01-18 05:38:37', 'customer', 0),
(119, 'Hồng', 'chợ Sơn kì', 'K43 chợ Sơn kì (82/17 Đỗ Nhuận)', '[]', '[]', '2015-01-18 05:39:35', 'customer', 0),
(120, 'Thảo', 'chợ Sơn kì', 'K49 chợ Sơn kì', '[]', '[]', '2015-01-18 05:40:07', 'customer', 0),
(121, 'Huyền Nam', 'chợ Sơn kì', 'K51 chợ Sơn kì', '[]', '[]', '2015-01-18 05:40:48', 'customer', 0),
(122, 'Đức Phương - anh Toản', 'cửa hàng số 51B', '78/7 Cống Lở,F5,Q tân Bình', '[]', '[]', '2015-01-18 06:16:54', 'customer', 0),
(123, NULL, 'Hoa Hồng', '672 CMT8 ,F5,Q tân Bình', '[]', '[]', '2015-01-18 06:18:32', 'customer', 0),
(124, 'Thành', 'chợ Tân Phú 1', 'H2-3 chợ Tân Phú 1 (chợ phường 17)', '[]', '[]', '2015-01-18 06:20:33', 'customer', 0),
(125, NULL, 'chợ Tân Phú 1', 'H4 chợ Tân Phú 1 (chợ phường 17)', '[]', '[]', '2015-01-18 06:21:09', 'customer', 0),
(126, 'Ngọc Hương', 'chợ Tân Phú 1', 'H11 chợ Tân Phú 1 (chợ phường 17)', '[]', '[]', '2015-01-18 06:21:43', 'customer', 0),
(127, 'Non', 'chợ Tân Phú 2', '8A chợ Tân Phú 2 (chợ phường 18)', '[]', '[]', '2015-01-18 06:22:46', 'customer', 0),
(128, 'Nữ', 'chợ Tân Phú 2', 'Sạp 4 chợ Tân Phú 2 (chợ phường 18)', '[]', '[]', '2015-01-18 06:29:11', 'customer', 0),
(129, 'Cô Bảy', 'chợ Tân Phú 2', 'Kios 4chợ Tân Phú 2 (chợ phường 18)', '[]', '[]', '2015-01-18 06:30:17', 'customer', 0),
(130, 'Anh', 'chợ Tân Phú 2', 'Kios 4 chợ Tân Phú 2 (chợ phường 18)', '[]', '[]', '2015-01-18 06:31:25', 'customer', 0),
(131, 'Hùng Thảo', 'chợ Tân Phú 2', '9 chợ Tân Phú 2 (chợ phường 18)', '[]', '[]', '2015-01-18 06:32:22', 'customer', 0),
(132, 'Bảy Giỏi', 'chợ Tân Phú 2', 'F11 chợ Tân Phú 2 (chợ phường 18)', '[]', '[]', '2015-01-18 06:33:08', 'customer', 0),
(133, 'Hà', 'chợ Tân Phú 2', 'J13 chợ Tân Phú 2 (chợ phường 18)', '[]', '[]', '2015-01-18 06:33:53', 'customer', 0),
(134, 'Mai', 'chợ Tân Phú 2', 'J15 chợ Tân Phú 2 (chợ phường 18)', '[]', '[]', '2015-01-18 06:34:36', 'customer', 0),
(135, 'Thy', 'chợ Tân Phú 2', 'H15 chợ Tân Phú 2 (chợ phường 18)', '[]', '[]', '2015-01-18 06:35:10', 'customer', 0),
(136, 'Tư Hậu', 'chợ Tân Phú 2', 'L16 chợ Tân Phú 2 (chợ phường 18)', '[]', '[]', '2015-01-18 06:36:00', 'customer', 0),
(137, 'Thảo Vy', 'chợ Tân Phú 2', 'M16 chợ Tân Phú 2 (chợ phường 18)', '[]', '[]', '2015-01-18 06:36:39', 'customer', 0),
(138, 'Bích', 'Chợ Tân Hương', 'K10 Chợ Tân Hương', '[]', '[]', '2015-01-18 06:42:19', 'customer', 0),
(139, 'Ngọc Trâm', 'Chợ Tân Hương', 'A2-8 Chợ Tân Hương', '[]', '[]', '2015-01-18 06:43:51', 'customer', 0),
(140, 'Lý', 'Chợ Tân Hương', 'A2-11 Chợ Tân Hương', '[]', '[]', '2015-01-18 06:44:41', 'customer', 0),
(141, 'Nga', 'Chợ Tân Hương', 'A2-12 Chợ Tân Hương', '[]', '[]', '2015-01-18 06:45:50', 'customer', 0),
(142, 'Thúy', 'Chợ Tân Hương', 'A2-15 Chợ Tân Hương', '[]', '[]', '2015-01-18 06:46:46', 'customer', 0),
(143, 'Nga', 'Chợ Tân Hương', 'C2-24 Chợ Tân Hương', '[]', '[]', '2015-01-18 06:47:31', 'customer', 0),
(144, 'Loan', 'Chợ Tân Hương', 'C3-1 Chợ Tân Hương', '[]', '[]', '2015-01-18 06:48:14', 'customer', 0),
(145, 'Mười', 'Chợ Tân Hương', 'C3-6 Chợ Tân Hương', '[]', '[]', '2015-01-18 06:49:57', 'customer', 0),
(146, 'Nga', 'Chợ Tân Hương', 'C3-8 Chợ Tân Hương', '[]', '[]', '2015-01-18 06:51:31', 'customer', 0),
(147, 'Ngã Tư Đất Mới', NULL, '301 Chiến Lược', '[]', '["0913751986"]', '2015-02-08 07:30:36', 'customer', 0),
(148, 'Ngọc Gò Vấp', 'Bảo Ngọc', '134 Cây Trâm (Gò Vấp)', '["33966197","39366197"]', '[]', '2015-02-08 07:51:59', 'customer', 0),
(149, 'Q Lý', 'Sửa Xe Quốc', 'K16 Tô Hiệu', '[]', '["0908698260"]', '2015-02-08 08:24:39', 'customer', 0),
(150, 'Minh Hùng', 'Cty Nhựa Minh Hùng', '103/7 Ao Đôi F. Bình Trị Đông', '[]', '["0903331884"]', '2015-02-08 08:26:15', 'partner', 0),
(151, '', NULL, 'Đối diện Châu Âu Cơ', '[]', '["0933347935"]', '2015-02-08 08:27:14', 'customer', 0),
(152, 'Nguyễn Thị Duyên', NULL, '688/83/2 F. Bình Hưng Hòa', '[]', '["0966038138","0973801801"]', '2015-02-08 08:29:30', 'customer', 0),
(153, 'Hường', NULL, NULL, '[]', '["0938351936"]', '2015-02-08 08:29:58', 'customer', 0),
(154, 'Huỳnh Văn Nghệ', NULL, NULL, '[]', '["0903388621"]', '2015-02-08 08:30:27', 'customer', 0),
(155, 'Anh Định', NULL, '293 Bình Long F. Bình Hưng Hòa', '["62655723"]', '[]', '2015-02-08 08:31:37', 'customer', 0),
(156, '', NULL, '670 Bình Long', '[]', '[]', '2015-02-08 08:32:03', 'customer', 0),
(157, NULL, 'Hợp Thành', '166 Bình Long F. Phú Thạnh', '[]', '[]', '2015-02-08 08:33:04', 'customer', 0),
(158, NULL, NULL, '206 Bình Long', '[]', '[]', '2015-02-08 08:33:20', 'customer', 0),
(159, 'Nguyệt', NULL, '194 Bình Long ( Bệnh Viện Tân Phú)', '[]', '["0907603653"]', '2015-02-08 08:34:37', 'customer', 0),
(160, 'Anh Toản', 'Đức Phương', 'F15 Q. Tân Bình', '["38155327"]', '["0909660552"]', '2015-02-08 08:37:03', 'customer', 0),
(161, 'Tường Vy', '', 'Nhà Giữ Xe Lộ B Chung Cư Sơn Kỳ', '["66753006"]', '[]', '2015-02-08 08:38:28', 'customer', 0),
(162, NULL, NULL, '005 Lô B Chung Cư Sơn Kỳ', '[]', '["0984063592"]', '2015-02-08 08:39:06', 'customer', 0),
(163, 'Huyền Nam', NULL, 'K51  Chợ Sơn Kỳ', '[]', '[]', '2015-02-08 08:40:09', 'customer', 0),
(164, 'Chị Hồng', NULL, 'K43 Chợ Sơn Kỳ', '[]', '[]', '2015-02-08 08:40:51', 'customer', 0),
(165, 'Trực', NULL, '92 Huỳnh Văn Nghệ', '[]', '["0903388621"]', '2015-02-08 08:41:23', 'customer', 0),
(166, NULL, NULL, '18/95 Đỗ Nhuận', '["62765143"]', '["0918171206"]', '2015-02-08 08:42:15', 'customer', 0),
(167, NULL, 'Đức Phât', '382 A Đất Mới F. Bình Trị Đông', '["22473515"]', '["0918171206"]', '2015-02-08 08:43:13', 'customer', 0),
(168, 'Toàn', NULL, '264 Kinh Dương Vương', '[]', '["0969599995","0935576689"]', '2015-02-08 08:44:22', 'customer', 0),
(169, 'Thanh Thu', NULL, '82 DC 9 F. Sơn Kỳ', '["54441813"]', '[]', '2015-02-08 08:45:09', 'customer', 0),
(170, 'Đức Thịnh', NULL, '72 Độc Lập', '["58125519"]', '[]', '2015-02-08 08:45:42', 'customer', 0),
(171, NULL, NULL, '84 Dương Quảng Hàm', '["38953102"]', '["0987290029","0906777849"]', '2015-02-08 08:47:11', 'customer', 0),
(172, NULL, NULL, '2F DC9 F. Sơn Kỳ', '["62655369"]', '[]', '2015-02-08 08:47:56', 'customer', 0),
(173, '', NULL, '172 Đỗ Bí', '["38609250"]', '[]', '2015-02-08 08:48:28', 'customer', 0),
(174, '', NULL, '30/35 Đỗ Nhuận F. Sơn Kỳ', '["66511059"]', '["0973015139"]', '2015-02-08 08:49:39', 'customer', 0),
(175, NULL, 'Minh Thiện', '76 Độc Lập F. Tân Thành', '["38497828"]', '[]', '2015-02-08 08:50:36', 'customer', 0),
(176, 'Lệ', 'Kim Hồng', '155 Kinh Dương Vương', '["54080158"]', '[]', '2015-02-08 08:51:49', 'customer', 0),
(177, NULL, NULL, '38 Đình Nghi Xuân', '[]', '["0907738422"]', '2015-02-08 08:52:13', 'customer', 0),
(178, NULL, 'Quốc Lập', '83 Điện Cao Thế F. Tân Sơn Nhì', '["38130190","38427045"]', '[]', '2015-02-08 08:53:26', 'customer', 0),
(179, NULL, NULL, '83 Đô Đốc Lập', '[]', '["01647399379"]', '2015-02-08 08:54:10', 'customer', 0),
(180, 'Thái', NULL, 'Dương Văn Dương', '[]', '["0903655445"]', '2015-02-08 08:54:35', 'customer', 0),
(181, NULL, NULL, '18/97 Đỗ Nhuận', '[]', '["0938621523"]', '2015-02-08 08:55:02', 'customer', 0),
(182, NULL, NULL, '199 Độc Lập', '[]', '["0938772500"]', '2015-02-08 08:55:28', 'customer', 0),
(183, NULL, 'Hồng Quang', '38/1/14 Đô Đốc Long', '[]', '["0909410432"]', '2015-02-08 08:56:13', 'customer', 0),
(184, 'Ngô Ngọc', NULL, '84 Dương Quảng Hàm', '["38953102"]', '["0987290029"]', '2015-02-08 08:56:59', 'customer', 0),
(185, 'Chị vuông', NULL, '128 Đỗ Bí', '[]', '["0975464377"]', '2015-02-08 09:01:17', 'customer', 0),
(186, 'Đối diện Đức Phát', NULL, '475 Đất Mới', '[]', '["01699646855"]', '2015-02-08 09:02:46', 'customer', 0),
(187, 'Trường Nam Việt', NULL, '25 Dương Đức Hiền', '[]', '["0909660848"]', '2015-02-08 09:03:38', 'customer', 0),
(188, NULL, NULL, '25 Dương Khuê', '[]', '["0902880225"]', '2015-02-08 09:04:20', 'customer', 0),
(189, 'Thành', NULL, '362 A Đặng Thúc Vinh', '[]', '["0977785742"]', '2015-02-08 09:05:20', 'customer', 0),
(190, 'Huy', NULL, '99 Đỗ Đức Dục', '["38648499"]', '[]', '2015-02-08 09:05:55', 'customer', 0),
(191, '', 'Phương Dung', '13 Đỗ Thừa Luông', '[]', '["0902338554"]', '2015-02-08 09:06:42', 'customer', 0),
(192, 'Lan', NULL, '33 Đỗ Thừa Luông', '["62655596"]', '["0908671110"]', '2015-02-08 09:07:23', 'customer', 0),
(193, NULL, NULL, '44 Đỗ Đức Dục', '[]', '[]', '2015-02-08 09:07:47', 'customer', 0),
(194, '', 'Cẩm Tú', '34 Độc Lập', '[]', '["01228609726"]', '2015-02-08 09:08:32', 'customer', 0),
(195, NULL, 'Đức Phát', '20 Độc Lập', '["38496683"]', '[]', '2015-02-08 09:09:07', 'customer', 0),
(196, NULL, NULL, '332/17 Độc Lập', '["54080496"]', '[]', '2015-02-08 09:09:40', 'customer', 0),
(197, '', 'Lan Hào', '178 Độc Lập', '["38427729"]', '[]', '2015-02-08 09:10:17', 'customer', 0),
(198, NULL, 'Thùy Dương', '250 Độc Lập', '["62731164"]', '["0906802108"]', '2015-02-08 09:11:02', 'customer', 0),
(199, NULL, 'Sơn Lâm', '60 Dương Văn Dương', '["38470873"]', '[]', '2015-02-08 09:11:43', 'customer', 0),
(200, 'Anh Minh', NULL, '58 Dương Văn Dương', '["22178851"]', '[]', '2015-02-08 09:12:27', 'customer', 0),
(201, NULL, NULL, '93 Dương Văn Dương', '["40855021"]', '[]', '2015-02-08 09:13:27', 'customer', 0),
(202, 'Hà', NULL, '11/27 Dương Đức Hiền', '[]', '["0907909841"]', '2015-02-08 09:14:28', 'customer', 0),
(203, 'Hiền', NULL, '11/30 Dương Đức Hiền', '["38162303"]', '[]', '2015-02-08 09:15:06', 'customer', 0),
(204, 'Cô Bích', NULL, '14/17 Đỗ Thừa Luông', '[]', '[]', '2015-02-08 09:15:40', 'customer', 0),
(205, 'Cô Tư', 'Khánh Ngọc', '70 Đỗ Thị Tâm', '[]', '["01264597655"]', '2015-02-08 09:16:16', 'customer', 0),
(206, 'Phạm Thị Lý', NULL, '164 Đỗ Đình Thám', '[]', '[]', '2015-02-08 09:17:09', 'customer', 0),
(207, NULL, 'Hợp Tác Xã Sơn Kỳ', '18/2A Đỗ Nhuận', '["62693229"]', '["0909580576"]', '2015-02-08 09:18:18', 'customer', 0),
(208, 'Hà', NULL, '278 Gò Dầu F. Tân Quý', '[]', '["0937338791","914002921"]', '2015-02-08 10:14:45', 'customer', 0),
(209, 'Xuân Hoa', NULL, '266 Gò Dầu', '["38470646","66725693"]', '["0907272332"]', '2015-02-08 10:15:45', 'customer', 0),
(210, 'Lê Văn', NULL, '98 Gò Dầu', '["54080624"]', '[]', '2015-02-08 10:16:18', 'customer', 0),
(211, 'Minh Liên', NULL, '48 Gò Dầu', '["8417385"]', '["0937919046"]', '2015-02-08 10:17:14', 'customer', 0),
(212, 'Huy Hiếu', NULL, '230 Gò Dầu', '["38470873"]', '[]', '2015-02-08 10:17:48', 'customer', 0),
(213, 'Tuyết', NULL, '159 Gò Dầu', '["54449665"]', '[]', '2015-02-08 10:18:25', 'customer', 0),
(214, '', 'Thảo Hiền', '238 Gò Dầu', '["35590963"]', '[]', '2015-02-08 10:19:02', 'customer', 0),
(215, 'Duyệt', NULL, '212 Gò Dầu', '[]', '["913116606"]', '2015-02-08 10:19:52', 'customer', 0),
(216, 'Việt', NULL, '210 Gò Dầu', '["36085550","38473471"]', '[]', '2015-02-08 10:20:46', 'customer', 0),
(217, NULL, NULL, '33 Gò Dầu', '[]', '["0902650921"]', '2015-02-08 10:21:09', 'customer', 0),
(218, NULL, NULL, '430 Gò Dầu', '["35590021"]', '[]', '2015-02-08 10:21:34', 'customer', 0),
(219, NULL, 'Bình Mai', '148 Gò Dầu', '["54084966"]', '[]', '2015-02-08 10:22:01', 'customer', 0),
(220, NULL, 'Trung Nghĩa', '326 Gò Dầu', '[]', '["0937598932"]', '2015-02-08 10:22:37', 'customer', 0),
(221, NULL, NULL, '101/17/16 Gò Dầu', '["38470186"]', '["0909361768","0906834044"]', '2015-02-08 10:23:39', 'customer', 0),
(222, NULL, 'Cửa Hàng Tự Chọn Fret Food', '73 Gò Dầu', '["39251435"]', '["0916803038"]', '2015-02-08 10:25:05', 'customer', 0),
(223, NULL, NULL, '53 Gò Xoài', '["22421142"]', '[]', '2015-02-08 10:25:36', 'customer', 0),
(224, NULL, 'Tân Bội Bội', '77 Gò xoài', '[]', '["0977898567"]', '2015-02-08 10:26:09', 'customer', 0),
(225, NULL, NULL, '209 Gò Xoài', '["66799802"]', '[]', '2015-02-08 10:26:41', 'customer', 0),
(226, NULL, NULL, '58 Gò Xoài', '["38756360"]', '[]', '2015-02-08 10:27:03', 'customer', 0),
(227, NULL, 'Gia Phúc', NULL, '[]', '["0907030028"]', '2015-02-08 10:27:59', 'customer', 0),
(228, NULL, 'Thảo Vy', '38 Hoàng Ngọc Phách', '[]', '["0934751844"]', '2015-02-08 10:28:30', 'customer', 0),
(229, 'Quế (Vinamilk)', NULL, '38/3 Hoàng Ngọc Phách', '[]', '[]', '2015-02-08 10:29:40', 'customer', 0),
(230, 'Quýt', NULL, '59 Hiền Vương', '[]', '["909137703"]', '2015-02-08 10:30:18', 'customer', 0),
(231, NULL, 'Tuyết Trinh', '293 Hiền Vương', '["38611409"]', '[]', '2015-02-08 10:30:50', 'customer', 0),
(232, 'Hạnh', 'Phú Thịnh', '85 Hiền Vương', '["35440340","54340345"]', '[]', '2015-02-08 10:31:45', 'customer', 0),
(233, NULL, 'Tuyết Nhi', '316 Hiền Vương', '["38476213","39782764"]', '[]', '2015-02-08 10:32:28', 'customer', 0),
(234, NULL, 'Thảo Huy', '105 Hoàng Ngọc Phách F. Tân Thới Hòa', '["38606142"]', '[]', '2015-02-08 10:33:19', 'customer', 0),
(235, 'Hằng', NULL, '37 Hoàng Ngọc Phách', '["54086422"]', '[]', '2015-02-08 10:34:02', 'customer', 0),
(236, 'Phương', NULL, '18/9 Hoàng Ngọc Phách', '["38607407"]', '[]', '2015-02-08 10:34:27', 'customer', 0),
(237, 'Huỳnh', NULL, '8/26 Hoàng Ngọc Phách', '[]', '["0903166627"]', '2015-02-08 10:35:13', 'customer', 0),
(238, 'Thủy', NULL, '95 Hoàng Ngọc Phách', '["384273902"]', '[]', '2015-02-08 10:35:48', 'customer', 0),
(239, 'Hiền', 'Sông Hương', '32 Hoàng Ngọc Phách', '[]', '["0903774436"]', '2015-02-08 10:36:21', 'customer', 0),
(240, NULL, 'Bách Hóa', '43 Hoàng Ngọc Phách', '["38623023"]', '[]', '2015-02-08 10:37:03', 'customer', 0),
(241, NULL, 'Ngọc Anh', '18/3 Hoàng Ngọc Phách', '["38606029","38648799"]', '[]', '2015-02-08 10:37:52', 'customer', 0),
(242, 'Hồng', NULL, '80 Hoàng Xuân Nhị', '[]', '["1268792021"]', '2015-02-08 10:38:29', 'customer', 0),
(243, 'Hà', NULL, '92 Hoàng Xuân Nhị', '[]', '["909719689"]', '2015-02-08 10:38:59', 'customer', 0),
(244, 'Chánh', NULL, '95 Hoàng Xuân Nhị', '["84532412"]', '[]', '2015-02-08 10:40:03', 'customer', 0),
(245, 'Thái', 'Thảo Nguyên', '128 Huỳnh Thiện Lộc', '["39730076"]', '[]', '2015-02-08 10:40:45', 'customer', 0),
(246, 'Tuấn', NULL, '106 Huỳnh Thiện Lộc', '[]', '["0903852168"]', '2015-02-08 10:41:15', 'customer', 0),
(247, 'Hải', NULL, '35 Huỳnh Thiện Lộc', '[]', '["0937582168"]', '2015-02-08 10:41:45', 'customer', 0),
(248, 'Châu', NULL, '16 Huỳnh Thiện Lộc', '["386523544"]', '[]', '2015-02-08 10:42:12', 'customer', 0),
(249, NULL, NULL, '45/53 Huỳnh Thiện Lộc', '["39737334"]', '["0906644087"]', '2015-02-08 10:42:42', 'customer', 0),
(250, NULL, NULL, '42/23 Huỳnh Thiện Lộc', '[]', '["0909707038"]', '2015-02-08 10:43:08', 'customer', 0),
(251, NULL, NULL, '53 Đoàn Hồng Phước', '["39737734"]', '["0906644087"]', '2015-02-08 10:43:52', 'customer', 0),
(252, 'Hạnh', 'Thúy Nga', '42/60/1 Hồ Đắc Di', '["38120861"]', '["0935367472"]', '2015-02-08 10:46:18', 'customer', 0),
(253, 'Yến', NULL, '42/32 Hồ Đắc Di', '["62841324"]', '[]', '2015-02-08 10:47:00', 'customer', 0),
(254, 'Linh', NULL, '18 Hồ Đắc Di', '["38151676"]', '[]', '2015-02-08 10:47:24', 'customer', 0),
(255, 'Huỳnh', NULL, '42 Hồ Đắc Di', '["38120708"]', '["0907399109"]', '2015-02-08 10:48:00', 'customer', 0),
(256, 'Trinh', NULL, '20/66/4', '["38427184","38121385"]', '[]', '2015-02-08 10:48:48', 'customer', 0),
(257, NULL, 'Đinh Tuấn', '20/8 Hồ Đắc Di', '["66574781"]', '["5933531235"]', '2015-02-08 10:49:19', 'customer', 0),
(258, 'Ngoan', NULL, '69 Hoàng Văn Hòe', '["835590491"]', '[]', '2015-02-08 10:49:47', 'customer', 0),
(259, 'Oanh', NULL, '45 Hoàng Văn Hòe', '["46801855"]', '[]', '2015-02-08 10:50:11', 'customer', 0),
(260, NULL, NULL, '495 HL2 F. Bình Trị Đông', '["38759364"]', '[]', '2015-02-08 10:50:39', 'customer', 0),
(261, NULL, 'Kim Hạnh', '736 Hoàng Văn Hòe', '["22423209"]', '["0918766798"]', '2015-02-08 10:51:12', 'customer', 0),
(262, NULL, NULL, '564 Hoàng Văn Hòe', '[]', '["0902778507"]', '2015-02-08 10:51:45', 'customer', 0),
(263, 'Ngọc', 'Tuấn Khôi', '486 Hoàng Văn Hòe', '[]', '["0933732899"]', '2015-02-08 10:52:23', 'customer', 0),
(264, NULL, NULL, '457 Hoàng Văn Hòe', '["54355438"]', '[]', '2015-02-08 10:52:48', 'customer', 0),
(265, NULL, 'Điềm Thúy', '680 Hoàng Văn Hòe', '[]', '["0933770411","0918763250"]', '2015-02-08 10:53:59', 'customer', 0),
(266, NULL, 'Bãi Xe Thanh Tòng', '549 Hoàng Văn Hòe', '[]', '["0906304168"]', '2015-02-08 10:54:38', 'customer', 0),
(267, NULL, 'Thanh Vi', '426 Hoàng Văn Hòe', '[]', '["0908088074"]', '2015-02-08 10:55:31', 'customer', 0),
(268, NULL, 'NPP Kim Hoa-Cafe Việt', '907/42 Hoàng Văn Hòe', '[]', '[]', '2015-02-08 10:56:44', 'partner', 0),
(269, 'Minh', NULL, 'HL 3', '["37503242"]', '[]', '2015-02-08 10:57:10', 'customer', 0),
(270, 'Thủy', 'Siêu Thị Sữa', 'Huỳnh Văn Bánh', '[]', '["01225717322"]', '2015-02-08 10:58:29', 'customer', 0),
(271, 'Đức', NULL, '38 Ích Thiện', '["38104039"]', '["0936175294"]', '2015-02-08 10:59:05', 'customer', 0),
(272, NULL, NULL, '129 Hiền Vương', '["38610920"]', '[]', '2015-02-08 11:00:46', 'customer', 0),
(273, NULL, 'Nhấn Ngọc', '31A Hiền Vương F. Phú Thạnh', '["38610776"]', '["0909891654"]', '2015-02-08 11:01:29', 'customer', 0),
(274, 'Linh (gạo)', NULL, '213 B Hiền Vương', '[]', '["0909179911"]', '2015-02-08 11:02:06', 'customer', 0),
(275, NULL, 'Ngọc Trinh', '12 Hiền Vương', '["38605064","38608538"]', '[]', '2015-02-08 11:03:14', 'customer', 0),
(276, NULL, NULL, '5 Hoàng Xuân Nhị', '[]', '["01665514383"]', '2015-02-08 11:03:37', 'customer', 0),
(277, NULL, 'Titi', '34 Hoàng Xuân Nhị F.Phú Trung', '["39744798"]', '[]', '2015-02-08 11:04:13', 'customer', 0),
(278, 'Phú', NULL, '41/2 Hoàng Lê Kha F9 Q6', '["39698527"]', '["0918030207"]', '2015-02-08 11:05:26', 'customer', 0),
(279, 'Phương', NULL, '237/32/2 Hòa Bình F.Hiệp Tân', '["22370944"]', '[]', '2015-02-08 11:06:05', 'customer', 0),
(280, NULL, NULL, '100 Hòa Bình', '[]', '["01226282742"]', '2015-02-08 11:06:32', 'customer', 0),
(281, NULL, 'Phương Linh', '44 Hòa Bình', '["38651116"]', '[]', '2015-02-08 11:07:03', 'customer', 0),
(282, NULL, NULL, '45 Hòa Bình', '["62547647"]', '[]', '2015-02-08 11:07:26', 'customer', 0),
(283, NULL, NULL, '115 Hòa Bình', '[]', '["0918733673"]', '2015-02-08 11:07:48', 'customer', 0),
(284, NULL, 'Sơn tĩnh điện', '290 Hòa Bình (hẻm)', '["66746795"]', '[]', '2015-02-08 11:08:34', 'customer', 0),
(285, '', 'Lưu Luyến', '66 Hòa Hưng F13 Q10', '[]', '["0938715737","0918844921"]', '2015-02-08 11:09:25', 'customer', 0),
(286, NULL, NULL, '107 Huỳnh Văn Một', '[]', '["0978543543"]', '2015-02-08 11:10:21', 'customer', 0),
(287, NULL, NULL, '85 Huỳnh Tấn Phát', '["38729812"]', '[]', '2015-02-08 11:10:43', 'customer', 0),
(288, 'Nga (mèo)', NULL, '28 Học Lạc', '["38577050","38565075"]', '[]', '2015-02-08 11:11:43', 'customer', 0),
(289, 'Trực', NULL, '92 Huỳnh Văn Nghệ', '[]', '["0903388621"]', '2015-02-08 11:12:11', 'customer', 0),
(290, 'Phúc', NULL, '330 Hồng Lạc', '[]', '["01664299947"]', '2015-02-08 11:14:32', 'customer', 0),
(291, '', 'Thanh Vy', '142/22 Thoại Ngọc Hầu', '[]', '["0982953039"]', '2015-02-08 11:15:08', 'customer', 0),
(292, 'Cường (thuốc)', NULL, NULL, '["0937056137"]', '[]', '2015-02-08 11:15:53', 'customer', 0),
(293, 'Hiếu (điện)', '7 Tân', NULL, '[]', '["0938385951"]', '2015-02-08 11:16:24', 'customer', 0),
(294, 'Nhã (xây dựng)', NULL, NULL, '[]', '["01224932229"]', '2015-02-08 11:16:48', 'customer', 0),
(295, 'Dũng', 'Tụ Bù', NULL, '[]', '["0903617853"]', '2015-02-08 11:17:17', 'customer', 0),
(296, 'Kiệt (2 Khiêm)', NULL, NULL, '[]', '["0907366755"]', '2015-02-08 11:17:49', 'customer', 0),
(297, 'Kim Sơn', NULL, NULL, '[]', '["0977994895"]', '2015-02-08 11:18:07', 'customer', 0),
(298, 'Chị 3 Ngọc', NULL, '228 Lô M chung cư Ngô Gia Tự F2 Q10', '[]', '["0908270993","0934048751"]', '2015-02-08 11:19:09', 'customer', 0),
(299, 'Bằng (cô 9)', NULL, NULL, '[]', '["01697105199"]', '2015-02-08 11:19:30', 'customer', 0),
(300, 'Ngân', NULL, NULL, '[]', '["01292807367"]', '2015-02-08 11:19:54', 'customer', 0),
(301, 'Tín', NULL, NULL, '[]', '["01669293737"]', '2015-02-08 11:20:17', 'customer', 0),
(302, 'Cô 5 (Út Lưu)', NULL, NULL, '[]', '["0723886210"]', '2015-02-08 11:20:55', 'customer', 0),
(303, 'Sơn (bác  2 Tâm)', NULL, '70 Đồng Nai TT. Tam Đảo', '[]', '["0934170684"]', '2015-02-08 11:21:43', 'customer', 0),
(304, 'Năm Kiểng', NULL, NULL, '[]', '["0902809895"]', '2015-02-08 11:22:09', 'customer', 0),
(305, 'Kiệt Linh', NULL, NULL, '[]', '["0938524209"]', '2015-02-08 11:22:28', 'customer', 0),
(306, 'Công an F. Hiệp Tân', NULL, NULL, '["39612769"]', '[]', '2015-02-08 11:22:57', 'customer', 0),
(307, 'Lực ( thợ máy ô tô)', NULL, NULL, '[]', '["0937194702"]', '2015-02-08 11:23:54', 'customer', 0),
(308, 'Giang (hộp đen ô tô)', NULL, NULL, '[]', '["0938314313"]', '2015-02-08 11:24:18', 'customer', 0),
(309, 'Bảo (nv)', NULL, NULL, '[]', '["01693915106"]', '2015-02-08 11:24:46', 'customer', 0),
(310, 'Nghỉ (A One)', NULL, NULL, '[]', '["0973330290"]', '2015-02-08 11:25:18', 'customer', 0),
(311, 'Bình (CSGT Q6)', NULL, NULL, '[]', '["0908375239"]', '2015-02-08 11:25:51', 'customer', 0),
(312, 'Cô Giáo Phương (nước tương)', NULL, NULL, '[]', '["0933918836"]', '2015-02-08 11:26:30', 'customer', 0),
(313, 'Dũng (tiếp thị)', NULL, NULL, '[]', '["0933918836"]', '2015-02-08 11:26:58', 'customer', 0),
(314, 'Khóm (nv)', NULL, NULL, '[]', '["0188557411"]', '2015-02-08 11:27:19', 'customer', 0),
(315, 'Huy (tài xế)', NULL, NULL, '[]', '["01286998694"]', '2015-02-08 11:27:44', 'customer', 0),
(316, NULL, NULL, '169 D Kênh Tân Hóa', '[]', '["0902963428"]', '2015-02-08 11:28:36', 'customer', 0),
(317, NULL, 'Anh Thư', '409 Kênh Tân Hóa', '["54068462"]', '[]', '2015-02-08 11:29:08', 'customer', 0),
(318, 'Vang', NULL, '325/8 Kênh Tân Hóa', '["39730141"]', '[]', '2015-02-08 11:29:41', 'customer', 0),
(319, 'Hải', NULL, '173/41 Khuông Việt', '["62730594"]', '[]', '2015-02-08 11:30:08', 'customer', 0),
(320, 'Thu', NULL, '15/7 Khuông Việt', '[]', '["0937171487"]', '2015-02-08 11:30:40', 'customer', 0),
(321, 'Hải', NULL, '173/94', '["62730584"]', '[]', '2015-02-08 11:31:10', 'customer', 0),
(322, NULL, 'Bách Hóa 210', '210 Khuông Việt', '["38853137"]', '[]', '2015-02-08 11:31:39', 'customer', 0),
(323, 'An', NULL, '173/45/94 Khuông Việt', '["38618679"]', '[]', '2015-02-08 11:32:07', 'customer', 0),
(324, 'Châu', NULL, '211 Khuông Việt', '["38605161"]', '[]', '2015-02-08 11:32:44', 'customer', 0),
(325, 'Trang', NULL, '213/79/22', '["39742258"]', '[]', '2015-02-08 11:33:06', 'customer', 0),
(326, 'Tuyết', NULL, '173/45/12', '[]', '["0979825089"]', '2015-02-08 11:33:38', 'customer', 0),
(327, 'Liên', 'Thảo Vi', '162 Khuông Việt', '["62652928"]', '["0906952459","0906954459"]', '2015-02-08 11:34:25', 'customer', 0),
(328, 'Linh', NULL, '173/20 Khuông Việt', '[]', '["01224942308"]', '2015-02-08 11:34:54', 'customer', 0),
(329, NULL, NULL, '278 Khuông Việt', '[]', '["0128789830"]', '2015-02-08 11:35:21', 'customer', 0),
(330, NULL, NULL, '268 Khuông Việt', '[]', '["0909531786"]', '2015-02-08 11:36:17', 'customer', 0),
(331, 'Hội', NULL, '128 Khuông Việt', '["66731450"]', '[]', '2015-02-08 11:36:44', 'customer', 0),
(332, NULL, NULL, '299/4 Khuông Việt', '[]', '["0982392425"]', '2015-02-08 11:37:13', 'customer', 0),
(333, 'Trang', '', NULL, '["9742258"]', '[]', '2015-02-08 11:38:18', 'customer', 0),
(334, NULL, NULL, '293/13 Khuông Việt', '[]', '["0903826836"]', '2015-02-08 11:39:38', 'customer', 0),
(335, NULL, NULL, '300/9 Khuông Việt', '[]', '["0907139487"]', '2015-02-08 11:40:08', 'customer', 0),
(336, NULL, 'Sơn Trang', '213/79/22 Khuông Việt', '["39742258"]', '[]', '2015-02-08 11:40:39', 'customer', 0),
(337, NULL, NULL, '178 Khuông Việt', '[]', '["0938798245"]', '2015-02-08 11:41:02', 'customer', 0),
(338, NULL, NULL, '278 Khuông Việt', '[]', '["01287898305"]', '2015-02-08 11:41:24', 'customer', 0),
(339, 'Yến', NULL, '38 Khiếu Năng Tĩnh', '["37515987"]', '["09744412204"]', '2015-02-08 11:42:12', 'customer', 0),
(340, 'Toàn', 'Phú Đường', '264 Kinh Dương Vương', '["22150041"]', '["0969599995"]', '2015-02-08 11:43:16', 'customer', 0);

-- --------------------------------------------------------

--
-- Table structure for table `export_bill`
--

CREATE TABLE IF NOT EXISTS `export_bill` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `warehouse_from` bigint(20) DEFAULT NULL,
  `warehouse_to` bigint(20) DEFAULT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=4 ;

--
-- Dumping data for table `export_bill`
--

INSERT INTO `export_bill` (`id`, `warehouse_from`, `warehouse_to`, `created`) VALUES
(1, 2, 4, '2014-11-27 18:28:57'),
(2, 1, 2, '2014-12-01 13:32:15'),
(3, 3, 5, '2014-12-02 15:43:11');

-- --------------------------------------------------------

--
-- Table structure for table `export_detail`
--

CREATE TABLE IF NOT EXISTS `export_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `export_id` bigint(20) DEFAULT NULL,
  `product_id` bigint(20) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=7 ;

--
-- Dumping data for table `export_detail`
--

INSERT INTO `export_detail` (`id`, `export_id`, `product_id`, `quantity`) VALUES
(1, 1, 1, 2),
(2, 1, 2, 4),
(3, 2, 1, 4),
(4, 2, 2, 2),
(5, 3, 2, 5),
(6, 3, 3, 3);

-- --------------------------------------------------------

--
-- Table structure for table `order`
--

CREATE TABLE IF NOT EXISTS `order` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `customer_id` bigint(20) DEFAULT NULL,
  `total_price` bigint(20) DEFAULT NULL,
  `delivery` enum('1','0') COLLATE utf8_unicode_ci DEFAULT '0',
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT '2',
  `shipment_id` int(11) DEFAULT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=5 ;

--
-- Dumping data for table `order`
--

INSERT INTO `order` (`id`, `customer_id`, `total_price`, `delivery`, `status`, `shipment_id`, `created`) VALUES
(1, 4, 2192500, '1', '6', 1, '2015-02-01 16:42:07'),
(2, NULL, 2495000, '1', '1', 2, '2015-02-08 09:26:17'),
(3, NULL, 45000, '0', '2', NULL, '2015-02-08 09:36:21'),
(4, 113, 390000, '0', '2', NULL, '2015-02-08 09:41:50');

-- --------------------------------------------------------

--
-- Table structure for table `order_detail`
--

CREATE TABLE IF NOT EXISTS `order_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) DEFAULT NULL,
  `product_id` bigint(20) DEFAULT NULL,
  `quantity` bigint(20) DEFAULT NULL,
  `unit` bigint(20) DEFAULT NULL,
  `cost` int(11) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `total` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=8 ;

--
-- Dumping data for table `order_detail`
--

INSERT INTO `order_detail` (`id`, `order_id`, `product_id`, `quantity`, `unit`, `cost`, `price`, `total`) VALUES
(1, 1, 1, 10, 113, 0, 78000, 780000),
(2, 1, 8, 15, 33, 0, 5500, 82500),
(3, 1, 23, 10, 67, 0, 133000, 1330000),
(4, 2, 3, 15, 23, 0, 3000, 45000),
(5, 2, 2, 10, 19, 0, 245000, 2450000),
(6, 3, 3, 15, 23, 0, 3000, 45000),
(7, 4, 1, 5, 113, 26, 78000, 390000);

-- --------------------------------------------------------

--
-- Table structure for table `order_status_type`
--

CREATE TABLE IF NOT EXISTS `order_status_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=6 ;

--
-- Dumping data for table `order_status_type`
--

INSERT INTO `order_status_type` (`id`, `name`) VALUES
(1, 'Đang Giao'),
(2, 'Đang lên'),
(3, 'Đã Giao'),
(4, 'Xuất lại kho'),
(5, 'Để Lại');

-- --------------------------------------------------------

--
-- Table structure for table `position`
--

CREATE TABLE IF NOT EXISTS `position` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `position`
--

INSERT INTO `position` (`id`, `name`) VALUES
(1, 'NV bán hàng'),
(2, 'Tài xế'),
(3, 'Bốc xếp');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE IF NOT EXISTS `products` (
  `id` bigint(25) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `product_type` int(255) DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated` timestamp NULL DEFAULT NULL,
  `active` int(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=145 ;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `code`, `name`, `product_type`, `description`, `created`, `updated`, `active`) VALUES
(1, '8934563307448', 'Thùng Hảo 100 nhỏ (32)', 1, '', '2015-01-17 16:23:03', NULL, 0),
(2, '8934563303778', 'Thùng Hảo 100 lớn', 1, '', '2015-01-17 15:56:49', NULL, 0),
(3, '8934563123130', 'Gói Hảo 100 Chua Cay', 1, '', '2015-01-17 16:02:52', NULL, 0),
(4, '8934563138165', 'Gói Hảo Chua Cay', 1, '', '2015-01-17 16:08:05', NULL, 0),
(5, '8934563305049', 'Thùng Hảo Chua Cay (32)', 1, NULL, '2015-01-17 16:23:12', NULL, 0),
(6, '8934563305048', 'Thùng Hảo Chua Cay (30)', 1, NULL, '2015-01-17 16:23:19', NULL, 0),
(7, '8934563070748', 'Thùng Nhịp Sống Bò Kho (32)', 1, NULL, '2015-01-17 16:23:51', NULL, 0),
(8, '8934563461140', 'Gói Nhịp Sống Bò Kho', 1, NULL, '2015-01-17 16:21:06', NULL, 0),
(9, '8934563070847', 'Thùng Nhịp Sống Nam Vang (32)', 1, NULL, '2015-01-17 16:22:55', NULL, 0),
(10, '8934563455149', 'Gói Nhịp Sống Nam Vang', 1, NULL, '2015-01-17 16:24:35', NULL, 0),
(11, '8934563032210', 'Thùng Mì Ly Enjoy LTCC', 1, NULL, '2015-01-17 16:27:54', NULL, 0),
(12, '8934563643157', 'Ly Enjoy LTCC', 1, NULL, '2015-01-17 16:28:50', NULL, 0),
(13, '8934563306847', 'Thùng Hảo TXCN (30)', 1, NULL, '2015-01-17 16:33:05', NULL, 0),
(14, '8934563151157', 'Gói Hảo TXCN', 1, NULL, '2015-01-17 16:34:15', NULL, 0),
(15, '8934563150549', 'Thùng Hảo TH (30)', 1, NULL, '2015-01-17 16:35:32', NULL, 0),
(16, '8934563805159', 'Gói Mì Hảo TH', 1, NULL, '2015-01-17 16:36:41', NULL, 0),
(17, '18934684026164', 'Thùng Mì Aone (32)', 1, NULL, '2015-01-17 16:38:48', NULL, 0),
(18, '8934684026167', 'Gói Mì Aone', 1, NULL, '2015-01-17 16:39:24', NULL, 0),
(19, '8934563309442', 'Thùng Mì Chíp Chíp TCC (33)', 1, NULL, '2015-01-17 16:41:00', NULL, 0),
(20, '8934563148133', 'Gói Mì Chíp Chíp TCC', 1, NULL, '2015-01-17 16:41:51', NULL, 0),
(21, '08934684129080', 'Thùng Mì Sức Sống LTCC (30)', 1, NULL, '2015-01-17 16:43:52', NULL, 0),
(22, '8934684029083', 'Gói Mì Sức Sống LTCC', 1, NULL, '2015-01-17 16:44:50', NULL, 0),
(23, '8934563251543', 'Thùng Phở Bò Đệ Nhất (32)', 1, NULL, '2015-01-17 16:47:09', NULL, 0),
(24, '8934563215132', 'Gói Phở Bò Đệ Nhất', 1, NULL, '2015-01-17 16:48:06', NULL, 0),
(25, '8934563250133', 'Thùng Phở Xưa Nay (24)', 1, NULL, '2015-01-17 16:49:41', NULL, 0),
(26, '8934563201142', 'Gói Phở Xưa Nay', 1, NULL, '2015-01-17 16:50:12', NULL, 0),
(27, '8934563247249', 'Thùng Bún Hằng Nga BGH (30)', 1, NULL, '2015-01-17 16:51:41', NULL, 0),
(28, '8934563973155', 'Gói Bún Hằng Nga BGH', 1, NULL, '2015-01-17 16:52:33', NULL, 0),
(29, '8934679422400', 'Thùng Cháo Gấu Đỏ (50)', 1, NULL, '2015-01-17 16:54:09', NULL, 0),
(30, '8934679452407', 'Gói Cháo Gấu Đỏ', 1, NULL, '2015-01-17 16:55:39', NULL, 0),
(31, '18936077160387', 'Thùng Cháo Mộc Sen TBRC (50)', 1, NULL, '2015-01-17 16:59:51', NULL, 0),
(32, '8936077160380', 'Gói Cháo Mộc Sen TBRC', 1, NULL, '2015-01-17 17:01:21', NULL, 0),
(33, '8934563134051', 'Thùng Miến Phú Hương SH', 1, NULL, '2015-01-17 17:12:44', NULL, 0),
(34, '8934563120115', 'Hộp Miến Phú Hương SH', 1, NULL, '2015-01-17 17:12:55', NULL, 0),
(35, '8934563301156', 'Gói Miến Phú Hương SH', 1, NULL, '2015-01-17 17:13:04', NULL, 0),
(36, '8934563120450', 'Thùng Miến Phú Hương LTT', 1, NULL, '2015-01-17 17:07:06', NULL, 0),
(37, '8934563120412', 'Hộp Miến Phú Hương LTT', 1, NULL, '2015-01-17 17:08:22', NULL, 0),
(38, '8934563304157', 'Gói Miếng Phú Hương LTT', 1, NULL, '2015-01-17 17:08:56', NULL, 0),
(39, '8934563120351', 'Thùng Miến Phú Hương TB', 1, NULL, '2015-01-17 17:12:33', NULL, 0),
(40, '8934563120313', 'Hộp Miếng Phú Hương TB', 1, NULL, '2015-01-17 17:13:57', NULL, 0),
(41, '8934563303150', 'Gói Miếng Phú Hương TB', 1, NULL, '2015-01-17 17:14:31', NULL, 0),
(42, '8934563032234', 'Thùng Mì Ly Modern BHRT', 1, NULL, '2015-01-17 17:17:07', NULL, 0),
(43, '8934563622138', 'Ly Modern BHRT', 1, NULL, '2015-01-17 17:17:59', NULL, 0),
(44, '8934563031930', 'Thùng Mì Ly Modern LTT', 1, NULL, '2015-01-17 17:24:42', NULL, 0),
(45, '8934563619138', 'Ly Modern LTT', 1, NULL, '2015-01-17 17:25:21', NULL, 0),
(46, '8938504344059', 'Hộp Phô Mai Bò Cười', 3, NULL, '2015-02-01 07:20:20', NULL, 0),
(47, '18938504344056', 'Thùng Phô Mai Bò Cười', 3, NULL, '2015-02-01 07:25:30', NULL, 0),
(48, '18934673601822', 'Thùng SCh VNM Nha Đam', 2, NULL, '2015-02-01 07:31:36', NULL, 0),
(49, '8934673601825', 'Hộp SC VNM Nha Đam', 2, NULL, '2015-02-01 07:34:46', NULL, 0),
(50, '88934572183398', 'Thùng XX VS Heo', 3, NULL, '2015-02-01 07:42:22', NULL, 0),
(51, '8934572183392', 'Bịch XX VS Heo', 3, NULL, '2015-02-01 07:44:41', NULL, 0),
(52, '8934572183391', 'Cây XX VS Heo', 4, NULL, '2015-02-01 16:29:11', NULL, 0),
(53, '8936016400081', 'Cây Bastos Xanh', 9, NULL, '2015-02-01 16:28:56', NULL, 0),
(54, '8936016400089', 'Gói Bastos Xanh', 4, NULL, '2015-02-01 16:28:37', NULL, 0),
(55, '8936016400041', 'Cây Bastos Đỏ', 8, NULL, '2015-02-01 07:52:43', NULL, 1),
(56, '8936016400042', 'Cây Bastos Đỏ', 8, NULL, '2015-02-01 07:58:52', NULL, 0),
(57, '8936016400041', 'Gói Bastos Đỏ', 8, NULL, '2015-02-01 07:57:04', NULL, 0),
(58, '8934647041201', 'Cây Ngựa Trắng', 8, NULL, '2015-02-01 08:01:43', NULL, 0),
(59, '8934647041206', 'Gói Ngựa Trắng', 8, NULL, '2015-02-01 08:03:06', NULL, 1),
(60, '8934603102081', 'Cây Era Xanh', 8, NULL, '2015-02-01 08:18:20', NULL, 0),
(61, '8934603102088', 'Gói Era Xanh', 8, NULL, '2015-02-01 08:16:15', NULL, 0),
(62, '8934603102061', 'Cây Era Đỏ', 8, NULL, '2015-02-01 08:17:56', NULL, 0),
(63, '8934603102064', 'Gói Era Đỏ', 8, NULL, '2015-02-01 08:18:54', NULL, 0),
(64, '8934674020111', 'Cây Fine', 8, NULL, '2015-02-01 08:20:39', NULL, 0),
(65, '8934674020113', 'Gói Fine', 8, NULL, '2015-02-01 08:21:30', NULL, 0),
(66, '8934603220010', 'Cây Hòa Bình', 8, NULL, '2015-02-01 08:23:01', NULL, 0),
(67, '8934603202016', 'Gói Hòa Bình', 8, NULL, '2015-02-01 08:25:44', NULL, 0),
(68, '8934647041221', 'Cây Núi', 8, NULL, '2015-02-01 08:28:42', NULL, 0),
(69, '8934647041220', 'Gói Núi', 8, NULL, '2015-02-01 08:29:23', NULL, 0),
(70, '8934647002451', 'Cây Hoàng Tử Xanh', 8, NULL, '2015-02-01 08:31:18', NULL, 0),
(71, '8934647002450', 'Gói Hoàng Tử Xanh', 8, NULL, '2015-02-01 08:32:02', NULL, 0),
(72, '8935004400011', 'Cây 555 Xanh', 8, NULL, '2015-02-01 08:33:42', NULL, 0),
(73, '8935004400018', 'Gói 555 Xanh', 8, NULL, '2015-02-01 08:34:28', NULL, 0),
(74, '8934603002031', 'Cây Cotab', 8, NULL, '2015-02-01 08:38:39', NULL, 0),
(75, '8934603002036', 'Gói Cotab', 8, NULL, '2015-02-01 08:37:57', NULL, 0),
(76, '8934603002101', 'Cây SG đỏ', 8, NULL, '2015-02-01 08:40:37', NULL, 0),
(77, '8934603002104', 'Gói SG Đỏ', 8, NULL, '2015-02-01 08:42:06', NULL, 0),
(78, '8935004400041', 'Cây 555 Bạc', 8, NULL, '2015-02-01 08:43:25', NULL, 0),
(79, '8935004400049', 'Gói 555 Bạc', 8, NULL, '2015-02-01 08:44:28', NULL, 0),
(80, '8934603102661', 'Cây Melia Hộp', 8, NULL, '2015-02-01 08:46:25', NULL, 0),
(81, '8934603102668', 'Gói Melia Hộp', 8, NULL, '2015-02-01 08:47:28', NULL, 0),
(82, '8934674012311', 'Cây Mèo Lớn', 8, NULL, '2015-02-01 08:49:28', NULL, 0),
(83, '8934674012316', 'Gói Mèo Lớn', 8, NULL, '2015-02-01 08:50:11', NULL, 0),
(84, '8934674010711', 'Cây Mèo Nhỏ', 8, NULL, '2015-02-01 08:52:07', NULL, 0),
(85, '8934674010718', 'Gói Mèo Nhỏ', 8, NULL, '2015-02-01 08:53:13', NULL, 0),
(86, '89301231', 'Cây Man Trắng', 8, NULL, '2015-02-01 08:56:23', NULL, 0),
(87, '89301234', 'Gói Man Trắng', 8, NULL, '2015-02-01 08:57:04', NULL, 0),
(88, '8934603102021', 'Cây Sou', 8, NULL, '2015-02-01 09:00:38', NULL, 1),
(89, '8934603102021', 'Cây Sou', 8, NULL, '2015-02-01 09:02:04', NULL, 0),
(90, '8934603102026', 'Gói Sou', 8, NULL, '2015-02-01 09:02:52', NULL, 0),
(91, '18934673537350', 'Thùng Sữa VNM Bịch', 2, NULL, '2015-02-01 09:29:10', NULL, 0),
(92, '8934673502351', 'Bịch Sữa VNM Dâu', 2, NULL, '2015-02-01 09:31:36', NULL, 0),
(93, '18934673573341', 'Thùng VNM 100% (180)', 2, NULL, '2015-02-01 09:35:13', NULL, 0),
(94, '8934673573344', 'Hộp Sữa VNM 100%(180)', 2, NULL, '2015-02-01 09:37:18', NULL, 0),
(95, '18934673311509', 'Thùng Sữa Ông Thọ', 2, NULL, '2015-02-01 09:40:11', NULL, 0),
(96, '8934673311502', 'Lon Sữa Ông Thọ', 2, NULL, '2015-02-01 09:41:04', NULL, 0),
(97, '18934673573327', 'Thùng Sữa 100% (110)', 2, NULL, '2015-02-01 09:44:25', NULL, 0),
(98, '8934673573320', 'Hộp Sữa VNM 100 (110)', 2, NULL, '2015-02-01 09:51:08', NULL, 0),
(99, '18936025771207', 'Thùng Sữa Kun 180', 2, NULL, '2015-02-01 10:46:20', NULL, 0),
(100, '8936025771118', 'Hộp Sữa Kun 180', 2, NULL, '2015-02-01 10:41:04', NULL, 0),
(101, '18934673314500', 'Thùng Sữa Sao Xanh', 2, NULL, '2015-02-01 09:54:01', NULL, 0),
(102, '8934673314503', 'Lon Sữa Sao Xanh', 2, NULL, '2015-02-01 09:55:10', NULL, 0),
(103, '8934614021736', 'Thùng Sữa Fami Bịch', 2, NULL, '2015-02-01 09:58:48', NULL, 0),
(104, '8934614021644', 'Bịch Sữa Fami 200', 2, NULL, '2015-02-01 10:01:17', NULL, 0),
(105, '08934841900286', 'Thùng Yomost Cam', 2, NULL, '2015-02-01 10:04:24', NULL, 0),
(106, '8934841900286', 'Hộp Sữa Yomost 180', 2, NULL, '2015-02-01 10:05:46', NULL, 0),
(107, '18935106910177', 'Thùng Sữa VXM Bịch', 2, NULL, '2015-02-01 10:10:17', NULL, 0),
(108, '8935106910170', 'Bịch Sữa Vixumilk', 2, NULL, '2015-02-01 10:11:18', NULL, 0),
(109, '18935217400154', 'Thùng Sữa ADM 180', 2, NULL, '2015-02-01 10:14:13', NULL, 0),
(110, '8935217400157', 'Hộp Sữa ADM 180', 2, NULL, '2015-02-01 10:15:35', NULL, 0),
(111, '8934614021767', 'Thùng Sữa Fami Hộp 200', 2, NULL, '2015-02-01 10:21:37', NULL, 0),
(112, '8934614021743', 'Hộp Sữa Fami 200', 2, NULL, '2015-02-01 10:23:09', NULL, 0),
(113, '18936025771115', 'Thùng Sữa Kun 110', 2, NULL, '2015-02-01 10:44:27', NULL, 0),
(114, '8936025771118', 'Hộp Sữa Kun 110', 2, NULL, '2015-02-01 10:45:18', NULL, 0),
(115, '28935049510110', 'Thùng Coca Cola Lon', 1, NULL, '2015-02-01 10:49:53', NULL, 0),
(116, '8935049510116', 'Lon Cocacola', 1, NULL, '2015-02-01 10:51:24', NULL, 0),
(117, '8934822104337', 'Thùng Tiger Thường', 1, NULL, '2015-02-01 10:52:58', NULL, 0),
(118, '8934822104337', 'Thùng Tiger Xuân', 1, NULL, '2015-02-01 10:55:02', NULL, 0),
(119, '8934822101336', 'Lon Tiger', 1, NULL, '2015-02-01 10:56:50', NULL, 0),
(120, '58934588002026', 'Pepsi Lon', 1, NULL, '2015-02-01 10:58:40', NULL, 0),
(121, '8934588012020', 'Lon Pepsi', 1, NULL, '2015-02-01 10:59:52', NULL, 0),
(122, '8934822204334', 'Thùng Heineken Thường', 1, NULL, '2015-02-01 11:02:09', NULL, 0),
(123, '8934822201333', 'Lon Heineken', 1, NULL, '2015-02-01 11:04:13', NULL, 0),
(124, '8934822204334', 'Thùng Heineken Xuân', NULL, NULL, '2015-02-01 11:07:28', NULL, 0),
(125, '18935012413304', 'Thùng Bía Sài Gòn', 1, NULL, '2015-02-01 11:09:18', NULL, 0),
(126, '8935012413307', 'Lon Bia Sài Gòn', 1, NULL, '2015-02-01 11:10:17', NULL, 0),
(127, '18935012413335', 'Thùng Bia 333', 1, NULL, '2015-02-01 11:11:49', NULL, 0),
(128, '8935012413338', 'Lon Bia 333', 1, NULL, '2015-02-01 11:13:30', NULL, 0),
(129, '08934841901382', 'Thùng Sữa CGHL 180', 2, NULL, '2015-02-01 11:21:21', NULL, 0),
(130, '8934841901382', 'Hộp Sữa CGHL 180', 2, NULL, '2015-02-01 11:20:21', NULL, 0),
(131, '08934841141146', 'Thùng Sữa Hoàn Hảo', 2, NULL, '2015-02-01 11:23:28', NULL, 0),
(132, '8934841141146', 'Lon Sữa Hoàn Hảo', 2, NULL, '2015-02-01 11:24:08', NULL, 0),
(133, '08934841901207', 'Thùng Sữa Fristi 48', 2, NULL, '2015-02-01 11:26:37', NULL, 0),
(134, '8934841901207', 'Hũ Sữa Fristi 48', 2, NULL, '2015-02-01 11:28:25', NULL, 0),
(135, '8935106940047', 'Thùng Sữa VXM Đặc', 2, NULL, '2015-02-01 11:31:42', NULL, 0),
(136, '8935106940023', 'Lon Sữa VXM Đặc', 2, NULL, '2015-02-01 11:32:50', NULL, 0),
(137, '18934673573396', 'Thùng Sữa 100% 1L', 2, NULL, '2015-02-01 11:35:02', NULL, 0),
(138, '8934673573399', 'Hộp Sữa 100% 1L', 2, NULL, '2015-02-01 11:35:47', NULL, 0),
(139, '06934804025759', 'Thùng Sữa Milo 115', 2, NULL, '2015-02-01 11:38:11', NULL, 0),
(140, '8934804025742', 'Hộp Sữa Milo 115', 2, NULL, '2015-02-01 11:39:34', NULL, 0),
(141, '6345435435345', 'nghgfch', 1, NULL, '2015-02-01 16:14:09', NULL, 1),
(142, '6546541234654', 'fghgf h', 2, NULL, '2015-02-01 16:14:06', NULL, 1),
(143, '234432432432', 'dfgfdgfdg', 0, NULL, '2015-02-01 16:14:02', NULL, 1),
(144, '2342343242', 'sdfsdfds', 0, NULL, '2015-02-01 16:13:58', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `products_buy_price`
--

CREATE TABLE IF NOT EXISTS `products_buy_price` (
  `id` bigint(50) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(50) NOT NULL,
  `warehousing_id` int(25) DEFAULT NULL,
  `updated` timestamp NULL DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `price` bigint(50) DEFAULT NULL,
  `partner` bigint(25) NOT NULL,
  `quantity` bigint(25) NOT NULL DEFAULT '0',
  `unit` bigint(25) DEFAULT NULL,
  `warehouse` enum('retail','wholesale') COLLATE utf8_unicode_ci DEFAULT 'wholesale',
  `remaining_quantity` bigint(25) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=29 ;

--
-- Dumping data for table `products_buy_price`
--

INSERT INTO `products_buy_price` (`id`, `product_id`, `warehousing_id`, `updated`, `created`, `price`, `partner`, `quantity`, `unit`, `warehouse`, `remaining_quantity`) VALUES
(22, 12, 6, NULL, '2015-01-18 08:52:28', 150000, 1, 10, 49, 'wholesale', 10),
(23, 18, 6, NULL, '2015-01-18 08:52:28', 45000, 1, 10, 58, 'wholesale', 10),
(24, 18, NULL, NULL, '2015-01-18 08:54:53', 45000, 5, 10, 58, 'retail', 5),
(25, 12, NULL, NULL, '2015-01-18 08:54:53', 150000, 5, 10, 49, 'retail', 5),
(26, 1, 7, NULL, '2015-02-05 16:22:35', 7800000, 5, 100, 113, 'wholesale', 100),
(27, 7, 7, NULL, '2015-02-05 16:22:35', 8425000, 5, 50, 42, 'wholesale', 50),
(28, 53, 8, NULL, '2015-02-05 16:24:11', 1360000, 5, 20, 310, 'wholesale', 20);

-- --------------------------------------------------------

--
-- Table structure for table `products_sale_price`
--

CREATE TABLE IF NOT EXISTS `products_sale_price` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(255) NOT NULL,
  `parent_id` bigint(25) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `quantity` bigint(25) DEFAULT NULL,
  `price` bigint(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=313 ;

--
-- Dumping data for table `products_sale_price`
--

INSERT INTO `products_sale_price` (`id`, `product_id`, `parent_id`, `name`, `description`, `quantity`, `price`) VALUES
(19, 2, NULL, 'Thùng', NULL, 1, 245000),
(20, 2, 19, 'gói', NULL, 110, 2500),
(23, 3, NULL, 'gói', NULL, 1, 3000),
(24, 4, NULL, 'Gói', NULL, 1, 3500),
(33, 8, NULL, 'Gói', NULL, 1, 5500),
(38, 5, NULL, 'Thùng', NULL, 1, 94000),
(39, 5, 38, 'Gói', NULL, 32, 3500),
(40, 6, NULL, 'Thùng', NULL, 1, 90000),
(41, 6, 40, 'Gói', NULL, 30, 3500),
(42, 7, NULL, 'Thùng', NULL, 1, 168500),
(43, 7, 42, 'Gói', NULL, 32, 5500),
(44, 9, NULL, 'Thùng', NULL, 1, 168500),
(45, 9, 44, 'Gói', NULL, 32, 5500),
(46, 10, NULL, 'Gói', NULL, 1, 5500),
(47, 11, NULL, 'Thùng', NULL, 1, 165000),
(48, 11, 47, 'Ly', NULL, 12, 15000),
(49, 12, NULL, 'Ly', NULL, 1, 15000),
(50, 13, NULL, 'Thùng', NULL, 1, 92500),
(51, 13, 50, 'Gói', NULL, 30, 4000),
(52, 14, NULL, 'Gói', NULL, 1, 4000),
(53, 15, NULL, 'Thùng', NULL, 1, 92500),
(54, 15, 53, 'Gói', NULL, 30, 4000),
(55, 16, NULL, 'Gói', NULL, 1, 4000),
(56, 17, NULL, 'Thùng', NULL, 1, 116000),
(57, 17, 56, 'Gói', NULL, 32, 4500),
(58, 18, NULL, 'Gói', NULL, 1, 4500),
(59, 19, NULL, 'Thùng', NULL, 1, 68000),
(60, 19, 59, 'Gói', NULL, 33, 3000),
(61, 20, NULL, 'Gói', NULL, 1, 3000),
(64, 21, NULL, 'Thùng', NULL, 1, 60000),
(65, 21, 64, 'Gói', NULL, 30, 3000),
(66, 22, NULL, 'Gói', NULL, 1, 3000),
(67, 23, NULL, 'Thùng', NULL, 1, 133000),
(68, 23, 67, 'Gói', NULL, 32, 5000),
(69, 24, NULL, 'Gói', NULL, 1, 5000),
(70, 25, NULL, 'Thùng', NULL, 1, 143000),
(71, 25, 70, 'Gói', NULL, 24, 7000),
(72, 26, NULL, 'Gói', NULL, 1, 7000),
(73, 27, NULL, 'Thùng', NULL, 1, 160000),
(74, 27, 73, 'Gói', NULL, 30, 6500),
(75, 28, NULL, 'Gói', NULL, 1, 6500),
(76, 29, NULL, 'Thùng', NULL, 1, 123000),
(77, 29, 76, 'Gói', NULL, 50, 3500),
(78, 30, NULL, 'Gói', NULL, 1, 3500),
(79, 31, NULL, 'Thùng', NULL, 1, 115000),
(80, 31, 79, 'Gói', NULL, 50, 3500),
(81, 32, NULL, 'Gói', NULL, 1, 3500),
(88, 36, NULL, 'Thùng', NULL, 1, 386000),
(89, 36, 88, 'Hộp', NULL, 4, 97000),
(90, 36, 89, 'Gói', NULL, 12, 9000),
(91, 37, NULL, 'Hộp', NULL, 1, 97000),
(92, 37, 91, 'Gói', NULL, 12, 9000),
(93, 38, NULL, 'Gói', NULL, 1, 9000),
(94, 39, NULL, 'Thùng', NULL, 1, 386000),
(95, 39, 94, 'Hộp', NULL, 4, 97000),
(96, 39, 95, 'Gói', NULL, 12, 9000),
(97, 33, NULL, 'Thùng', NULL, 1, 386000),
(98, 33, 97, 'Hộp', NULL, 4, 97000),
(99, 33, 98, 'Gói', NULL, 12, 9000),
(100, 34, NULL, 'Hộp', NULL, 1, 97000),
(101, 34, 100, 'Gói', NULL, 12, 9000),
(102, 35, NULL, 'Gói', NULL, 1, 9000),
(103, 40, NULL, 'Hộp', NULL, 1, 97000),
(104, 40, 103, 'Gói', NULL, 12, 9000),
(105, 41, NULL, 'Gói', NULL, 1, 9000),
(106, 42, NULL, 'Thùng', NULL, 1, 132000),
(107, 42, 106, 'Ly', NULL, 24, 6500),
(109, 44, NULL, 'Thùng', NULL, 1, 132000),
(110, 44, 109, 'Ly', NULL, 24, 6500),
(111, 45, NULL, 'Ly', NULL, 1, 6500),
(112, 43, NULL, 'Ly', NULL, 1, 6500),
(113, 1, NULL, 'Thùng', NULL, 1, 78000),
(114, 1, 113, 'Gói', NULL, 32, 3000),
(118, 46, NULL, 'Hộp', NULL, 1, 27000),
(127, 48, NULL, 'Thùng', NULL, 1, 270000),
(128, 48, 127, 'Hộp', NULL, 48, 6000),
(129, 49, NULL, 'Hộp', NULL, 1, 6000),
(136, 50, NULL, 'Thùng', NULL, 1, 345000),
(137, 50, 136, 'Bịch', NULL, 20, 17500),
(138, 50, 137, 'Cây', NULL, 1, 4000),
(139, 51, NULL, 'Bịch', NULL, 1, 17500),
(140, 51, 139, 'Cây', NULL, 5, 4000),
(145, 55, NULL, 'Cây', NULL, 1, 94),
(148, 57, NULL, 'Gói', NULL, 1, 10000),
(149, 56, NULL, 'Cây', NULL, 1, 94000),
(150, 56, 149, 'Gói', NULL, 10, 10000),
(153, 59, NULL, 'Gói', NULL, 1, 19000),
(154, 58, NULL, 'Cây', NULL, 1, 185000),
(155, 58, 154, 'Gói', NULL, 10, 19000),
(158, 61, NULL, 'Gói', NULL, 1, 6500),
(159, 62, NULL, 'Cây', NULL, 1, 55000),
(160, 62, 159, 'Gói', NULL, 10, 6000),
(161, 60, NULL, 'Cây', NULL, 1, 58000),
(162, 60, 161, 'Gói', NULL, 10, 6500),
(163, 63, NULL, 'Gói', NULL, 1, 6000),
(164, 64, NULL, 'Cây', NULL, 1, 110000),
(165, 64, 164, 'Gói', NULL, 10, 11500),
(166, 65, NULL, 'Gói', NULL, 1, 11500),
(167, 66, NULL, 'Cây', NULL, 1, 84000),
(168, 66, 167, 'Gói', NULL, 10, 9000),
(169, 67, NULL, 'Gói', NULL, 1, 9000),
(170, 68, NULL, 'Cây', NULL, 1, 144000),
(171, 68, 170, 'Gói', NULL, 10, 15000),
(172, 69, NULL, 'Gói', NULL, 1, 15000),
(173, 70, NULL, 'Cây', NULL, 1, 67000),
(174, 70, 173, 'Gói', NULL, 10, 7000),
(175, 71, NULL, 'Gói', NULL, 1, 7000),
(176, 72, NULL, 'Cây', NULL, 1, 222000),
(177, 72, 176, 'Gói', NULL, 10, 22500),
(181, 75, NULL, 'Gói', NULL, 1, 9500),
(182, 74, NULL, 'Cây', NULL, 1, 91000),
(183, 74, 182, 'Gói', NULL, 10, 9500),
(184, 76, NULL, 'Cây', NULL, 1, 118000),
(185, 76, 184, 'Gói', NULL, 10, 12000),
(186, 77, NULL, 'Gói', NULL, 1, 12000),
(187, 78, NULL, 'Cây', NULL, 1, 194000),
(188, 78, 187, 'Gói', NULL, 10, 20000),
(189, 79, NULL, 'Gói', NULL, 1, 20000),
(190, 80, NULL, 'Cây', NULL, 1, 58000),
(191, 80, 190, 'Gói', NULL, 10, 6000),
(192, 81, NULL, 'Gói', NULL, 1, 6000),
(193, 82, NULL, 'Cây', NULL, 1, 161000),
(194, 82, 193, 'Gói', NULL, 10, 16500),
(195, 83, NULL, 'Gói', NULL, 1, 16500),
(196, 84, NULL, 'Cây', NULL, 1, 195000),
(197, 84, 196, 'Gói', NULL, 20, 10000),
(198, 85, NULL, 'Gói', NULL, 1, 10000),
(199, 86, NULL, 'Cây', NULL, 1, 203000),
(200, 86, 199, 'Gói', NULL, 10, 20500),
(201, 87, NULL, 'Gói', NULL, 1, 20500),
(202, 88, NULL, 'Cây', NULL, 1, 54000),
(203, 89, NULL, 'Cây', NULL, 1, 54000),
(204, 89, 203, 'Gói', NULL, 10, 6000),
(205, 90, NULL, 'Gói', NULL, 1, 6000),
(206, 91, NULL, 'Thùng', NULL, 1, 272000),
(207, 91, 206, 'Bịch', NULL, 48, 6000),
(208, 92, NULL, 'Bịch', NULL, 1, 6000),
(209, 93, NULL, 'Thùng', NULL, 1, 308000),
(210, 93, 209, 'Hộp', NULL, 48, 7000),
(211, 94, NULL, 'Hộp', NULL, 1, 7000),
(212, 95, NULL, 'Thùng', NULL, 1, 950000),
(213, 95, 212, 'Lon', NULL, 48, 20000),
(214, 96, NULL, 'Lon', NULL, 1, 20000),
(215, 97, NULL, 'Thùng', NULL, 1, 197000),
(216, 97, 215, 'Hộp', NULL, 48, 4500),
(221, 98, NULL, 'Hộp', NULL, 1, 4500),
(222, 101, NULL, 'Thùng', NULL, 1, 752000),
(223, 101, 222, 'Lon', NULL, 48, 16000),
(224, 102, NULL, 'Lon', NULL, 1, 16000),
(227, 104, NULL, 'Bịch', NULL, 1, 3500),
(228, 105, NULL, 'Thùng', NULL, 1, 292000),
(229, 105, 228, 'Hộp', NULL, 48, 6500),
(230, 106, NULL, 'Hộp', NULL, 1, 6500),
(231, 107, NULL, 'Thùng', NULL, 1, 238000),
(232, 107, 231, 'Bịch', NULL, 50, 5000),
(233, 108, NULL, 'Bịch', NULL, 1, 5000),
(234, 109, NULL, 'Thùng', NULL, 1, 288000),
(235, 109, 234, 'Hộp', NULL, 48, 6500),
(236, 110, NULL, 'Hộp', NULL, 1, 6500),
(237, 103, NULL, 'Thùng', NULL, 1, 123000),
(238, 103, 237, 'Bịch', NULL, 40, 3500),
(239, 111, NULL, 'Thùng', NULL, 1, 133000),
(240, 111, 239, 'Hộp', NULL, 36, 4000),
(241, 112, NULL, 'Hộp', NULL, 1, 4000),
(245, 113, NULL, 'Thùng', NULL, 1, 180000),
(246, 113, 245, 'Hộp', NULL, 48, 4000),
(247, 114, NULL, 'Hộp', NULL, 1, 4000),
(248, 99, NULL, 'Thùng', NULL, 1, 270000),
(249, 99, 248, 'Hộp', NULL, 48, 6000),
(250, 100, NULL, 'Hộp', NULL, 1, 6000),
(251, 115, NULL, 'Thùng', NULL, 1, 175000),
(252, 115, 251, 'Lon', NULL, 24, 7500),
(253, 116, NULL, 'Lon', NULL, 1, 7500),
(254, 117, NULL, 'Thùng', NULL, 1, 285000),
(255, 117, 254, 'Lon', NULL, 24, 12000),
(256, 118, NULL, 'Thùng', NULL, 1, 292000),
(257, 118, 256, 'Lon', NULL, 24, 12500),
(258, 119, NULL, 'Lon', NULL, 1, 12500),
(259, 120, NULL, 'Thùng', NULL, 1, 155000),
(260, 120, 259, 'Lon', NULL, 24, 7000),
(261, 121, NULL, 'Lon', NULL, 1, 7000),
(264, 123, NULL, 'Lon', NULL, 1, 15000),
(265, 122, NULL, 'Thùng', NULL, 1, 355000),
(266, 122, 265, 'Lon', NULL, 24, 15000),
(267, 124, NULL, 'Thùng', NULL, 1, 365000),
(268, 124, 267, 'Lon', NULL, 24, 15000),
(269, 125, NULL, 'Thùng', NULL, 1, 280000),
(270, 125, 269, 'Lon', NULL, 24, 12000),
(271, 126, NULL, 'Lon', NULL, 1, 12000),
(272, 127, NULL, 'Thùng', NULL, 1, 217000),
(273, 127, 272, 'Lon', NULL, 24, 9500),
(274, 128, NULL, 'Lon', NULL, 1, 9500),
(277, 130, NULL, 'Hộp', NULL, 1, 6500),
(278, 129, NULL, 'Thùng', NULL, 1, 292000),
(279, 129, 278, 'Hộp', NULL, 48, 6500),
(280, 131, NULL, 'Thùng', NULL, 1, 690000),
(281, 131, 280, 'Lon', NULL, 48, 14500),
(282, 132, NULL, 'Lon', NULL, 1, 14500),
(283, 133, NULL, 'Thùng', NULL, 1, 140000),
(284, 133, 283, 'Hũ', NULL, 48, 3500),
(285, 134, NULL, 'Hũ', NULL, 1, 3500),
(286, 135, NULL, 'Thùng', NULL, 1, 652000),
(287, 135, 286, 'Lon', NULL, 48, 14000),
(288, 136, NULL, 'Lon', NULL, 1, 14000),
(289, 137, NULL, 'Thùng', NULL, 1, 330000),
(290, 137, 289, 'Hộp', NULL, 12, 28000),
(291, 138, NULL, 'Hộp', NULL, 1, 28000),
(292, 139, NULL, 'Thùng', NULL, 1, 205000),
(293, 139, 292, 'Hộp', NULL, 48, 4500),
(294, 140, NULL, 'Hộp', NULL, 1, 4500),
(295, 141, NULL, 'thùng', NULL, 1, 320000),
(296, 142, NULL, 'thung', NULL, 1, 362555),
(299, 47, NULL, 'Thùng', NULL, 1, 938000),
(300, 47, 299, 'Hộp', NULL, 36, 27000),
(301, 73, NULL, 'Gói', NULL, 1, 22500),
(302, 143, NULL, 'thung', NULL, 1, 3652255),
(303, 144, NULL, 'dfgfdg', NULL, 1, 3222),
(309, 54, NULL, 'Gói', NULL, 1, 7000),
(310, 53, NULL, 'Cây', NULL, 1, 68000),
(311, 53, 310, 'Gói', NULL, 10, 7000),
(312, 52, NULL, 'Cây', NULL, 1, 4000);

-- --------------------------------------------------------

--
-- Table structure for table `products_type`
--

CREATE TABLE IF NOT EXISTS `products_type` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `active` int(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=10 ;

--
-- Dumping data for table `products_type`
--

INSERT INTO `products_type` (`id`, `name`, `description`, `created`, `active`) VALUES
(1, 'Mì Ăn Liền', NULL, '2015-01-17 15:34:56', 0),
(2, 'Nước Giải Khát', '', '2015-01-17 15:36:27', 0),
(3, 'Sữa', '', '2015-01-17 15:37:01', 0),
(4, 'Fast Food', '', '2015-01-17 15:38:43', 0),
(5, 'Hóa Mỹ Phẩm', '', '2015-01-17 15:35:42', 0),
(6, 'Vật Dụng Cá Nhân', NULL, '2015-01-17 15:35:57', 0),
(7, 'Gia Vị', NULL, '2015-01-17 15:37:13', 0),
(8, 'Bột Hòa Tan', '', '2015-01-17 15:37:53', 0),
(9, 'Thuốc Lá', NULL, '2015-02-01 07:47:22', 0);

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE IF NOT EXISTS `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`) VALUES
(1, 'admin'),
(2, 'manager'),
(3, 'user');

-- --------------------------------------------------------

--
-- Table structure for table `shipments`
--

CREATE TABLE IF NOT EXISTS `shipments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `truck_id` bigint(20) DEFAULT NULL,
  `driver` bigint(20) DEFAULT NULL,
  `sub_driver` bigint(20) DEFAULT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `allow` enum('1','0') COLLATE utf8_unicode_ci DEFAULT '0',
  `status` enum('2','1','3','0') COLLATE utf8_unicode_ci DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=3 ;

--
-- Dumping data for table `shipments`
--

INSERT INTO `shipments` (`id`, `truck_id`, `driver`, `sub_driver`, `created`, `allow`, `status`) VALUES
(1, 1, 5, 3, '2015-02-01 16:46:33', '1', '3'),
(2, 1, 1, 2, '2015-02-08 09:26:51', '1', '3');

-- --------------------------------------------------------

--
-- Table structure for table `staffs`
--

CREATE TABLE IF NOT EXISTS `staffs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `cmnd` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `avatar` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `fatherland` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `address_permanent` text CHARACTER SET utf8,
  `address_temporary` text CHARACTER SET utf8,
  `salary` int(11) DEFAULT NULL,
  `start_day` date DEFAULT NULL,
  `end_day` date DEFAULT NULL,
  `sex` tinyint(4) DEFAULT '0',
  `position` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `active` varchar(4) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `staffs`
--

INSERT INTO `staffs` (`id`, `name`, `cmnd`, `dob`, `avatar`, `fatherland`, `address_permanent`, `address_temporary`, `salary`, `start_day`, `end_day`, `sex`, `position`, `active`) VALUES
(1, 'Hao Nguyen', '024976066', '1991-03-04', 'c510bb9bda506d6af637bb7cac7b40ca.jpg', 'Ha Nam', '114 le van quoi', '114 le van quoi', 6000000, '2014-05-23', '2015-01-01', 1, '2', '0'),
(2, 'Tín Trần', '0254157896', '1991-02-01', '52b7c052c28b9c5e59d284240fedc9dd.jpg', 'Hồ Chí Minh', '23 Lê Đại', '23 Lê Cao Lãng', 10000000, '2014-12-01', '2015-12-09', 1, '3', '0'),
(3, 'Mỹ Linh', '0125478596', '1997-03-20', NULL, 'Hà Nam', '113 Huyền trân công chúa', '23 cách mạng tháng 8', 6000000, '2015-02-03', '2017-06-02', 0, NULL, '0'),
(4, 'Nguyễn Văn A', '2012547896', '1991-05-02', '5636d4a120271231f09040f6d6a094dc.jpg', 'sdfdmas,bdskjfh', 'sdfkjhgdkfjlsfh', 'sdkjghsdkjflh', 6962552, '2014-12-03', NULL, 1, NULL, '0'),
(5, 'Hà Trần Tín', '0214587963', '1991-02-01', NULL, 'Hồ Chí Minh', '54 lê lai', '54 Lê Lai', 6000000, '2015-01-01', NULL, 1, '1', '0');

-- --------------------------------------------------------

--
-- Table structure for table `trucks`
--

CREATE TABLE IF NOT EXISTS `trucks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `active` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `trucks`
--

INSERT INTO `trucks` (`id`, `name`, `created`, `active`) VALUES
(1, '1823', '2015-01-20 13:51:18', 0),
(2, '1475', '2015-01-20 13:57:14', 1),
(3, '2587', '2015-01-20 14:04:08', 1),
(4, '7777', '2015-01-20 14:04:13', 0),
(5, '3456', '2015-01-20 15:50:33', 0),
(6, '8758', '2015-01-25 07:25:39', 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `role` tinyint(4) DEFAULT NULL,
  `active` varchar(255) DEFAULT '0',
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `user_name`, `password`, `role`, `active`, `created`) VALUES
(1, 'admin', '123456', 1, '0', '2015-01-30 19:37:11'),
(2, 'hao', '123456', 2, '1', '2015-01-30 19:37:49'),
(3, 'kiet', '14789', 3, '0', '2015-01-30 20:03:46'),
(4, 'hao', 'sony', 1, '0', '2015-01-31 10:07:42');

-- --------------------------------------------------------

--
-- Table structure for table `warehouses`
--

CREATE TABLE IF NOT EXISTS `warehouses` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `allow` enum('1','0') COLLATE utf8_unicode_ci DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=6 ;

--
-- Dumping data for table `warehouses`
--

INSERT INTO `warehouses` (`id`, `name`, `address`, `description`, `allow`) VALUES
(1, 'Đổng khởi', '112 lê làm phường tân thành quận tân phú', 'kho này đek có gì lưu hết =))', ''),
(2, 'Lê Lư', '452 Lê Lư, phường phú thạnh quận tân phú', 'ở đây cũng éo có hàng', ''),
(3, 'Lê Văn Quới', '139 Lê Văn Quới, Phường Bình Hưng Hòa A, Quận Bình Tân', NULL, ''),
(4, 'CMT8', '112 cách mạng tháng 8', NULL, ''),
(5, 'aon mall', '12 bờ bao tân thăng', NULL, '');

-- --------------------------------------------------------

--
-- Table structure for table `warehouses_detail`
--

CREATE TABLE IF NOT EXISTS `warehouses_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `warehouses_id` bigint(20) DEFAULT NULL,
  `product_id` bigint(20) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `quantity` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=22 ;

--
-- Dumping data for table `warehouses_detail`
--

INSERT INTO `warehouses_detail` (`id`, `warehouses_id`, `product_id`, `created`, `quantity`) VALUES
(1, 1, 1, '2014-11-15 08:51:25', 6),
(2, 1, 2, '2014-11-15 08:51:25', 0),
(3, 1, 3, '2014-11-15 08:51:25', 0),
(4, 2, 1, '2014-11-15 08:51:25', 6),
(5, 2, 2, '2014-11-15 08:51:25', 0),
(6, 2, 3, '2014-11-15 08:51:25', 0),
(7, 3, 1, '2014-11-15 08:51:25', 18),
(8, 3, 2, '2014-11-15 08:51:26', 0),
(9, 3, 3, '2014-11-15 08:51:26', 5),
(10, 4, 1, '2014-11-15 08:51:26', 8),
(11, 4, 2, '2014-11-15 08:51:26', 1),
(12, 4, 3, '2014-11-15 08:51:26', 11),
(13, 5, 1, '2014-11-15 08:51:26', 60),
(14, 5, 2, '2014-11-15 08:51:26', 0),
(15, 5, 3, '2014-11-15 08:51:26', 0),
(16, 1, 4, '2014-11-16 07:04:57', 0),
(17, 2, 4, '2014-11-16 07:04:58', 6),
(18, 3, 4, '2014-11-16 07:04:58', 5),
(19, 4, 4, '2014-11-16 07:04:59', 9),
(20, 5, 4, '2014-11-16 07:04:59', 3),
(21, 3, 23, '2015-02-01 16:50:16', 5);

-- --------------------------------------------------------

--
-- Table structure for table `warehouse_retail`
--

CREATE TABLE IF NOT EXISTS `warehouse_retail` (
  `id` bigint(25) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(25) NOT NULL,
  `quantity` bigint(25) DEFAULT NULL,
  `unit` bigint(25) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=3 ;

--
-- Dumping data for table `warehouse_retail`
--

INSERT INTO `warehouse_retail` (`id`, `product_id`, `quantity`, `unit`) VALUES
(1, 8, 160, 33),
(2, 57, 160, 148);

-- --------------------------------------------------------

--
-- Table structure for table `warehouse_wholesale`
--

CREATE TABLE IF NOT EXISTS `warehouse_wholesale` (
  `id` bigint(25) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(25) NOT NULL,
  `quantity` bigint(25) DEFAULT NULL,
  `unit` bigint(25) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=4 ;

--
-- Dumping data for table `warehouse_wholesale`
--

INSERT INTO `warehouse_wholesale` (`id`, `product_id`, `quantity`, `unit`) VALUES
(1, 1, 95, 113),
(2, 7, 45, 42),
(3, 53, 20, 310);

-- --------------------------------------------------------

--
-- Table structure for table `warehousing`
--

CREATE TABLE IF NOT EXISTS `warehousing` (
  `id` bigint(50) NOT NULL AUTO_INCREMENT,
  `price` bigint(50) DEFAULT NULL,
  `debit` bigint(50) DEFAULT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `warehouse` enum('wholesale','retail') COLLATE utf8_unicode_ci DEFAULT 'wholesale',
  `allow` enum('1','0') COLLATE utf8_unicode_ci DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=9 ;

--
-- Dumping data for table `warehousing`
--

INSERT INTO `warehousing` (`id`, `price`, `debit`, `created`, `warehouse`, `allow`) VALUES
(1, 200000, 0, '2014-11-04 17:24:09', 'wholesale', '0'),
(2, 6600000, 0, '2014-11-05 17:18:43', 'wholesale', '1'),
(3, 13000000, 0, '2014-11-05 17:24:52', 'wholesale', '0'),
(4, 11000000, 1000000, '2014-11-05 17:27:09', 'wholesale', '1'),
(5, 10400000, 400000, '2014-11-16 07:03:26', 'wholesale', '1'),
(6, 195000, 0, '2015-01-18 08:52:28', 'wholesale', '0'),
(7, 16225000, 0, '2015-02-05 16:22:35', 'wholesale', '1'),
(8, 1360000, 0, '2015-02-05 16:24:11', 'wholesale', '1');

-- --------------------------------------------------------

--
-- Table structure for table `warehousing_history`
--

CREATE TABLE IF NOT EXISTS `warehousing_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) DEFAULT NULL,
  `warehouses_id` bigint(20) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `warehousing_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=56 ;

--
-- Dumping data for table `warehousing_history`
--

INSERT INTO `warehousing_history` (`id`, `product_id`, `warehouses_id`, `quantity`, `created`, `warehousing_id`) VALUES
(1, 1, 1, 5, '2014-11-15 08:51:25', NULL),
(2, 2, 1, 8, '2014-11-15 08:51:25', NULL),
(3, 3, 1, 10, '2014-11-15 08:51:25', NULL),
(4, 1, 2, 6, '2014-11-15 08:51:25', NULL),
(5, 2, 2, 6, '2014-11-15 08:51:25', NULL),
(6, 3, 2, 20, '2014-11-15 08:51:25', NULL),
(7, 1, 3, 8, '2014-11-15 08:51:25', NULL),
(8, 2, 3, 9, '2014-11-15 08:51:26', NULL),
(9, 3, 3, 20, '2014-11-15 08:51:26', NULL),
(10, 1, 4, 7, '2014-11-15 08:51:26', NULL),
(11, 2, 4, 1, '2014-11-15 08:51:26', NULL),
(12, 3, 4, 10, '2014-11-15 08:51:26', NULL),
(13, 1, 5, 9, '2014-11-15 08:51:26', NULL),
(14, 2, 5, 1, '2014-11-15 08:51:26', NULL),
(15, 3, 5, 0, '2014-11-15 08:51:26', NULL),
(16, 2, 1, 2, '2014-11-15 10:47:00', 2),
(17, 3, 1, 4, '2014-11-15 10:47:00', 2),
(18, 2, 2, 3, '2014-11-15 10:47:00', 2),
(19, 3, 2, 2, '2014-11-15 10:47:00', 2),
(20, 2, 3, 5, '2014-11-15 10:47:00', 2),
(21, 3, 3, 3, '2014-11-15 10:47:00', 2),
(22, 2, 4, 0, '2014-11-15 10:47:00', 2),
(23, 3, 4, 8, '2014-11-15 10:47:00', 2),
(24, 2, 5, 0, '2014-11-15 10:47:00', 2),
(25, 3, 5, 7, '2014-11-15 10:47:00', 2),
(26, 1, 1, 25, '2014-11-16 07:04:57', 5),
(27, 3, 1, 5, '2014-11-16 07:04:57', 5),
(28, 4, 1, 3, '2014-11-16 07:04:57', 5),
(29, 1, 2, 3, '2014-11-16 07:04:58', 5),
(30, 3, 2, 4, '2014-11-16 07:04:58', 5),
(31, 4, 2, 6, '2014-11-16 07:04:58', 5),
(32, 1, 3, 5, '2014-11-16 07:04:58', 5),
(33, 3, 3, 3, '2014-11-16 07:04:58', 5),
(34, 4, 3, 5, '2014-11-16 07:04:58', 5),
(35, 1, 4, 6, '2014-11-16 07:04:58', 5),
(36, 3, 4, 8, '2014-11-16 07:04:59', 5),
(37, 4, 4, 9, '2014-11-16 07:04:59', 5),
(38, 1, 5, 55, '2014-11-16 07:04:59', 5),
(39, 3, 5, 20, '2014-11-16 07:04:59', 5),
(40, 4, 5, 3, '2014-11-16 07:05:00', 5),
(41, 1, 1, 0, '2015-02-05 16:22:40', 7),
(42, 7, 1, 0, '2015-02-05 16:22:40', 7),
(43, 1, 2, 0, '2015-02-05 16:22:40', 7),
(44, 7, 2, 0, '2015-02-05 16:22:40', 7),
(45, 1, 3, 0, '2015-02-05 16:22:40', 7),
(46, 7, 3, 0, '2015-02-05 16:22:40', 7),
(47, 1, 4, 0, '2015-02-05 16:22:40', 7),
(48, 7, 4, 0, '2015-02-05 16:22:40', 7),
(49, 1, 5, 0, '2015-02-05 16:22:40', 7),
(50, 7, 5, 0, '2015-02-05 16:22:40', 7),
(51, 53, 1, 0, '2015-02-05 16:24:13', 8),
(52, 53, 2, 0, '2015-02-05 16:24:13', 8),
(53, 53, 3, 0, '2015-02-05 16:24:13', 8),
(54, 53, 4, 0, '2015-02-05 16:24:13', 8),
(55, 53, 5, 0, '2015-02-05 16:24:13', 8);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
