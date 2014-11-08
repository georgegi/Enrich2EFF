set nocount on;

declare @t varchar(100), @header varchar(max), @cs varchar(max) 
	--, @t = 'Extract_SIS_Lookups'

declare T cursor for
select name 
from sys.objects 
where name like 'Extract[_]SIS[_]%'
and name not like '%Lookups[_]%'
and name not like '%pivot'

open T

fetch T into @t
while @@FETCH_STATUS = 0
begin

select @cs = '''"''+', @header = '''"'

select 
	@header = @header+c.name+case when c.column_id = (select max(column_id) from sys.columns where object_id = o.object_id) then '"''' else '","' end,
	@cs = @cs+'convert(varchar(100),'+c.name+')'+ case when c.column_id = (select max(column_id) from sys.columns where object_id = o.object_id) then '+''"''' else '+''","''+' end
from sys.objects o
join sys.columns c on o.object_id = c.object_id 
where o.name = @t
and c.name not like '%RefID'


print 'print '+@header
print 'select '+@cs+'
from x_DATATEAM.'+@t+'

'

fetch T into @t
end
close T
deallocate T



