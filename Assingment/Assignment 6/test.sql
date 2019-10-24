--Name: Xingjian Diao
--Pitt User Name: xid32
----CS1555/2055 - DATABASE MANAGEMENT SYSTEMS (FALL 2019)
----DEPT. OF COMPUTER SCIENCE, UNIVERSITY OF PITTSBURGH
----ASSIGNMENT #6: SQL/PL: FUNCTIONS, PROCEDURES, AND TRIGGERS

--Clean up
drop table if exists report cascade;
drop table if exists coverage cascade;
drop table if exists intersection cascade;
drop table if exists road cascade;
drop table if exists sensor cascade;
drop table if exists worker cascade;
drop table if exists forest cascade;
drop table if exists state cascade;
drop table if exists emergency cascade;
drop domain if exists energy_dom cascade;

commit;

--Create tables
create table FOREST
(
    Forest_No  varchar(10),
    Name       varchar(30),
    Area       float,
    Acid_Level float,
    MBR_XMin   float,
    MBR_XMax   float,
    MBR_YMin   float,
    MBR_YMax   float,
    Constraint forest_PK primary key (Forest_No) not deferrable
);

create table STATE
(
    Name         varchar(30),
    Abbreviation varchar(2),
    Area         float,
    Population   int,
    Constraint State_PK primary key (Abbreviation) not deferrable
);

create table COVERAGE
(
    Forest_No  varchar(10),
    State      varchar(2),
    Percentage float,
    Area       float,
    Constraint coverage_PK primary key (Forest_No, State) not deferrable,
    Constraint coverage_FK1 foreign key (Forest_No) references FOREST (Forest_No) initially deferred deferrable,
    Constraint coverage_FK2 foreign key (State) references State (Abbreviation) initially deferred deferrable
);


create table ROAD
(
    Road_No varchar(10),
    Name    varchar(30),
    Length  float,
    Constraint road_PK primary key (Road_No) not deferrable
);

create table INTERSECTION
(
    Forest_No varchar(10),
    Road_No   varchar(10),
    Constraint intersection_PK primary key (Forest_No, Road_No) not deferrable,
    Constraint intersection_FK1 foreign key (Forest_No) references FOREST (Forest_No) initially deferred deferrable,
    Constraint intersection_FK2 foreign key (Road_No) references ROAD (Road_No) initially deferred deferrable
);

create table SENSOR
(
    Sensor_Id    int,
    X            float,
    Y            float,
    Last_Charged timestamp,
    Last_Read    timestamp,
    Constraint sensor_PK primary key (Sensor_Id) not deferrable
);

create table REPORT
(
    Sensor_Id   int,
    Temperature float,
    Report_Time timestamp,
    Constraint report_PK primary key (Sensor_Id, Report_Time) not deferrable,
    Constraint report_FK foreign key (Sensor_Id) references SENSOR (Sensor_Id) initially deferred deferrable
);

create table WORKER
(
    SSN  varchar(9),
    Name varchar(30),
    Age  int,
    Rank int,
    Constraint worker_PK primary key (SSN) not deferrable
);

create table Emergency
(
    Sensor_id   int,
    Report_Time timestamp,
    constraint emergency_PK primary key (Sensor_Id, Report_Time) deferrable,
    constraint emergency_FK foreign key (Sensor_Id, Report_Time) references REPORT (Sensor_Id, Report_Time) initially deferred deferrable
);

commit;

alter table FOREST
    add Constraint forest_UQ_name UNIQUE (name) initially immediate deferrable;

alter table FOREST
    add Constraint forest_UQ_MBR UNIQUE (MBR_XMin, MBR_XMax, MBR_YMin, MBR_YMax) initially immediate deferrable;

alter table STATE
    add Constraint state_UQ_Name UNIQUE (Name) initially immediate deferrable;

alter table SENSOR
    add Constraint sensor_UQ_coordinate UNIQUE (X, Y) initially immediate deferrable;

CREATE DOMAIN energy_dom AS
    INT CHECK (value >= 0 AND value <= 100);

alter table SENSOR
    add energy energy_dom not null;

alter table FOREST
    add constraint forest_acid_range check (Acid_Level >= 0 and Acid_Level <= 1);

alter table FOREST
    add Constraint MBRCheck CHECK (MBR_XMax > MBR_XMin and MBR_YMax > MBR_YMin) initially immediate not deferrable;

alter table COVERAGE
    add Constraint PercentageCheck CHECK (Percentage >= 0 and Percentage <= 1) initially immediate not deferrable;

alter table SENSOR
    add Maintainer varchar(9) default null;

alter table SENSOR
    add Constraint sensor_FK foreign key (Maintainer) references WORKER (SSN) initially deferred deferrable;

commit;

INSERT INTO FOREST
VALUES ('1', 'Allegheny National Forest', 40000.0, 0.3, 134.0, 550.0, 233.0, 598.0);
INSERT INTO FOREST
VALUES ('2', 'Pennsylvania Forest', 10000.0, 0.75, 21.0, 100.0, 35.0, 78.0);

INSERT INTO STATE
VALUES ('Pennsylvania', 'PA', 50000.0, 1400000);
INSERT INTO STATE
VALUES ('Ohio', 'OH', 45000.0, 1200000);

INSERT INTO COVERAGE
VALUES (1, 'PA', 0.4, 16000.0);
INSERT INTO COVERAGE
VALUES (1, 'OH', 0.6, 24000.0);
INSERT INTO COVERAGE
VALUES (2, 'PA', 1, 10000.0);

INSERT INTO ROAD
VALUES (1, 'FORBES', 500.0);
INSERT INTO ROAD
VALUES (2, 'BIGELOW', 300.0);

INSERT INTO INTERSECTION
VALUES ('1', '1');
INSERT INTO INTERSECTION
VALUES ('1', '2');
INSERT INTO INTERSECTION
VALUES ('2', '1');
INSERT INTO INTERSECTION
VALUES ('2', '2');

INSERT INTO WORKER
VALUES ('123456789', 'John', 22, 3);
INSERT INTO WORKER
VALUES ('121212121', 'Jason', 30, 5);

INSERT INTO SENSOR
VALUES (1, 150.0, 300.0, to_timestamp('01-JAN-2019 10:00:00', 'DD-MON-YYYY HH24:MI:SS'),
        to_timestamp('01-JAN-2019 10:00:00', 'DD-MON-YYYY HH24:MI:SS'), 20, '123456789');
INSERT INTO SENSOR
VALUES (2, 200.0, 400.0, to_timestamp('01-JAN-2019 10:00:00', 'DD-MON-YYYY HH24:MI:SS'),
        to_timestamp('01-JAN-2019 10:00:00', 'DD-MON-YYYY HH24:MI:SS'), 30, '123456789');
INSERT INTO SENSOR
VALUES (3, 50.0, 50.0, to_timestamp('01-JAN-2019 10:00:00', 'DD-MON-YYYY HH24:MI:SS'),
        to_timestamp('01-JAN-2019 10:00:00', 'DD-MON-YYYY HH24:MI:SS'), 30, '121212121');
INSERT INTO SENSOR
VALUES (4, 50.0, 15.0, to_timestamp('01-JAN-2019 10:00:00', 'DD-MON-YYYY HH24:MI:SS'),
        to_timestamp('01-JAN-2019 10:00:00', 'DD-MON-YYYY HH24:MI:SS'), 30, null);
INSERT INTO SENSOR
VALUES (5, 60.0, 60.0, to_timestamp('01-JAN-2019 10:00:00', 'DD-MON-YYYY HH24:MI:SS'),
        to_timestamp('01-JAN-2019 10:00:00', 'DD-MON-YYYY HH24:MI:SS'), 40, '121212121');

INSERT INTO REPORT
VALUES (1, 55, to_timestamp('10-JAN-2019 09:00:00', 'DD-MON-YYYY HH24:MI:SS'));
INSERT INTO REPORT
VALUES (1, 57, to_timestamp('10-JAN-2019 14:00:00', 'DD-MON-YYYY HH24:MI:SS'));
INSERT INTO REPORT
VALUES (1, 40, to_timestamp('10-JAN-2019 20:00:00', 'DD-MON-YYYY HH24:MI:SS'));
INSERT INTO REPORT
VALUES (2, 58, to_timestamp('10-JAN-2019 12:30:00', 'DD-MON-YYYY HH24:MI:SS'));
INSERT INTO REPORT
VALUES (2, 59, to_timestamp('10-JAN-2019 13:00:00', 'DD-MON-YYYY HH24:MI:SS'));
INSERT INTO REPORT
VALUES (3, 50, to_timestamp('01-JAN-2019 12:30:00', 'DD-MON-YYYY HH24:MI:SS'));
INSERT INTO REPORT
VALUES (4, 30, to_timestamp('01-JAN-2019 22:00:00', 'DD-MON-YYYY HH24:MI:SS'));
INSERT INTO REPORT
VALUES (5, 33, to_timestamp('02-JAN-2019 22:00:00', 'DD-MON-YYYY HH24:MI:SS'));
INSERT INTO REPORT
VALUES (5, 32, to_timestamp('02-JAN-2019 22:30:00', 'DD-MON-YYYY HH24:MI:SS'));

commit;


---Question1
---a
create or replace function pro_Update_Last_Read (input_sensor_id INT, read_time timestamp)
returns void as
$$
    begin
        update SENSOR
        set SENSOR.Last_Read = read_time
        where SENSOR.Sensor_Id = input_sensor_id;
    end;
$$ language plpgsql;
commit ;


--b
create or replace function fun_Compute_Percentage(input_forest_no char(10), area_covered float)
returns float as
$$
    DECLARE
        percent float := 0.0;
    begin
        select (area_covered/Area) into percent
        from Forest
        where Forest_No = input_forest_no;
        if percent > 1.0 then
            return 1.0;
        else
            return percent;
        end if;
    end;
$$ language plpgsql;
commit ;

--Question 2.
--a
create or replace function pro_Update_Last_Read ()
returns trigger as
$$
    begin
        update SENSOR
        set Last_Read = new.Report_Time
        where Sensor_Id = new.Sensor_Id;
        return new;
    end;
$$ language plpgsql;
drop trigger if exists tri_Last_Read on Report;
create trigger tri_Last_Read
    after insert
    on Report
    for each row
    execute procedure pro_Update_Last_Read();


--b
create or replace function fun_Compute_Percentage()
returns trigger as
$$
    declare
        percent float := 0.0;
    begin
        select new.Area/Area into percent
        from Forest where forest_no = new.forest_no;
        if percent > 1 then
            percent = 1.0;
        end if;
        update Coverage
            set percentage = percent
            where forest_no = new.forest_no and state = new.state;
        return new;
    end;
$$ language plpgsql;
drop trigger if exists tri_Percentage on Coverage;
create trigger tri_Percentage
    after update of Area on Coverage
    for each row
    execute procedure fun_Compute_Percentage();



--c
create or replace function fun_Emergency() returns trigger as
$$
    begin
        if new.Temperature > 100
            then insert into emergency values (new.Sensor_Id, new.Report_Time);
        end if;
        return new;
    end;
$$ language plpgsql;
drop trigger if exists tri_Emergency on report;
create trigger tri_Emergency
    after insert on Report
    for each row
    execute procedure fun_Emergency();

--3
--a
select * from SENSOR;
INSERT INTO REPORT
VALUES (3, 52, to_timestamp('02-JAN-2019 22:02:00', 'DD-MON-YYYY HH24:MI:SS'));
select * from SENSOR;

--b
select * from COVERAGE;
update coverage
set area = 22222.0
where forest_no = '1' and state = 'OH';
select * from COVERAGE;


--c
select * from EMERGENCY;
INSERT INTO REPORT
VALUES (2, 123, to_timestamp('02-JAN-2019 22:35:07', 'DD-MON-YYYY HH24:MI:SS'));
select * from EMERGENCY;


--4
--explicit
create or replace procedure ex_proc_list_name()
as
$$
DECLARE
    r record;
    cr cursor
        for select name
            from FOREST;
begin
    open cr;
    loop
        fetch cr into r;
        exit when not found;
        raise notice '%', r.name;
    end loop;
    close cr;
end
$$
    language plpgsql;
call ex_proc_list_name();

--implicit
create or replace procedure im_proc_list_name()
as
$$
declare
    r record;
begin
    for r in select name from FOREST
        loop
            raise notice '%', r.name;
        end loop;
end
$$ language plpgsql;
call im_proc_list_name();