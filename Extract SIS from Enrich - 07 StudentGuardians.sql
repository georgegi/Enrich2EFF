
print '"ID","StudentID","GuardianID","RelationshipID"'
select '"'+convert(varchar(100),ID)+'","'+convert(varchar(100),StudentID)+'","'+convert(varchar(100),GuardianID)+'","'+convert(varchar(100),RelationshipID)+'"'
from x_DATATEAM.Extract_SIS_StudentGuardians

