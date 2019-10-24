-- Tianrun Gu
-- tig19

--- Question 1
-- (a)  List the names of all forests that have acid level between 0.65 and 0.85 inclusive.
select name from forest where acid_level between 0.65 and 0.85;

--- (b) Retrieve the names of all forests, each of which has at least 50% of its area in PA.
select f.name
from forest f
inner join coverage c on f.forest_no = c.forest_no and c.percentage > 0.5 and c.state = 'PA';

-- (c)  Find the names of all roads in the forest whose name is “Allegheny National Forest”.
select r.name
from road r
inner join intersection i on r.road_no = i.road_no
inner join forest f on i.forest_no = f.forest_no and f.name = 'Allegheny National Forest';

-- (d)  List all the sensors along with the name of the workers who maintain them. The sensors without maintainers should also be listed.
select s.sensor_id, w.name
from sensor s, worker w
right join sensor s2 on w.ssn = s2.maintainer;

-- (e)  List the pairs of states that share at least one forest (i.e., cover parts of the same forests). Each pair should be listed only once, e.g., if the tuple (PA, OH) is already listed, then the tuple (OH, PA) should not be listed.
select distinct s1.state, s2.state
from coverage s1
join coverage s2 on s1.forest_no = s2.forest_no
and s2.state > s1.state;

-- (f) For each forest, find its average temperature and number of sensors. Display the result in descending order of the average temperatures.
select avg(r.temperature) as avg_temp, count(r.sensor_id) as sensor_count
from report r
join sensor s on r.sensor_id = s.sensor_id
join forest f on s.x <= f.mbr_xmax and s.x >= f.mbr_xmin and s.y <= f.mbr_ymax and s.y >= f.mbr_ymin
group by f.forest_no
order by avg(r.temperature) desc;

-- (g) Find the locations of sensors that reported the highest temperature.

drop table if exists max_tempttt cascade;
drop table if exists id_temp cascade;

select max(temperature) as max_t into max_tempttt
from report;

select r.sensor_id into id_temp
from report r
join max_tempttt on max_tempttt.max_t = r.temperature;

select s.x, s.y
from sensor s
join id_temp it on s.sensor_id = it.sensor_id;

-- (h) Find the states whose forests cover more than 30% of the state’s area (assuming that forests do not overlap).
select state1.name, sum(coverage1.percentage * forest1.area / state1.area) from COVERAGE coverage1
    join FOREST forest1 on coverage1.forest_no = forest1.Forest_No
    join STATE state1 on coverage1.state = state1.abbreviation
    group by state1.name
    having sum(coverage1.percentage * forest1.area / state1.area) > 0.3;

-- (i) Find the states that have higher area of forest than the forest area in Ohio.


-- (j) Find the names of all forests such that no sensors in those forests reported anything between Jan. 9, 2019 and Jan. 11, 2019 (Please use Set Membership or Set Comparisons operators for this question).
select forest1.name from FOREST forest1
    where forest1.forest_no not in (
        select forest1.forest_no from report report1
            join sensor sensor1 on report1.sensor_id = sensor1.sensor_id
            join forest forest1 on sensor1.y >= forest1.mbr_ymin and sensor1.y<= forest1.mbr_ymax
            and sensor1.x >= forest1.mbr_xmin and sensor1.x <= forest1.mbr_xmax
            where Report_Time <= '2019-01-11' and  report_time >='2019-01-09');