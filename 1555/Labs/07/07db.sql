drop table if exists class cascade;
create table class
(
  classid          int,
  max_num_students int,
  cur_num_students int,
  primary key (classid)
);

drop table if exists register cascade;
create table register
(
  student_name    varchar(10),
  classid         int,
  date_registered date,
  primary key (student_name, classid),
  foreign key (classid) references class (classid)
);

insert into class
values (1, 2, 1);
insert into class
values (2, 4, 0);

insert into register
values ('Mary', 1, '03-JAN-2012');

commit;
