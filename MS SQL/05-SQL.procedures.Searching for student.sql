create proc SearchStudent @student_surname varchar(64)
as
select Student.st_name as [Ім'я], 
	Student.st_birthday as [Дата народження], 
	Student.st_parents as [Адреса батьків],
	Card.group_code as [Код спеціальності], 
	Card.dormitory_number as [№ гуртожитку],  
	Card.room_number as [Номер кімнати]
from Student inner join Card on Student.st_number = Card.st_number
where Student.st_name like @student_surname

exec SearchStudent 'Іванов Іван'

create proc GetStudentsInDormitory @dormitory int
as 
select Student.st_name as [Ім'я], 
	Student.st_birthday as [Дата народження], 
	Card.faculty_code as [Код факультету],
	Card.group_code as [Код спеціальності]
from Student inner join Card on Student.st_number = Card.st_number
where Card.dormitory_number = @dormitory;
	
exec GetStudentsInDormitory 3
create proc FacultyStCount @st_count int output, @faculty int, @faculty_name  varchar(64) output
as
set @faculty_name = (select Faculty.faculty_name from faculty where Faculty.faculty_code = @faculty)
set @st_count = (select Count(*) from
(select Student.st_name as [Ім'я], 
	Student.st_birthday as [Дата народження], 
	Card.faculty_code as [Код факультету],
	Card.group_code as [Код спеціальності]
from Student inner join Card on Student.st_number = Card.st_number
where Card.faculty_code = @faculty
) as T)
declare @f_count int
declare @f_name varchar(64)
exec FacultyStCount @f_count output, 1, @f_name output
print 'Факультет: ' + @f_name;
print 'Кількість студентів, які проживають у гуртожитку: ' + cast(@f_count as varchar(64));

drop proc GetFreePlaces
create proc GetFreePlaces @free_places int output, @dormitory int
as
begin
set @free_places  = 160 - (select Count(*) 
from (select Student.st_name as [Ім'я], 
	Student.st_birthday as [Дата народження], 
	Card.faculty_code as [Код факультету],
	Card.group_code as [Код спеціальності]
from Student inner join Card on Student.st_number = Card.st_number
where Card.dormitory_number = @dormitory)as T);
print 'Гуртожиток №: ' + cast(@dormitory as varchar(2))
print 'Вільних місць: '  + cast(@free_places as varchar(4))
end;

declare @free int
exec GetFreePlaces @free output, 3