/*
Navicat MySQL Data Transfer

Source Server         : 192.168.1.98
Source Server Version : 50173
Source Host           : 192.168.1.98:3306
Source Database       : byr

Target Server Type    : MYSQL
Target Server Version : 50173
File Encoding         : 65001

Date: 2016-09-09 17:24:45
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
  `title` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `content` text,
  `user_id` varchar(255) DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  `publish_time` datetime DEFAULT NULL,
  `insert_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
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
  `title` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `content` text,
  `user_id` varchar(255) DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  `board_name` varchar(255) DEFAULT NULL,
  `post_num` int(11) DEFAULT NULL,
  `publish_time` datetime DEFAULT NULL,
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

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(255) NOT NULL,
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
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for user_id
-- ----------------------------
DROP TABLE IF EXISTS `user_id`;
CREATE TABLE `user_id` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
