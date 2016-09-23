/*
Navicat MySQL Data Transfer

Source Server         : 192.168.1.98
Source Server Version : 50173
Source Host           : 192.168.1.98:3306
Source Database       : byr

Target Server Type    : MYSQL
Target Server Version : 50173
File Encoding         : 65001

Date: 2016-09-23 16:30:42
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
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` char(16) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `url` varchar(80) DEFAULT NULL,
  `content` text,
  `user_id` varchar(13) DEFAULT NULL,
  `user_name` varchar(40) DEFAULT NULL,
  `publish_time` datetime DEFAULT NULL,
  `insert_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `post_id` (`post_id`),
  KEY `url` (`url`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `user_name` (`user_name`) USING BTREE,
  KEY `publish_time` (`publish_time`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=1000001 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for post
-- ----------------------------
DROP TABLE IF EXISTS `post`;
CREATE TABLE `post` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` char(16) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `url` varchar(80) DEFAULT NULL,
  `content` text,
  `user_id` varchar(13) DEFAULT NULL,
  `user_name` varchar(40) DEFAULT NULL,
  `board_name` varchar(30) DEFAULT NULL,
  `post_num` int(11) DEFAULT NULL,
  `publish_time` datetime DEFAULT NULL,
  `last_time` datetime DEFAULT NULL,
  `insert_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`post_id`),
  KEY `post_id` (`post_id`) USING BTREE,
  KEY `title` (`title`) USING BTREE,
  KEY `url` (`url`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `user_name` (`user_name`) USING BTREE,
  KEY `board_name` (`board_name`) USING BTREE,
  KEY `post_num` (`post_num`) USING BTREE,
  KEY `publish_time` (`publish_time`) USING BTREE,
  KEY `last_time` (`last_time`) USING BTREE,
  KEY `insert_time` (`insert_time`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=1000001 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(255) NOT NULL,
  `post_num` int(11) DEFAULT NULL,
  `comment_num` int(11) DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `astro` varchar(255) DEFAULT NULL,
  `qq` varchar(255) DEFAULT NULL,
  `msn` varchar(255) DEFAULT NULL,
  `home_page` varchar(255) DEFAULT NULL,
  `level` varchar(255) DEFAULT NULL,
  `post_count` int(11) DEFAULT NULL,
  `score` int(11) DEFAULT NULL,
  `life` int(11) DEFAULT NULL,
  `last_login_time` datetime DEFAULT NULL,
  `last_login_ip` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `face_url` varchar(255) DEFAULT NULL,
  `face_height` float DEFAULT NULL,
  `face_width` float DEFAULT NULL,
  `insert_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `post_num` (`post_num`) USING BTREE,
  KEY `comment_num` (`comment_num`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for user_id
-- ----------------------------
DROP TABLE IF EXISTS `user_id`;
CREATE TABLE `user_id` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
