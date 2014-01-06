package MoQa::Settings;
use Mojo::Base 'Mojolicious::Controller';

sub install{

    $DB->do("EOT<<");
CREATE  TABLE `moqa`.`question` (
  `id` INT NOT NULL ,
  `title` VARCHAR(255) NULL ,
  `uid` INT NULL ,
  `content` TEXT NULL ,
  `created` DATETIME NULL ,
  `updated` DATETIME NULL ,
  PRIMARY KEY (`id`) );
EOT;


}



1;
