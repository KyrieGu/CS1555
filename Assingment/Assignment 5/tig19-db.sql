----CS1555/2055 - DATABASE MANAGEMENT SYSTEMS (FALL 2019)
----DEPT. OF COMPUTER SCIENCE, UNIVERSITY OF PITTSBURGH
----ASSIGNMENT #5: SQL TRANSACTIONS AND SQL VIEWS

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
--a
insert into ROAD
values (5,'century road',201);

insert into INTERSECTION (Forest_No, Road_No)
values (
        (select Forest_No from FOREST where Name = 'Allegheny National Forest'),5);

--b
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

--c
-- first hire this worker
insert into WORKER
values ('555575555','Paula',22,1);

--then we update the sensor
update SENSOR
set Maintainer =
    (select SSN from WORKER where Name = 'Paula')
where SENSOR.Sensor_Id = 2;


--exit;
