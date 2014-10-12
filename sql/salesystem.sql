/*
Navicat MySQL Data Transfer

Source Server         : mySQL
Source Server Version : 50524
Source Host           : localhost:3306
Source Database       : salesystem

Target Server Type    : MYSQL
Target Server Version : 50524
File Encoding         : 65001

Date: 2014-10-13 00:23:13
*/

SET FOREIGN_KEY_CHECKS=0;

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
INSERT INTO `products` VALUES ('1', '102', 'bò húc', '4', 'nước tăng lực', '2014-10-12 11:11:39', null);
INSERT INTO `products` VALUES ('2', '123', 'mì hảo hảo', '2', 'vua của các loại mì tôm', '2014-10-11 18:17:16', null);
INSERT INTO `products` VALUES ('3', '456', 'sting', '3', 'nước uống đéo có gas', '2014-10-12 10:36:39', null);
INSERT INTO `products` VALUES ('4', '256', 'cocacola', '4', 'nước uống như lol', '2014-10-12 10:39:29', null);

-- ----------------------------
-- Table structure for `products_buy_price`
-- ----------------------------
DROP TABLE IF EXISTS `products_buy_price`;
CREATE TABLE `products_buy_price` (
  `id` bigint(50) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(50) NOT NULL,
  `updated` timestamp NULL DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `price` bigint(50) DEFAULT NULL,
  `partner` bigint(25) NOT NULL,
  `quantity` bigint(25) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of products_buy_price
-- ----------------------------
INSERT INTO `products_buy_price` VALUES ('1', '1', null, '2014-10-12 23:25:14', '12000', '1', '1');
INSERT INTO `products_buy_price` VALUES ('2', '2', null, '2014-10-12 23:25:14', '65000', '1', '10');

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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of products_sale_price
-- ----------------------------
INSERT INTO `products_sale_price` VALUES ('3', '2', null, 'thùng', null, '1', '12000');
INSERT INTO `products_sale_price` VALUES ('4', '2', '3', 'lốc', null, '4', '6000');
INSERT INTO `products_sale_price` VALUES ('5', '2', '4', 'gói', null, '6', '3000');
INSERT INTO `products_sale_price` VALUES ('6', '3', null, 'thùng', null, '1', '25000');
INSERT INTO `products_sale_price` VALUES ('7', '3', '6', 'lốc', null, '4', '20000');
INSERT INTO `products_sale_price` VALUES ('8', '3', '7', 'gói', null, '6', '9000');
INSERT INTO `products_sale_price` VALUES ('9', '4', null, 'thùng', null, '1', '36000');
INSERT INTO `products_sale_price` VALUES ('10', '4', '9', 'lốc', null, '6', '25000');
INSERT INTO `products_sale_price` VALUES ('11', '4', '10', 'chai', null, '6', '6000');
INSERT INTO `products_sale_price` VALUES ('14', '1', null, 'thùng', null, '1', '123000');
INSERT INTO `products_sale_price` VALUES ('15', '1', '14', 'lốc', null, '3', '24000');

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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of products_type
-- ----------------------------
INSERT INTO `products_type` VALUES ('1', 'bánh snack', 'khoai tây chiên', '2014-10-01 22:01:35');
INSERT INTO `products_type` VALUES ('2', 'mì gói ', 'tập hợp nhiều loại mì cùng một lúc', '2014-10-09 00:18:54');
INSERT INTO `products_type` VALUES ('3', 'nước tương', null, '2014-10-08 20:06:29');
INSERT INTO `products_type` VALUES ('4', 'nước ngọt', 'nước như cục cưt', '2014-10-12 10:37:55');
INSERT INTO `products_type` VALUES ('5', 'bia', 'ngon vai', '2014-10-12 23:32:28');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of warehouse_retail
-- ----------------------------

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of warehouse_wholesale
-- ----------------------------
INSERT INTO `warehouse_wholesale` VALUES ('1', '1', '1', '12');
INSERT INTO `warehouse_wholesale` VALUES ('2', '2', '10', '3');

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
