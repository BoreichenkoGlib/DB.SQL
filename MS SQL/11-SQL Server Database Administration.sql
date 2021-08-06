create login login1 with password = 'boreichenko-glib'
use kontrolna_1
create user login1 for login login1

--роли БД
alter role db_backupoperator add member login1
exec sp_helprolemember

--новая роль БД
create role role1 authorization db_ddladmin
alter role db_ddladmin add member login1
alter role role1 add member login1
alter role db_ddladmin drop member login1

--разрешения для роли
grant select to role1

--разрешения для пользователя
grant select to login1
grant select to login1
revoke insert to login1
deny delete to login1


USE [master]
GO
CREATE SERVER ROLE [BulkAdmin4] AUTHORIZATION [sa]
GO
ALTER SERVER ROLE [BulkAdmin4] ADD MEMBER [login1]
GO
GRANT Administer Bulk Operations TO [login1]
GO


SELECT DB_NAME() AS 'Database', p.name, p.type_desc, p.is_fixed_role, dbp.state_desc,
dbp.permission_name, so.name, so.type_desc
FROM sys.database_permissions dbp
LEFT JOIN sys.objects so ON dbp.major_id = so.object_id
LEFT JOIN sys.database_principals p ON dbp.grantee_principal_id = p.principal_id
--WHERE p.name = 'ProdDataEntry'
ORDER BY so.name, dbp.permission_name;


--Роли на сервере:
exec sp_helpsrvrolemember
--Роли и в БД
exec sp_helpsrvrolemember


USE kontrolna_1
go
exec sp_addlogin @loginame = 'glib3_login', @passwd='2'
exec sp_adduser 'glib3_login', 'glib3_loginu'
grant select ON dogovoru to glib3_loginu
--создание роли
exec sp_addrole df
grant create table to df
--Проверка
exec sp_helpuser

BACKUP DATABASE AdventureWorks
TO DISK = ‘C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\Backup\boreichenko.bak’WITH INIT, NAME = ‘AdventureWorks Full Db backup’,
DESCRIPTION = ‘AdventureWorks Full Database Backup

RESTORE DATABASE AdventureWorks
FROM DISK = ‘C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\Backup\boreichenko.bak’
WITH RECOVERY, REPLACE
