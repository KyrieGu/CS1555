drop table student cascade constraints;
drop table student_dir cascade constraints;
drop table course cascade constraints;
drop table course_taken cascade constraints;

create table student (
	sid varchar2(5) not null,
	name varchar2(15) not null,
	class number(2),
	major varchar2(10),
	constraint pk_student primary key (sid)
);

create table student_dir (
	sid varchar2(5) not null,
	address varchar2(100),
	phone varchar2(20),
	constraint pk_student_dir primary key (sid),
	constraint fk_student_dir foreign key (sid) references student
);

create table course (
	course_no varchar2(6) not null,
	name varchar2(100),
	course_level varchar2(5),
	constraint pk_course primary key (course_no)
);

create table course_taken (
	course_no varchar2(6) not null,
	term varchar2(11) not null,
	sid varchar2(5) not null,
	grade dec(3, 2),
	constraint pk_course_taken primary key (course_no, term, sid),
	constraint fk_course_taken_course_no foreign key (course_no) references course,
	constraint fk_course_taken_sid foreign key (sid) references student
);

-- insert
