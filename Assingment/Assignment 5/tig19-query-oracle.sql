----CS1555/2055 - DATABASE MANAGEMENT SYSTEMS (FALL 2019)
----DEPT. OF COMPUTER SCIENCE, UNIVERSITY OF PITTSBURGH
----ASSIGNMENT #5: SQL TRANSACTIONS AND SQL VIEWS

-- Tianrun Gu
-- tgi19@pitt.edu

--Clean up
drop table report cascade constraints;
drop table coverage cascade constraints;
drop table intersection cascade constraints;
drop table road cascade constraints;
drop table sensor cascade constraints;
drop table worker cascade constraints;
drop table forest cascade constraints;
drop table state cascade constraints;

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
    Constraint forest_PK primary key (Forest_No)
);

create table STATE
(
    Name         varchar(30),
    Abbreviation varchar(2),
    Area         float,
    Population   int,
    Constraint State_PK primary key (Abbreviation)
);

create table COVERAGE
(
    Forest_No  varchar(10),
    State      varchar(2),
    Percentage float,
    Area       float,
    Constraint coverage_PK primary key (Forest_No, State),
    Constraint coverage_FK1 foreign key (Forest_No) references FOREST (Forest_No),
    Constraint coverage_FK2 foreign key (State) references State (Abbreviation)
);

create table ROAD
(
    Road_No varchar(10),
    Name    varchar(30),
    Length  float,
    Constraint road_PK primary key (Road_No)
);

create table INTERSECTION
(
    Forest_No varchar(10),
    Road_No   varchar(10),
    Constraint intersection_PK primary key (Forest_No, Road_No),
    Constraint intersection_FK1 foreign key (Forest_No) references FOREST (Forest_No),
    Constraint intersection_FK2 foreign key (Road_No) references ROAD (Road_No)
);

create table SENSOR
(
    Sensor_Id    int,
    X            float,
    Y            float,
    Last_Charged timestamp,
    Constraint sensor_PK primary key (Sensor_Id)
);

create table REPORT
(
    Sensor_Id   int,
    Temperature float,
    Report_Time timestamp,
    Constraint report_PK primary key (Sensor_Id, Report_Time),
    Constraint report_FK foreign key (Sensor_Id) references SENSOR (Sensor_Id)
);

create table WORKER
(
    SSN  varchar(9),
    Name varchar(30),
    Age  int,
    Rank int,
    Constraint worker_PK primary key (SSN)
);

commit;

------------------------------------------------------------------------------

--Question 3

--a

alter table FOREST
    add Constraint forest_UQ_name UNIQUE (name);

alter table FOREST
    add Constraint forest_UQ_MBR UNIQUE (MBR_XMin, MBR_XMax, MBR_YMin, MBR_YMax);

alter table STATE
    add Constraint state_UQ_Name UNIQUE (Name);

alter table SENSOR
    add Constraint sensor_UQ_coordinate UNIQUE (X, Y);


--b
alter table SENSOR add energy int not null;
alter table SENSOR add constraint sensor_energy_check CHECK (energy >= 0 AND energy <= 100);

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

--exit;
--3
--(a) Find the top 3 sensors that have issued the highest amount of reports.
select R.Sensor_Id from REPORT R join SENSOR S on R.Sensor_Id = S.Sensor_Id
group by R.Sensor_Id
order by count(R.Sensor_Id) desc fetch next 3 rows only;

--(b) Find the next 2 sensors after the top 3 sensors that have issued the highest amount of reports.
select R.Sensor_Id from REPORT R join SENSOR S on R.Sensor_Id = S.Sensor_Id
group by R.Sensor_Id
order by count(R.Sensor_Id) desc
offset 3 row fetch next 2 rows only;

--4
--(a) A view named DUTIES that counts, for each worker, the total number of sensors that are
--maintained by the him/her.
create view DUTIES as
    select S.maintainer, count(S.Sensor_Id) as cts from SENSOR S
    group by S.Maintainer
    order by S.Maintainer;
drop view DUTIES cascade constraints;

--(b) Create a materialized view named DUTIES MV that corresponds to the DUTIES view.
create materialized view DUTIESMV (Sensor_Id, stotal) as
    select Maintainer, count(Sensor_id) as cts from SENSOR
    group by Maintainer
    order by Maintainer;
drop materialized view DUTIESMV preserve table;

--(c) A view named FOREST SENSOR that lists all forests along with its sensors (Forest no,
--Name, Sensor Id).
create view FOREST_SENSOR as
    select F.Forest_No, F.Name, S.Sensor_Id from FOREST F join SENSOR S
        on (F.MBR_XMin <= S.X and F.MBR_XMax >= S.X and F.MBR_YMin <= S.Y and F.MBR_YMax >= S.Y)
        order by F.Forest_No;
drop view FOREST_SENSOR cascade constraints;

--5
--(a) Q1: Find the names of the workers who maintain the maximum number of sensors.
select w.Name, d.cts from WORKER w
    join DUTIES d on w.SSN = d.maintainer
--order by d.cts desc ;
where d.cts = (select max(d2.cts) from DUTIES d2);


--(b) Q2: Find the names of all forests such that no sensors in those forests reported anything
--between 10-AUG-2019 00:00:00 and 11-AUG-2019 00:00:00.
 select f.name from FOREST f
where f.name not in(select f.name from forest f
    join SENSOR s on s.X <= f.MBR_XMax and s.X >= f.MBR_XMin and s.Y <= f.MBR_YMax and s.Y >= f.MBR_YMin
    join report r on s.Sensor_Id = r.sensor_id
    where Report_Time between TO_DATE('2019-08-10 00:00:00', 'YYYY-MM-DD HH24:MI:SS') and TO_DATE('2019-08-11 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
    );

--(c) If you have used DUTIES (or DUTIES MV) in any of the above queries, then write a second
--query SQL using DUTIES MV (or DUTIES). When annotating the answers, annotate with
--“MV” the queries which use DUTIES MV; e.g., Q1 MV and Q2 MV.
--Q1_MV
select w.Name, d.stotal from WORKER w
    join DUTIESMV d on w.SSN = d.Sensor_Id
--order by d.cts desc ;
where d.stotal = (select max(d2.cts) from DUTIES d2);


--(d) Compare and report the differences between views and materialized views in term of execution
--time. Execution time recording can be turned on using:
--For psql (PostgreSQL): \timing on;
--For sqlplus (Oracle): set timing on;
--time for view 00:00:00.02
--time for m view 00:00:00.01
--time collected from sqlplus