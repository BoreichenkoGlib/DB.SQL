 CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'newPassword';

 select * from sys.key_encryptions
 drop master key

 BACKUP MASTER KEY TO FILE = 'c:\sqltest2012_masterkey_backup.bak'
 ENCRYPTION BY PASSWORD = 'Password1'

 CREATE CERTIFICATE TDECertificate WITH SUBJECT ='TDE Certificate for DBClients'
select * from sys.certificates where name='TDECertificate'

BACKUP CERTIFICATE TDECertificate
 TO FILE = 'c:\sqltest2012_cert_TDECertificate'
 WITH PRIVATE KEY
 (
 FILE = 'c:\sqltest2012SQLPrivateKeyFile',
 ENCRYPTION BY PASSWORD = 'Password3'
 );

 USE lab_1
CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_128
ENCRYPTION BY SERVER CERTIFICATE TDECertificate;

ALTER DATABASE lab_1
SET ENCRYPTION ON ;
-----------------------------------------------------------
ALTER DATABASE MySecretDB SET ENCRYPTION ON

SELECT DB_NAME(database_id), encryption_state, percent_complete FROM sys.dm_database_encryption_keys
--------------------------------------------------------------
USE master
go
-- Создаем главный ключ базы данных master
IF(not EXISTS(SELECT * FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##')) 
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'My$Strong$Password$123'
go
-- Создаем сертификат, которым будем шифровать DEK
CREATE CERTIFICATE DEK_EncCert WITH SUBJECT = 'DEK Encryption Certificate'
go 
-- Создаем базу данных, которую будем шифровать
CREATE DATABASE MySecretDB
go
-- И сразу делаем ее полную резервную копию (секретных данных здесь нет)
BACKUP DATABASE MySecretDB TO DISK = 'c:\temp\MySecretDB.bak' WITH INIT
go
USE MySecretDB
go 
-- Создаем таблицу и заполняем ее секретными данными
-- Делаем это в транзакции с меткой T1
BEGIN TRAN T1 WITH MARK

CREATE TABLE dbo.MySecretTable (Data varchar(200) not null)

INSERT dbo.MySecretTable (Data) VALUES ('It is my secret')

COMMIT
go 
-- Шифруем базу данных
CREATE DATABASE ENCRYPTION KEY WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE DEK_EncCert
go
ALTER DATABASE MySecretDB SET ENCRYPTION ON
go 
--Проверяем, что база данных зашифрована:
SELECT DB_NAME(database_id), encryption_state FROM 
sys.dm_database_encryption_keys

USE master
go
DROP DATABASE MySecretDB
go
DROP CERTIFICATE DEK_EncCert 
go

RESTORE DATABASE MySecretDB FROM DISK = 'd:\temp\MySecretDB.bak' WITH NORECOVERY
RESTORE LOG MySecretDB FROM DISK = 'd:\temp\MySecretDB.trn'

RESTORE DATABASE MySecretDB FROM DISK = 'd:\temp\MySecretDB.bak' WITH NORECOVERY
RESTORE LOG MySecretDB FROM DISK = 'd:\temp\MySecretDB.trn' WITH STOPATMARK = 'T1' 

go
USE MySecretDB
go
SELECT * FROM dbo.MySecretTable
go

