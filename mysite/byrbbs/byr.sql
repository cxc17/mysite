/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50713
 Source Host           : localhost
 Source Database       : byr

 Target Server Type    : MySQL
 Target Server Version : 50713
 File Encoding         : utf-8

 Date: 09/26/2016 00:37:48 AM
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `board`
-- ----------------------------
DROP TABLE IF EXISTS `board`;
CREATE TABLE `board` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `board_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `board_name` (`board_name`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `comment`
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
--  Table structure for `data`
-- ----------------------------
DROP TABLE IF EXISTS `data`;
CREATE TABLE `data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data_name` varchar(20) NOT NULL,
  `data_value` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `post`
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
--  Table structure for `user`
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(14) NOT NULL,
  `post_num` int(11) DEFAULT NULL,
  `comment_num` int(11) DEFAULT NULL,
  `user_name` varchar(40) DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `astro` varchar(10) DEFAULT NULL,
  `qq` varchar(100) DEFAULT NULL,
  `msn` varchar(100) DEFAULT NULL,
  `home_page` varchar(100) DEFAULT NULL,
  `level` varchar(10) DEFAULT NULL,
  `post_count` int(11) DEFAULT NULL,
  `score` int(11) DEFAULT NULL,
  `life` int(11) DEFAULT NULL,
  `last_login_time` datetime DEFAULT NULL,
  `last_login_ip` varchar(50) DEFAULT NULL,
  `last_login_site` varchar(20) NOT NULL,
  `last_login_bupt` varchar(20) NOT NULL,
  `status` varchar(30) DEFAULT NULL,
  `face_url` varchar(80) DEFAULT NULL,
  `face_height` float DEFAULT NULL,
  `face_width` float DEFAULT NULL,
  `insert_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `post_num` (`post_num`) USING BTREE,
  KEY `comment_num` (`comment_num`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `user_id`
-- ----------------------------
DROP TABLE IF EXISTS `user_id`;
CREATE TABLE `user_id` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS = 1;
