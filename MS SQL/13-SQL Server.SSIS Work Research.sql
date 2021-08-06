-- ������ �� ����������� � ���� ��������� ������
CREATE DATABASE DemoSSIS_SourceA
GO

ALTER DATABASE DemoSSIS_SourceA SET RECOVERY SIMPLE 
GO

-- ������ �� ����������� � ���� ��������� ������
CREATE DATABASE DemoSSIS_SourceB
GO

ALTER DATABASE DemoSSIS_SourceB SET RECOVERY SIMPLE 
GO

-- �� ����������� � ���� ���������� ������
CREATE DATABASE DemoSSIS_Target
GO

ALTER DATABASE DemoSSIS_Target SET RECOVERY SIMPLE 
GO
------------------------------------------------------
--� ����� ���������� �������� �������� ������� � �������� �� ��������� �������:
USE DemoSSIS_SourceA
GO

-- �������� �� ��������� A
CREATE TABLE Products(
  ID int NOT NULL IDENTITY,
  Title nvarchar(50) NOT NULL,
  Price money,
CONSTRAINT PK_Products PRIMARY KEY(ID)
)
GO

-- ��������� ������� ��������� �������
SET IDENTITY_INSERT Products ON

INSERT Products(ID,Title,Price)VALUES
(1,N'����',20),
(2,N'���������',NULL),
(3,N'�����',100),
(4,N'�������',80),
(5,N'�������',25)

SET IDENTITY_INSERT Products OFF
GO
-----------------------------------------------------------
USE DemoSSIS_SourceB
GO

-- �������� �� ��������� B
CREATE TABLE Products(
  ID int NOT NULL IDENTITY,
  Title nvarchar(50) NOT NULL,
  Price money,
CONSTRAINT PK_Products PRIMARY KEY(ID)
)
GO

-- ��������� ������� ��������� �������
SET IDENTITY_INSERT Products ON

INSERT Products(ID,Title,Price)VALUES
(1,N'�������',200),
(2,N'��� ������������',70),
(3,N'�������',220),
(4,N'�������',150),
(5,N'��������� �����',15)

SET IDENTITY_INSERT Products OFF
GO
----------------------------------------------------------
--�������� ������� � ����������� ����:
USE DemoSSIS_Target
GO
-- ����������� �������
CREATE TABLE Products(
  ID int NOT NULL IDENTITY,
  Title nvarchar(50) NOT NULL,
  Price money,
  SourceID char(1) NOT NULL, -- ������������ ��� ������������� ���������
  SourceProductID int NOT NULL, -- ID � ���������
CONSTRAINT PK_Products PRIMARY KEY(ID),
CONSTRAINT UK_Products UNIQUE(SourceID,SourceProductID),
CONSTRAINT CK_Products_SourceID CHECK(SourceID IN('A','B'))
)
GO
-------------------------------------------------------
--