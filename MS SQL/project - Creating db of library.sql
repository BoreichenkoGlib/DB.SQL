--��������� ���� ����� ��������
create database db_library

use db_library

--��������� ������� "����������"
create table Faculties(
id_facult int not null primary key,
name_facult varchar(50) not null,
)

--��������� ������� "������������"
create table Specialities(
id_spec int not null primary key,
name_spec varchar(50) not null,
)

--��������� ������� "����������� ��������"
create table library_staff(
id_staff int not null primary key,
name_staff varchar(50) not null,
)

--��������� ������� "�����"
create table books(
id_book int not null primary key,
name_book varchar(50) not null,
name_author varchar(50) not null,
year_publication date,
kilkist_of_book int not null,
)

--��������� ������� "�������"
create table caffedra(
id_caff int not null primary key,
name_caff varchar(50) not null,
)

 --��������� ������� "�����"
create table Groups(
id_group int not null primary key,
group_name varchar(50),
id_faculty int foreign key references Faculties(id_facult),
)

--��������� ������� "��������"
create table students (
id_stud int not null primary key,
stud_name varchar(50) not null,
stud_birth date,
id_faculty int foreign key references Faculties(id_facult),
id_spec int foreign key references Specialities(id_spec),
id_group int foreign key references Groups(id_group),
stud_cours int not null,
)

--��������� ������� "���������"
create table proffesors(
id_prof int not null primary key,
prof_name varchar(50),
id_caff int foreign key references caffedra(id_caff),
)

--��������� ������� "������� ����"
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

--������� ������ ������
insert into Faculties (id_facult, name_facult) values 
('1', '��������� ����������-������������ ���������'),
('2', '��������� ������������-����������� ���������'),
('3', '��������� ������ �� ����� ��������������'),
('4', '�i�����-������i���� ���������'),
('5', '��������� ��������� ��������� �� �����')

select * from Faculties

insert into Groups (id_group, group_name, id_faculty) values
('121', '�������� ����������� ������������', '2'),
('122', '��������� �����','2'),
('123', '���������� ��������','2'),
('125', 'ʳ����������','2'),
('126', '����������� ������� �� �������㳿','2'),
('163', '���������� ��������','2'),
('172', '�������������� �� ����������','1'),
('131', '��������� �������','1'),
('133', '�������� ���������������','1'),
('152', '���������','1'),
('71', '���� � �������������','3'),
('51', '��������','3'),
('73', '����������','3'),
('101', '�������','4'),
('184', 'ó�������','4'),
('183', '������ ����������','4'),
('81', '�����','5'),
('35', 'Գ������','5'),
('281', '������� ���������','5')

select * from Groups

--������ ��� ������ �� ����� �� ���� ���������� ��������
select Groups.id_group, Groups.group_name, Faculties.name_facult
from Groups join Faculties ON Faculties.id_facult = Groups.id_faculty

insert into caffedra(id_caff, name_caff) values 
('1', '������� ��������� �������'),
('2', '������� ���������� �������㳿'),
('3', '������� ������ �� ���� ����������'),
('4', '������� ���������� ���������������'),
('5', '������� ������� ����������� ������������'),
('6', '������� ��������� ������� �� ��������������'),
('7', '������� ���������� ������� �� �����������'),
('8', '������� �������� �������'),
('9', '������� ����������'),
('10', '������� �����㳿'),
('11', '������� ��������� ���������'),
('12', '������� ��������� �������'),
('13', '������� �����'),
('14', '������� ���������'),
('15', '������� �������㳿')

select * from caffedra

insert into books(id_book, name_book, name_author, year_publication, kilkist_of_book) values 
('1', 'CASE-����������',							'�������',		'1993', '2'),
('2', '����������� ������ ������',					'�������',		'2001', '1'),
('3', '���������� �������������',					'��������',		'2006', '4'),
('4', '�������� � ������� ��� ������',				'���������',	'1993', '6'),
('5', '���������������� ��� ������ Delphi',			'�������',		'2006', '8'),
('6', '���� ������',								'��������',		'2010', '3'),
('7', '������������� ���������',					'��������',		'2001', '4'),
('8', '����������� � ���������� ��������',			'�������',		'2016', '7'),
('9', 'C���������',									'�������',		'2011', '3'),
('10', '������������ ��������',						'������',		'1993', '7'),
('11', '���������� ������ ������� ������',			'����',			'2012', '3'),
('12', '����������� ��������� ������',				'�������',		'2006', '8'),
('13', '������������� � ����������',				'�������',		'2001', '2'),
('14', '����������� ������� � ��������������',		'��������',		'2013', '7'),
('15', '���������� ������� ����������� ������',		'���������',	'1993', '9'),
('16', 'IDEF-����������',							'�������',		'2018', '2'),
('17', '������ � ��������������',					'�������',		'2019', '3'),
('18', '��������-��������������� ����������',		'���������',	'2001', '8'),
('19', '������ ������������',						'�������',		'2020', '3'),
('20', 'Access 2002',								'���������',	'1993', '8'),
('21', '������� � ����������',						'�������',		'2021', '6'),
('22', '������ � ������',							'��������',		'2006', '8'),
('23', '����������������� ���� ��������',			'���������',	'2001', '7'),
('24', 'SQL',										'�������',		'2011', '9')

select * from books

insert into library_staff(id_staff, name_staff) values 
('1', '������ ����� ���������'),
('2', 'ϳ������� ������� ��������'),
('3', '�������� ������� ����������'),
('4', '����� �������� �������'),
('5', '���������� ������ ���������'),
('6', '�������� ������ ���������')

select * from library_staff

insert into Specialities(id_spec, name_spec) values 
('121', '�������� ����������� ������������'),
('122', '��������� �����'),
('123', '���������� ��������'),
('125', 'ʳ����������'),
('126', '����������� ������� �� �������㳿'),
('163', '���������� ��������'),
('172', '�������������� �� ����������'),
('131', '��������� �������'),
('133', '�������� ���������������'),
('152', '���������'),
('71', '���� � �������������'),
('51', '��������'),
('73', '����������'),
('101', '�������'),
('184', 'ó�������'),
('183', '������ ����������'),
('81', '�����'),
('35', 'Գ������'),
('281', '������� ���������')

select * from Specialities

insert into proffesors(id_prof, prof_name, id_caff) values 
('1',	'��������� ���� ��������',			1),
('2',	'������������ ³���� ��������',		2),
('3',	'ѳ������ ������ �������',			3),
('4',	'�������� ������ ��������',		4),
('5',	'�������� �������� �����������',	5),
('6',	'������ ������� ��������',			6),
('7',	'���������� ������ ���������',	7),
('8',	'������� ������� ��������',		8),
('9',	'������ ����� ����������',			9),
('10',	'������� ������ �������',			10),
('11',	'������ �������� ��������',			11)

select * from proffesors

insert into students(id_stud,stud_name,stud_birth,id_faculty,id_spec,id_group,stud_cours) values 
('1', '������� ���� ³��������',			'2001/01/08','1','121','121', '2'),
('2', '������ ���� �����������',			'1999/02/01','2','122','122', '3'),
('3', '������ �������� ���������',			'1998/03/12','3','123','123', '3'),
('4', '�������������� ��� �������������',	'2000/04/08','4','125','125', '4'),
('5', '���������� ��� ���������',			'1999/05/01','5','126','126', '3'),
('6', '����� ���� ����������',				'1998/06/12','1','123','123', '2'),
('7', '������ ���� ������',					'2001/07/08','2','123','123', '3'),
('8', '������������ ����� ����������',		'1999/09/01','3','123','123', '3'),
('9', '������� �������� ���������',			'1998/12/12','4','123','123', '3')

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

--��������� ��� ������� ��������� � ��� �����---------------------- 
SELECT @@Servername AS ServerName ,
TABLE_CATALOG ,
TABLE_SCHEMA ,
TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME ;

--��������� ������������, ��������------------------------------------
--�������� �������� ���� (ID_�����, �����, �������, �����, ���������)
use db_library
go
create view ShowCatalog AS 
		select 
		catalog_book_distribution.id_giving AS ID_�����, 
		books.name_book AS �����_�����,
		students.stud_name AS �������,
		Groups.group_name AS �����,
		library_staff.name_staff AS ���_����������
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

--�������� ��'� �������� ��������� �� ���� �� ������� ������-----------------
use db_library
go
create view ShowStudentsByGroup AS select
		students.stud_name as �������,
		Faculties.name_facult as ���������,
		students.stud_cours as ����,
		Groups.group_name as �����
			from Groups 
			 join students on 
			 students.id_group = Groups.id_group
			 join Faculties on 
			 Faculties.id_facult = students.id_faculty where 
			 (Groups.group_name = '���������� ��������')
go

select * from ShowStudentsByGroup

--��������� ��� ������������ ��������� � ��� �����--------------------------
SELECT @@Servername AS ServerName ,
DB_NAME() AS DBName ,
Name AS ViewName ,
create_date
FROM sys.Views
ORDER BY Name

--��������� ������� �� ���������� ��������������----------------------------------
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

--��������� ����� �� �������������� ��������� ����---------------------------------
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

--��������� �����----------------------------------------------------------------
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

--��������� ����� ��� ���
exec sp_helprole

--��������� �����, �����������, ��������� ����������� �� ���---------------------
use db_library

create login ������ with password = '34652734'
create user ������ for login ������
alter role Librarian add member ������

create login ϳ������� with password = '2836746'
create user ϳ������� for login ϳ�������
alter role Librarian add member ϳ�������

create login �������� with password = '7627864'
create user �������� for login ��������
alter role Librarian add member ��������

create login ����� with password = '7386478'
create user ����� for login �����
alter role Librarian add member �����

create login ���������� with password = '7489724'
create user ���������� for login ����������
alter role Librarian add member ����������

create login �������� with password = '5435469'
create user �������� for login ��������
alter role Librarian add member ��������

create login ���������� with password = '878654'
create user ���������� for login ����������
alter role Adminer add member ����������

--��������� ������ ��� ������������ � ��
EXEC sp_helpuser

--��������� ����� ��� ����� ������������
SELECT name,type_desc FROM sys.sql_logins

--����������--------------------------------------------------------------------
create symmetric key sym_key_1
with algorithm = aes_256
encryption by password = 'admin'

open symmetric key sym_key_1 decryption by password = 'admin'

select name_staff from library_staff

select EncryptByKey(Key_GUID('sym_key_1'), convert(varchar(50),name_staff))name_staff
into library_staff_copy from library_staff

select * from library_staff_copy
select * from library_staff
--�������������---------------------------------------------------------------------
SELECT Convert(varchar(50), DecryptByKey(name_staff))
FROM library_staff_copy

alter table library_staff_copy alter column name_staff varchar(MAX)