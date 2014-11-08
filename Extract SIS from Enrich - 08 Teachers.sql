
print '"ID","SchoolID","Firstname","Lastname","EmailAddress","GenderCode","EthnicityCode","Street","City","State","ZipCode","PhoneNumber"'
select '"'+convert(varchar(100),ID)+'","'+convert(varchar(100),SchoolID)+'","'+convert(varchar(100),Firstname)+'","'+convert(varchar(100),Lastname)+'","'+convert(varchar(100),EmailAddress)+'","'+convert(varchar(100),GenderCode)+'","'+convert(varchar(100),EthnicityCode)+'","'+convert(varchar(100),Street)+'","'+convert(varchar(100),City)+'","'+convert(varchar(100),State)+'","'+convert(varchar(100),ZipCode)+'","'+convert(varchar(100),PhoneNumber)+'"'
from x_DATATEAM.Extract_SIS_Teachers

