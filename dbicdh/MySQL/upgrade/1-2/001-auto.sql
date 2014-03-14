-- Convert schema '/home/leetom/git/MoQa/dbicdh/_source/deploy/1/001-auto.yml' to '/home/leetom/git/MoQa/dbicdh/_source/deploy/2/001-auto.yml':;

;
BEGIN;

;
SET foreign_key_checks=0;

;
CREATE TABLE answer (
  id integer NOT NULL auto_increment,
  uid integer NOT NULL,
  qid integer NOT NULL,
  content text NOT NULL,
  created timestamp NOT NULL,
  updated timestamp NULL,
  vote_up integer NULL DEFAULT 0,
  vote_down integer NULL DEFAULT 0,
  PRIMARY KEY (id)
);

;
CREATE TABLE role (
  id integer NOT NULL auto_increment,
  name varchar(45) NOT NULL,
  description text NULL,
  perm integer NOT NULL,
  PRIMARY KEY (id)
);

;
SET foreign_key_checks=1;

;
ALTER TABLE question ADD COLUMN best_answer integer NULL DEFAULT 0;

;

COMMIT;

