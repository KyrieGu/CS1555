-- Assignment 6
-- Tianrun Gu
-- Tig19@pitt.edu

----CS1555/2055 - DATABASE MANAGEMENT SYSTEMS (FALL 2019)
----DEPT. OF COMPUTER SCIENCE, UNIVERSITY OF PITTSBURGH
----ASSIGNMENT #6: SQL/PL: FUNCTIONS, PROCEDURES, AND TRIGGERS

--Clean up
drop table report cascade constraints;
drop table coverage cascade constraints;
drop table intersection cascade constraints;
drop table road cascade constraints;
drop table sensor cascade constraints;
drop table worker cascade constraints;
drop table forest cascade constraints;
drop table state cascade constraints;
drop table emergency cascade constraints;

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

alter table SENSOR
    add energy int not null;
alter table SENSOR
    add constraint sensor_energy_check CHECK (energy >= 0 AND energy <= 100);

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

-- 1.Implement the following procedure and function in PostgreSQL and Oracle.
-- a. Create stored procedure pro Update Last Read that updates the Last Read attribute of a specific sensor. The procedure has the following inputs:
-- – input sensor id: the ID of the sensor to be updated
-- – read time: the value to be used to update the Last Read attribute.
create or replace procedure pro_Update_Last_Read(new_report_time timestamp, new_sensor_id int)
AS
begin
    UPDATE SENSOR
    set LAST_READ = new_report_time
    where sensor.SENSOR_ID = new_sensor_id;
end;
/

-- b. Create the function fun Compute Percentage that, given a specific amount area covered as part of a forest’s area covered by some state, returns the percentage of area covered out of the whole area of the forest. The function has the following inputs:
-- – input forest no: the ID of the forest in consideration
-- – area covered: the part of the forest’s area covered by some state.
create or replace function fun_Compute_Percentage(input_forest_no varchar2, area_covered float)
    return float as
    forest_area float;
    result      float;

begin
    select area
    into forest_area
    from forest
    where FOREST_NO = input_forest_no;

    if area_covered >= forest_area then
        result := 1;
    else
        result := area_covered / forest_area;
    end if;

    return result;

end ;
/

-- 2. Implement the following triggers in PostgreSQL and Oracle.
-- (a) Define a trigger tri Last Read so that when a sensor reports a new temperature, the trigger will automatically update the value of Last Read of that sensor. The trigger body should use the procedure pro Update Last Read created above.
create or replace trigger tri_Last_Read
    after insert
    on REPORT
    for each row
begin
    pro_Update_Last_Read(:NEW.REPORT_TIME, :NEW.SENSOR_ID);
end;
/

-- (b) Define a trigger tri Percentage so that when the area of a forest covered by some state is updated, the trigger automatically update the corresponding value of ”percentage“, using the function fun Compute Percentage created above.
create or replace trigger tri_Percentage
    before update
    on COVERAGE
    for each row

begin
    :NEW.percentage := fun_Compute_Percentage(:new.FOREST_NO, :new.AREA);
end;
/


-- (c) Define a trigger tri Emergency so that when a new report is inserted with the reported temperature greater than 100, the trigger inserts a corresponding tuple into table Emergency.
create or replace function fun_Emergency(input_temp float)
    return int as
begin
    if input_temp > 100 then
        return 1;
    else
        return 0;
    end if;

end;
/

create or replace trigger tri_Emergency
    after insert
    on REPORT
    for each row

begin
    if fun_Emergency(:NEW.TEMPERATURE) = 1
    then
        insert into EMERGENCY values (:NEW.SENSOR_ID, :NEW.REPORT_TIME);
    end if;
end;
/

-- 3.Verify the triggers created in Question 2 in PostgreSQL and Oracle.
--(a) Test the trigger tri Last Read in 3 steps:
--i. Display the content of SENSOR.
select *
from sensor;
--ii. Add a new report with a report time.
INSERT into REPORT
values (2, 59, to_timestamp('13-OCT-2019 09:00:00', 'DD-MON-YYYY HH24:MI:SS'));
--iii. Display the content of SENSOR.
select *
from sensor;

--(b) Test the trigger tri Percentage in 3 steps:
--i. Display the content of COVERAGE.
select *
from COVERAGE;
--ii. Update the area of a forest covered by some state.
update COVERAGE
set area = 4000.0
where FOREST_NO = 1
  and state = 'PA';
--iii. Display the content of COVERAGE.
select *
from COVERAGE;

-- (c)
--(c) Test the trigger tri Emergency in 3 steps:
--i. Display the content of EMERGENCY.
select *
from EMERGENCY;
--ii. Add a new report with a temperature greater than 100.
INSERT into REPORT
values (3, 120, to_timestamp('20-OCT-2019 09:00:00', 'DD-MON-YYYY HH24:MI:SS'));
--iii. Display the content of EMERGENCY.
select *
from EMERGENCY;

-- 4.Write a procedure with a cursor and call the procedure to list the names of the forests in PostgreSQL and Oracle. You need to implement the cursor both explicitly and implicitly for each DBMS.
-- For the explicit cursor, you need to declare the cursor, open it, and fetch records from it.
-- For the implicit cursor, you don’t need to declare the cursor, only use the “for loop” to fetch records.
-- Use the following command to print the names:
-- – For PostgreSQL: raise notice ’%’, forest record.name;
-- – For Oracle (SQL Plus): dbms output.put line(forest record.name);
-- (Run SET SERVEROUTPUT ON at program start)
-- – For Oracle (DataGrip): dbms output.put line(forest record.name);
-- (Click the Enable SYS.DBMS OUTPUT button first (Command+F8 on MacOS, Ctrl+F8 on Windows))
create or replace procedure get_all_forest_name(dummy int)
AS
    CURSOR cur_forest IS
        select *
        from forest;
    forest_record forest%rowtype;

begin
    if not cur_forest%ISOPEN
    THEN
        OPEN cur_forest;
    end if;

    loop
        fetch cur_forest into forest_record;
        exit when cur_forest%notfound;
        dbms_output.put_line(forest_record.name);
    end loop;
end;
/

call get_all_forest_name(1);

--implicit
create or replace procedure get_all_forest_name_implicit(dummy int)
AS
    forest_record forest%rowtype;
begin
    for forest_record in (
        select name from forest
        )
        loop
            dbms_output.put_line(forest_record.name);
        end loop;
end;
/

call get_all_forest_name_implicit(1);