create database db_school

use db_school       

create table collective(
CollectiveId int not null primary key identity(1,1),
collectiveCod varchar(20) unique,
course varchar(2),
amountTime int,
studentsNum int
)
create table discipline(
disciplineId int not null primary key identity(1,1),
subjectName varchar(40),
category varchar(40),
total_hours int
)
create table term(
controlType varchar(40),
teacherName varchar(60),
eventDate smalldatetime,
CollectiveId int FOREIGN KEY REFERENCES collective(CollectiveId),
AssignmentId int FOREIGN KEY REFERENCES discipline(disciplineId)
)


sp_rename 'term.AssignmentId', 'disciplineId', 'COLUMN';

insert into collective (collectiveCod, course , amountTime, studentsNum)
values ('ki4',2, 65, 23),
('pi50',2, 70, 26),
('pi51',2, 70, 15)

SELECT * FROM collective

insert into discipline (subjectName , category, total_hours  )
values ('math', 'technical ', 15),
('literature','humanitarian', 25),
('art','humanitarian', 25),
('algorythm','humanitarian', 30)

create table term(
controlType varchar(40),
teacherName varchar(60),
eventDate smalldatetime,
CollectiveId int FOREIGN KEY REFERENCES collective(CollectiveId),
AssignmentId int FOREIGN KEY REFERENCES discipline(disciplineId)
)

insert into term (controlType , teacherName, eventDate, CollectiveId, AssignmentId)
values 
('exam', 'Petro ', '1955-12-13 12:40:00', (select CollectiveId from collective where collectiveCod = 'ki4'),(select disciplineId from discipline where subjectName = 'art')),
('exam', 'Petro ', '1955-12-11 12:40:00', (select CollectiveId from collective where collectiveCod = 'ki4'), (select disciplineId from discipline where subjectName = 'literature')),
('exam','Mukola', '1955-12-13 12:40:00', (select CollectiveId from collective where collectiveCod = 'pi50'), (select disciplineId from discipline where subjectName = 'literature')),
('exam','Mucluha', '1955-12-13 10:40:00', (select CollectiveId from collective where collectiveCod = 'pi50'), (select disciplineId from discipline where subjectName = 'math')),
('exam','Eney', '1955-12-13 12:40:00', (select CollectiveId from collective where collectiveCod = 'pi51'), (select disciplineId from discipline where subjectName = 'algorythm'))



create view maxStudentsTeacher as -- 2 ім'я викладача, який взяв групу з максимальною кількістю студентів(пізніше, я зрозумів, що умова трохи інакша)
select teacherName from term where CollectiveId=(
select collectiveId from collective 
ORDER BY studentsNum desc
OFFSET 0 ROWS
fetch next 1 rows only
)
and controlType = 'exam'

select * from maxStudentsTeacher


SELECT * FROM dbo.collective
SELECT * FROM dbo.discipline
SELECT * FROM dbo.term

select collectiveId from collective 
ORDER BY studentsNum desc
OFFSET 0 ROWS
fetch next 1 rows only

SELECT collectiveCod, count(*) as NumOfExams FROM dbo.term -- 1 просто кількість іспитів
	join collective on collective.CollectiveId = term.CollectiveId
	Group by collectiveCod

SELECT collectiveCod, count(*) as NumOfExams, sum(total_hours) as totalHours FROM dbo.term -- 1 кількість іспитів + годин по всіх предметах
	join collective on collective.CollectiveId = term.CollectiveId
	join discipline on discipline.disciplineId = term.disciplineId
Group by collectiveCod
order by NumOfExams desc


create view teacherWithMax as
SELECT teacherName, sum(studentsNum) as AmountStudentAsAll FROM dbo.term  -- 2 ім'я викладача з кількістю студентів, які прийняв викладач за всю сесію
	join collective on collective.CollectiveId= term.CollectiveId 
where controlType = 'exam'
group by teacherName
ORDER BY sum(studentsNum) desc
OFFSET 0 ROWS
fetch next 1 rows only


select * from teacherWithMax

create View numOf as  -- з цього ходить скільки предметів з напрямів
SELECT collectiveCod,category, count(*) as numOfSub FROM term
	join collective on collective.CollectiveId = term.CollectiveId
	join discipline on discipline.disciplineId = term.disciplineId
where collectiveCod LIKE 'pi50'
group by  collectiveCod,category

with total as  -- розвязок відсотка на кожен напряму, для створення процедури, view треба буде замінити на весь код
    ( select sum(numOfSub)as total from numOf)
select numOf.category,
CAST(numOf.numOfSub AS float) / CAST(total.total AS float) * 100 as proc
from numOf, total


select t.collectiveCod, t.category, t.numOfSub,
case when t.category is not null then CAST(t.numOfSub AS float) / CAST(count(*) AS float)
end as pros

CREATE PROCEDURE GroupSubjectProc as
with allQuery as ( --   3 view не вийшло замінити просто так, вирішив, зробити так, за групу беру 'pi50'
SELECT collectiveCod,category, count(*) as numOfSub FROM term
	join collective on collective.CollectiveId = term.CollectiveId
	join discipline on discipline.disciplineId = term.disciplineId
where collectiveCod LIKE 'pi50'
group by  collectiveCod,category)
, total as
    ( select sum(allQuery.numOfSub)as total from allQuery)
select allQuery.category,
Cast(CAST(allQuery.numOfSub AS float) / CAST(total.total AS float) * 100 as varchar) + '%' as piece
from allQuery, total

exec GroupSubjectProc

create proc CheckSameDateGroup( @groupName varchar(10), -- 4 Іспити в один день, на вході назва групи, виході- кількість в один день та дата
@foo varchar(3) output,
@date varchar(12) output
) as
BEGIN
(select @foo=c.countOnDate, @date=c.ExamDate from (select controlType, CAST(eventDate as date) as ExamDate, collective.collectiveCod, count(term.CollectiveId) as countOnDate
from term join
			collective on collective.CollectiveId = term.CollectiveId
where collective.collectiveCod = @groupName
group by controlType,CAST(eventDate as date), collective.collectiveCod
having count(term.CollectiveId) > 1)c)
 print(coalesce((@foo + ' exams in the same day'),'No exams in the same day'))
 print(@date)
END

declare @examNum varchar(7)
declare @examdate varchar(7)
exec CheckSameDateGroup @groupName='pi50',
	@foo=@examNum output,
	@date=@examdate output

declare @examNum varchar(7)
declare @examdate varchar(7)
exec CheckSameDateGroup @groupName='ki4',
	@foo=@examNum output,
	@date=@examdate output

CREATE TRIGGER delDisc ON discipline after Delete as -- тригер, якщо видаляється дисципліна, вона видаляється й в іспитах, табл. term
declare @disc as varchar(10)
select @disc = disciplineId from deleted
BEGIN 
	delete term
	from term
	where disciplineId = @disc
END

select * from discipline
select * from term

ALTER TABLE dbo.term NOCHECK CONSTRAINT FK__term__Assignment__619B8048
delete from discipline where subjectName='math'
ALTER TABLE dbo.term CHECK CONSTRAINT FK__term__Assignment__619B8048