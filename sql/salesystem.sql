/*
Navicat MySQL Data Transfer

Source Server         : mySQL
Source Server Version : 50524
Source Host           : localhost:3306
Source Database       : salesystem

Target Server Type    : MYSQL
Target Server Version : 50524
File Encoding         : 65001

Date: 2014-12-19 00:04:51
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
  `debit` bigint(20) DEFAULT NULL,
  `price_total` bigint(50) DEFAULT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `warehouse` enum('retail','wholesale') COLLATE utf8_unicode_ci DEFAULT 'wholesale',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of bill
-- ----------------------------
INSERT INTO `bill` VALUES ('1', 'B4F712', '1', null, '2925000', '2014-10-23 21:20:57', 'wholesale');
INSERT INTO `bill` VALUES ('2', '3BF074', '1', null, '3900000', '2014-10-23 21:21:19', 'wholesale');
INSERT INTO `bill` VALUES ('3', '1E0646', '1', null, '800000', '2014-10-23 21:32:06', 'retail');
INSERT INTO `bill` VALUES ('4', 'C87029', '1', null, '300000', '2014-10-23 21:32:34', 'retail');
INSERT INTO `bill` VALUES ('5', 'F14B6C', '1', null, '6000000', '2014-10-23 22:33:12', 'wholesale');
INSERT INTO `bill` VALUES ('6', '7AFB33', '1', null, '6000000', '2014-10-23 22:35:38', 'wholesale');
INSERT INTO `bill` VALUES ('7', '5F883A', '1', null, '3600000', '2014-10-23 22:38:09', 'wholesale');
INSERT INTO `bill` VALUES ('8', 'C672D8', '1', null, '6600000', '2014-10-23 22:38:40', 'wholesale');
INSERT INTO `bill` VALUES ('9', 'E0455F', '1', '460000', '26460000', '2014-11-15 14:25:02', 'wholesale');
INSERT INTO `bill` VALUES ('10', '401EC4', '1', '250000', '13250000', '2014-12-01 20:29:31', 'wholesale');
INSERT INTO `bill` VALUES ('11', 'DBE7C9', '1', '195000', '3195000', '2014-12-02 22:45:53', 'wholesale');
INSERT INTO `bill` VALUES ('15', 'C9B123', '3', null, '3150000', '2014-12-18 00:52:50', 'wholesale');
INSERT INTO `bill` VALUES ('16', '8FCD60', '3', '430000', '8430000', '2014-12-18 00:57:26', 'wholesale');
INSERT INTO `bill` VALUES ('17', '40396B', '2', null, '6480000', '2014-12-18 01:18:14', 'wholesale');
INSERT INTO `bill` VALUES ('18', 'AE9ED9', '2', null, '6775000', '2014-12-18 01:19:30', 'wholesale');
INSERT INTO `bill` VALUES ('19', '7FABA6', '3', null, '4375000', '2014-12-18 23:35:27', 'wholesale');
INSERT INTO `bill` VALUES ('20', '42CBB3', '3', '260000', '3260000', '2014-12-18 23:36:03', 'wholesale');

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
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
INSERT INTO `bill_detail` VALUES ('9', '9', '1', '12', '780000');
INSERT INTO `bill_detail` VALUES ('10', '9', '2', '35', '21000000');
INSERT INTO `bill_detail` VALUES ('11', '9', '3', '13', '4680000');
INSERT INTO `bill_detail` VALUES ('12', '10', '1', '10', '650000');
INSERT INTO `bill_detail` VALUES ('13', '10', '3', '30', '10800000');
INSERT INTO `bill_detail` VALUES ('14', '10', '4', '12', '1800000');
INSERT INTO `bill_detail` VALUES ('15', '11', '2', '5', '3000000');
INSERT INTO `bill_detail` VALUES ('16', '11', '1', '3', '195000');
INSERT INTO `bill_detail` VALUES ('20', '15', '1', '6', '65000');
INSERT INTO `bill_detail` VALUES ('21', '15', '2', '7', '180000');
INSERT INTO `bill_detail` VALUES ('22', '15', '4', '10', '150000');
INSERT INTO `bill_detail` VALUES ('23', '16', '1', '6', '65000');
INSERT INTO `bill_detail` VALUES ('24', '16', '3', '9', '360000');
INSERT INTO `bill_detail` VALUES ('25', '16', '2', '8', '600000');
INSERT INTO `bill_detail` VALUES ('26', '17', '3', '3', '360000');
INSERT INTO `bill_detail` VALUES ('27', '17', '2', '9', '600000');
INSERT INTO `bill_detail` VALUES ('28', '18', '1', '5', '65000');
INSERT INTO `bill_detail` VALUES ('29', '18', '2', '9', '600000');
INSERT INTO `bill_detail` VALUES ('30', '18', '4', '7', '150000');
INSERT INTO `bill_detail` VALUES ('31', '19', '1', '5', '325000');
INSERT INTO `bill_detail` VALUES ('32', '19', '2', '6', '3600000');
INSERT INTO `bill_detail` VALUES ('33', '19', '4', '3', '450000');
INSERT INTO `bill_detail` VALUES ('34', '20', '1', '4', '260000');
INSERT INTO `bill_detail` VALUES ('35', '20', '2', '5', '3000000');

-- ----------------------------
-- Table structure for `customers`
-- ----------------------------
DROP TABLE IF EXISTS `customers`;
CREATE TABLE `customers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `store_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone_home` int(20) DEFAULT NULL,
  `phone_mobile` int(20) DEFAULT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `type` enum('customer','partner') COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of customers
-- ----------------------------
INSERT INTO `customers` VALUES ('1', 'Tin', 'Ngoc Thanh Thao', '23 nkkn', '369852147', '326589877', '2014-12-05 01:25:07', 'partner');
INSERT INTO `customers` VALUES ('2', 'Hao Nguyen', null, '116 le van quoi', '839783536', '965392345', '2014-12-05 01:26:36', 'customer');
INSERT INTO `customers` VALUES ('3', 'Kiet Nguyen', null, '23 No Trang Long', '236985741', '2147483647', '2014-12-06 00:37:41', 'customer');
INSERT INTO `customers` VALUES ('4', 'Linh Nguyến', null, '112 Hai Bà Trưng', '2147483647', '2147483647', '2014-12-18 23:03:14', 'customer');
INSERT INTO `customers` VALUES ('5', 'Lan Nguyến', 'lan rừng', '96 lê lư', '2147483647', '2147483647', '2014-12-18 23:04:59', 'partner');

-- ----------------------------
-- Table structure for `export_bill`
-- ----------------------------
DROP TABLE IF EXISTS `export_bill`;
CREATE TABLE `export_bill` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `warehouse_from` bigint(20) DEFAULT NULL,
  `warehouse_to` bigint(20) DEFAULT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of export_bill
-- ----------------------------
INSERT INTO `export_bill` VALUES ('1', '2', '4', '2014-11-28 01:28:57');
INSERT INTO `export_bill` VALUES ('2', '1', '2', '2014-12-01 20:32:15');
INSERT INTO `export_bill` VALUES ('3', '3', '5', '2014-12-02 22:43:11');

-- ----------------------------
-- Table structure for `export_detail`
-- ----------------------------
DROP TABLE IF EXISTS `export_detail`;
CREATE TABLE `export_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `export_id` bigint(20) DEFAULT NULL,
  `product_id` bigint(20) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of export_detail
-- ----------------------------
INSERT INTO `export_detail` VALUES ('1', '1', '1', '2');
INSERT INTO `export_detail` VALUES ('2', '1', '2', '4');
INSERT INTO `export_detail` VALUES ('3', '2', '1', '4');
INSERT INTO `export_detail` VALUES ('4', '2', '2', '2');
INSERT INTO `export_detail` VALUES ('5', '3', '2', '5');
INSERT INTO `export_detail` VALUES ('6', '3', '3', '3');

-- ----------------------------
-- Table structure for `order`
-- ----------------------------
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `customer_id` bigint(20) DEFAULT NULL,
  `total_price` bigint(20) DEFAULT NULL,
  `delivery` enum('1','0') COLLATE utf8_unicode_ci DEFAULT '0',
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT '2',
  `shipment_id` int(11) DEFAULT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of order
-- ----------------------------
INSERT INTO `order` VALUES ('1', '2', '6775000', '1', '1', '1', '2014-12-12 20:14:03');
INSERT INTO `order` VALUES ('2', '3', '3150000', '1', '1', '2', '2014-12-13 13:54:46');
INSERT INTO `order` VALUES ('3', '3', '8430000', '1', '1', '2', '2014-12-13 16:19:45');
INSERT INTO `order` VALUES ('4', '2', '6480000', '1', '1', '2', '2014-12-13 17:04:29');
INSERT INTO `order` VALUES ('5', '3', '6000000', '0', '2', '3', '2014-12-15 16:19:34');
INSERT INTO `order` VALUES ('6', '2', '5400000', '0', '1', '4', '2014-12-15 16:22:01');
INSERT INTO `order` VALUES ('7', '3', '4375000', '1', '1', '5', '2014-12-18 23:26:17');
INSERT INTO `order` VALUES ('8', '3', '3260000', '1', '1', '5', '2014-12-18 23:30:24');
INSERT INTO `order` VALUES ('9', '2', '3000000', '0', '2', '6', '2014-12-18 23:42:53');
INSERT INTO `order` VALUES ('10', '3', '1620000', '0', '2', '6', '2014-12-18 23:43:16');

-- ----------------------------
-- Table structure for `order_detail`
-- ----------------------------
DROP TABLE IF EXISTS `order_detail`;
CREATE TABLE `order_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) DEFAULT NULL,
  `product_id` bigint(20) DEFAULT NULL,
  `quantity` bigint(20) DEFAULT NULL,
  `unit` bigint(20) DEFAULT NULL,
  `cost` int(11) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `total` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of order_detail
-- ----------------------------
INSERT INTO `order_detail` VALUES ('1', '1', '1', '5', '1', '1', '65000', '325000');
INSERT INTO `order_detail` VALUES ('2', '1', '2', '9', '3', '2', '600000', '5400000');
INSERT INTO `order_detail` VALUES ('3', '1', '4', '7', '9', '8', '150000', '1050000');
INSERT INTO `order_detail` VALUES ('4', '2', '1', '6', '1', '1', '65000', '390000');
INSERT INTO `order_detail` VALUES ('5', '2', '2', '7', '4', '2', '180000', '1260000');
INSERT INTO `order_detail` VALUES ('6', '2', '4', '10', '9', '8', '150000', '1500000');
INSERT INTO `order_detail` VALUES ('7', '3', '1', '6', '1', '1', '65000', '390000');
INSERT INTO `order_detail` VALUES ('8', '3', '3', '9', '6', '4', '360000', '3240000');
INSERT INTO `order_detail` VALUES ('9', '3', '2', '8', '3', '2', '600000', '4800000');
INSERT INTO `order_detail` VALUES ('10', '4', '3', '3', '6', '4', '360000', '1080000');
INSERT INTO `order_detail` VALUES ('11', '4', '2', '9', '3', '2', '600000', '5400000');
INSERT INTO `order_detail` VALUES ('12', '5', '2', '7', '3', '2', '600000', '4200000');
INSERT INTO `order_detail` VALUES ('13', '5', '3', '5', '6', '4', '360000', '1800000');
INSERT INTO `order_detail` VALUES ('14', '6', '3', '15', '6', '4', '360000', '5400000');
INSERT INTO `order_detail` VALUES ('15', '7', '1', '5', '1', '1', '65000', '325000');
INSERT INTO `order_detail` VALUES ('16', '7', '2', '6', '3', '2', '600000', '3600000');
INSERT INTO `order_detail` VALUES ('17', '7', '4', '3', '9', '8', '150000', '450000');
INSERT INTO `order_detail` VALUES ('18', '8', '1', '4', '1', '1', '65000', '260000');
INSERT INTO `order_detail` VALUES ('19', '8', '2', '5', '3', '2', '600000', '3000000');
INSERT INTO `order_detail` VALUES ('20', '9', '2', '5', '3', '2', '600000', '3000000');
INSERT INTO `order_detail` VALUES ('21', '10', '2', '9', '4', '2', '180000', '1620000');

-- ----------------------------
-- Table structure for `order_status_type`
-- ----------------------------
DROP TABLE IF EXISTS `order_status_type`;
CREATE TABLE `order_status_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of order_status_type
-- ----------------------------
INSERT INTO `order_status_type` VALUES ('1', 'Đang Giao');
INSERT INTO `order_status_type` VALUES ('2', 'Đang lên');
INSERT INTO `order_status_type` VALUES ('3', 'Đã Giao');
INSERT INTO `order_status_type` VALUES ('4', 'Xuất lại kho');
INSERT INTO `order_status_type` VALUES ('5', 'Để Lại');

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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of products_buy_price
-- ----------------------------
INSERT INTO `products_buy_price` VALUES ('1', '1', null, null, '2014-10-23 21:19:35', '16000000', '1', '100', '1', 'wholesale', '0');
INSERT INTO `products_buy_price` VALUES ('2', '2', null, null, '2014-10-23 21:19:35', '25000000', '1', '50', '3', 'wholesale', '0');
INSERT INTO `products_buy_price` VALUES ('3', '1', null, null, '2014-10-23 21:20:30', '7500000', '1', '50', '1', 'wholesale', '20');
INSERT INTO `products_buy_price` VALUES ('4', '3', null, null, '2014-10-23 21:20:30', '18000000', '1', '60', '6', 'wholesale', '0');
INSERT INTO `products_buy_price` VALUES ('5', '2', null, null, '2014-10-23 21:30:56', '1000000', '1', '50', '5', 'retail', '0');
INSERT INTO `products_buy_price` VALUES ('6', '1', null, null, '2014-10-23 21:30:57', '210000', '1', '60', '2', 'retail', '60');
INSERT INTO `products_buy_price` VALUES ('7', '2', null, null, '2014-10-23 21:31:24', '1600000', '1', '80', '5', 'retail', '75');
INSERT INTO `products_buy_price` VALUES ('8', '4', null, null, '2014-10-23 22:43:11', '3600000', '1', '30', '9', 'wholesale', '18');
INSERT INTO `products_buy_price` VALUES ('9', '3', null, null, '2014-10-23 22:43:11', '15000000', '1', '50', '6', 'wholesale', '47');
INSERT INTO `products_buy_price` VALUES ('10', '1', '1', null, '2014-11-05 00:24:09', '200000', '1', '1', '1', 'wholesale', '1');
INSERT INTO `products_buy_price` VALUES ('11', '2', '2', null, '2014-11-06 00:18:44', '3600000', '1', '10', '3', 'wholesale', '5');
INSERT INTO `products_buy_price` VALUES ('12', '3', '2', null, '2014-11-06 00:18:44', '3000000', '1', '25', '6', 'wholesale', '25');
INSERT INTO `products_buy_price` VALUES ('13', '1', '3', null, '2014-11-06 00:24:52', '6000000', '1', '100', '1', 'wholesale', '100');
INSERT INTO `products_buy_price` VALUES ('14', '3', '3', null, '2014-11-06 00:24:52', '4000000', '1', '50', '6', 'wholesale', '50');
INSERT INTO `products_buy_price` VALUES ('15', '4', '3', null, '2014-11-06 00:24:52', '3000000', '1', '60', '9', 'wholesale', '60');
INSERT INTO `products_buy_price` VALUES ('16', '1', '4', null, '2014-11-06 00:27:09', '3000000', '1', '50', '1', 'wholesale', '50');
INSERT INTO `products_buy_price` VALUES ('17', '2', '4', null, '2014-11-06 00:27:09', '5000000', '1', '25', '3', 'wholesale', '25');
INSERT INTO `products_buy_price` VALUES ('18', '3', '4', null, '2014-11-06 00:27:09', '3000000', '1', '60', '6', 'wholesale', '60');
INSERT INTO `products_buy_price` VALUES ('19', '1', '5', null, '2014-11-16 14:03:27', '5000000', '1', '100', '1', 'wholesale', '100');
INSERT INTO `products_buy_price` VALUES ('20', '3', '5', null, '2014-11-16 14:03:28', '3000000', '1', '50', '6', 'wholesale', '50');
INSERT INTO `products_buy_price` VALUES ('21', '4', '5', null, '2014-11-16 14:03:28', '2400000', '1', '30', '9', 'wholesale', '30');

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
-- Table structure for `shipments`
-- ----------------------------
DROP TABLE IF EXISTS `shipments`;
CREATE TABLE `shipments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `truck_id` bigint(20) DEFAULT NULL,
  `driver` bigint(20) DEFAULT NULL,
  `sub_driver` bigint(20) DEFAULT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `allow` enum('1','0') COLLATE utf8_unicode_ci DEFAULT '0',
  `status` enum('2','1','3','0') COLLATE utf8_unicode_ci DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of shipments
-- ----------------------------
INSERT INTO `shipments` VALUES ('1', '1', '1', '2', '2014-12-13 16:13:23', '0', '3');
INSERT INTO `shipments` VALUES ('2', '1', '1', '2', '2014-12-13 17:07:02', '0', '3');
INSERT INTO `shipments` VALUES ('3', '2', '1', '2', '2014-12-15 16:19:43', '0', '0');
INSERT INTO `shipments` VALUES ('4', '1', '1', '2', '2014-12-15 16:22:27', '1', '2');
INSERT INTO `shipments` VALUES ('5', '2', '1', '2', '2014-12-18 23:30:37', '1', '3');
INSERT INTO `shipments` VALUES ('6', '1', '1', '2', '2014-12-18 23:43:25', '0', '0');

-- ----------------------------
-- Table structure for `warehouses`
-- ----------------------------
DROP TABLE IF EXISTS `warehouses`;
CREATE TABLE `warehouses` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `allow` enum('1','0') COLLATE utf8_unicode_ci DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of warehouses
-- ----------------------------
INSERT INTO `warehouses` VALUES ('1', 'Đổng khởi', '112 lê làm phường tân thành quận tân phú', 'kho này đek có gì lưu hết =))', '');
INSERT INTO `warehouses` VALUES ('2', 'Lê Lư', '452 Lê Lư, phường phú thạnh quận tân phú', 'ở đây cũng éo có hàng', '');
INSERT INTO `warehouses` VALUES ('3', 'Lê Văn Quới', '139 Lê Văn Quới, Phường Bình Hưng Hòa A, Quận Bình Tân', null, '');
INSERT INTO `warehouses` VALUES ('4', 'CMT8', '112 cách mạng tháng 8', null, '');
INSERT INTO `warehouses` VALUES ('5', 'aon mall', '12 bờ bao tân thăng', null, '');

-- ----------------------------
-- Table structure for `warehouses_detail`
-- ----------------------------
DROP TABLE IF EXISTS `warehouses_detail`;
CREATE TABLE `warehouses_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `warehouses_id` bigint(20) DEFAULT NULL,
  `product_id` bigint(20) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `quantity` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of warehouses_detail
-- ----------------------------
INSERT INTO `warehouses_detail` VALUES ('1', '1', '1', '2014-11-15 15:51:25', '10');
INSERT INTO `warehouses_detail` VALUES ('2', '1', '2', '2014-11-15 15:51:25', '1');
INSERT INTO `warehouses_detail` VALUES ('3', '1', '3', '2014-11-15 15:51:25', '15');
INSERT INTO `warehouses_detail` VALUES ('4', '2', '1', '2014-11-15 15:51:25', '6');
INSERT INTO `warehouses_detail` VALUES ('5', '2', '2', '2014-11-15 15:51:25', '0');
INSERT INTO `warehouses_detail` VALUES ('6', '2', '3', '2014-11-15 15:51:25', '15');
INSERT INTO `warehouses_detail` VALUES ('7', '3', '1', '2014-11-15 15:51:25', '13');
INSERT INTO `warehouses_detail` VALUES ('8', '3', '2', '2014-11-15 15:51:26', '5');
INSERT INTO `warehouses_detail` VALUES ('9', '3', '3', '2014-11-15 15:51:26', '20');
INSERT INTO `warehouses_detail` VALUES ('10', '4', '1', '2014-11-15 15:51:26', '8');
INSERT INTO `warehouses_detail` VALUES ('11', '4', '2', '2014-11-15 15:51:26', '5');
INSERT INTO `warehouses_detail` VALUES ('12', '4', '3', '2014-11-15 15:51:26', '26');
INSERT INTO `warehouses_detail` VALUES ('13', '5', '1', '2014-11-15 15:51:26', '60');
INSERT INTO `warehouses_detail` VALUES ('14', '5', '2', '2014-11-15 15:51:26', '6');
INSERT INTO `warehouses_detail` VALUES ('15', '5', '3', '2014-11-15 15:51:26', '30');
INSERT INTO `warehouses_detail` VALUES ('16', '1', '4', '2014-11-16 14:04:57', '0');
INSERT INTO `warehouses_detail` VALUES ('17', '2', '4', '2014-11-16 14:04:58', '6');
INSERT INTO `warehouses_detail` VALUES ('18', '3', '4', '2014-11-16 14:04:58', '5');
INSERT INTO `warehouses_detail` VALUES ('19', '4', '4', '2014-11-16 14:04:59', '9');
INSERT INTO `warehouses_detail` VALUES ('20', '5', '4', '2014-11-16 14:04:59', '3');

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
INSERT INTO `warehouse_wholesale` VALUES ('1', '1', '271', '1');
INSERT INTO `warehouse_wholesale` VALUES ('2', '2', '23', '3');
INSERT INTO `warehouse_wholesale` VALUES ('3', '3', '227', '6');
INSERT INTO `warehouse_wholesale` VALUES ('4', '4', '108', '9');

-- ----------------------------
-- Table structure for `warehousing`
-- ----------------------------
DROP TABLE IF EXISTS `warehousing`;
CREATE TABLE `warehousing` (
  `id` bigint(50) NOT NULL AUTO_INCREMENT,
  `price` bigint(50) DEFAULT NULL,
  `debit` bigint(50) DEFAULT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `warehouse` enum('wholesale','retail') COLLATE utf8_unicode_ci DEFAULT 'wholesale',
  `allow` enum('1','0') COLLATE utf8_unicode_ci DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of warehousing
-- ----------------------------
INSERT INTO `warehousing` VALUES ('1', '200000', '0', '2014-11-05 00:24:09', 'wholesale', '0');
INSERT INTO `warehousing` VALUES ('2', '6600000', '0', '2014-11-06 00:18:43', 'wholesale', '1');
INSERT INTO `warehousing` VALUES ('3', '13000000', '0', '2014-11-06 00:24:52', 'wholesale', '0');
INSERT INTO `warehousing` VALUES ('4', '11000000', '1000000', '2014-11-06 00:27:09', 'wholesale', '1');
INSERT INTO `warehousing` VALUES ('5', '10400000', '400000', '2014-11-16 14:03:26', 'wholesale', '1');

-- ----------------------------
-- Table structure for `warehousing_history`
-- ----------------------------
DROP TABLE IF EXISTS `warehousing_history`;
CREATE TABLE `warehousing_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) DEFAULT NULL,
  `warehouses_id` bigint(20) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `warehousing_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of warehousing_history
-- ----------------------------
INSERT INTO `warehousing_history` VALUES ('1', '1', '1', '5', '2014-11-15 15:51:25', null);
INSERT INTO `warehousing_history` VALUES ('2', '2', '1', '8', '2014-11-15 15:51:25', null);
INSERT INTO `warehousing_history` VALUES ('3', '3', '1', '10', '2014-11-15 15:51:25', null);
INSERT INTO `warehousing_history` VALUES ('4', '1', '2', '6', '2014-11-15 15:51:25', null);
INSERT INTO `warehousing_history` VALUES ('5', '2', '2', '6', '2014-11-15 15:51:25', null);
INSERT INTO `warehousing_history` VALUES ('6', '3', '2', '20', '2014-11-15 15:51:25', null);
INSERT INTO `warehousing_history` VALUES ('7', '1', '3', '8', '2014-11-15 15:51:25', null);
INSERT INTO `warehousing_history` VALUES ('8', '2', '3', '9', '2014-11-15 15:51:26', null);
INSERT INTO `warehousing_history` VALUES ('9', '3', '3', '20', '2014-11-15 15:51:26', null);
INSERT INTO `warehousing_history` VALUES ('10', '1', '4', '7', '2014-11-15 15:51:26', null);
INSERT INTO `warehousing_history` VALUES ('11', '2', '4', '1', '2014-11-15 15:51:26', null);
INSERT INTO `warehousing_history` VALUES ('12', '3', '4', '10', '2014-11-15 15:51:26', null);
INSERT INTO `warehousing_history` VALUES ('13', '1', '5', '9', '2014-11-15 15:51:26', null);
INSERT INTO `warehousing_history` VALUES ('14', '2', '5', '1', '2014-11-15 15:51:26', null);
INSERT INTO `warehousing_history` VALUES ('15', '3', '5', '0', '2014-11-15 15:51:26', null);
INSERT INTO `warehousing_history` VALUES ('16', '2', '1', '2', '2014-11-15 17:47:00', '2');
INSERT INTO `warehousing_history` VALUES ('17', '3', '1', '4', '2014-11-15 17:47:00', '2');
INSERT INTO `warehousing_history` VALUES ('18', '2', '2', '3', '2014-11-15 17:47:00', '2');
INSERT INTO `warehousing_history` VALUES ('19', '3', '2', '2', '2014-11-15 17:47:00', '2');
INSERT INTO `warehousing_history` VALUES ('20', '2', '3', '5', '2014-11-15 17:47:00', '2');
INSERT INTO `warehousing_history` VALUES ('21', '3', '3', '3', '2014-11-15 17:47:00', '2');
INSERT INTO `warehousing_history` VALUES ('22', '2', '4', '0', '2014-11-15 17:47:00', '2');
INSERT INTO `warehousing_history` VALUES ('23', '3', '4', '8', '2014-11-15 17:47:00', '2');
INSERT INTO `warehousing_history` VALUES ('24', '2', '5', '0', '2014-11-15 17:47:00', '2');
INSERT INTO `warehousing_history` VALUES ('25', '3', '5', '7', '2014-11-15 17:47:00', '2');
INSERT INTO `warehousing_history` VALUES ('26', '1', '1', '25', '2014-11-16 14:04:57', '5');
INSERT INTO `warehousing_history` VALUES ('27', '3', '1', '5', '2014-11-16 14:04:57', '5');
INSERT INTO `warehousing_history` VALUES ('28', '4', '1', '3', '2014-11-16 14:04:57', '5');
INSERT INTO `warehousing_history` VALUES ('29', '1', '2', '3', '2014-11-16 14:04:58', '5');
INSERT INTO `warehousing_history` VALUES ('30', '3', '2', '4', '2014-11-16 14:04:58', '5');
INSERT INTO `warehousing_history` VALUES ('31', '4', '2', '6', '2014-11-16 14:04:58', '5');
INSERT INTO `warehousing_history` VALUES ('32', '1', '3', '5', '2014-11-16 14:04:58', '5');
INSERT INTO `warehousing_history` VALUES ('33', '3', '3', '3', '2014-11-16 14:04:58', '5');
INSERT INTO `warehousing_history` VALUES ('34', '4', '3', '5', '2014-11-16 14:04:58', '5');
INSERT INTO `warehousing_history` VALUES ('35', '1', '4', '6', '2014-11-16 14:04:58', '5');
INSERT INTO `warehousing_history` VALUES ('36', '3', '4', '8', '2014-11-16 14:04:59', '5');
INSERT INTO `warehousing_history` VALUES ('37', '4', '4', '9', '2014-11-16 14:04:59', '5');
INSERT INTO `warehousing_history` VALUES ('38', '1', '5', '55', '2014-11-16 14:04:59', '5');
INSERT INTO `warehousing_history` VALUES ('39', '3', '5', '20', '2014-11-16 14:04:59', '5');
INSERT INTO `warehousing_history` VALUES ('40', '4', '5', '3', '2014-11-16 14:05:00', '5');

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
