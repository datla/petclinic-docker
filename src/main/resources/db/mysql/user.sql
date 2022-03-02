CREATE DATABASE IF NOT EXISTS petclinicdb;

ALTER DATABASE petclinicdb
  DEFAULT CHARACTER SET utf8
  DEFAULT COLLATE utf8_general_ci;

GRANT ALL PRIVILEGES ON petclinicdb.* TO 'petclinic'@'%' IDENTIFIED BY 'pclinic';
