-- первая БД выступающая в роли источника данных
CREATE DATABASE DemoSSIS_SourceA
GO

ALTER DATABASE DemoSSIS_SourceA SET RECOVERY SIMPLE 
GO

-- вторая БД выступающая в роли источника данных
CREATE DATABASE DemoSSIS_SourceB
GO

ALTER DATABASE DemoSSIS_SourceB SET RECOVERY SIMPLE 
GO

-- БД выступающая в роли получателя данных
CREATE DATABASE DemoSSIS_Target
GO

ALTER DATABASE DemoSSIS_Target SET RECOVERY SIMPLE 
GO
------------------------------------------------------
--В базах источниках создадим тестовые таблицы и наполним их тестовыми данными:
USE DemoSSIS_SourceA
GO

-- продукты из источника A
CREATE TABLE Products(
  ID int NOT NULL IDENTITY,
  Title nvarchar(50) NOT NULL,
  Price money,
CONSTRAINT PK_Products PRIMARY KEY(ID)
)
GO

-- наполняем таблицу тестовыми данными
SET IDENTITY_INSERT Products ON

INSERT Products(ID,Title,Price)VALUES
(1,N'Клей',20),
(2,N'Корректор',NULL),
(3,N'Скотч',100),
(4,N'Стикеры',80),
(5,N'Скрепки',25)

SET IDENTITY_INSERT Products OFF
GO
-----------------------------------------------------------
USE DemoSSIS_SourceB
GO

-- продукты из источника B
CREATE TABLE Products(
  ID int NOT NULL IDENTITY,
  Title nvarchar(50) NOT NULL,
  Price money,
CONSTRAINT PK_Products PRIMARY KEY(ID)
)
GO

-- наполняем таблицу тестовыми данными
SET IDENTITY_INSERT Products ON

INSERT Products(ID,Title,Price)VALUES
(1,N'Ножницы',200),
(2,N'Нож канцелярский',70),
(3,N'Дырокол',220),
(4,N'Степлер',150),
(5,N'Шариковая ручка',15)

SET IDENTITY_INSERT Products OFF
GO
----------------------------------------------------------
--Создадим таблицу в принимающей базе:
USE DemoSSIS_Target
GO
-- принимающая таблица
CREATE TABLE Products(
  ID int NOT NULL IDENTITY,
  Title nvarchar(50) NOT NULL,
  Price money,
  SourceID char(1) NOT NULL, -- используется для идентификации источника
  SourceProductID int NOT NULL, -- ID в источнике
CONSTRAINT PK_Products PRIMARY KEY(ID),
CONSTRAINT UK_Products UNIQUE(SourceID,SourceProductID),
CONSTRAINT CK_Products_SourceID CHECK(SourceID IN('A','B'))
)
GO
-------------------------------------------------------
--