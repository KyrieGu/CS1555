drop table if exists student cascade;
drop table if exists student_dir cascade;
drop table if exists course cascade;
drop table if exists course_taken cascade;
drop table if exists instructor cascade;
drop table if exists course_offered cascade;

create table student
(
  sid   varchar(5)  not null,
  name  varchar(15) not null,
  class int,
  major varchar(10),
  constraint pk_student primary key (sid)
);

create table student_Dir
(
  sid     varchar(5) not null,
  address varchar(100),
  phone   varchar(20),
  constraint pk_student_Dir primary key (sid),
  constraint fk_student_Dir foreign key (sid) references student (sid)
);

create table course
(
  course_no    varchar(10) not null,
  name         varchar(100),
  course_level varchar(10),
  constraint pk_Course primary key (course_no)
);

create table course_taken
(
  course_no varchar(10) not null,
  term      varchar(15) not null,
  sid       varchar(5)  not null,
  grade     real,
  constraint pk_course_taken primary key (course_no, sid, term),
  constraint fk_1_course_taken foreign key (sid) references student (sid),
  constraint fk_2_course_taken foreign key (course_no) references Course (course_no) on update cascade
);

create table instructor
(
  id   varchar(5)  not null,
  fname  varchar(15) not null,
  lname  varchar(15) not null,
  constraint pk_instructor primary key (id)
);

create table course_offered
(
  course_no varchar(10) not null,
  term      varchar(15) not null,
  instructorID       varchar(5)  not null,
  constraint pk_course_offered primary key (course_no, instructorID, term),
  constraint fk_1_course_offered foreign key (instructorID) references instructor (id),
  constraint fk_2_course_offered foreign key (course_no) references Course (course_no)
);

--insert data into student table
insert into student(sid, name, class, major)
values ('123', 'John', 3, 'CS');

insert into student(sid, name, class, major)
values ('124', 'Mary', 3, 'CS');

insert into student(sid, name, class, major)
values ('126', 'Sam', 2, 'CS');

insert into student(sid, name, class, major)
values ('129', 'Julie', 2, 'Math');

--insert data into student_dir table
insert into student_dir(sid, address, phone)
values ('123', '333 Library St', '555-535-5263');

insert into student_dir(sid, address, phone)
values ('124', '219 Library St', '555-963-9653');

insert into student_dir(sid, address, phone)
values ('129', '555 Library St', '555-123-4567');

--insert data into course
insert into course(course_no, name, course_level)
values ('CS1520', 'Web Applications', 'UGrad');

insert into course(course_no, name, course_level)
values ('CS1555', 'Database Management Systems', 'UGrad');

insert into course(course_no, name, course_level)
values ('CS1550', 'Operating Systems', 'UGrad');

insert into course(course_no, name, course_level)
values ('CS2550', 'Database Management Systems', 'Grad');

insert into course(course_no, name, course_level)
values ('CS1655', 'Secure Data Management and Web Applications', 'UGrad');

--insert into course_taken
insert into course_taken(course_no, sid, term, grade)
values ('CS1520', '123', 'Fall 19', 3.75);

insert into course_taken(course_no, sid, term, grade)
values ('CS1520', '124', 'Fall 19', 4);

insert into course_taken(course_no, sid, term, grade)
values ('CS1520', '126', 'Fall 19', 3);

insert into course_taken(course_no, sid, term, grade)
values ('CS1555', '123', 'Fall 19', 4);

insert into course_taken(course_no, sid, term, grade)
values ('CS1555', '124', 'Fall 19', null);

insert into course_taken(course_no, sid, term, grade)
values ('CS1550', '123', 'Spring 20', null);

insert into course_taken(course_no, sid, term, grade)
values ('CS1550', '124', 'Spring 20', null);

insert into course_taken(course_no, sid, term, grade)
values ('CS1550', '126', 'Spring 20', null);

insert into course_taken(course_no, sid, term, grade)
values ('CS1550', '129', 'Spring 20', null);

insert into course_taken(course_no, sid, term, grade)
values ('CS2550', '124', 'Spring 20', null);

insert into course_taken(course_no, sid, term, grade)
values ('CS1520', '126', 'Spring 20', null);


insert into course_taken(course_no, sid, term, grade)
values ('CS1655', '123', 'Spring 20', null);

--insert data into instructor table
insert into instructor(id, fname, lname)
values ('888', 'Constantinos', 'Costa');

insert into instructor(id, fname, lname)
values ('999', 'Panos', 'Chrysanthis');
commit ;

insert into course_offered(course_no, term, instructorID)
values ('CS1520', 'Fall 19', '999');

insert into course_offered(course_no, term, instructorID)
values ('CS1555', 'Fall 19', '888');

insert into course_offered(course_no, term, instructorID)
values ('CS1550', 'Fall 19', '888');

insert into course_offered(course_no, term, instructorID)
values ('CS1550', 'Spring 20', '999');

