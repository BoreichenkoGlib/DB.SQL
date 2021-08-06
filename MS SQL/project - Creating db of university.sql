drop database db_university

create database db_university

use master
use db_university

create table students (
id_stud int not null primary key,
stud_name varchar(50) not null,
stud_birth date,
id_faculty int foreign key references Faculties(id_facult),
id_spec int foreign key references Specialities(id_spec),
id_group int foreign key references Groups(id_group),
stud_cours int not null,
)

 

create table Groups(
id_group int not null primary key,
group_name varchar(50),
--id_stud int foreign key references students(id_stud),
id_faculty int foreign key references Faculties(id_facult),
)

alter table Groups add id_stud int
alter table Groups add foreign key (id_stud) references students(id_stud)  

create table proffesors(
id_prof int not null primary key,
prof_name varchar(50),
id_caff int foreign key references caffedra(id_caff),
prof_vacancy varchar(40),
)


create table schedule(
id_sched int not null primary key,
time_less time,
id_discipline int foreign key references discipline(id_discipline),
id_prof int foreign key references proffesors(id_prof),
id_room int foreign key references class_room(id_room),
id_group int foreign key references Groups(id_group),
)



create table Faculties(
id_facult int not null primary key,
name_facult varchar(50) not null,
)

create table Specialities(
id_spec int not null primary key,
name_spec varchar(50) not null,
)

create table class_room(
id_room int not null primary key,
num_room varchar(50) not null,
is_avaliable int,
)


create table discipline(
id_discipline int not null primary key,
name_discipline varchar(50) not null,
)

create table caffedra(
id_caff int not null primary key,
name_caff varchar(50) not null,
)

insert into Faculties (id_facult, name_facult) values 
('1', 'FIKT'),
('2', 'GEF'),
('3', 'FIM')

select * from Faculties

insert into Groups (id_group, group_name, id_faculty) values
('123', 'Computer engeniers', '1'),
('121', 'Programmers','1'),
('126', 'System administrator','3')

select * from Groups

select Groups.id_group, Groups.group_name, Faculties.name_facult
from Groups join Faculties ON Faculties.id_facult = Groups.id_faculty

insert into caffedra(id_caff, name_caff) values 
('1', 'Highest Mathematics'),
('2', 'Phisics'),
('3', 'Computer engenire and cyber security')

insert into discipline(id_discipline, name_discipline) values 
('1', 'Logic Mathematics'),
('2', 'Phisics'),
('3', 'OO Programing')

insert into class_room(id_room, num_room, is_avaliable) values 
('1', '101', 1),
('2', '224', 1),
('3', '332', 1)

insert into Specialities(id_spec, name_spec) values 
('123', 'Computer engeniers'),
('121', 'Program engeniers'),
('126', 'System engeniers')


insert into proffesors(id_prof,prof_name,prof_vacancy,id_caff) values 
('11', 'Efimenko Andriy Anatoliyovich','Head of cafedra',3),
('12', 'Morozov Andiy Vasylovich', 'Prorector',3),
('13', 'Sugonyak Inna Ivanivna', 'Head of cafedra',3)
/*
create table students (
id_stud int not null primary key,
stud_name varchar(50) not null,
stud_birth date,
id_faculty int foreign key references Faculties(id_facult),
id_spec int foreign key references Specialities(id_spec),
id_group int foreign key references Groups(id_group),
stud_cours int not null,
)
*/

insert into students(id_stud,stud_name,stud_birth,id_faculty,id_spec,id_group,stud_cours) values 
('69', 'Biloshytskiy Roman','2000/03/08','1','123','123', '3'),
('43', 'Voinalovich Vlad','1999/02/01','1','123','123', '3'),
('13', 'Liminovich Ivan','1998/12/12','1','123','123', '3')

select * from students

insert into schedule(id_sched,time_less,id_discipline,id_prof,id_group,id_room) values 
('1', '8:30:00','1','13','123','1'),
('2', '10:00:00','2','11','123','2'),
('3', '11:40:00','3','12','123','1')


--select * from students

create view ShowScheduleAllGroups AS 
		select 
		schedule.time_less AS Times, 
		discipline.name_discipline AS Discipline,
		proffesors.prof_name AS Professor,
		Groups.group_name AS Groups,
		class_room.num_room AS Auditory
		from discipline inner join schedule on 
		schedule.id_discipline = discipline.id_discipline
						inner join proffesors on 
						proffesors.id_prof = schedule.id_prof
						inner join Groups on 
						Groups.id_group = schedule.id_group
						inner join class_room on 
						class_room.id_room = schedule.id_room

						select * from ShowScheduleAllGroups

						drop view ShowStudentsByGroup

create view ShowStudentsByGroup AS select
		students.stud_name as student,
		Faculties.name_facult as faculty,
		students.stud_cours as cours,
		Groups.group_name as Groups
			from Groups 
			 join students on 
			 students.id_group = Groups.id_group
			 join Faculties on 
			 Faculties.id_facult = students.id_faculty where 
			 (Groups.group_name = 'Computer engeniers')


select * from ShowStudentsByGroup

create nonclustered index ix_Student_id on students(id_stud)
create nonclustered index ix_Student_name on students(stud_name)
create nonclustered index ix_Schedule_time on Schedule(time_less)




select index_type_desc,  page_count,
record_count, avg_page_space_used_in_percent, avg_fragment_size_in_pages
from sys.dm_db_index_physical_stats
(db_id(N'db_university'), OBJECT_ID(N'students'), Null, Null, 'Detailed')

select index_type_desc,  page_count,
record_count, avg_page_space_used_in_percent, avg_fragment_size_in_pages
from sys.dm_db_index_physical_stats
(db_id(N'db_university'), OBJECT_ID(N'schedule'), Null, Null, 'Detailed')

alter index all on students reorganize
alter index all on students rebuild with (fillfactor = 80, sort_in_tempdb = on, statistics_norecompute = on)
alter index all on Schedule reorganize
alter index all on Schedule rebuild with (fillfactor = 80, sort_in_tempdb = on, statistics_norecompute = on)

select index_type_desc, avg_fragment_size_in_pages, avg_fragmentation_in_percent
from sys.dm_db_index_physical_stats (db_id(N'db_university'), OBJECT_ID(N'students'), Null, Null, 'Detailed')
select index_type_desc, avg_fragment_size_in_pages, avg_fragmentation_in_percent
from sys.dm_db_index_physical_stats (db_id(N'db_university'), OBJECT_ID(N'schedule'), Null, Null, 'Detailed')



CREATE TABLE BackupError (
    db SYSNAME PRIMARY KEY,
    dt DATETIME NOT NULL DEFAULT GETDATE(),
    msg NVARCHAR(2048)
)

declare @path NVARCHAR(MAX)
set @path = 'E:\' + 'db_university' + CONVERT(CHAR(8), GETDATE(), 112) + '.bak'
backup database db_university to disk = @path with differential,
NOFORMAT, NOINIT, NAME = 'db_university Backup', SKIP, NOREWIND, NOUNLOAD, STATS = 10 

create role Student
create role Proffesor
create role Adminer

grant select, update, delete, insert on schedule to Adminer 
grant select, update, insert on schedule to Adminer, Proffesor
grant select, insert on schedule to Student

select * from sysusers


create login Stud_1 with password = '1'
create user Stud_1 for login Stud_1
alter role Student add member Stud_1

create login Stud_2 with password = '2'
create user Stud_2 for login Stud_2
alter role Adminer add member Stud_2

execute as user = 'Stud_1'
select * from schedule
go
delete from schedule where id_sched = 1



create symmetric key sym_key_1
with algorithm = aes_256
encryption by password = 'adminer'

/*copy table*/
select *	
into proff_copy
from proffesors
where 1 <> 1;

/*oprn key*/
open symmetric key sym_key_1 decryption by 
password = 'adminer'
/*shifr */

select * from proff_copy
select * from proffesors

insert into proff_copy
values
('11', EncryptByKey(Key_GUID('sym_key_1'),convert(nvarchar(50), 'Efimenko Andriy Anatoliyovich')),'3','3')
/*Розшифрування */ 
SELECT Convert(nvarchar(50), DecryptByKey(prof_name))
FROM proff_copy

alter table proff_copy alter column prof_name varchar(MAX)

 
