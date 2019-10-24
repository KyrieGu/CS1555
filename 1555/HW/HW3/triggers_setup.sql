-- setup tables

drop table if exists students cascade;

create table students (
	id integer primary key,
	name varchar(24)
);

insert into students values(1, 'Alice');
insert into students values(2, 'Bob');
insert into students values(3, 'Charlie');
insert into students values(4, 'Denise');
insert into students values(5, 'Edward');

drop table if exists courses cascade;

create table courses (
	num varchar(6) primary key,
	open boolean not null,
	enrolled integer default 0,
	lim integer default 3
);



drop table if exists enrollment cascade;

create table enrollment (
	student integer references students(id),
	course varchar(6) references courses(num)
);

-- insert starting data

insert into enrollment values(1, 'CS1501');
insert into enrollment values(2, 'CS1501');
insert into enrollment values(3, 'CS1501');
insert into enrollment values(4, 'CS1501');


insert into courses values('CS1555', True);
insert into courses values('CS1501', True);
insert into courses values('CS1520', True);

delete from enrollment where student = 1;
delete from enrollment where student = 2;
delete from enrollment where student = 3;
delete from enrollment where student = 4;
delete from enrollment where student = 5;
delete from courses where open = FALSE;
delete from courses where open = TRUE;

update courses set enrolled = 2 where num = 'CS1501';

insert into enrollment values(1, 'CS1555');
update courses set enrolled = 1 where num = 'CS1555';

insert into enrollment values(4, 'CS1520');
insert into enrollment values(5, 'CS1520');
update courses set enrolled = 2 where num = 'CS1520';


/*triggers*/

drop function if exists func_1() cascade ;
drop trigger if exists trigger_1 on enrollment;


drop function if exists func_2() cascade;
drop trigger if exists trigger_2 on enrollment;

--in (select course from enrollment)
--(select course from enrollment where course = new.course)
--where num = old.course
create or replace function func_1() returns trigger as
  $$
  declare
    enrol integer;
		limt integer;
  begin
		select enrolled into enrol from courses where num = NEW.course;
		select lim into limt from courses where num = NEW.course;
		if enrol < limt then
			update courses set enrolled = enrol + 1 where num = NEW.course;
		  --insert into courses values (new.course,true,0,0);
			if enrol = limt - 1 then
				update courses set open = False where num = NEW.course;
			end if;
		end if;
		return new;
  end;
  $$ language plpgsql;

create trigger trigger_1
  after insert
  on enrollment
  for each row
  execute procedure func_1();


create or replace function func_2() returns trigger as
  $$
  declare
    open_1 boolean;
  begin
		select open into open_1 from courses where num = new.course;
		if open_1 = FALSE then
   		RAISE EXCEPTION 'CANNOT INSERT, NOT OPEN';
		end if;
		return new;
	end;
  $$language plpgsql;

create trigger trigger_2
  before insert
  on enrollment
  for each row
  execute procedure func_2();