print '"ID","StudentID","CourseID","StartDate","EndDate"'
select distinct '"'+convert(varchar(100),e.ID)+'","'+convert(varchar(100),StudentID)+'","'+convert(varchar(100),CourseID)+'","'+convert(varchar(100),e.StartDate)+'","'+convert(varchar(100),e.EndDate)+'"'
from x_DATATEAM.Extract_SIS_Enrollments e
join RosterYear ry on e.StartDate between ry.StartDate and ry.EndDate
where ry.StartYear = '2013'
