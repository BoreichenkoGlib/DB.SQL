--1--
create proc lab6_proc1 as
select Tovar.Nazva as [Назва товару], tovar.Price*zakaz_tovar.Kilkist as [Вартість], sotrudnik.Fname as [Прізвище], sotrudnik.Name as [Ім'я] 
	from sotrudnik inner join zakaz on sotrudnik.id_sotrud=zakaz.id_sotrud 
	inner join zakaz_tovar on zakaz.id_zakaz=zakaz_tovar.id_zakaz  
	INNER JOIN tovar on tovar.id_tovar=zakaz_tovar.id_tovar
where sotrudnik.Name='Олексій'
--2--
create proc lab6_proc2 as
update tovar set Price=Price*0.9
	where id_postav=(select postachalnik.id_postach 
					from postachalnik 
						where postachalnik.Nazva='ТОВ "Арей"')
--3--
create proc lab6_proc3 @k varchar(20)
as
select tovar.Nazva as [Назва товару], tovar.Price*zakaz_tovar.Kilkist as [Вартість], klient.Nazva as [Клієнт]
	from klient inner join ((tovar inner join zakaz_tovar 
on tovar.id_tovar=zakaz_tovar.id_tovar) inner join zakaz 
on zakaz.id_zakaz=zakaz_tovar.id_zakaz) 
on klient.id_klient=zakaz.id_klient 
where klient.Nazva=@k
exec lab6_proc3 'ПП Апин В.С.'
--4--
create proc lab6_proc4
@t int, @p float 
as
update tovar set Price=Price*(1 -@p) 
where NaSklade <= @t
exec lab6_proc4 15, 0.25;
--5--
create proc lab6_proc5
@t varchar(20)='Молоко', @p float = 0.1
as
update tovar set Price=Price*(1 -@p)
where Nazva=@t
exec lab6_proc5
--6--
create proc lab6_proc6 
@m int, @s float output 
as
select @s=sum(tovar.Price*zakaz_tovar.Kilkist)
	from tovar INNER JOIN zakaz_tovar on tovar.id_tovar=zakaz_tovar.id_tovar 
				inner join zakaz on zakaz.id_zakaz=zakaz_tovar.id_zakaz
	group by month(zakaz.date_naznach)
	having month(zakaz.date_naznach)=@m
declare @proc6 float
exec lab6_proc6 7, @proc6 output
print @proc6
--7--
create proc lab6_subproc7
@f varchar(20) output, @n varchar(20)
 as
select @f=City 
from klient
where Nazva=@n
create proc lab6_proc7
@suma float output, @n varchar(20)
as
declare @pr varchar(20)
exec lab6_subproc7 @pr output, @n
select @suma=(tovar.Price*zakaz_tovar.kilkist)
from zakaz inner join zakaz_tovar on zakaz.id_zakaz = zakaz_tovar.id_zakaz
inner join tovar on zakaz_tovar.id_tovar = tovar.id_tovar
where zakaz.id_klient in (select id_klient from klient
where city = @pr)
declare @f1 varchar(20)
exec lab6_proc7 @f1 output, @n = 'ТОВ "Арей"'
Print @f1


--Тригери--
--1--
create trigger lab6_oneRow
on zakaz_tovar for insert
as
if @@ROWCOUNT = 1 
begin
if not exists(
select  * from inserted
		where inserted.Kilkist <= all(select tovar.NaSklade 
		from tovar, zakaz_tovar where tovar.id_tovar= zakaz_tovar.id_tovar))
begin
rollback tran print 'Нема товару'
end
end

INSERT INTO zakaz_tovar(id_zakaz, id_tovar, Kilkist, Znigka)
VALUES (8,7,5, 0.05)
INSERT INTO zakaz_tovar(id_zakaz, id_tovar, Kilkist, Znigka)
VALUES (10,4,20, 0)
--2--
create trigger triger_ins on zakaz_tovar
for insert 
as
declare @x int, @y int
if @@ROWCOUNT = 1 
begin
if not exists(select * 
from inserted 
where - inserted.Kilkist <= all(select tovar.NaSklade
from tovar, zakaz_tovar 
where tovar.id_tovar= zakaz_tovar. id_tovar))
begin
rollback tran print 'Нестача товару'
end
if not exists ( select i.id_tovar, i.Kilkist, 2 from tovar N, inserted i 
where N. id_tovar =i.id_tovar)
print 'Товар не продається'
else begin
select @y=i.id_tovar, @x=i.Kilkist 
from zakaz_tovar N, inserted i 
where N.id_tovar=i.id_tovar 
update tovar 
set NaSklade=NaSklade-@x 
where id_tovar=@y
print 'Ok'
end
end
INSERT INTO zakaz_tovar(id_zakaz, id_tovar, Kilkist, Znigka)
VALUES (10,7,10, 0)
--3--
create trigger lab6_del
on zakaz_tovar for delete 
as
if @@ROWCOUNT = 1 
begin 
declare @y int,@x int 
select @y=id_tovar, @x=Kilkist 
from deleted 
update tovar set NaSklade=NaSklade+@x 
where id_tovar=@y
end

delete
from zakaz_tovar
where id_zakaz = 1 and id_tovar = 1;
