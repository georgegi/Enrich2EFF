/*
	Data fixes necessary before successful export

-- fixed data issue with bad race ids having been used for students and teachers
-- there were duplicates with IsActive = 0
-- update enumvalue set IsActive = 0 where ID = 'AB72BC47-897E-4C37-A0DD-CB7FC272EE27' 
-- update enumvalue set IsActive = 0 where ID = 'A5473E41-75CD-4EF8-A43A-2EA257408C0C'
-- many students didn't have a race

--insert StudentRace (StudentID, RaceID)
--select s.ID, ev.ID
--from PWRSCH.MAP_StudentID m -- 16656
--join Student s on m.DestID = s.ID -- 16656
--join PWRSCH.Students ps on m.StudentID = ps.ID -- 16656
--join x_DATATEAM.Extract_SIS_Students e on s.ID = e.StudentRefID 
--join EnumValue ev on ps.Ethnicity = ev.Code and ev.Type = (select ID from EnumType where Type = 'ETH')
--where s.ID not in (select StudentID from StudentRace)

-- there were 2 students sharing the same number
--update student set Number = '712146968' where ID = '6F0C53EC-3061-4D01-B0A6-6E92E6E1AF5D' and not exists (select 1 from student where Number = '712146968')

*/




if OBJECT_ID('x_DATATEAM.Extract_SIS_StudentRacePivot') is not null
drop view x_DATATEAM.Extract_SIS_StudentRacePivot 
go

create view x_DATATEAM.Extract_SIS_StudentRacePivot -- duh. there aren't any
as
/*
	Assumes up to 2 races per student

*/
select 
	StudentRefID = s.ID,
	StudentID = s.Number, 
	Races = max(ev1.Code+ISNULL(';'+ev2.Code,''))
from Student s
join StudentRace r1 on s.ID = r1.StudentID
join EnumValue ev1 on r1.RaceID = ev1.ID
	and ev1.Code = (
		select min(evx1.Code)
		from StudentRace rx1
		join EnumValue evx1 on rx1.RaceID = evx1.ID 
		where r1.StudentID = rx1.StudentID
	)
left join StudentRace r2 on s.ID = r2.StudentID --- and convert(varchar(36), r1.RaceID) < convert(varchar(36), r2.RaceID)
left join EnumValue ev2 on r2.RaceID = ev2.ID
	and ev2.Code > ev1.Code
where 1=1
and s.OID = 'EBAE3676-0CA9-4BB9-A7A7-CA35D35976BB' -- specific to SC Demo
and s.CurrentSchoolID is not null
and s.Number is not null
and s.DOB < dateadd(yy, -3, GETDATE()) -- at least 3 years old
group by s.ID, s.Number
go



if OBJECT_ID('x_DATATEAM.Extract_SIS_TeacherRacesPivot') is not null
drop view x_DATATEAM.Extract_SIS_TeacherRacesPivot 
go

create view x_DATATEAM.Extract_SIS_TeacherRacesPivot 
as
/*
	Assumes up to 2 races per Teacher

*/
select 
	TeacherID = t.ID,
	Races = max(ev1.Code+ISNULL(';'+ev2.Code,''))
from Teacher t
join TeacherRace r1 on t.ID = r1.TeacherID
join EnumValue ev1 on r1.RaceID = ev1.ID
	and ev1.Code = (
		select min(evx1.Code)
		from TeacherRace rx1
		join EnumValue evx1 on rx1.RaceID = evx1.ID 
		where r1.TeacherID = rx1.TeacherID
	)
left join TeacherRace r2 on t.ID = r2.TeacherID --- and convert(varchar(36), r1.RaceID) < convert(varchar(36), r2.RaceID)
left join EnumValue ev2 on r2.RaceID = ev2.ID
	and ev2.Code > ev1.Code
where 1=1
and t.CurrentSchoolID is not null
group by t.ID
go


if OBJECT_ID('x_DATATEAM.Extract_SIS_Students') is not null
drop view x_DATATEAM.Extract_SIS_Students 
go

create view x_DATATEAM.Extract_SIS_Students
as
select 
	StudentRefID = s.ID,
	ID = isnull(s.Number,''), 
	Firstname, 
	Middlename = isnull(Middlename,''), 
	Lastname, 
	SchoolRefID = sch.ID,
	SchoolID = sch.Number, 
	DistrictNumber = isnull(s.Number,''), 
	GradeLevelCode = g.Name,
	SSN = isnull(s.SSN,''),
	StateNumber = isnull(s.x_SunsNumber,''),
	BirthDate = convert(varchar, DOB, 101),
	EthnicityCode = sr.Races, -- Lookup ETH
	IsHispanic = s.IsHispanic,
	GenderCode = gen.Code,
	Street = isnull(s.Street,''),
	City = 'Oklahoma City',
	State = 'OK',
	ZipCode = '73105',
	PhoneNumber = isnull(s.PhoneNumber,'')
-- select s.Number
from Student s
join School sch on s.CurrentSchoolID = sch.ID -- watch for null School.Number
left join x_DATATEAM.Extract_SIS_StudentRacePivot sr on s.ID = sr.StudentRefID
left join GradeLevel g on s.CurrentGradeLevelID = g.ID
left join EnumValue gen on s.GenderID = gen.ID
where CurrentSchoolID is not null
and s.ID in (
select StudentID from StudentSchoolHistory where StartDate < GETDATE()
and ISNULL(enddate, dateadd(dd, -1, getdate())) < GETDATE() -- no future enrollment data
)
and s.DOB < dateadd(yy, -3, GETDATE()) -- at least 3 years old
and s.OID = 'EBAE3676-0CA9-4BB9-A7A7-CA35D35976BB' -- specific to SC Demo
and s.Number is not null
go



-- lookups

if OBJECT_ID('x_DATATEAM.Extract_SIS_Lookups_Race') is not null
drop view x_DATATEAM.Extract_SIS_Lookups_Race
go

create view x_DATATEAM.Extract_SIS_Lookups_Race
as
select 
	Type = 'ETH', 
	r.Code, 
	Label = r.DisplayValue 
from EnumValue r
where r.Type = (select ID from EnumType t where t.Type = 'ETH') 
and r.IsActive = 1 
and len(r.Code) = 1
go




if OBJECT_ID('x_DATATEAM.Extract_SIS_Schools') is not null
drop view x_DATATEAM.Extract_SIS_Schools 
go

create view x_DATATEAM.Extract_SIS_Schools
as
select 
	SchoolRefID = sch.ID,
	ID = sch.Number,
	Name = sch.Name,
	Abbreviation = sch.Abbreviation,
	Number = sch.Number,
	Street = sch.Street,
	City = 'Oklahoma City',
	State = 'OK',
	ZipCode = '73105',
	PhoneNumber = sch.PhoneNumber
from x_DATATEAM.Extract_SIS_Students s
join School sch on s.SchoolRefID = sch.ID
group by 
	sch.ID,
	sch.Number,
	sch.Name,
	sch.Abbreviation,
	sch.Street,
	sch.PhoneNumber
go


-- studentschools


if OBJECT_ID('x_DATATEAM.Extract_SIS_StudentSchools') is not null
drop view x_DATATEAM.Extract_SIS_StudentSchools 
go

create view x_DATATEAM.Extract_SIS_StudentSchools
as
select 
	StudentID = s.ID, -- SIS studentid 
	SchoolID = sch.Number, -- SIS SchoolID
	StartDate = convert(varchar, h.StartDate, 101),
	EndDate = isnull(convert(varchar, h.EndDate, 101), '')
from x_DATATEAM.Extract_SIS_Students s
join StudentSchoolHistory h on s.StudentRefID = h.StudentID
join x_DATATEAM.Extract_SIS_Schools sch on h.SchoolID = sch.SchoolRefID
go



-- studentgrades
if OBJECT_ID('x_DATATEAM.Extract_SIS_StudentGrades') is not null
drop view x_DATATEAM.Extract_SIS_StudentGrades
go

create view x_DATATEAM.Extract_SIS_StudentGrades
as
select 
	StudentID = s.ID, -- SIS studentid 
	Grade = g.Name, -- SIS SchoolID
	StartDate = convert(varchar, gh.StartDate, 101),
	EndDate = isnull(convert(varchar, gh.EndDate, 101), '')
from x_DATATEAM.Extract_SIS_Students s
join StudentGradeLevelHistory gh on s.StudentRefID = gh.StudentID
join GradeLevel g on gh.GradeLevelID = g.ID
go

-- Guardians
if OBJECT_ID('x_DATATEAM.Extract_SIS_Guardians') is not null
drop view x_DATATEAM.Extract_SIS_Guardians
go

create view x_DATATEAM.Extract_SIS_Guardians
as
select 
	ID = sg.PersonID,
	Firstname = p.Firstname,
	LastName = p.Lastname,
	EmailAddress = p.EmailAddress,
	Street = s.Street,
	City = 'Oklahoma City',
	State = 'OK',
	ZipCode = '73105',
	HomePhoneNumber = p.HomePhone,
	WorkPhoneNumber = p.WorkPhone,
	CellPhoneNumber = p.CellPhone
from x_DATATEAM.Extract_SIS_Students s
join StudentGuardian sg on s.StudentRefID = sg.StudentID
join Person p on sg.PersonID = p.ID 
--where p.LastName = s.LastName -- parent and student last names are never the same.  ugh.
go









-- StudentGuardians
if OBJECT_ID('x_DATATEAM.Extract_SIS_StudentGuardians') is not null
drop view x_DATATEAM.Extract_SIS_StudentGuardians
go

create view x_DATATEAM.Extract_SIS_StudentGuardians
as
select 
	sg.ID,
	StudentID = s.ID,
	GuardianID = sg.PersonID,
	RelationshipID = rel.Name
from x_DATATEAM.Extract_SIS_Students s
join StudentGuardian sg on s.StudentRefID = sg.StudentID
join StudentGuardianRelationship rel on sg.RelationshipID = rel.ID
go


-- lookups rel


if OBJECT_ID('x_DATATEAM.Extract_SIS_Lookups_Relationship') is not null
drop view x_DATATEAM.Extract_SIS_Lookups_Relationship
go

create view x_DATATEAM.Extract_SIS_Lookups_Relationship
as
select Type = 'REL',
	Code = convert(varchar(8), RelationshipID),
	Label = RelationshipID
from x_DATATEAM.Extract_SIS_StudentGuardians
group by RelationshipID
go


-- Teachers
if OBJECT_ID('x_DATATEAM.Extract_SIS_Teachers') is not null
drop view x_DATATEAM.Extract_SIS_Teachers
go

create view x_DATATEAM.Extract_SIS_Teachers
as
select
	t.ID, 
	SchoolID = sch.Number,
	t.Firstname,
	t.Lastname,
	t.EmailAddress,
	GenderCode = isnull(gen.Code,''),
	EthnicityCode = isnull(tr.Races,''),
	Street = t.Street,
	City = 'Oklahoma City',
	State = 'OK',
	ZipCode = '73105',
	PhoneNumber = t.PhoneNumber
from Teacher t
join Person p on t.EmailAddress = p.EmailAddress -- 1482
join School sch on t.CurrentSchoolID = sch.ID
left join EnumValue gen on t.GenderID = gen.ID
left join x_DATATEAM.Extract_SIS_TeacherRacesPivot tr on t.ID = tr.TeacherID
where t.EmailAddress not in (
	select d.EmailAddress
	from Teacher d 
	group by d.EmailAddress
	having count(*) > 1)
go


--Classes
if OBJECT_ID('x_DATATEAM.Extract_SIS_Classes') is not null
drop view x_DATATEAM.Extract_SIS_Classes
go

create view x_DATATEAM.Extract_SIS_Classes
as
select 
	cr.ID, 
	SchoolID = sch.Number, 
	th.TeacherID,
	CourseName = cr.ClassName, 
	cr.SectionName,
	CourseNumber = cr.CourseCode,
	MinGradeLevelCode = ming.Name,
	MaxGradeLevelCode = maxg.Name
from ClassRoster cr
join ClassRosterTeacherHistory th on cr.ID = th.ClassRosterID
join RosterYear ry on cr.RosterYearID = ry.ID
join x_DATATEAM.Extract_SIS_Teachers t on th.TeacherID = t.ID
join GradeLevel ming on cr.MinGradeID = ming.ID
join GradeLevel maxg on cr.MaxGradeID = maxg.ID
join School sch on cr.SchoolID = sch.ID
where th.EndDate is null
go

-- Enrollments

if OBJECT_ID('x_DATATEAM.Extract_SIS_Enrollments') is not null
drop view x_DATATEAM.Extract_SIS_Enrollments
go

create view x_DATATEAM.Extract_SIS_Enrollments
as
select 
	ID = convert(varchar(36), cr.ID)+s.Number+cr.CourseCode+convert(varchar, scrh.StartDate, 101),
	StudentID = s.Number,
	CourseID = cr.CourseCode,
	StartDate = convert(varchar, scrh.StartDate, 101),
	EndDate = convert(varchar, scrh.EndDate, 101)
from ClassRoster cr
join StudentClassRosterHistory scrh on cr.ID = scrh.ClassRosterID
join Student s on scrh.StudentID = s.ID
where StartDate >= '7/1/2013' -- 183044
and cr.ID = (
	select top 1 crx.ID
	from ClassRoster crx
	join StudentClassRosterHistory scrhx on crx.ID = scrhx.ClassRosterID
	where scrh.StudentID = scrhx.StudentID
	and cr.CourseCode = crx.CourseCode
	and scrh.StartDate = scrhx.StartDate
	order by crx.SectionName desc
)
go

--select top 100 * from ClassRoster 


-- lookups
if OBJECT_ID('x_DATATEAM.Extract_SIS_Lookups') is not null
drop view x_DATATEAM.Extract_SIS_Lookups
go

create view x_DATATEAM.Extract_SIS_Lookups
as
select Type, Code, Label from x_DATATEAM.Extract_SIS_Lookups_Race
union all
select Type, Code, Label from x_DATATEAM.Extract_SIS_Lookups_Relationship
go











-- select * from x_DATATEAM.Extract_SIS_Teachers

--select ID, count(*) tot from x_DATATEAM.Extract_SIS_Teachers group by ID having count(*) > 1 -- none
-- select * from x_DATATEAM.Extract_SIS_Enrollments

--select StudentID, CourseID, StartDate, count(*) tot from x_DATATEAM.Extract_SIS_Enrollments group by StudentID, CourseID, StartDate having count(*) > 1






--select * 
--from x_DATATEAM.Extract_SIS_Enrollments
--where StudentID = '869778225000'
--and CourseId = '08961600'
--and Startdate = '2013-08-20 00:00:00.000' -- same start dates, different end dates. different IDs.


-- select * from ClassRoster where ID in ('EF7B8B5A-598A-47A1-A5F9-1D2CAAC3345B', '5D192B40-3839-4C75-B767-31668CB7EFE9')




-- select top 100 * from StudentClassRosterHistory order by enddate desc

--select * from ClassRoster where ID = 'C31F5027-00AB-4D8E-A22B-0CDDF90F6499'
--select * from RosterYear where ID = 'EE98B081-65A6-4FDC-B3B9-1F4BC1DE84D2'




-- select o.name, c.name from sys.objects o join sys.columns c on o.object_id = c.object_id where schema_id = 1 and type = 'U' and c.name like '%course%'

--select o.name, ct.name, cc.name
--from sys.objects o
--join sys.columns ct on o.object_id = ct.object_id and ct.name like '%teacher%'
--join sys.columns cc on o.object_id = cc.object_id and cc.name like '%class%'





-- Oklahoma City, Oklahoma  73105

-- users
if OBJECT_ID('x_DATATEAM.Extract_Users_UserProfile') is not null
drop view x_DATATEAM.Extract_Users_UserProfile
go

create view x_DATATEAM.Extract_Users_UserProfile
as
select u.ID, RoleID, Username, CanPerformAllServices, CanSignAllServices, IsSchoolAutoSelected, u.CurrentFailedLoginAttempts, u.RoleStatusID, u.LastLoginContextID
from UserProfile u
join Person p on u.ID = p.ID
join x_DATATEAM.Extract_SIS_Teachers t on p.EmailAddress = t.EmailAddress -- 1219
where u.Deleted is null -- 1702 w/o teacher join
go


if OBJECT_ID('x_DATATEAM.Extract_Users_Person') is not null
drop view x_DATATEAM.Extract_Users_Person
go

create view x_DATATEAM.Extract_Users_Person
as
select 
	p.ID, 
	p.TypeID, 
	p.Firstname, 
	p.Lastname, 
	p.EmailAddress, 
	p.Street, 
	City = 'Oklahoma City', 
	State = 'OK', 
	ZipCode = '73105', 
	HomePhone, 
	WorkPhone, 
	CellPhone, 
	ManuallyEntered, 
	Title = isnull(Title, '')
from Person p 
join UserProfile u on p.ID = u.ID
join x_DATATEAM.Extract_SIS_Teachers t on p.emailaddress = t.emailaddress -- 1219
where u.Deleted is null -- 1702 w/o teacher join
go

-- select * from x_DATATEAM.Extract_Users_Person




-- find necessary UserProfile associated records
--select * from x_DATATEAM.Extract_Users_UserProfile

--x_datateam.findguid 'D99AF1F9-062F-45AF-AA0D-002B6D9BBB8C'
--select * from dbo.Person where ID = 'D99AF1F9-062F-45AF-AA0D-002B6D9BBB8C'
--select * from dbo.Report where Owner = 'D99AF1F9-062F-45AF-AA0D-002B6D9BBB8C'
--select * from dbo.StudentGroup where OwnerID = 'D99AF1F9-062F-45AF-AA0D-002B6D9BBB8C'
--select * from dbo.Teacher where UserProfileID = 'D99AF1F9-062F-45AF-AA0D-002B6D9BBB8C'
--select * from dbo.UserProfile where ID = 'D99AF1F9-062F-45AF-AA0D-002B6D9BBB8C'
--select * from dbo.UserProfileOrgUnit where UserProfileID = 'D99AF1F9-062F-45AF-AA0D-002B6D9BBB8C'
--select * from dbo.UserProfileSchool where UserProfileID = 'D99AF1F9-062F-45AF-AA0D-002B6D9BBB8C'
--select * from dbo.UserProfileServiceDefPermission where UserProfileID = 'D99AF1F9-062F-45AF-AA0D-002B6D9BBB8C'

--select * from x_DATATEAM.MAP_UserProfileData where ID = 'D99AF1F9-062F-45AF-AA0D-002B6D9BBB8C'
--select * from x_DATATEAM.Person_20141107 where ID = 'D99AF1F9-062F-45AF-AA0D-002B6D9BBB8C'
--select * from x_DATATEAM.Teacher_20141107 where UserProfileID = 'D99AF1F9-062F-45AF-AA0D-002B6D9BBB8C'


--select t.*, p.EmailAddress
--from x_datateam.extract_sis_teachers t -- 1219
--left join x_DATATEAM.Extract_Users_Person p on t.EmailAddress = p.EmailAddress -- 1219

--select * from Teacher where ID = '1B797D7B-E488-4EE1-A687-00F486A44D40'
--select * from UserProfile where ID = 'C6FA29DF-D227-4E26-AB1F-177C46AE879F'
--select * from Person where ID = 'C6FA29DF-D227-4E26-AB1F-177C46AE879F'

--cyrusconnor@demo.excentenrich.com
--annabellaconnor@demo.excentenrich.com


--select t.*, p.EmailAddress
--from x_datateam.extract_sis_teachers t -- 2041
--left join x_DATATEAM.Extract_Users_Person p on t.EmailAddress = p.EmailAddress -- 1215
--where p.ID is null -- no records




--select t.FirstName, t.LastName, t.EmailAddress, p.FirstName, p.LastName, p.EmailAddress, Same = case when t.EmailAddress <> p.EmailAddress then 0 else 1 end 
--from x_datateam.extract_sis_teachers v -- 2041
--join Teacher t on v.ID = t.ID
--join UserProfile u on t.UserProfileID = u.ID
--join Person p on u.id = p.ID
---- 2041
--order by Same -- 845 different emails.  bad matches?



--select t.Firstname, t.Lastname, t.emailaddress
--from Teacher t
--join Person p on t.FirstName = p.FirstName and t.LastName = p.LastName --- 1482
-- where t.UserProfileID = 'C6FA29DF-D227-4E26-AB1F-177C46AE879F'

--select t.Firstname, t.Lastname, count(*) tot
--from Teacher t
--group by t.Firstname, t.Lastname
--having count(*)> 1
-- 0!!!!!!!!!!!


--select p.Firstname, p.Lastname, count(*) tot
--from Person p 
--where p.Deleted is null
--and p.TypeID = 'U'
--group by p.Firstname, p.Lastname
--having count(*)> 1
---- 0

--select *
--into x_DATATEAM.Person_20141107
--from Person
--where TypeID = 'U'
--and Deleted is null

--select *
--into x_DATATEAM.Teacher_20141107
--from Teacher


--update t set emailaddress = lower(firstname+lastname)+'@demo.excentenrich.com'
---- select firstname, lastname, emailaddress, lower(firstname+lastname)+'@demo.excentenrich.com'
--from teacher t
--where emailaddress != lower(firstname+lastname)+'@demo.excentenrich.com' -- 5174?


--update p set emailaddress = lower(firstname+lastname)+'@demo.excentenrich.com'
---- select firstname, lastname, emailaddress, lower(firstname+lastname)+'@demo.excentenrich.com'
--from Person p
--where emailaddress != lower(firstname+lastname)+'@demo.excentenrich.com' -- 1484





