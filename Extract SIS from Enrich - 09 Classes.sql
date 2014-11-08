
print '"ID","SchoolID","TeacherID","CourseName","SectionName","CourseNumber","MinGradeLevelCode","MaxGradeLevelCode"'
select '"'+convert(varchar(100),ID)+'","'+convert(varchar(100),SchoolID)+'","'+convert(varchar(100),TeacherID)+'","'+convert(varchar(100),CourseName)+'","'+convert(varchar(100),SectionName)+'","'+convert(varchar(100),CourseNumber)+'","'+convert(varchar(100),MinGradeLevelCode)+'","'+convert(varchar(100),MaxGradeLevelCode)+'"'
from x_DATATEAM.Extract_SIS_Classes



