drop table class cascade constraints;
create table class(
classid number(2),
max_num_students number(2),
cur_num_students number(2),
primary key(classid)
);

drop table register cascade constraints;
create table register(
student_name varchar2(10),
classid number(2),
date_registered date,
primary key(student_name, classid),
foreign key (classid) references class(classid)
);

insert into class values(1, 2, 1);
insert into class values (2,4,0);

insert into register values ('Mary',1, '03-JAN-2012');

commit;
