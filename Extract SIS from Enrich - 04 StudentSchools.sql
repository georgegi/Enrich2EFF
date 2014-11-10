
print '"StudentID","SchoolID","StartDate","EndDate"'
select '"'+convert(varchar(100),StudentID)+'","'+convert(varchar(100),SchoolID)+'","'+convert(varchar(100),ss.StartDate)+'","'+convert(varchar(100),ss.EndDate)+'"'
from x_DATATEAM.Extract_SIS_StudentSchools ss
join RosterYear ry on ss.StartDate between ry.StartDate and ry.EndDate
where ry.StartYear = '2013'



