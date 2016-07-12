/*
Navicat MySQL Data Transfer

Source Server         : 192.168.1.98
Source Server Version : 50173
Source Host           : 192.168.1.98:3306
Source Database       : byr

Target Server Type    : MYSQL
Target Server Version : 50173
File Encoding         : 65001

Date: 2016-06-28 14:41:13
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for board
-- ----------------------------
DROP TABLE IF EXISTS `board`;
CREATE TABLE `board` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `board_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `board_name` (`board_name`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
  `post_id` varchar(255) NOT NULL,
  `comment_id` int(11) NOT NULL AUTO_INCREMENT,
  `comment_url` varchar(255) DEFAULT NULL,
  `comment_content` mediumtext,
  `commenter_id` varchar(255) DEFAULT NULL,
  `commenter_name` varchar(255) DEFAULT NULL,
  `comment_time` datetime DEFAULT NULL,
  `insert_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`comment_id`),
  KEY `post_id` (`post_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1000000 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for post
-- ----------------------------
DROP TABLE IF EXISTS `post`;
CREATE TABLE `post` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` varchar(255) DEFAULT NULL,
  `post_title` varchar(255) DEFAULT NULL,
  `post_url` varchar(255) DEFAULT NULL,
  `post_content` mediumtext,
  `author_id` varchar(255) DEFAULT NULL,
  `author_name` varchar(255) DEFAULT NULL,
  `board_name` varchar(255) DEFAULT NULL,
  `post_num` int(11) DEFAULT NULL,
  `post_time` datetime DEFAULT NULL,
  `last_time` datetime DEFAULT NULL,
  `insert_time` datetime DEFAULT NULL,
  `modify_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `board_name` (`board_name`)
) ENGINE=MyISAM AUTO_INCREMENT=1000000 DEFAULT CHARSET=utf8;
