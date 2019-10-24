-- Part 1
-- Question 1
-- Oracle and Postgres
select s.SID, s.name, avg(grade) as GPA
from course_taken ct
         join student s on ct.sid = s.sid
group by s.sid, s.name
order by GPA
FETCH FIRST 2 ROWS ONLY;
--or
select s.SID, s.name, avg(grade) as GPA
from course_taken ct
         join student s on ct.sid = s.sid
group by s.sid, s.name
order by GPA
limit 2;
--or
SELECT  x.SID, x.name,x.GPA
FROM (
select s.SID, s.name, avg(grade) as GPA,
ROW_NUMBER() OVER (ORDER BY avg(grade))
from course_taken ct
         join student s on ct.sid = s.sid
group by s.sid, s.name
) x
WHERE ROW_NUMBER <=2;

-- In oracle
select * from (
select s.SID, s.name, avg(grade) as GPA
from course_taken ct
         join student s on ct.sid = s.sid
group by s.sid, s.name
order by GPA)
WHERE rownum <= 2;

-- Question 2
select i.sid,
       i.name,
       (1 + (select count(*)
             from (select s.sid, s.name, avg(grade) as gpa
                   from course_taken ct
                            join student s on ct.sid = s.sid
                   where grade is not null
                   group by s.sid, s.name
                   having avg(grade) > i.gpa
                   order by gpa) as e)
           ) as rank
from (select s.sid, s.name, avg(grade) as gpa
      from course_taken ct
               join student s on ct.sid = s.sid
      where grade is not null
      group by s.sid, s.name
      order by gpa) as i
order by rank;

-- Simplify
create or replace view student_gpa as
select s.sid, s.name, avg(grade) as gpa
from course_taken ct
         join student s on ct.sid = s.sid
where grade is not null
group by s.sid, s.name
order by gpa;

-- Now the query
select sid,
       name,
       (1 + (select count(*)
             from student_gpa as e
             where e.gpa > i.gpa)
           ) as rank
from student_gpa as i
order by rank;

-- Part 2
-- Question 1
create or replace view student_courses as
select s.sid, s.name, count(course_no) as num_courses
from student s,
     course_taken ct
where s.sid = ct.sid
group by s.sid, s.name;

-- Question 2
drop materialized view if exists mv_student_courses;
create materialized view mv_student_courses
as
select s.sid, s.name, count(course_no) as num_courses
from student s,
     course_taken ct
where s.sid = ct.sid
group by s.sid, s.name;

insert into course_taken (course_no, sid, term, grade)
values ('CS1555', '129', 'Fall 19', null);
commit;

-- Question 3
--REFRESH MATERIALIZED VIEW mv_student_courses;
select *
from mv_student_courses;
select *
from student_courses;
commit;
