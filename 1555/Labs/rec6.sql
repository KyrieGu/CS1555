----include Student_DB.sql----
---QUES 1---
--SELECT name FROM student WHERE sid ='123' ; This is projection
--always remember to run the database creation file first before running selection part
SELECT course_taken.sid, course_taken.course_no FROM course_taken WHERE course_taken.term = 'Fall 18' and course_taken.grade IS NULL;
--Q4--
SELECT course.course_no, course_taken.sid FROM course NATURAL JOIN course_taken WHERE course.name='Operating Systems';


--q6--
SELECT student.name,course_taken.grade,course_taken.course_no FROM course_taken NATURAL JOIN student ORDER BY course_taken.grade LIMIT 3;

--q7