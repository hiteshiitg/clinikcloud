SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `uwave`
--

DROP DATABASE `clinikcloud`;
CREATE DATABASE `clinikcloud` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `clinikcloud`;

drop table if exists hospital_speciality;
create table if not exists hospital_speciality(
	hospital_speciality_id bigint(20) not null auto_increment,
	name varchar(128) not null,
	primary key(hospital_speciality_id)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;


drop table if exists hospital;
create table if not exists hospital(
	hospital_id bigint(20) not null auto_increment,
	name varchar(512) not null,
	logo_file varchar(2048),
	phone varchar(20),
	email varchar(256),
	customer_care_no varchar(20),
	is_multi_speciality boolean default false,
	primary key(id)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

drop table if exists hospital_branch;
create table if not exists hospital_branch(
	hospital_branch_id bigint(20) not null auto_increment,
	hospital_id bigint(20) not null,
	name varchar(512),
	address varchar(2048),
	phone varchar(200),
	email varchar(2048),
	customer_care_no varchar(20),
	is_main_branch boolean default false,
	is_multi_speciality boolean default false,
	primary key(hospital_branch_id)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
alter table hospital_branch
	add constraint hospital_branch_fk1 foreign key(hospital_id) references hospital(hospital_id);
	
drop table if exists speciality;
create table if not exists speciality(
	speciality_id int not null auto_increment,
	name varchar(128) not null,
	primary key(speciality_id)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
alter table speciality
	add constraint speciality_uk1 unique key(name);
	
	
drop table if exists hospital_speciality_map;
create table if not not exists  hospital_speciality_map(
	hospital_speciality_map_id bigint(20) not null auto_increment,
	hospital_branch_id bigint(20) not null ,
	speciality_id int not null,
	primary key(hospital_speciality_map_id)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;


DROP TABLE IF EXISTS user_type;
create table if not exists user_type(
  user_type_id INT NOT NULL,
  name varchar(32),
  display_name varchar(128),
  primary key(user_type_id)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

alter table user_type add CONSTRAINT user_type_unique1 UNIQUE KEY(name);

insert into user_type (user_type_id,name) values (1,'admin');
insert into user_type (user_type_id,name) values (2,'doctor');
insert into user_type (user_type_id,name) values (3,'nurse');
insert into user_type (user_type_id,name) values (4,'staff');

drop table if exists ccuser;
create table if not exists ccuser(
  	user_id bigint(20) NOT NULL AUTO_INCREMENT,
  	hospital_branch_id bigint(20) not null,
  	username varchar(256) NOT NULL,
  	password varchar(256),
  	first_name varchar(128),
  	last_name varchar(128),
  	work_phone varchar(20),
  	personal_phone varchar(20),
  	work_email varchar(256),
  	personal_email varchar(256),
  	nickname varchar(128),
  	address varchar(2048),
  	dob timestamp null,
  	height double,
  	photo varchar(2048),
  	joining_date timestamp null,
  	last_date timestamp null,
  	create_time timestamp NOT NULL default current_timestamp,
  	PRIMARY KEY(user_id)
  )ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
  
  ALTER TABLE ccuser
  	add CONSTRAINT ccuser_uk1 UNIQUE KEY(username),
  	add constraint ccuser_fk1 foreign key(hospital_branch_id) references hospital_branch(hospital_branch_id);
  	
drop table if exists user_type_mapping;
create table if not exists user_type_mapping(
	user_type_mapping_id bigint(20) not null auto_increment,
	user_type_id int not null,
	user_id bigint(20) not null,
	primary key(user_type_mapping_id)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
  
alter table user_type_mapping
	add CONSTRAINT user_map_fk1 foreign key(user_id) references ccuser(user_id),
	add constraint user_map_fk2 foreign key(user_type_id) references user_type(user_type_id),
	add constraint user_map_uk1 unique key(user_id,user_type_id);

drop table if exists doctor;
create table if not exists doctor(
	doctor_id bigint(20) not null auto_increment,
	user_id bigint(20) not null,
	user_type_id int not null default 2 CHECK (user_type_id = 2),
	degree varchar(128), 
	primary key(doctor_id)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

alter table doctor
	add CONSTRAINT doctor_fk1 foreign key(user_id) references user(user_id),
	add constraint doctor_fk2 foreign key(user_type_id) references user_type(user_type_id),
	add constraint doctor_fk3 foreign key(user_id,user_type_id) references user_type_mapping(user_id,user_type_id);
	
	
  DROP TABLE IF EXISTS user_session;
CREATE TABLE if not exists user_session (
	id bigint(20) NOT NULL AUTO_INCREMENT,
	session_id VARCHAR(512) NOT NULL,
	last_access_time TIMESTAMP NOT NULL,
	user_id bigint(20) not null,
	PRIMARY KEY(ID)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
alter table user_session
add CONSTRAINT user_session_fk1 FOREIGN KEY (user_id) REFERENCES user(id),
add CONSTRAINT user_session_unique1 UNIQUE KEY(session_id);


	

