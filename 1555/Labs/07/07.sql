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
values ('CS1555', '129', 'Fall 18', null);
commit;

-- Question 3
--REFRESH MATERIALIZED VIEW mv_student_courses;
select * from mv_student_courses;
select * from student_courses;
commit;
