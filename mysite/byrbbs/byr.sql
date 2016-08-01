/*
Navicat MySQL Data Transfer

Source Server         : 192.168.1.98
Source Server Version : 50173
Source Host           : 192.168.1.98:3306
Source Database       : byr

Target Server Type    : MYSQL
Target Server Version : 50173
File Encoding         : 65001

Date: 2016-08-01 10:53:09
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
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
  `post_id` char(16) NOT NULL,
  `comment_id` int(11) NOT NULL AUTO_INCREMENT,
  `comment_url` varchar(255) DEFAULT NULL,
  `comment_content` text,
  `commenter_id` varchar(255) DEFAULT NULL,
  `commenter_name` varchar(255) DEFAULT NULL,
  `comment_time` datetime DEFAULT NULL,
  `insert_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`comment_id`),
  KEY `post_id` (`post_id`),
  KEY `comment_url` (`comment_url`) USING BTREE,
  KEY `commenter_id` (`commenter_id`) USING BTREE,
  KEY `commenter_name` (`commenter_name`) USING BTREE,
  KEY `comment_time` (`comment_time`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=1000001 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for post
-- ----------------------------
DROP TABLE IF EXISTS `post`;
CREATE TABLE `post` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` char(16) NOT NULL,
  `post_title` varchar(255) DEFAULT NULL,
  `post_url` varchar(255) DEFAULT NULL,
  `post_content` text,
  `author_id` varchar(255) DEFAULT NULL,
  `author_name` varchar(255) DEFAULT NULL,
  `board_name` varchar(255) DEFAULT NULL,
  `post_num` int(11) DEFAULT NULL,
  `post_time` datetime DEFAULT NULL,
  `last_time` datetime DEFAULT NULL,
  `insert_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`post_id`),
  KEY `post_id` (`post_id`) USING BTREE,
  KEY `post_title` (`post_title`) USING BTREE,
  KEY `post_url` (`post_url`) USING BTREE,
  KEY `author_id` (`author_id`) USING BTREE,
  KEY `author_name` (`author_name`) USING BTREE,
  KEY `board_name` (`board_name`) USING BTREE,
  KEY `post_num` (`post_num`) USING BTREE,
  KEY `post_time` (`post_time`) USING BTREE,
  KEY `last_time` (`last_time`) USING BTREE,
  KEY `insert_time` (`insert_time`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=1000001 DEFAULT CHARSET=utf8;
