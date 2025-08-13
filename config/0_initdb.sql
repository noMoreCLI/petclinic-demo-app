CREATE USER 'DBMon_Agent_User'@'%' IDENTIFIED BY 'AppDynamicsS3cur3';
GRANT SELECT,PROCESS,SHOW DATABASES ON *.* TO 'DBMon_Agent_User'@'%';
GRANT REPLICATION CLIENT ON *.* TO 'DBMon_Agent_User'@'%';
FLUSH privileges;
CREATE DATABASE IF NOT EXISTS petclinic;

ALTER DATABASE petclinic
  DEFAULT CHARACTER SET utf8
  DEFAULT COLLATE utf8_general_ci;

GRANT ALL PRIVILEGES ON petclinic.* TO 'petclinic'@'%' IDENTIFIED BY 'petclinic';
