/*
Navicat MySQL Data Transfer

Source Server         : mySQL
Source Server Version : 50524
Source Host           : localhost:3306
Source Database       : salesystem

Target Server Type    : MYSQL
Target Server Version : 50524
File Encoding         : 65001

Date: 2014-10-23 22:53:33
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `bill`
-- ----------------------------
DROP TABLE IF EXISTS `bill`;
CREATE TABLE `bill` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bill_code` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `customer_id` bigint(25) DEFAULT NULL,
  `price_total` bigint(50) DEFAULT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `warehouse` enum('retail','wholesale') COLLATE utf8_unicode_ci DEFAULT 'wholesale',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of bill
-- ----------------------------
INSERT INTO `bill` VALUES ('1', 'B4F712', '1', '2925000', '2014-10-23 21:20:57', 'wholesale');
INSERT INTO `bill` VALUES ('2', '3BF074', '1', '3900000', '2014-10-23 21:21:19', 'wholesale');
INSERT INTO `bill` VALUES ('3', '1E0646', '1', '800000', '2014-10-23 21:32:06', 'retail');
INSERT INTO `bill` VALUES ('4', 'C87029', '1', '300000', '2014-10-23 21:32:34', 'retail');
INSERT INTO `bill` VALUES ('5', 'F14B6C', '1', '6000000', '2014-10-23 22:33:12', 'wholesale');
INSERT INTO `bill` VALUES ('6', '7AFB33', '1', '6000000', '2014-10-23 22:35:38', 'wholesale');
INSERT INTO `bill` VALUES ('7', '5F883A', '1', '3600000', '2014-10-23 22:38:09', 'wholesale');
INSERT INTO `bill` VALUES ('8', 'C672D8', '1', '6600000', '2014-10-23 22:38:40', 'wholesale');

-- ----------------------------
-- Table structure for `bill_detail`
-- ----------------------------
DROP TABLE IF EXISTS `bill_detail`;
CREATE TABLE `bill_detail` (
  `id` bigint(50) NOT NULL AUTO_INCREMENT,
  `bill_id` bigint(50) NOT NULL,
  `product_id` bigint(50) DEFAULT NULL,
  `quantity` bigint(50) DEFAULT NULL,
  `price` bigint(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of bill_detail
-- ----------------------------
INSERT INTO `bill_detail` VALUES ('1', '0', '1', '45', '2925000');
INSERT INTO `bill_detail` VALUES ('2', '0', '1', '60', '3900000');
INSERT INTO `bill_detail` VALUES ('3', '3', '2', '40', '800000');
INSERT INTO `bill_detail` VALUES ('4', '4', '2', '15', '300000');
INSERT INTO `bill_detail` VALUES ('5', '0', '2', '10', '6000000');
INSERT INTO `bill_detail` VALUES ('6', '7', '3', '10', '3600000');
INSERT INTO `bill_detail` VALUES ('7', '8', '3', '10', '3600000');
INSERT INTO `bill_detail` VALUES ('8', '8', '2', '5', '3000000');

-- ----------------------------
-- Table structure for `products`
-- ----------------------------
DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `id` bigint(25) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `product_type` int(255) DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of products
-- ----------------------------
INSERT INTO `products` VALUES ('1', '123', 'mì hảo hảo', '1', 'ngon ngon', '2014-10-23 21:15:58', null);
INSERT INTO `products` VALUES ('2', '456', 'thuốc con mèo', '3', 'độc', '2014-10-23 21:17:08', null);
INSERT INTO `products` VALUES ('3', '789', 'cocacola', '2', 'nước ngọt có gas', '2014-10-23 21:18:25', null);
INSERT INTO `products` VALUES ('4', '123', 'kẹo bibika', '4', 'kẹo như cứt', '2014-10-23 22:40:53', null);

-- ----------------------------
-- Table structure for `products_buy_price`
-- ----------------------------
DROP TABLE IF EXISTS `products_buy_price`;
CREATE TABLE `products_buy_price` (
  `id` bigint(50) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(50) NOT NULL,
  `updated` timestamp NULL DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `price` bigint(50) DEFAULT NULL,
  `partner` bigint(25) NOT NULL,
  `quantity` bigint(25) NOT NULL DEFAULT '0',
  `unit` bigint(25) DEFAULT NULL,
  `warehouse` enum('retail','wholesale') COLLATE utf8_unicode_ci DEFAULT 'wholesale',
  `remaining_quantity` bigint(25) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of products_buy_price
-- ----------------------------
INSERT INTO `products_buy_price` VALUES ('1', '1', null, '2014-10-23 21:19:35', '16000000', '1', '100', '1', 'wholesale', '0');
INSERT INTO `products_buy_price` VALUES ('2', '2', null, '2014-10-23 21:19:35', '25000000', '1', '50', '3', 'wholesale', '35');
INSERT INTO `products_buy_price` VALUES ('3', '1', null, '2014-10-23 21:20:30', '7500000', '1', '50', '1', 'wholesale', '45');
INSERT INTO `products_buy_price` VALUES ('4', '3', null, '2014-10-23 21:20:30', '18000000', '1', '60', '6', 'wholesale', '40');
INSERT INTO `products_buy_price` VALUES ('5', '2', null, '2014-10-23 21:30:56', '1000000', '1', '50', '5', 'retail', '0');
INSERT INTO `products_buy_price` VALUES ('6', '1', null, '2014-10-23 21:30:57', '210000', '1', '60', '2', 'retail', '60');
INSERT INTO `products_buy_price` VALUES ('7', '2', null, '2014-10-23 21:31:24', '1600000', '1', '80', '5', 'retail', '75');
INSERT INTO `products_buy_price` VALUES ('8', '4', null, '2014-10-23 22:43:11', '3600000', '1', '30', '9', 'wholesale', '30');
INSERT INTO `products_buy_price` VALUES ('9', '3', null, '2014-10-23 22:43:11', '15000000', '1', '50', '6', 'wholesale', '50');

-- ----------------------------
-- Table structure for `products_sale_price`
-- ----------------------------
DROP TABLE IF EXISTS `products_sale_price`;
CREATE TABLE `products_sale_price` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(255) NOT NULL,
  `parent_id` bigint(25) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `quantity` bigint(25) DEFAULT NULL,
  `price` bigint(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of products_sale_price
-- ----------------------------
INSERT INTO `products_sale_price` VALUES ('1', '1', null, 'Thùng', null, '1', '65000');
INSERT INTO `products_sale_price` VALUES ('2', '1', '1', 'Gói', null, '24', '3500');
INSERT INTO `products_sale_price` VALUES ('3', '2', null, 'Thùng', null, '1', '600000');
INSERT INTO `products_sale_price` VALUES ('4', '2', '3', 'Cây', null, '10', '180000');
INSERT INTO `products_sale_price` VALUES ('5', '2', '4', 'Gói', null, '20', '20000');
INSERT INTO `products_sale_price` VALUES ('6', '3', null, 'Thùng', null, '1', '360000');
INSERT INTO `products_sale_price` VALUES ('7', '3', '6', 'Lốc', null, '12', '250000');
INSERT INTO `products_sale_price` VALUES ('8', '3', '7', 'Chai', null, '6', '6000');
INSERT INTO `products_sale_price` VALUES ('9', '4', null, 'Thùng', null, '1', '150000');
INSERT INTO `products_sale_price` VALUES ('10', '4', '9', 'Gói', null, '60', '10000');

-- ----------------------------
-- Table structure for `products_type`
-- ----------------------------
DROP TABLE IF EXISTS `products_type`;
CREATE TABLE `products_type` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of products_type
-- ----------------------------
INSERT INTO `products_type` VALUES ('1', 'mì gói', null, '2014-10-15 23:17:07');
INSERT INTO `products_type` VALUES ('2', 'nước uống', '', '2014-10-15 23:17:17');
INSERT INTO `products_type` VALUES ('3', 'thuốc lá', '', '2014-10-15 23:17:24');
INSERT INTO `products_type` VALUES ('4', 'bánh kẹo', '', '2014-10-15 23:17:32');
INSERT INTO `products_type` VALUES ('5', 'kem đánh răng', '', '2014-10-15 23:17:50');
INSERT INTO `products_type` VALUES ('6', 'lăn nách', null, '2014-10-19 14:40:40');

-- ----------------------------
-- Table structure for `warehouse_retail`
-- ----------------------------
DROP TABLE IF EXISTS `warehouse_retail`;
CREATE TABLE `warehouse_retail` (
  `id` bigint(25) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(25) NOT NULL,
  `quantity` bigint(25) DEFAULT NULL,
  `unit` bigint(25) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of warehouse_retail
-- ----------------------------
INSERT INTO `warehouse_retail` VALUES ('1', '2', '75', '5');
INSERT INTO `warehouse_retail` VALUES ('2', '1', '60', '2');

-- ----------------------------
-- Table structure for `warehouse_wholesale`
-- ----------------------------
DROP TABLE IF EXISTS `warehouse_wholesale`;
CREATE TABLE `warehouse_wholesale` (
  `id` bigint(25) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(25) NOT NULL,
  `quantity` bigint(25) DEFAULT NULL,
  `unit` bigint(25) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of warehouse_wholesale
-- ----------------------------
INSERT INTO `warehouse_wholesale` VALUES ('1', '1', '45', '1');
INSERT INTO `warehouse_wholesale` VALUES ('2', '2', '35', '3');
INSERT INTO `warehouse_wholesale` VALUES ('3', '3', '90', '6');
INSERT INTO `warehouse_wholesale` VALUES ('4', '4', '30', '9');

-- ----------------------------
-- Procedure structure for `make_intervals`
-- ----------------------------
DROP PROCEDURE IF EXISTS `make_intervals`;
DELIMITER ;;
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

 END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for `getValueBuy`
-- ----------------------------
DROP FUNCTION IF EXISTS `getValueBuy`;
DELIMITER ;;
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
END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for `getValueSell`
-- ----------------------------
DROP FUNCTION IF EXISTS `getValueSell`;
DELIMITER ;;
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
END
;;
DELIMITER ;
