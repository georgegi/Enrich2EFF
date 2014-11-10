
print '"StudentID","Grade","StartDate","EndDate"'
select '"'+convert(varchar(100),StudentID)+'","'+convert(varchar(100),Grade)+'","'+convert(varchar(100),sg.StartDate)+'","'+convert(varchar(100),sg.EndDate)+'"'
from x_DATATEAM.Extract_SIS_StudentGrades sg
join RosterYear ry on sg.StartDate between ry.StartDate and ry.EndDate
where ry.StartYear = '2013'
