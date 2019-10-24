-- Question 1
select ct.sid, ct.course_no
from course_taken ct
where ct.term = 'Fall 19'
  and ct.grade is null;

-- Question 2a
select s.sid, s.name, count(distinct course_no) as num_courses
from student s,
     course_taken ct
where s.sid = ct.sid
group by s.sid, s.name;

-- Question 2b
select s.sid, s.name, count(distinct course_no) as num_courses
from student s
         join course_taken ct on ct.sid = s.sid
group by s.sid, s.name;

-- Question 3
select s.SID, s.name, avg(grade) as GPA
from course_taken ct
         join student s on ct.sid = s.sid
group by s.sid, s.name
having avg(grade) > 3.7
order by GPA desc;

-- Question 4
select SID
from student
where sid not in (
    select SID
    from course_taken
    where term = 'Fall 19');

-- Question 5
select sid, course_no -- Postgres
from course_taken ct1
where not exists(
        (select course_no
         from course
         where course_level = 'UGrad')
        except
        (select course_no
         from course_taken ct2
         where ct1.sid = ct2.sid));

select sid, course_no -- Oracle
from course_taken ct1
where not exists(
        (select course_no
         from course
         where course_level = 'UGrad')
        MINUS
        (select course_no
         from course_taken ct2
         where ct1.sid = ct2.sid));

-- Question 6
select * from
(select instructorID as id,count(course_no) as N_courses
from course_offered
group by instructorID) as ic natural join instructor i