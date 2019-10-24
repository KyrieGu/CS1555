create trigger trigger1
on enrollments
after Insert
as
begin

    declare @enrol as integer // variables to hold the current enrollment

    declare @limit as integer //variables to hold the limit of enrollment

    select @enrol = enrolled, @limit = lim from course where num = (select course from inserted)

    if @enrol < @limit //when we have available enrollment

        begin

        update courses set enrolled = @enrol +1 where num = (select course from inserted)

        if @enrol == @limit - 1

        update courses set open = False where num = (select course from inserted)

        end
end
go

create trigger trigger2
on enrollments
before insert
as
begin
    declare @enrol as integer // variables to hold the current enrollment

    declare @limit as integer //variables to hold the limit of enrollment

    select @enrol = enrolled, @limit = lim from course where num = (select course from inserted)

    if @enrol >= @limit //when we have available enrollment
        delete from enrollments where (select * from inserted)
end
go