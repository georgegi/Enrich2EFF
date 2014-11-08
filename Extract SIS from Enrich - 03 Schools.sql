print '"ID","Name","Abbreviation","Number","Street","City","State","ZipCode","PhoneNumber"'
select '"'+convert(varchar(100),ID)+'","'+convert(varchar(100),Name)+'","'+convert(varchar(100),Abbreviation)+'","'+convert(varchar(100),Number)+'","'+convert(varchar(100),Street)+'","'+convert(varchar(100),City)+'","'+convert(varchar(100),State)+'","'+convert(varchar(100),ZipCode)+'","'+convert(varchar(100),PhoneNumber)+'"'
from x_DATATEAM.Extract_SIS_Schools
