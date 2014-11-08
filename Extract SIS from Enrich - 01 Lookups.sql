print '"Type","Code","Label"'
select '"'+convert(varchar(100),Type)+'","'+convert(varchar(100),Code)+'","'+convert(varchar(100),Label)+'"'
from x_DATATEAM.Extract_SIS_Lookups
