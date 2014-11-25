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
	address varchar(2048),
	customer_care_no varchar(20),
	is_multi_speciality boolean default false,
	primary key(hospital_id)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
	
drop table if exists speciality;
create table if not exists speciality(
	speciality_id int not null auto_increment,
	name varchar(128) not null,
	primary key(speciality_id)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
alter table speciality
	add constraint speciality_uk1 unique key(name);
	
	
drop table if exists hospital_speciality_map;
create table if not exists  hospital_speciality_map(
	hospital_speciality_map_id bigint(20) not null auto_increment,
	hospital__id bigint(20) not null ,
	speciality_id int not null,
	primary key(hospital_speciality_map_id)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

alter table hospital_speciality_map
	add constraint speciality_map_fk1 foreign key(hospital__id) references hospital(hospital__id),
	add constraint speciality_map_fk1 foreign key(speciality_id) references speciality(speciality_id);


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
  	add CONSTRAINT ccuser_uk1 UNIQUE KEY(username);
  	
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
	add CONSTRAINT doctor_fk1 foreign key(user_id) references ccuser(user_id),
	add constraint doctor_fk2 foreign key(user_type_id) references user_type(user_type_id),
	add constraint doctor_fk3 foreign key(user_id,user_type_id) references user_type_mapping(user_id,user_type_id);
	
drop table if exists nurse;
create table if not exists nurse(
	nurse_id bigint(20) not null auto_increment,
	user_id bigint(20) not null,
	user_type_id int not null default 2 CHECK (user_type_id = 3),
	nurse_degree varchar(256),
	primary key(nurse_id)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
	
alter table nurse
	add CONSTRAINT nurse_fk1 foreign key(user_id) references ccuser(user_id),
	add constraint nurse_fk2 foreign key(user_type_id) references user_type(user_type_id),
	add constraint nurse_fk3 foreign key(user_id,user_type_id) references user_type_mapping(user_id,user_type_id);
	
  DROP TABLE IF EXISTS user_session;
CREATE TABLE if not exists user_session (
	id bigint(20) NOT NULL AUTO_INCREMENT,
	session_id VARCHAR(512) NOT NULL,
	last_access_time TIMESTAMP NOT NULL,
	user_id bigint(20) not null,
	PRIMARY KEY(ID)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
alter table user_session
add CONSTRAINT user_session_fk1 FOREIGN KEY (user_id) REFERENCES ccuser(user_id),
add CONSTRAINT user_session_unique1 UNIQUE KEY(session_id);

drop table if exists patient;
create table if not exists patient(
	patient_id bigint(20) not null auto_increment,
	first_name varchar(64) not null,
	last_name varchar(64) not null,
	dob timestamp null,
	sex CHAR(1) CHECK (sex IN ('M', 'F')),
	local_address varchar(2048),
	permanent_address varchar(2048),
	phone varchar(20),
	email varchar(1028),
	insurance_info varchar(2048),
	religion varchar(64),
	nationality varchar(64),
	passport_no varchar(64),
	emergency_contact_no varchar(20),
	create_time timestamp default current_timestamp,
	primary key(patient_id)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

drop table if exists hospital_bed;
create table if not exists hospital_bed(
	hospital_bed_id bigint(20) not null auto_increment,
	hospital_id bigint(20) not null,
	hospital_floor_no int,
	hospital_floor_name varchar(32),
	ward_no int,
	ward_name varchar(128),
	bed_no varchar(32),
	primary key(hospital_bed_id)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

drop table if exists in_patient;
create table if not exists in_patient(
	in_patient_id bigint(20) not null auto_increment,
	patient bigint(20) not null,
	hospital_bed bigint(20) not null,
	admit_date timestamp,
	discharge_date timestamp,
	doctor_incharge bigint(20),
	nurse_incharge bigint(20),
	create_date timestamp default current_timestamp,
	primary key(in_patient_id)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
	
alter table in_patient
	add constraint in_patient_fk1 foreign key(patient) references patient(patient_id),
	add constraint in_patient_fk2 foreign key(hospital_bed) references hospital_bed(hospital_bed_id),
	add constraint in_patient_fk3 foreign key(doctor_incharge) references doctor(doctor_id),
	add constraint nurse_incharge_fk4 foreign key(nurse_incharge) references nurse(nurse_id);
	
drop table if exists in_patient_visit;
create table if not exists in_patient_visit(
	in_patient_visit_id bigint(20) not null auto_increment,
	in_patient bigint(20) not null,
	visiting_doctor bigint(20),
	visiting_nurse bigint(20),
	visit_type varchar(256),
	doctor_note text,
	nurse_note text,
	medicine_prescribed text,
	visit_time timestamp,
	visit_duration long,
	visit_start_time timestamp,
	visit_end_time timestamp,
	primary key(in_patient_visit_id)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

alter table in_patient_visit
	add constraint in_patient_visit_fk1 foreign key(in_patient) references in_patient(in_patient_id),
	add constraint in_patient_visit_fk2 foreign key(visiting_doctor) references doctor(doctor_id),
	add constraint in_patient_visit_fk3 foreign key(visiting_nurse) references nurse(nurse_id);

drop table if exists out_patient;
create table if not exists out_patient(
	out_patient_id bigint(20) not null auto_increment,
	out_patient bigint(20) not null,
	visiting_doctor bigint(20) not null,
	visiting_nurse bigint(20),
	visit_start_time timestamp,
	visit_end_time timestamp,
	visit_duration long,
	doctor_note text,
	nurse_note text,
	medicine_prescribed text,
	main_disease varchar(256),
	primary key(out_patient_id)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

alter table out_patient
	add constraint out_patient_fk1 foreign key(out_patient) references patient(patient_id),
	add constraint out_patient_fk2 foreign key(visiting_doctor) references doctor(doctor_id),
	add constraint out_patient_fk3 foreign key(visiting_nurse) references nurse(nurse_id);

drop table if exists billing_type;
create table if not exists billing_type(
	billing_type_id bigint(20) not null auto_increment,
	bill_type varchar(256) not null,
	per_unit_charge double not null,
	bill_note varchar(2048),
	primary key(billing_type_id)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

drop table if exists patient_com_bill;
create table if not exists patient_com_bill(
	patient_com_bill_id bigint(20) not null auto_increment,
	patient bigint(20) not null,
	bill_create_date timestamp default current_timestamp,
	total_bill double not null,
	amount_paid double not null,
	mode_of_payment double,
	note varchar(2048),
	primary key(patient_com_bill_id)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

alter table patient_com_bill
	add constraint patient_com_bill_fk1 foreign key(patient) references patient(patient_id);
	
drop table if exists patient_bill;
create table if not exists patient_bill(
	patient_bill_id bigint(20) not null auto_increment,
	patient_com_bill bigint(20) not null,
	billing_type bigint(20) not null,
	unit float not null,
	bill_amount double not null,
	primary key(patient_bill_id)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
	
alter table patient_bill
	add constraint patient_bill_fk1 foreign key(patient_com_bill) references patient_com_bill(patient_com_bill_id),
	add constraint patient_bill_fk2 foreign key(billing_type) references billing_type(billing_type_id);
