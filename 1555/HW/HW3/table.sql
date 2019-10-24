create table students ( 
    id integer primary key, 
    name varchar(24) 
);

create table courses ( 
    num varchar(6) primary key, 
    open boolean not null, 
    enrolled integer default 0, 
    lim integer default 3 
);

create table enrollment ( 
    student integer references students(id), 
    course varchar(6) references courses(num) 
);