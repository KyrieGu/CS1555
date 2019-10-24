--this is to drop the table if it has existed
drop table if exists bank cascade;

--create table bank
create table bank(
code char(4) not null,
name varchar(20),
addr varchar(30),
primary key(code),
unique(name)
);

--table customer
drop table if exists customer cascade;
create table customer(
ssn char(9) not null,
name varchar(30),
phone varchar(15),
addr varchar(30),
num_accounts numeric(2,0),
primary key (ssn)
);

--table account
drop table if exists account cascade;
create table account(
acc_no varchar(15) not null,
ssn  char(9),
code char(4),
open_date date,
balance numeric(15,2),
close_date date,
primary key(acc_no),
foreign key (ssn) references customer(ssn),
foreign key(code) references bank(code),
check((close_date is null) or (close_date > open_date))
);

--table loan
drop table if exists loan cascade;
create table loan(
ssn     char(9) not null,
code char(4) not null,
open_date date not null,
amount numeric(15,2),
close_date date,
primary key(ssn, code, open_date),
foreign key (ssn) references customer(ssn),
foreign key (code) references bank(code)
);

--table alert
drop table if exists alert cascade;
create table alert(
alert_date date not null,
balance numeric(15,2) not null,
loan numeric(15,2) not null,
primary key (alert_date)
);

--insert data
insert into bank values('1234','Pitt Bank', '111 University St');

insert into customer values('123456789', 'John', '555-535-5263','100 University St',1);
insert into customer values('111222333', 'Mary', '555-535-3333','20 University St',1);

insert into account values('123','123456789', '1234', '2008-09-10', 500, null);
insert into account values('124','111222333','1234','2009-10-10', 1000, null);

insert into loan values('111222333', '1234', '2010-09-15', 100, null);

commit;

-- question 1
--staff.html
--Create a function that returns true if a customer can pay his loan or false when his balance
-- is less than his loan. Test the function using the ssn 123456789.

CREATE OR REPLACE FUNCTION can_pay_loan(customer_ssn char(9))
    RETURNS BOOLEAN AS $$

    DECLARE can pay BOOLEAN:= FALSE;

    BEGIN
        SELECT a.ssn =  l.ssn
        FROM account a 


    END;


$$


















-- CREATE OR REPLACE FUNCTION can_pay_loan(customer_ssn char(9))
--     RETURNS BOOLEAN AS
-- $$
--     DECLARE
--         can_pay BOOLEAN := false;
--     BEGIN
--         --start query
--         SELECT (account.ssn = customer_ssn)
--             INTO can_pay
--             FROM account
--                 LEFT JOIN loan on account.ssn = loan.ssn
--             WHERE account.ssn = customer_ssn AND account.balance > loan.amount
--                 OR loan.ssn is null;
--
--         -- end query
--
--         RETURN can_pay;
-- end;
--     $$ LANGUAGE plpsql;
--
--     SELECT can_pay_loan('123456789');


--question 2

CREATE OR REPLACE FUNCTION check_customers_can_pay(rand_number InTEGER, discount INTEGER)
    RETURNS text AS

$$
DECLARE
    report      TEXT DEFAULT '';
    rec_customer RECORD;
    count integer := 0;
    cur_customers CURSOR;

BEGIN
        --open the cursor
    OPEN cur_customers;

    LOOP

        END LOOP;

    CLOSE cur_customers;

    RETURN report;

end;


    $$
