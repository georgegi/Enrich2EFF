print '"ID","StudentID","CourseID","StartDate","EndDate"'
select '"'+convert(varchar(100),ID)+'","'+convert(varchar(100),StudentID)+'","'+convert(varchar(100),CourseID)+'","'+convert(varchar(100),StartDate)+'","'+convert(varchar(100),EndDate)+'"'
from x_DATATEAM.Extract_SIS_Enrollments