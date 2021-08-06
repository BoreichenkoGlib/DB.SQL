create database store_boreichenko

use store_boreichenko
go
--створюю таблицю товар
create table [goods](
id_goods int identity(1,1) not null,
primary key(id_goods),
name_goods varchar(50) not null,
code_by_goods int not null,
chenged_material varchar(50) not null
)
--створюю таблицю поставщик
create table [provider](
id_provider int identity(1,1) not null,
primary key (id_provider),
name_provider varchar(50) not null,
adress_provider varchar(50) not null,
phone_number decimal(10,0) not null,
AccountNumber decimal(10,0) not null
)
--створюю таблицю поставка
create table [delivery](
id_delivery int identity(1,1) not null,
id_goods int not null,
id_provider int not null,
counts int not null,
date_post date not null,
prices decimal(10,2) not null
foreign key (id_goods) references goods (id_goods),
foreign key (id_provider) references provider (id_provider)
)
--ввожу тестові записи в таблицю товари
insert into [goods] values 
('Coca-Cola',50,'л'),
('Roshen',15,'кг'),
('Mivina',2145,'кг');

--ввожу тестові записи в таблицю поставщик
insert into [provider] values
('Fora','Hlibna 21',0638459789,001),
('EKO','Kievska 24',0638459789,001),
('Kwara','Chudnivska',0638459789,001),
('Dastore','Olzicha 85/a',0984575569,002);

--ввожу тестові записи в таблию поставка
insert into [delivery] values
(3,1,10,'2020-12-14',24.99),
(1,1,20,'2020-12-14',89.99),
(2,1,15,'2020/12/14',14.99),
(3,2,40,'2020/12/14',17.99);

--створюю кластерний і некластерний індекси
create clustered index ClusInd on delivery(id_delivery)
create nonclustered index NonClusInd1 on delivery(id_goods)

--вивожу індекси
select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS

--імпортувати список товарів
use store_boreichenko
select * from goods

--створюю 3 користувачів
create login head with password = '1111'
create login manager with password = '111'
create login storekeeper with password = '11'

use store_boreichenko
create user head for login head
create user manager for login manager
create user storekeeper for login storekeeper

--ролі в БД
alter role db_backupoperator add member head
exec sp_helprolemember
alter role db_backupoperator add member manager
exec sp_helprolemember
alter role db_backupoperator add member storekeeper
exec sp_helprolemember

USE [store_boreichenko]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [head]
GO
USE [store_boreichenko]
GO
ALTER ROLE [db_datareader] ADD MEMBER [head]
GO
USE [store_boreichenko]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [head]
GO
USE [store_boreichenko]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [head]
GO
USE [store_boreichenko]
GO
ALTER ROLE [db_denydatareader] ADD MEMBER [head]
GO
USE [store_boreichenko]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [head]
GO
USE [store_boreichenko]
GO
ALTER ROLE [db_owner] ADD MEMBER [head]
GO

--новая роль БД
create role head_role authorization db_ddladmin
create role manager_role authorization db_ddladmin
create role storekeeper_role authorization db_ddladmin
alter role db_ddladmin add member head
alter role db_ddladmin drop member head
alter role db_ddladmin add member storekeeper
alter role db_ddladmin drop member storekeeper

--разрешения для роли
grant select to head_role
grant select to manager_role
grant select to storekeeper_role

--разрешения для пользователя
grant select to head
grant select to manager
grant select to storekeeper
revoke insert to head
deny delete to manager
deny delete to storekeeper

--backup_full_db_with_log
BACKUP DATABASE store_boreichenko
TO DISK = 'D:\store_boreichenko_full.bak' WITH INIT, NAME = 'boreichenko Full Db backup',
DESCRIPTION = 'Store Full Database Backup'

BACKUP LOG store_boreichenko
TO DISK = 'D:\store_boreichenko_log.bak' WITH NOINIT, NAME = 'boreichenko Translog backup',
DESCRIPTION = 'Store Transaction Log Backup', NOFORMAT

-- Відновлення Бази даних (за допомогою резервної копії)
RESTORE DATABASE store_boreichenko
FROM DISK = 'D:\store_boreichenko_full.bak' WITH RECOVERY, REPLACE

--restore_full_log
RESTORE LOG store_boreichenko
FROM DISK = 'E:\TSQL\store_boreichenko_log.bak' WITH NORECOVERY

