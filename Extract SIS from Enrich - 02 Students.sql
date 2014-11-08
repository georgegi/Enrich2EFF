
print '"ID","Firstname","Middlename","Lastname","SchoolID","DistrictNumber","GradeLevelCode","SSN","StateNumber","BirthDate","EthnicityCode","IsHispanic","GenderCode","Street","City","State","ZipCode","PhoneNumber"'
select '"'+convert(varchar(100),ID)+'","'+convert(varchar(100),Firstname)+'","'+convert(varchar(100),Middlename)+'","'+convert(varchar(100),Lastname)+'","'+convert(varchar(100),SchoolID)+'","'+convert(varchar(100),DistrictNumber)+'","'+convert(varchar(100),GradeLevelCode)+'","'+convert(varchar(100),SSN)+'","'+convert(varchar(100),StateNumber)+'","'+convert(varchar(100),BirthDate)+'","'+convert(varchar(100),EthnicityCode)+'","'+convert(varchar(100),IsHispanic)+'","'+convert(varchar(100),GenderCode)+'","'+convert(varchar(100),Street)+'","'+convert(varchar(100),City)+'","'+convert(varchar(100),State)+'","'+convert(varchar(100),ZipCode)+'","'+convert(varchar(100),PhoneNumber)+'"'
from x_DATATEAM.Extract_SIS_Students

