
print '"StudentID","Grade","StartDate","EndDate"'
select '"'+convert(varchar(100),StudentID)+'","'+convert(varchar(100),Grade)+'","'+convert(varchar(100),StartDate)+'","'+convert(varchar(100),EndDate)+'"'
from x_DATATEAM.Extract_SIS_StudentGrades
