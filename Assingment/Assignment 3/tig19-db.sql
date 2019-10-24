
--              TIG19
--              TIANRUN GU
--              Assignment 2

drop table if exists FOREST cascade;
drop table if exists STATE cascade;
drop table if exists COVERAGE cascade;
drop table if exists ROAD cascade;
drop table if exists INTERSECTION cascade;
drop table if exists SENSOR cascade;
drop table if exists REPORT cascade;
drop table if exists WORKER cascade;
drop domain if exists energy_dom cascade;

--                  Create table part                  ---
CREATE TABLE FOREST
(
    Forest_No VARCHAR (10) NOT NULL,
    Name VARCHAR(30)  NOT NULL,
    Area INTEGER,
    Acid_Level FLOAT,
    MBR_Xmin   FLOAT,
    MBR_XMax   FLOAT,
    MBR_Ymin   FLOAT,
    MBR_YMax   FLOAT,

    CONSTRAINT FOREST_PK
        PRIMARY KEY(Forest_No)

);

CREATE TABLE STATE(
    NAME VARCHAR(30) NOT NULL,
    Abbreviation VARCHAR(2) NOT NULL,
    Area FLOAT,
    Population  INTEGER,

    CONSTRAINT  STATE_PK
                  PRIMARY KEY(Abbreviation)
);

CREATE TABLE COVERAGE(
    Forest_No VARCHAR (10) NOT NULL,
    State   VARCHAR(2) NOT NULL ,
    Percentage  FLOAT,
    Area    FLOAT,

    CONSTRAINT COVERAGE_PK
                    PRIMARY KEY (Forest_No, STATE),

    CONSTRAINT COVERAGE_FK
        FOREIGN KEY (Forest_No) REFERENCES FOREST(Forest_No),

    CONSTRAINT COVERAGE_FK2
                  FOREIGN KEY (State) REFERENCES STATE(Abbreviation)
);


CREATE TABLE ROAD(
    Road_No VARCHAR (10) NOT NULL,
    Name    VARCHAR(10) NOT NULL,
    Length  FLOAT,

    CONSTRAINT ROAD_PK
                 PRIMARY KEY (Road_No)
);

CREATE TABLE INTERSECTION(
    Forest_No   VARCHAR(10) NOT NULL,
    Road_No     VARCHAR(10) NOT NULL,

    CONSTRAINT INTERSECTION_PK
                         PRIMARY KEY (Forest_No, Road_No),

    CONSTRAINT INTERSECTION_FK
        FOREIGN KEY (Forest_No) REFERENCES FOREST(Forest_No),

    CONSTRAINT INTERSECTION_FK2
                 FOREIGN KEY (Road_No)  REFERENCES ROAD(Road_No)
);

CREATE TABLE SENSOR(
    Sensor_ID   INTEGER NOT NULL,
    X           FLOAT,
    Y           FLOAT,
    Last_Charged    TIMESTAMP,

    CONSTRAINT SENSOR_PK
                   PRIMARY KEY (Sensor_ID)
);

CREATE TABLE REPORT(
    Sensor_ID INTEGER NOT NULL,
    Temperature FLOAT,
    Report_Time TIMESTAMP,

    CONSTRAINT REPORT_PK
                   PRIMARY KEY (Sensor_ID, Report_Time)
);

CREATE TABLE WORKER(
    SSN VARCHAR(9)  NOT NULL,
    Name   VARCHAR(30) NOT NULL,
    Age    INTEGER,
    Rank   INTEGER,

    CONSTRAINT WORKER_PK
                   PRIMARY KEY (SSN)
);

--                          Alter part                      --

--     Alter Forest
ALTER TABLE FOREST ADD
    CONSTRAINT FOREST_AK UNIQUE (Name);

ALTER TABLE FOREST
  ADD CONSTRAINT Acid_Level_value check (Acid_Level >= 0 AND Acid_Level <= 1);
------------------------------------------------------------

ALTER TABLE STATE ADD
    CONSTRAINT STATE_AK UNIQUE (NAME);

ALTER TABLE ROAD ADD
    CONSTRAINT ROAD_AK UNIQUE (NAME);

--  Alter Sensor
CREATE DOMAIN energy_dom AS INT CHECK
(value >= 0 AND value <= 100);

ALTER Table SENSOR ADD
    Energy  energy_dom;

ALTER TABLE SENSOR
  ADD Maintainer varchar(9),
  ADD CONSTRAINT SENSOR_FK foreign key (Maintainer)
            references WORKER(SSN) ;
------------------------------------------------------------

ALTER TABLE WORKER ADD
    CONSTRAINT WOKER_AK UNIQUE (Name);

------------------------------------------------------------
----                  Part 4              -----
INSERT INTO FOREST values (1, 'Allegheny National Forest', 40000.0, 0.3, 134.0, 550.0, 233.0, 598.0);
INSERT INTO FOREST values (2, 'Pennsylvania Forest', 10000.0, 0.75, 21.0, 100.0, 35.0, 78.0);

INSERT INTO STATE values ('Pennsylvania', 'PA', 50000.0, 1400000);
INSERT INTO STATE values ('Ohio', 'OH', 45000.0, 1200000);

INSERT INTO COVERAGE values (1, 'PA', 0.4, 16000.0);
INSERT INTO COVERAGE values (1, 'OH', 0.6, 24000.0);
INSERT INTO COVERAGE values (2, 'PA', 1, 10000.0);

INSERT INTO ROAD values (1, 'FORBES', 500.0);
INSERT INTO ROAD values (2, 'BIGELOW', 300.0);

INSERT INTO INTERSECTION values (1, 1);
INSERT INTO INTERSECTION values (1, 2);
INSERT INTO INTERSECTION values (2, 1);
INSERT INTO INTERSECTION values (2, 2);

INSERT INTO WORKER values (123456789, 'John', 22, 3);
INSERT INTO WORKER values (121212121, 'Jason', 30, 5);

INSERT INTO SENSOR values (1, 150.0, 300.0, '01-JAN-2019 10:00:00', 20, 123456789);
INSERT INTO SENSOR values (2, 200.0, 400.0, '01-JAN-2019 10:00:00', 30, 123456789);
INSERT INTO SENSOR values (3, 50.0, 50.0, '01-JAN-2019 10:00:00', 30, 121212121);
INSERT INTO SENSOR values (4, 50.0, 15.0, '01-JAN-2019 10:00:00', 30, NULL);
INSERT INTO SENSOR values (5, 60.0, 60.0, '01-JAN-2019 10:00:00', 40, 121212121);

INSERT INTO REPORT values (1, 55, '10-JAN-2019 09:00:00');
INSERT INTO REPORT values (1, 57, '10-JAN-2019 14:00:00');
INSERT INTO REPORT values (1, 40, '10-JAN-2019 20:00:00');
INSERT INTO REPORT values (2, 58, '10-JAN-2019 12:30:00');
INSERT INTO REPORT values (2, 59, '10-JAN-2019 13:00:00');
INSERT INTO REPORT values (3, 50, '10-JAN-2019 12:30:00');
INSERT INTO REPORT values (4, 30, '01-JAN-2019 22:00:00');
INSERT INTO REPORT values (5, 33, '02-JAN-2019 22:00:00');
INSERT INTO REPORT values (5, 32, '02-JAN-2019 22:30:00');



----                  Part 4b              -----
----            TEST Primary Key   -----
INSERT INTO ROAD VALUES (1, 'FORBES', 300.0);

---    Test not null
INSERT INTO WORKER VALUES (NULL,NULL,34,6);

--     Test unique key
INSERT INTO STATE VALUES ('OhioForTest', 'OH', 45000.0, 1200000);

--     Test Foreign key
INSERT INTO COVERAGE VALUES (3, 'PA', 0.4, 16000.0);
INSERT INTO SENSOR VALUES (6, 60.0, 60.0, '01-JAN-2019 10:00:00', 40, 121212122);

--     Test forest acid condition
INSERT INTO FOREST values (2, 'Pennsylvania Forest2', 10000.0, -1, 21.0, 100.0, 35.0, 78.0);