----CS1555/2055 - DATABASE MANAGEMENT SYSTEMS (FALL 2019)
----DEPT. OF COMPUTER SCIENCE, UNIVERSITY OF PITTSBURGH
----ASSIGNMENT #5: SQL TRANSACTIONS AND SQL VIEWS

-- Tianrun Gu
-- tig19@pitt.edu

--Clean up
drop table if exists report cascade;
drop table if exists coverage cascade;
drop table if exists intersection cascade;
drop table if exists road cascade;
drop table if exists sensor cascade;
drop table if exists worker cascade;
drop table if exists forest cascade;
drop table if exists state cascade;
drop domain if exists energy_dom cascade;

commit;

--Question 2

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
    Constraint forest_PK primary key (Forest_No) not deferrable --Question 1
);

create table STATE
(
    Name         varchar(30),
    Abbreviation varchar(2),
    Area         float,
    Population   int,
    Constraint State_PK primary key (Abbreviation) not deferrable --Question 1
);

create table COVERAGE
(
    Forest_No  varchar(10),
    State      varchar(2),
    Percentage float,
    Area       float,
    Constraint coverage_PK primary key (Forest_No, State) not deferrable, --Question 1
    Constraint coverage_FK1 foreign key (Forest_No) references FOREST (Forest_No) initially deferred deferrable, --Question 1
    Constraint coverage_FK2 foreign key (State) references State (Abbreviation) initially deferred deferrable --Question 1
);

create table ROAD
(
    Road_No varchar(10),
    Name    varchar(30),
    Length  float,
    Constraint road_PK primary key (Road_No) not deferrable --Question 1
);

create table INTERSECTION
(
    Forest_No varchar(10),
    Road_No   varchar(10),
    Constraint intersection_PK primary key (Forest_No, Road_No) not deferrable, -- Question 1
    Constraint intersection_FK1 foreign key (Forest_No) references FOREST (Forest_No) initially deferred deferrable, --Question 1
    Constraint intersection_FK2 foreign key (Road_No) references ROAD (Road_No) initially deferred deferrable --Question 1
);

create table SENSOR
(
    Sensor_Id    int,
    X            float,
    Y            float,
    Last_Charged timestamp,
    Constraint sensor_PK primary key (Sensor_Id) not deferrable --Question 1
);

create table REPORT
(
    Sensor_Id   int,
    Temperature float,
    Report_Time timestamp,
    Constraint report_PK primary key (Sensor_Id, Report_Time) not deferrable, --Question 1
    Constraint report_FK foreign key (Sensor_Id) references SENSOR (Sensor_Id) initially deferred deferrable --Question 1
);

create table WORKER
(
    SSN  varchar(9),
    Name varchar(30),
    Age  int,
    Rank int,
    Constraint worker_PK primary key (SSN) not deferrable --Question 1
);

commit;

------------------------------------------------------------------------------

--Question 3

--a

alter table FOREST
    add Constraint forest_UQ_name UNIQUE (name) initially immediate deferrable; -- Question 1

alter table FOREST
    add Constraint forest_UQ_MBR UNIQUE (MBR_XMin, MBR_XMax, MBR_YMin, MBR_YMax) initially immediate deferrable; -- Question 1

alter table STATE
    add Constraint state_UQ_Name UNIQUE (Name) initially immediate deferrable; -- Question 1

alter table SENSOR
    add Constraint sensor_UQ_coordinate UNIQUE (X, Y) initially immediate deferrable; -- Question 1


--b
CREATE DOMAIN energy_dom AS
    INT CHECK (value >= 0 AND value <= 100);

alter table SENSOR
    add energy energy_dom not null;

--c
alter table FOREST
    add constraint forest_acid_range check (Acid_Level >= 0 and Acid_Level <= 1);

--d
alter table SENSOR
    add Maintainer varchar(9) default null;

--e
alter table SENSOR
    add Constraint sensor_FK foreign key (Maintainer) references WORKER (SSN);

commit;

--Question 4

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
VALUES (1, 150.0, 300.0, to_timestamp('01-JAN-2019 10:00:00', 'DD-MON-YYYY HH24:MI:SS'), 20, '123456789');
INSERT INTO SENSOR
VALUES (2, 200.0, 400.0, to_timestamp('01-JAN-2019 10:00:00', 'DD-MON-YYYY HH24:MI:SS'), 30, '123456789');
INSERT INTO SENSOR
VALUES (3, 50.0, 50.0, to_timestamp('01-JAN-2019 10:00:00', 'DD-MON-YYYY HH24:MI:SS'), 30, '121212121');
INSERT INTO SENSOR
VALUES (4, 50.0, 15.0, to_timestamp('01-JAN-2019 10:00:00', 'DD-MON-YYYY HH24:MI:SS'), 30, null);
INSERT INTO SENSOR
VALUES (5, 60.0, 60.0, to_timestamp('01-JAN-2019 10:00:00', 'DD-MON-YYYY HH24:MI:SS'), 40, '121212121');

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

-- Question 2 modifies
--a PennDOT built a new road which crosses Allegheny National Forest. The road is named “century road”, which has road no 5 and length 201.
insert into ROAD
values (5,'century road',201);

insert into INTERSECTION (Forest_No, Road_No)
values (
        (select Forest_No from FOREST where Name = 'Allegheny National Forest'),5);

--b The administration office has switched John and Jason’s duties. They are now maintaining sensors that have been maintained by the other in the past.
update SENSOR
set Maintainer = case SENSOR.Maintainer
    when (select SSN from WORKER where Name = 'John')
    then (select SSN from WORKER where Name = 'Jason')
    when (select SSN from WORKER where Name = 'Jason')
    then (select SSN from WORKER where Name = 'John') end
where SENSOR.Maintainer in (
        (select SSN from WORKER where Name = 'Jason'),
        (select SSN from WORKER where Name = 'John')
);

--c The administration office have hired a new worker, Paula, who is age 22 and rank 1. Paula’s SSN is “555575555”. She is assigned to maintain sensor 2 from now on (and the previous maintainer of sensor 2 will not maintain sensor 2 any more).
-- first hire this worker
insert into WORKER
values ('555575555','Paula',22,1);

--then we update the sensor
update SENSOR
set Maintainer =
    (select SSN from WORKER where Name = 'Paula')
where SENSOR.Sensor_Id = 2;


-- Question 3
--a Find the top 3 sensors that have issued the highest amount of reports.
create view top_sensors as
select Sensor_Id from REPORT
group by Sensor_Id
order by (select count(sensor_id)) DESC;

select * from top_sensors limit 3;


--b Find the next 2 sensors after the top 3 sensors that have issued the highest amount of reports.
select *
from top_sensors
offset 3
fetch first 2 rows only;

drop view top_sensors;

-- Question 4
-- a A view named DUTIES that counts, for each worker, the total number of sensors that are maintained by the him/her.
create view DUTIES as
    select  SENSOR.Maintainer,count(Sensor_Id) as num_sensor
    from SENSOR
    join WORKER on SENSOR.Maintainer = WORKER.SSN
    group by SENSOR.Maintainer;

-- b Create a materialized view named DUTIES MV that corresponds to the DUTIES view.
create materialized view DUTIES_MV
    as select  SENSOR.Maintainer,count(Sensor_Id) as num_sensor
    from SENSOR
    join WORKER on SENSOR.Maintainer = WORKER.SSN
    group by SENSOR.Maintainer;

-- c A view named FOREST SENSOR that lists all forests along with its sensors (Forest no,
-- -- Name, Sensor Id).
create view FOREST_SENSOR as
    select forest_no, name, sensor_id from sensor s
        right join forest f
            on s.x between f.mbr_xmin and f.mbr_xmax and
               s.y between f.mbr_ymin and f.mbr_ymax;


-- Question 5

-- run extra data first

-- then refresh
refresh materialized view DUTIES_MV;

-- (a) Q1: Find the names of the workers who maintain the maximum number of sensors.
select Name
from WORKER
where SSN = (select Maintainer from DUTIES order by num_sensor DESC limit 1);

-- (b) Q2: Find the names of all forests such that no sensors in those forests reported anything between 10-AUG-2019 00:00:00 and 11-AUG-2019 00:00:00.
select distinct name from FOREST_SENSOR
    where name not in (
        select name from report r
            right join FOREST_SENSOR fs on r.sensor_id = fs.sensor_id
            where report_time between '10-AUG-2019' and '11-AUG-2019');

-- (c) If you have used DUTIES (or DUTIES MV) in any of the above queries, then write a second
-- query SQL using DUTIES MV (or DUTIES). When annotating the answers, annotate with
-- “MV” the queries which use DUTIES MV; e.g., Q1 MV and Q2 MV.
-- MV
select Name
from WORKER
where SSN = (select Maintainer from DUTIES_MV order by num_sensor DESC limit 1);

--(d) Compare and report the differences between views and materialized views in term of execution
--time. Execution time recording can be turned on using:
--For psql (PostgreSQL): \timing on;
--For sqlplus (Oracle): set timing on;
--Time for view solution 37.853ms
--Time for m view solution 19.082ms
--Time collected from psql


--exit;
