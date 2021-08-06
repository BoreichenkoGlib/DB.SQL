-------Lab 2-----------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

--CREATE DATABASE TOVAR
--go


--USE TOVAR


--CREATE TABLE [postach]
--(
-- [id_postach]    int NOT NULL IDENTITY(1,1) ,
-- [nazva_postach] text  ,
-- [ur_add]        text  ,
-- [R_R]           varchar(50)  ,
-- [tel]           int  ,
-- [contact]       text  ,


-- CONSTRAINT [PK_postach] PRIMARY KEY CLUSTERED ([id_postach] ASC)
--);

--CREATE TABLE [surovina]
--(
-- [id_surovinu]    int NOT NULL IDENTITY(1,1) ,
-- [nazva_surovinu] text  ,
-- [count] int ,


-- CONSTRAINT [PK_surovina] PRIMARY KEY CLUSTERED ([id_surovinu] ASC)
--);

--CREATE TABLE [vud_nakl]
--(
-- [id_vud_nakl] int NOT NULL IDENTITY(1,1) ,
-- [ceh]         int  ,
-- [date]        date  ,
-- [kilkist]     varchar(50)  ,
-- [id_surovinu] int  ,


-- CONSTRAINT [PK_Видаткова накладна] PRIMARY KEY CLUSTERED ([id_vud_nakl] ASC),
-- CONSTRAINT [FK_96] FOREIGN KEY ([id_surovinu])  REFERENCES [surovina]([id_surovinu])
--);




--CREATE TABLE [dogovoru]
--(
-- [id_dogovoru] int NOT NULL IDENTITY(1,1),
-- [id_postach]  int ,
-- [date]        date ,
-- [kilkist]     varchar(50) ,
-- [id_surovinu] int ,


-- CONSTRAINT [PK_Постачальники] PRIMARY KEY CLUSTERED ([id_dogovoru] ASC),
-- CONSTRAINT [FK_118] FOREIGN KEY ([id_surovinu])  REFERENCES [surovina]([id_surovinu]),
-- CONSTRAINT [FK_45] FOREIGN KEY ([id_postach])  REFERENCES [postach]([id_postach])
--);




--CREATE TABLE [prib_nakl]
--(
-- [id_prib_nakl] int NOT NULL IDENTITY(1,1),
-- [id_postach]   int ,
-- [id_dogovoru]  int ,
-- [date]         date ,
-- [kilkist]      varchar(50) ,
-- [id_surovinu]  int ,


-- CONSTRAINT [PK_Прибуткові накладні] PRIMARY KEY CLUSTERED ([id_prib_nakl] ASC),
-- CONSTRAINT [FK_115] FOREIGN KEY ([id_surovinu])  REFERENCES [surovina]([id_surovinu]),
-- CONSTRAINT [FK_42] FOREIGN KEY ([id_postach])  REFERENCES [postach]([id_postach]),
-- CONSTRAINT [FK_52] FOREIGN KEY ([id_dogovoru])  REFERENCES [dogovoru]([id_dogovoru])
--);
--go

-------Lab 3----------------------------------------------------------------------------------------
----------------------------------------------------------------------------

--INSERT [postach] ([nazva_postach], [ur_add], [R_R], [tel], [contact])
--VALUES ('pos1', 'ur_add1', '1111', 3081, '1111'),
--('pos2', 'ur_add2', '1112', 3082, '1112'),
--('pos3', 'ur_add3', '1113', 3083, '1113'),
--('pos4', 'ur_add4', '1114', 3084, '1114'),
--('pos5', 'ur_add5', '1115', 3085, '1115'),
--('pos6', 'ur_add6', '1116', 3086, '1116'),
--('pos7', 'ur_add7', '1117', 3087, '1117');

--INSERT [surovina] ([nazva_surovinu], [count])
--VALUES ('s1', 333),
--('s2', 44),
--('s3', 564),
--('s4', 45),
--('s5', 547),
--('s6', 456),
--('s7', 43535);

--INSERT [vud_nakl] ([ceh], [date], [kilkist], [id_surovinu])
--VALUES (1, getdate(), '5', '1'),
--(2, getdate(), '5', '2'),
--(3, getdate(), '5', '3'),
--(4, getdate(), '5', '4'),
--(5, getdate(), '5', '1'),
--(6, getdate(), '5', '2'),
--(7, getdate(), '5', '5');

--INSERT [dogovoru] ([id_postach], [date], [kilkist], [id_surovinu])
--VALUES (1, getdate(), '20', 1),
--(2, getdate(), '20', 1),
--(3, getdate(), '20', 3),
--(4, getdate(), '20', 1),
--(5, getdate(), '20', 4),
--(7, getdate(), '20', 1),
--(1, getdate(), '20', 5);

--INSERT [prib_nakl] ([id_postach], [id_dogovoru], [date], [kilkist], [id_surovinu])
--VALUES (1, 1, getdate(), '20', 1),
--(2, 2, getdate(), '20', 1),
--(3, 3, getdate(), '20', 1),
--(4, 4, getdate(), '20', 1),
--(5, 6, getdate(), '20', 1),
--(6, 7, getdate(), '20', 4);

--go

--USE TOVAR

--SELECT * FROM [postach] --1

--SELECT * FROM [surovina] --2

--SELECT * FROM [vud_nakl] --3

--SELECT * FROM [dogovoru] --4

--SELECT * FROM [prib_nakl] --5

--SELECT * FROM [surovina] --6
--WHERE [count] > 99;

--SELECT * FROM [dogovoru] --7
--WHERE [id_surovinu] = 1;

--SELECT * FROM [prib_nakl] --8
--WHERE [id_dogovoru] = 7;

--SELECT * FROM [postach] --9
--WHERE [nazva_postach] LIKE '%3%';

--SELECT * FROM [vud_nakl] --10
--WHERE [kilkist] LIKE '%5%';
--go

------ Lab 4 ---------------------------------------------------------------------------------------
----------------------------------------------------------------------------------

--use TOVAR
--go

--CREATE VIEW Surovina_full AS
--SELECT 
--	surovina.[id_surovinu]  AS ID,
--	surovina.[nazva_surovinu] AS NAME_S,
--	surovina.[count] AS COUNT_S
--FROM surovina
--go

--CREATE VIEW Dogovoru_full AS
--SELECT 
--	dogovoru.[id_dogovoru] AS ID,
--	dogovoru.[id_postach]  AS ID_post,
--	dogovoru.[date]        AS DATE_D,
--	dogovoru.[kilkist]     AS ADD_S,
--	dogovoru.[id_surovinu] AS ID_S
--FROM dogovoru
--go


--CREATE VIEW Vud_nakl_surch AS
--SELECT 
--vud_nakl.[id_vud_nakl] AS ID,
--vud_nakl.[ceh]         AS CEH,
--vud_nakl.[date]        AS DATE_V,
--vud_nakl.[kilkist]     AS CELL,
--vud_nakl.[id_surovinu] AS ID_S
--FROM vud_nakl
--go

--SELECT *
--FROM Surovina_full

--SELECT *
--FROM Dogovoru_full

--SELECT *
--FROM Vud_nakl_surch
----------- Lab 6 --------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------


--CREATE PROCEDURE Postach_p AS
--SELECT *
--FROM postach
--go

--CREATE PROCEDURE AddSurovina 
--	@# text,
--	@## int
--AS
--INSERT INTO surovina ([nazva_surovinu], [count])
--VALUES (@#, @##)
--go

--EXEC AddSurovina 's8', 98432 

--CREATE TRIGGER DefSurovina
--ON dogovoru
--AFTER INSERT, UPDATE
--AS
--UPDATE dogovoru
--SET [id_surovinu] = 1
--WHERE [id_dogovoru] = (SELECT [id_dogovoru] FROM inserted)


--INSERT [dogovoru] ([id_postach], [date], [kilkist], [id_surovinu])
--VALUES (1, getdate(), '2344', 4);


--SELECT * FROM [dogovoru] 
--WHERE [kilkist] LIKE '2344';

--------------Lab 7 ----------------------------------------------------------------------
-----------------------------------------------------------------------------------
--USE TOVAR

--CREATE NONCLUSTERED INDEX surovina_sort
--ON surovina ([count]);

--SELECT * FROM [surovina]

--CREATE NONCLUSTERED INDEX dogovoru_sort
--ON dogovoru ([kilkist]);

--SELECT * FROM [dogovoru]

--CREATE NONCLUSTERED INDEX vud_nakl_sort
--ON vud_nakl ([id_surovinu]);


--SELECT * FROM [vud_nakl]









