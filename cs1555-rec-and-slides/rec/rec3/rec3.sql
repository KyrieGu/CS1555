spool out replace;
spool out apend;

drop table t1 cascade constraints;

create table t1 (
	a1 varchar2(10) primary key
);

alter table t1 add a2 varchar2(5);
alter table t1 modify a2 varchar2(10);
alter table t1 modify a2 number(5);
alter table t1 modify a2 number(10,5);

alter table t1 modify a2 not null;
alter table t1 modify a2 null;
alter table t1 modify a2 default 1;
alter table t1 modify a2 default null;

alter table t1 add constraint t1_uniq_a2 unique (a2);
alter table t1 drop constraint t1_uniq_a2;
alter table t1 add constraint t1_a2_range
	check (a2 between 1 and 10);
alter table t1 drop constraint t1_a2_range;
alter table t1 add constraint t1_a2_range
	check (a2 between 1 and 5);

alter table t1 add constraint t1_a2_set_mem
	check (a2 in (1, 2, 3, 4, 5));

create table t2 (
	b1 number(10, 5) primary key
);

alter table t1 add constraint t1_a2_fk foreign key (a2)
	references t2 (b1);

insert into t1 (a1, a2) values ('pitt01', 5);

insert into t2 (b1) values (5);
insert into t1 (a1, a2) values ('pitt01', 5);

drop table t2;

drop table t2 cascade constraints;

alter table t1 add constraint t1_uniq_a12 unique (a1, a2);
alter table t1 drop column a2;
alter table t1 drop column a2 cascade constraints;


desc t1;
desc t2;

select * from t1;
select * from t2;

commit;

exit;
