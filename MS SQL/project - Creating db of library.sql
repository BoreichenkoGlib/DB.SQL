create database db_library

use db_library

create table Faculties(
id_facult int not null primary key,
name_facult varchar(50) not null,
)

create table Specialities(
id_spec int not null primary key,
name_spec varchar(50) not null,
)

create table library_staff(
id_staff int not null primary key,
name_staff varchar(50) not null,
)

create table books(
id_book int not null primary key,
name_book varchar(50) not null,
name_author varchar(50) not null,
year_publication date,
kilkist_of_book int not null,
)

create table caffedra(
id_caff int not null primary key,
name_caff varchar(50) not null,
)

create table Groups(
id_group int not null primary key,
group_name varchar(50),
id_faculty int foreign key references Faculties(id_facult),
)

create table students (
id_stud int not null primary key,
stud_name varchar(50) not null,
stud_birth date,
id_faculty int foreign key references Faculties(id_facult),
id_spec int foreign key references Specialities(id_spec),
id_group int foreign key references Groups(id_group),
stud_cours int not null,
)

create table proffesors(
id_prof int not null primary key,
prof_name varchar(50),
id_caff int foreign key references caffedra(id_caff),
)

create table catalog_book_distribution(
id_giving int not null primary key,
id_book int foreign key references books(id_book),
id_prof int foreign key references proffesors(id_prof),
id_stud int foreign key references students(id_stud),
id_group int foreign key references Groups(id_group),
id_staff int foreign key references library_staff(id_staff),
data_give date,
data_return date,
)

insert into Faculties (id_facult, name_facult) values 
('1', 'Факультет компютерно-інтегрованих технологій'),
('2', 'Факультет інформаційно-компютерних технологій'),
('3', 'Факультет бізнесу та сфери обслуговування'),
('4', 'Гiрничо-екологiчний факультет'),
('5', 'Факультет публічного управління та права')

select * from Faculties

insert into Groups (id_group, group_name, id_faculty) values
('121', 'Інженерія програмного забезпечення', '2'),
('122', 'Компютерні науки','2'),
('123', 'Комп’ютерна інженерія','2'),
('125', 'Кібербезпека','2'),
('126', 'Інформаційні системи та технології','2'),
('163', 'Біомедична інженерія','2'),
('172', 'Телекомунікації та радіотехніка','1'),
('131', 'Прикладна механіка','1'),
('133', 'Галузеве машинобудування','1'),
('152', 'Метрологія','1'),
('71', 'Облік і оподаткування','3'),
('51', 'Економіка','3'),
('73', 'Менеджмент','3'),
('101', 'Екологія','4'),
('184', 'Гірництво','4'),
('183', 'Захист середовища','4'),
('81', 'Право','5'),
('35', 'Філологія','5'),
('281', 'Публічне управління','5')

select * from Groups

--вибірка яка показує які групи до яких факультетів належать
select Groups.id_group, Groups.group_name, Faculties.name_facult
from Groups join Faculties ON Faculties.id_facult = Groups.id_faculty

insert into caffedra(id_caff, name_caff) values 
('1', 'Кафедра прикладної механіки'),
('2', 'Кафедра транспортні технології'),
('3', 'Кафедра фізики та вищої математики'),
('4', 'Кафедра галузевого машинобудування'),
('5', 'Кафедра інженерії програмного забезпечення'),
('6', 'Кафедра біомедичної інженерії та телекомунікації'),
('7', 'Кафедра комп’ютерної інженерії та кібербезпеки'),
('8', 'Кафедра розробки родовищ'),
('9', 'Кафедра маркшейдерії'),
('10', 'Кафедра екології'),
('11', 'Кафедра фізичного виховання'),
('12', 'Кафедра економічної безпеки'),
('13', 'Кафедра права'),
('14', 'Кафедра лінгвістики'),
('15', 'Кафедра психології')

select * from caffedra

insert into books(id_book, name_book, name_author, year_publication, kilkist_of_book) values 
('1', 'CASE-технологии',							'Вендров',		'1993', '2'),
('2', 'Структурный анализ систем',					'Семенов',		'2001', '1'),
('3', 'Визуальное моделирование',					'Кватрани',		'2006', '4'),
('4', 'Введение в системы баз данных',				'Новоженов',	'1993', '6'),
('5', 'Программирование баз данных Delphi',			'Вендров',		'2006', '8'),
('6', 'Базы данных',								'МакГоуэн',		'2010', '3'),
('7', 'Искусственный интеллект',					'Кватрани',		'2001', '4'),
('8', 'Программные и аппаратные средства',			'Вендров',		'2016', '7'),
('9', 'Cправочник',									'Семенов',		'2011', '3'),
('10', 'Исследование множеств',						'Чкалов',		'1993', '7'),
('11', 'Разработка метода сложных систем',			'Дейт',			'2012', '3'),
('12', 'Структурный системный анализ',				'Семенов',		'2006', '8'),
('13', 'Автоматизация и применение',				'Вендров',		'2001', '2'),
('14', 'Методология анализа и проектирования',		'Глущенко',		'2013', '7'),
('15', 'Разработка сложных программных систем',		'Поспелова',	'1993', '9'),
('16', 'IDEF-технологии',							'Вендров',		'2018', '2'),
('17', 'Анализ и проектирование',					'Фаронов',		'2019', '3'),
('18', 'Объектно-ориентированные технологии',		'Поспелова',	'2001', '8'),
('19', 'Библия пользователя',						'Семенов',		'2020', '3'),
('20', 'Access 2002',								'Новоженов',	'1993', '8'),
('21', 'Финансы и статистика',						'Вендров',		'2021', '6'),
('22', 'Модели и методы',							'МакГоуэн',		'2006', '8'),
('23', 'Структуризованный язык запросов',			'Поспелова',	'2001', '7'),
('24', 'SQL',										'Семенов',		'2011', '9')

select * from books

insert into library_staff(id_staff, name_staff) values 
('1', 'Курбас Шаміль Федорович'),
('2', 'Піддубний Амвросій Азарович'),
('3', 'Городнюк Ратибор Омелянович'),
('4', 'Хомич Миролюба Юхимівна'),
('5', 'Коломацька Рузалія Чеславівна'),
('6', 'Поточняк Аріадна Драганівна')

select * from library_staff

insert into Specialities(id_spec, name_spec) values 
('121', 'Інженерія програмного забезпечення'),
('122', 'Компютерні науки'),
('123', 'Комп’ютерна інженерія'),
('125', 'Кібербезпека'),
('126', 'Інформаційні системи та технології'),
('163', 'Біомедична інженерія'),
('172', 'Телекомунікації та радіотехніка'),
('131', 'Прикладна механіка'),
('133', 'Галузеве машинобудування'),
('152', 'Метрологія'),
('71', 'Облік і оподаткування'),
('51', 'Економіка'),
('73', 'Менеджмент'),
('101', 'Екологія'),
('184', 'Гірництво'),
('183', 'Захист середовища'),
('81', 'Право'),
('35', 'Філологія'),
('281', 'Публічне управління')

select * from Specialities

insert into proffesors(id_prof, prof_name, id_caff) values 
('1',	'Колесників Чара Азарович',			1),
('2',	'Маньковський Віктор Іванович',		2),
('3',	'Сірченко Щазина Іванівна',			3),
('4',	'Демчишин Шушана Полянівна',		4),
('5',	'Кухарчук Єпистима Валентинівна',	5),
('6',	'Петрик Збоїслав Златович',			6),
('7',	'Самсоненко Юліанна Русланівна',	7),
('8',	'Мазаракі Будимир Олегович',		8),
('9',	'Вишняк Текля Герасимівна',			9),
('10',	'Борачок Йовілла Фролівна',			10),
('11',	'Дергач Радомисл Жданович',			11)

select * from proffesors

insert into students(id_stud,stud_name,stud_birth,id_faculty,id_spec,id_group,stud_cours) values 
('1', 'Парубок Ілля Вікторович',			'2001/01/08','1','121','121', '2'),
('2', 'Довбуш Надій Соломонович',			'1999/02/01','2','122','122', '3'),
('3', 'Смаглій Живослав Йосипович',			'1998/03/12','3','123','123', '3'),
('4', 'Остроградський Гліб Ростиславович',	'2000/04/08','4','125','125', '4'),
('5', 'Бродацький Щек Пилипович',			'1999/05/01','5','126','126', '3'),
('6', 'Фещак Федір Драганович',				'1998/06/12','1','123','123', '2'),
('7', 'Грицай Юхим Янович',					'2001/07/08','2','123','123', '3'),
('8', 'Скрипниченко Панас Драганович',		'1999/09/01','3','123','123', '3'),
('9', 'Дмитрик Гатуслав Йосипович',			'1998/12/12','4','123','123', '3')

select * from students

insert into catalog_book_distribution(id_giving,id_book,id_prof, id_group, id_stud,id_staff,data_give,data_return) values 
('1','3','3', '121','1','1','2021/03/01','2021/03/10'),
('2','4','6', '122','2','1','2021/03/02','2021/03/11'),
('3','3','2', '123','3','1','2021/03/03','2021/03/12'),
('4','6','8', '125','4','2','2021/03/04','2021/03/13'),
('5','2','3', '126','5','2','2021/03/05','2021/03/14'),
('6','1','8', '163','6','2','2021/03/06','2021/03/15'),
('7','5','3', '172','7','2','2021/03/07','2021/03/16'),
('8','8','5', '51','8','2','2021/03/08','2021/03/17'),
('9','9','9', '73','9','1','2021/03/09','2021/03/18')

select * from catalog_book_distribution

--виведення всіх таблиць створених у базі даних---------------------- 
SELECT @@Servername AS ServerName ,
TABLE_CATALOG ,
TABLE_SCHEMA ,
TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME ;

--створення представлень, процедур------------------------------------
--перегляд каталогу книг (ID_книги, назва, студент, група, бібліотекар)
use db_library
go
create view ShowCatalog AS 
		select 
		catalog_book_distribution.id_giving AS ID_книги, 
		books.name_book AS Назва_книги,
		students.stud_name AS Студент,
		Groups.group_name AS Група,
		library_staff.name_staff AS Імя_бібліотекаря
		from books inner join catalog_book_distribution on 
		catalog_book_distribution.id_book = books.id_book
						inner join students on 
						students.id_stud = catalog_book_distribution.id_stud
						inner join Groups on 
						Groups.id_group = catalog_book_distribution.id_group
						inner join library_staff on 
						library_staff.id_staff = catalog_book_distribution.id_staff
go
select * from ShowCatalog

--drop view ShowCatalog

--викодить ім'я студента факультет та курс за обраною групою-----------------
use db_library
go
create view ShowStudentsByGroup AS select
		students.stud_name as Студент,
		Faculties.name_facult as Факультет,
		students.stud_cours as Курс,
		Groups.group_name as Група
			from Groups 
			 join students on 
			 students.id_group = Groups.id_group
			 join Faculties on 
			 Faculties.id_facult = students.id_faculty where 
			 (Groups.group_name = 'Комп’ютерна інженерія')
go

select * from ShowStudentsByGroup

--виведення всіх представлень створених у базі даних--------------------------
SELECT @@Servername AS ServerName ,
DB_NAME() AS DBName ,
Name AS ViewName ,
create_date
FROM sys.Views
ORDER BY Name

--створення індексів та проведення дефрагментації----------------------------------
create nonclustered index ix_Student_id on students(id_stud)
create nonclustered index ix_Student_name on students(stud_name)
create nonclustered index ix_Catalog_id on catalog_book_distribution(id_giving)

select index_type_desc,  page_count,
record_count, avg_page_space_used_in_percent, avg_fragment_size_in_pages
from sys.dm_db_index_physical_stats
(db_id(N'db_library'), OBJECT_ID(N'students'), Null, Null, 'Detailed')

select index_type_desc,  page_count,
record_count, avg_page_space_used_in_percent, avg_fragment_size_in_pages
from sys.dm_db_index_physical_stats
(db_id(N'db_library'), OBJECT_ID(N'catalog_book_distribution'), Null, Null, 'Detailed')

alter index all on students reorganize
alter index all on students rebuild with (fillfactor = 80, sort_in_tempdb = on, statistics_norecompute = on)
alter index all on catalog_book_distribution reorganize
alter index all on catalog_book_distribution rebuild with (fillfactor = 80, sort_in_tempdb = on, statistics_norecompute = on)

select index_type_desc, avg_fragment_size_in_pages, avg_fragmentation_in_percent
from sys.dm_db_index_physical_stats (db_id(N'db_library'), OBJECT_ID(N'students'), Null, Null, 'Detailed')
select index_type_desc, avg_fragment_size_in_pages, avg_fragmentation_in_percent
from sys.dm_db_index_physical_stats (db_id(N'db_library'), OBJECT_ID(N'catalog_book_distribution'), Null, Null, 'Detailed')

--створення повної та диференціальної резервних копій---------------------------------
declare @path NVARCHAR(MAX)
set @path = 'D:\db_library.bak'

backup database db_library
to disk = @path with init, 
name = 'library Full Backup',
description = 'library Full Backup'

backup database db_library 
to disk = @path with differential,
NOFORMAT, NOINIT, NAME = 'db_library Backup', SKIP, NOREWIND, NOUNLOAD, STATS = 10;
----------------------------------------------------------------------------------
declare @path_restore NVARCHAR(MAX)
set @path_restore = 'D:\db_library.bak'

restore database db_library
from disk = @path_restore
with recovery, replace;

--створення ролей----------------------------------------------------------------
use db_library

create role Librarian
create role Adminer

grant select, update, delete, insert on catalog_book_distribution to Adminer
grant select, insert on catalog_book_distribution to Librarian

grant select, update, delete, insert on books to Adminer
grant select, insert on books to Librarian

grant select, update, delete, insert on caffedra to Adminer
grant select, insert on caffedra to Librarian

grant select, update, delete, insert on Faculties to Adminer
grant select, insert on Faculties to Librarian

grant select, update, delete, insert on Groups to Adminer
grant select, insert on Groups to Librarian

grant select, update, delete, insert on library_staff to Adminer
grant select on library_staff to Librarian

grant select, update, delete, insert on proffesors to Adminer
grant select, insert on proffesors to Librarian

grant select, update, delete, insert on Specialities to Adminer
grant select, insert on Specialities to Librarian

grant select, update, delete, insert on students to Adminer
grant select, insert on students to Librarian

--drop role Librarian
--drop role Adminer

--виведення даних про ролі
exec sp_helprole

--створення логіну, користувача, додавання користувача до ролі---------------------
use db_library

create login Курбас with password = '34652734'
create user Курбас for login Курбас
alter role Librarian add member Курбас

create login Піддубний with password = '2836746'
create user Піддубний for login Піддубний
alter role Librarian add member Піддубний

create login Городнюк with password = '7627864'
create user Городнюк for login Городнюк
alter role Librarian add member Городнюк

create login Хомич with password = '7386478'
create user Хомич for login Хомич
alter role Librarian add member Хомич

create login Коломацька with password = '7489724'
create user Коломацька for login Коломацька
alter role Librarian add member Коломацька

create login Поточняк with password = '5435469'
create user Поточняк for login Поточняк
alter role Librarian add member Поточняк

create login Борейченко with password = '878654'
create user Борейченко for login Борейченко
alter role Adminer add member Борейченко

--виведення данних про користувачів в БД
EXEC sp_helpuser

--виведення даних про логіни користувачів
SELECT name,type_desc FROM sys.sql_logins

--шифрування--------------------------------------------------------------------
create symmetric key sym_key_1
with algorithm = aes_256
encryption by password = 'admin'

open symmetric key sym_key_1 decryption by password = 'admin'

select name_staff from library_staff

select EncryptByKey(Key_GUID('sym_key_1'), convert(varchar(50),name_staff))name_staff
into library_staff_copy from library_staff

select * from library_staff_copy
select * from library_staff
--Розшифрування---------------------------------------------------------------------
SELECT Convert(varchar(50), DecryptByKey(name_staff))
FROM library_staff_copy

alter table library_staff_copy alter column name_staff varchar(MAX)