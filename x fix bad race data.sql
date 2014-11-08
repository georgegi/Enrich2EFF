
Declare @code varchar(5), @keepid varchar(36), @tossid varchar(36), @q varchar(max)

declare KT cursor for 
select d.Code, ek.ID, et.ID
from (
	select Code, count(*) tot
	from EnumValue 
	where Type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535' 
	group by Code 
	having count(*) > 1
) d
join EnumValue ek on d.Code = ek.Code and ek.Type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535' and ek.IsActive = 1
join EnumValue et on d.Code = et.Code and et.Type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535' and et.IsActive = 0
order by d.Code

open KT

fetch KT into @code, @keepid, @tossid

while @@fetch_status = 0
begin

-- for ease of coding, delete the good duplicates, then update the bad ones to the good id
print '-- '+@code+'
delete sr
from StudentRace sr 
where sr.RaceID = '''+@keepid+'''
and exists (select 1 from StudentRace x where sr.StudentID = x.StudentID and x.RaceID = '''+@tossid+''')

update sr set RaceID = '''+@keepid+'''
from StudentRace sr 
where RaceID = '''+@tossid+'''

delete tr
from TeacherRace tr 
where tr.RaceID = '''+@keepid+'''
and exists (select 1 from TeacherRace x where tr.TeacherID = x.TeacherID and x.RaceID = '''+@tossid+''')

update tr set RaceID = '''+@keepid+'''
from TeacherRace tr 
where RaceID = '''+@tossid+'''

'

fetch KT into @code, @keepid, @tossid
end
close KT
deallocate KT




---- start here
begin tran
-- A
delete sr
from StudentRace sr 
where sr.RaceID = '5F00C956-D393-48F5-84C8-8CAB9C802BC0'
and exists (select 1 from StudentRace x where sr.StudentID = x.StudentID and x.RaceID = 'ADE42CF1-9AFD-44C9-9CA9-2704197F3603')

update sr set RaceID = '5F00C956-D393-48F5-84C8-8CAB9C802BC0'
from StudentRace sr 
where RaceID = 'ADE42CF1-9AFD-44C9-9CA9-2704197F3603'

delete tr
from TeacherRace tr 
where tr.RaceID = '5F00C956-D393-48F5-84C8-8CAB9C802BC0'
and exists (select 1 from TeacherRace x where tr.TeacherID = x.TeacherID and x.RaceID = 'ADE42CF1-9AFD-44C9-9CA9-2704197F3603')

update tr set RaceID = '5F00C956-D393-48F5-84C8-8CAB9C802BC0'
from TeacherRace tr 
where RaceID = 'ADE42CF1-9AFD-44C9-9CA9-2704197F3603'

-- B
delete sr
from StudentRace sr 
where sr.RaceID = '69D50CD4-B899-486B-9A53-0D7A149AFB6F'
and exists (select 1 from StudentRace x where sr.StudentID = x.StudentID and x.RaceID = 'F7410E68-F40D-4CFE-93CE-0312AA7EFF52')

update sr set RaceID = '69D50CD4-B899-486B-9A53-0D7A149AFB6F'
from StudentRace sr 
where RaceID = 'F7410E68-F40D-4CFE-93CE-0312AA7EFF52'

delete tr
from TeacherRace tr 
where tr.RaceID = '69D50CD4-B899-486B-9A53-0D7A149AFB6F'
and exists (select 1 from TeacherRace x where tr.TeacherID = x.TeacherID and x.RaceID = 'F7410E68-F40D-4CFE-93CE-0312AA7EFF52')

update tr set RaceID = '69D50CD4-B899-486B-9A53-0D7A149AFB6F'
from TeacherRace tr 
where RaceID = 'F7410E68-F40D-4CFE-93CE-0312AA7EFF52'

-- I
delete sr
from StudentRace sr 
where sr.RaceID = '3396EA22-46DA-41F1-9CB2-009804605A85'
and exists (select 1 from StudentRace x where sr.StudentID = x.StudentID and x.RaceID = 'AB72BC47-897E-4C37-A0DD-CB7FC272EE27')

update sr set RaceID = '3396EA22-46DA-41F1-9CB2-009804605A85'
from StudentRace sr 
where RaceID = 'AB72BC47-897E-4C37-A0DD-CB7FC272EE27'

delete tr
from TeacherRace tr 
where tr.RaceID = '3396EA22-46DA-41F1-9CB2-009804605A85'
and exists (select 1 from TeacherRace x where tr.TeacherID = x.TeacherID and x.RaceID = 'AB72BC47-897E-4C37-A0DD-CB7FC272EE27')

update tr set RaceID = '3396EA22-46DA-41F1-9CB2-009804605A85'
from TeacherRace tr 
where RaceID = 'AB72BC47-897E-4C37-A0DD-CB7FC272EE27'

-- P
delete sr
from StudentRace sr 
where sr.RaceID = '5F5246FF-A3A9-4506-B6A9-61FAD433BA1F'
and exists (select 1 from StudentRace x where sr.StudentID = x.StudentID and x.RaceID = 'A5473E41-75CD-4EF8-A43A-2EA257408C0C')

update sr set RaceID = '5F5246FF-A3A9-4506-B6A9-61FAD433BA1F'
from StudentRace sr 
where RaceID = 'A5473E41-75CD-4EF8-A43A-2EA257408C0C'

delete tr
from TeacherRace tr 
where tr.RaceID = '5F5246FF-A3A9-4506-B6A9-61FAD433BA1F'
and exists (select 1 from TeacherRace x where tr.TeacherID = x.TeacherID and x.RaceID = 'A5473E41-75CD-4EF8-A43A-2EA257408C0C')

update tr set RaceID = '5F5246FF-A3A9-4506-B6A9-61FAD433BA1F'
from TeacherRace tr 
where RaceID = 'A5473E41-75CD-4EF8-A43A-2EA257408C0C'

-- W
delete sr
from StudentRace sr 
where sr.RaceID = '669F6E99-B66A-43E0-AD0A-375F26089847'
and exists (select 1 from StudentRace x where sr.StudentID = x.StudentID and x.RaceID = '7995D209-3D96-4964-BC19-4D2D930F6BC4')

update sr set RaceID = '669F6E99-B66A-43E0-AD0A-375F26089847'
from StudentRace sr 
where RaceID = '7995D209-3D96-4964-BC19-4D2D930F6BC4'

delete tr
from TeacherRace tr 
where tr.RaceID = '669F6E99-B66A-43E0-AD0A-375F26089847'
and exists (select 1 from TeacherRace x where tr.TeacherID = x.TeacherID and x.RaceID = '7995D209-3D96-4964-BC19-4D2D930F6BC4')

update tr set RaceID = '669F6E99-B66A-43E0-AD0A-375F26089847'
from TeacherRace tr 
where RaceID = '7995D209-3D96-4964-BC19-4D2D930F6BC4'





rollback

commit




select r.StudentID, ev.Code, count(*) tot
from StudentRace r
join EnumValue ev on r.RaceID = ev.ID and ev.Type = (select ID from EnumType where Type = 'ETH') and ev.isactive = 1
group by r.StudentID, ev.Code 
having count(*) > 1

select * from StudentRace where studentID = '24EF64BB-DA44-4938-A11C-787CA089EBDF'
select * from EnumValue where ID in ('A5473E41-75CD-4EF8-A43A-2EA257408C0C', '5F5246FF-A3A9-4506-B6A9-61FAD433BA1F')


select r.StudentID, r.RaceID, count(*) tot
from StudentRace r
group by r.StudentID, r.RaceID
having count(*) > 1

select r.StudentID, count(*) tot
from StudentRace r
group by r.StudentID
having count(*) > 1




--(208 row(s) affected)

--(208 row(s) affected)

--(208 row(s) affected)

--(0 row(s) affected)

--(3 row(s) affected)

--(1141 row(s) affected)

--(1141 row(s) affected)

--(1141 row(s) affected)

--(0 row(s) affected)

--(30 row(s) affected)

--(22 row(s) affected)

--(22 row(s) affected)

--(52 row(s) affected)

--(0 row(s) affected)

--(2 row(s) affected)

--(3 row(s) affected)

--(3 row(s) affected)

--(19 row(s) affected)

--(0 row(s) affected)

--(5 row(s) affected)

--(13686 row(s) affected)

--(13686 row(s) affected)

--(13686 row(s) affected)

--(0 row(s) affected)

--(1362 row(s) affected)
