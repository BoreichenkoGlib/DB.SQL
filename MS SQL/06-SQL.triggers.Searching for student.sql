--1--
create trigger CheckGroup
on Card
for delete
as
declare @ind int = (select group_code from deleted)
declare @g int = (select Count(*) from Card
where group_code = @ind)
if @g = 0
begin
delete
from Groupa 
where group_code = @ind
end

--2--
create trigger AddStudent
on Card
for insert
as
declare @dorm int = (select dormitory_number from inserted)
declare @room int = (select room_number from inserted)
declare @count_st int = (select Count(*) from Card where room_number = @room and dormitory_number = @dorm)
if @count_st > 4
begin 
rollback tran print 'Немає місць'
end
--3--
select * from Student
drop trigger CheckYear
create trigger CheckYear
on Student
for insert
as
declare @d date = (select st_birthday from inserted)
if year(@d) not between 1900 and 2020
begin
rollback tran print 'Помилка! Введіть коректну дату народження!'
end

insert into Student(st_number, st_name, st_birthday, st_parents)
values
(13, 'test', '2021.01.01', 'test')



