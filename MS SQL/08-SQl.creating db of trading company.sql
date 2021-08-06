USE kontrolna_1

--створена таблиц€ - постачальник
CREATE TABLE [postach]
(
 [id_postach]    int NOT NULL IDENTITY(1,1) ,
 [nazva_postach] text  ,
 [ur_add]        text  ,
 [R_R]           varchar(50)  ,
 [tel]           int  ,
 [contact]       text  ,


 CONSTRAINT [PK_postach] PRIMARY KEY CLUSTERED ([id_postach] ASC)
);

--створена таблиц€ сировина
CREATE TABLE [surovina]
(
 [id_surovinu]    int NOT NULL IDENTITY(1,1) ,
 [nazva_surovinu] text  ,
 [count] int ,


 CONSTRAINT [PK_surovina] PRIMARY KEY CLUSTERED ([id_surovinu] ASC)
);

--створена таблиц€ видаткова накладна
CREATE TABLE [vud_nakl]
(
 [id_vud_nakl] int NOT NULL IDENTITY(1,1) ,
 [ceh]         int  ,
 [date]        date  ,
 [kilkist]     varchar(50)  ,
 [id_surovinu] int  ,


 CONSTRAINT [PK_¬идаткова накладна] PRIMARY KEY CLUSTERED ([id_vud_nakl] ASC),
 CONSTRAINT [FK_96] FOREIGN KEY ([id_surovinu])  REFERENCES [surovina]([id_surovinu])
);

--створена таблиц€ договори
CREATE TABLE [dogovoru]
(
 [id_dogovoru] int NOT NULL IDENTITY(1,1),
 [id_postach]  int ,
 [date]        date ,
 [kilkist]     varchar(50) ,
 [id_surovinu] int ,


 CONSTRAINT [PK_ѕостачальники] PRIMARY KEY CLUSTERED ([id_dogovoru] ASC),
 CONSTRAINT [FK_118] FOREIGN KEY ([id_surovinu])  REFERENCES [surovina]([id_surovinu]),
 CONSTRAINT [FK_45] FOREIGN KEY ([id_postach])  REFERENCES [postach]([id_postach])
);

--створена таблиц€ прибутков≥ накладн≥
CREATE TABLE [prib_nakl]
(
 [id_prib_nakl] int NOT NULL IDENTITY(1,1),
 [id_postach]   int ,
 [id_dogovoru]  int ,
 [date]         date ,
 [kilkist]      varchar(50) ,
 [id_surovinu]  int ,


 CONSTRAINT [PK_ѕрибутков≥ накладн≥] PRIMARY KEY CLUSTERED ([id_prib_nakl] ASC),
 CONSTRAINT [FK_115] FOREIGN KEY ([id_surovinu])  REFERENCES [surovina]([id_surovinu]),
 CONSTRAINT [FK_42] FOREIGN KEY ([id_postach])  REFERENCES [postach]([id_postach]),
 CONSTRAINT [FK_52] FOREIGN KEY ([id_dogovoru])  REFERENCES [dogovoru]([id_dogovoru])
);

--вношу дан≥ до таблиц≥
INSERT [postach] ([nazva_postach], [ur_add], [R_R], [tel], [contact])
VALUES ('pos1', 'ur_add1', '1111', 3081, '1111'),
('pos2', 'ur_add2', '1112', 3082, '1112'),
('pos3', 'ur_add3', '1113', 3083, '1113'),
('pos4', 'ur_add4', '1114', 3084, '1114'),
('pos5', 'ur_add5', '1115', 3085, '1115'),
('pos6', 'ur_add6', '1116', 3086, '1116'),
('pos7', 'ur_add7', '1117', 3087, '1117');

INSERT [surovina] ([nazva_surovinu], [count])
VALUES ('s1', 333),
('s2', 44),
('s3', 564),
('s4', 45),
('s5', 547),
('s6', 456),
('s7', 43535);

INSERT [vud_nakl] ([ceh], [date], [kilkist], [id_surovinu])
VALUES (1, getdate(), '5', '1'),
(2, getdate(), '5', '2'),
(3, getdate(), '5', '3'),
(4, getdate(), '5', '4'),
(5, getdate(), '5', '1'),
(6, getdate(), '5', '2'),
(7, getdate(), '5', '5');

INSERT [dogovoru] ([id_postach], [date], [kilkist], [id_surovinu])
VALUES (1, getdate(), '20', 1),
(2, getdate(), '20', 1),
(3, getdate(), '20', 3),
(4, getdate(), '20', 1),
(5, getdate(), '20', 4),
(7, getdate(), '20', 1),
(1, getdate(), '20', 5);

INSERT [prib_nakl] ([id_postach], [id_dogovoru], [date], [kilkist], [id_surovinu])
VALUES (1, 1, getdate(), '20', 1),
(2, 2, getdate(), '20', 1),
(3, 3, getdate(), '20', 1),
(4, 4, getdate(), '20', 1),
(5, 6, getdate(), '20', 1),
(6, 7, getdate(), '20', 4);

--роблю тестов≥ запити
SELECT * FROM [postach] --1
SELECT * FROM [surovina] --2
SELECT * FROM [vud_nakl] --3
SELECT * FROM [dogovoru] --4
SELECT * FROM [prib_nakl] --5
SELECT * FROM [surovina] --6
WHERE [count] > 99;
SELECT * FROM [dogovoru] --7
WHERE [id_surovinu] = 1;
SELECT * FROM [prib_nakl] --8
WHERE [id_dogovoru] = 7;
SELECT * FROM [postach] --9
WHERE [nazva_postach] LIKE '%3%';
SELECT * FROM [vud_nakl] --10
WHERE [kilkist] LIKE '%5%';

--процедуру, що визначаЇ к≥льк≥сть р€дк≥в 
--в таблиц€х Ѕƒ ≥ заносить результат в нову таблицю. 
USE kontrolna_1
GO
--створив табл куди будуть записуватись дан≥
CREATE TABLE [proc_1]
(
[lines] int
);
USE kontrolna_1
GO
--сама процедура
create procedure procedure_1
    @p1 int
as
BEGIN
	SELECT @p1 = COUNT(*) FROM dogovoru
	INSERT INTO proc_1(lines) VALUES(@p1)
	SELECT @p1 = COUNT(*) FROM postach
	INSERT INTO proc_1(lines) VALUES(@p1)
	SELECT @p1 = COUNT(*) FROM prib_nakl
	INSERT INTO proc_1(lines) VALUES(@p1)
	SELECT @p1 = COUNT(*) FROM surovina
	INSERT INTO proc_1(lines) VALUES(@p1)
	SELECT @p1 = COUNT(*) FROM vud_nakl
	INSERT INTO proc_1(lines) VALUES(@p1)
END
go
exec procedure_1 @p1 =1
SELECT * FROM [proc_1]
----------------------------------------------------------------------------------------------------
--процедуру, що визначаЇ к≥льк≥сть пол≥в 
--в таблиц€х Ѕƒ ≥ заносить результат в но-ву таблицю
USE kontrolna_1
GO
--створив табл куди будуть записуватись дан≥
CREATE TABLE [proc_2]
(
[fields] int
);
USE kontrolna_1
GO
--сама процедура
create procedure procedure_2
    @p1 int
as
BEGIN
	SELECT @p1 = COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'dogovoru'
	INSERT INTO proc_2(fields) VALUES(@p1)
	SELECT @p1 = COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'postach'
	INSERT INTO proc_2(fields) VALUES(@p1)
	SELECT @p1 = COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'prib_nakl'
	INSERT INTO proc_2(fields) VALUES(@p1)
	SELECT @p1 = COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'surovina'
	INSERT INTO proc_2(fields) VALUES(@p1)
	SELECT @p1 = COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'vud_nakl'
	INSERT INTO proc_2(fields) VALUES(@p1)
END
go
USE kontrolna_1
GO
exec procedure_2 @p1 =1
SELECT * FROM [proc_2]
------------------------------------------------------------------------------------------------------
--процедуру, що визначаЇ дл€ кожного пол€ 
--таблиц≥, к≥льк≥сть значень, що не по-вторюютьс€
USE kontrolna_1
GO
create procedure procedure_3
as
BEGIN
	------------------------------------------------------------1
	SELECT
	COUNT(DISTINCT [id_postach]) as nazva_postach_count,
 	COUNT(DISTINCT(CAST([date] AS nvarchar))) as date_count,
	COUNT(DISTINCT [kilkist]) as kilkist_count,
	COUNT(DISTINCT [id_surovinu]) as surovinu_count
	FROM dogovoru
	------------------------------------------------------2
	SELECT
	COUNT(DISTINCT(CAST([nazva_postach] as nvarchar))) as nazva_postach_count,	
	COUNT(DISTINCT(CAST([ur_add] as nvarchar))) as ur_add_count,			
	COUNT(DISTINCT [R_R]) as R_R_count,
	COUNT(DISTINCT [tel]) as tel_count,
	COUNT(DISTINCT(CAST([contact] as nvarchar))) as contact_count				
	FROM postach
	------------------------------------------------------3
	SELECT
	COUNT(DISTINCT [id_postach]) as id_postach_count,
	COUNT(DISTINCT [id_dogovoru]) as id_dogovoru_count,
	COUNT(DISTINCT(CAST([date] AS nvarchar))) as date_count,
	COUNT(DISTINCT [kilkist]) as kilkist_count
	FROM prib_nakl
	 --------------------------------------------------------4
	SELECT
	COUNT(DISTINCT(CAST([nazva_surovinu] as nvarchar))) as nazva_surovinu_count,			
	COUNT(DISTINCT [count]) as count_count
	FROM surovina
	--------------------------------------------------------5
	SELECT
	COUNT(DISTINCT [ceh]) as ceh_count,
	COUNT(DISTINCT(CAST([date] AS nvarchar))) as date_count,
	COUNT(DISTINCT [kilkist]) as kilkist_count,
	COUNT(DISTINCT [id_surovinu]) as id_surovinu_count
	FROM vud_nakl
END
go
exec procedure_3
--a.ƒл€ операц≥њ оновленн€ таблиц≥
--	“ригер, що оновлюЇ одночасно дан≥ в двох таблиц€х

create trigger Ins_dogovoru
on dogovoru for insert
as
update prib_nakl set kilkist = i.kilkist + i.kilkist
from inserted i
inner join prib_nakl p on p.id_prib_nakl = i.id_dogovoru
go
 
create trigger Del_dogovotu
on dogovoru for delete
as
update prib_nakl set kilkist = kilkist - 
isnull((select sum(cast(d.kilkist as int)) from deleted d where d.id_dogovoru = prib_nakl.id_prib_nakl group by d.id_dogovoru),0)
go
 
create trigger Upd_dogovoru
on dogovoru for update
as
update prib_nakl set kilkist = kilkist
- isnull((select sum(cast(d.kilkist as int)) from deleted d where d.id_dogovoru = prib_nakl.id_prib_nakl group by d.id_dogovoru),0)
+ isnull((select sum(cast(i.kilkist as int)) from inserted i where i.id_dogovoru = prib_nakl.id_prib_nakl group by i.id_dogovoru),0) 
go

select * from dogovoru
select * from prib_nakl

update dogovoru set kilkist = '50'

select * from dogovoru
select * from prib_nakl

--DROP TRIGGER Ins_dogovoru
--DROP TRIGGER Del_dogovotu
--DROP TRIGGER Upd_dogovoru

--	“ригер, що при онвленн≥ в≥дхил€Ї зм≥ни €кощо 
--	Ї звТ€зан≥ дан≥ в ≥нш≥й таблиц≥

CREATE TRIGGER trigger1
    ON dogovoru INSTEAD OF UPDATE      
AS 
BEGIN
    IF (EXISTS (SELECT id_dogovoru FROM dogovoru WHERE kilkist IN(SELECT id_prib_nakl FROM prib_nakl))
        OR EXISTS (SELECT id_prib_nakl FROM prib_nakl WHERE kilkist IN(SELECT id_dogovoru FROM dogovoru))) BEGIN
        ROLLBACK;
    END
END

select * from dogovoru
select * from prib_nakl

update dogovoru set kilkist = '10'

select * from dogovoru
select * from prib_nakl

--b.ƒл€ операц≥њ знищенн€ даних з таблиц≥:
--	“ригер, що знищуЇ звТ€зан≥ дан≥ одночасно в двох таблиц€х
CREATE TRIGGER del_in_tables
ON postach INSTEAD OF DELETE
AS
BEGIN
DECLARE @id int;
SELECT @id = id_postach from deleted;
DELETE FROM dogovoru WHERE id_postach = @id;
DELETE FROM postach WHERE id_postach = @id;
print 'yes';
END
--	“ригер, що при знищенн≥ перев≥р€Ї на€вн≥сть в ≥нш≥й таблиц≥ 
--	даних, що в≥дпо-в≥дають задан≥й умов≥ ≥ в≥дхил€Ї знищенн€ даних

CREATE TRIGGER tablename_delete 
ON dogovoru FOR DELETE
AS
    SET NOCOUNT ON

    IF EXISTS (SELECT * FROM vud_nakl WHERE kilkist > 1)
    BEGIN
        RAISERROR ('¬»ƒјЋ≈ЌЌя «јЅќ–ќЌ≈Ќ≈ !!!', 0, 1) WITH NOWAIT
        ROLLBACK
    END

    SET NOCOUNT OFF
GO

drop trigger tablename_delete 

select * from dogovoru
select * from vud_nakl

delete dogovoru

select * from dogovoru
select * from vud_nakl

--c.ƒл€ операц≥њ вставки даних:
--	—творти тригер, що реал≥зуЇ вставку даних ≥ зм≥ну к≥лькост≥ 
--	р€дк≥в в таблиц≥ (дан≥ про к≥льк≥сть р€дк≥в в таблиц€х 
--	м≥ст€тьс€ в окрем≥й таблиц≥).

--створив табл куди будуть записуватись дан≥
CREATE TABLE [table_1]
(
 [id_dogovoru] int NOT NULL IDENTITY(1,1),
 [id_postach]  int ,
 [date]        date ,
 [kilkist]     varchar(50) ,
 [id_surovinu] int ,


 CONSTRAINT [PK_ѕостачальники] PRIMARY KEY CLUSTERED ([id_dogovoru] ASC),
);
------------------------------------------------------------
SELECT * FROM table_1
-------------------------------------------------------------
INSERT [table_1] ([id_postach], [date], [kilkist], [id_surovinu])
VALUES (99, getdate(), '99', 99);
----------------------------------------------------------
USE kontrolna_1
GO
CREATE TRIGGER row_INSERT
ON table_1 INSTEAD OF INSERT 
AS
BEGIN
INSERT INTO dogovoru([id_postach], [date], [kilkist], [id_surovinu])
SELECT id_postach, date, kilkist, id_surovinu
FROM table_1
END
 -------------------------------------------------------------------------
INSERT table_1([id_postach], [date], [kilkist], [id_surovinu])
VALUES (1, getdate(), '20', 1);
SELECT * FROM dogovoru
--drop trigger row_INSERT
