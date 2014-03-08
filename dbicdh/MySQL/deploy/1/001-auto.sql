-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Sat Mar  8 11:15:24 2014
-- 
;
SET foreign_key_checks=0;
--
-- Table: `question`
--
CREATE TABLE `question` (
  `id` integer NOT NULL auto_increment,
  `title` varchar(255) NULL,
  `uid` integer NULL,
  `content` text NULL,
  `created` timestamp NULL,
  `updated` timestamp NULL,
  `viewed` integer NULL DEFAULT 0,
  `vote_up` integer NULL DEFAULT 0,
  `vote_down` integer NULL DEFAULT 0,
  PRIMARY KEY (`id`)
);
--
-- Table: `tag`
--
CREATE TABLE `tag` (
  `id` integer NOT NULL auto_increment,
  `name` varchar(45) NOT NULL,
  `description` text NULL,
  `related` integer NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE `tag_UNIQUE` (`name`)
);
--
-- Table: `tagged`
--
CREATE TABLE `tagged` (
  `id` integer NOT NULL auto_increment,
  `qid` integer NOT NULL,
  `tid` integer NOT NULL,
  PRIMARY KEY (`id`)
);
--
-- Table: `user`
--
CREATE TABLE `user` (
  `id` integer NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `pass` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp,
  `last_login` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `score` integer NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
);
SET foreign_key_checks=1;
