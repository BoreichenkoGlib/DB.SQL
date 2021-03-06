use torg_firm

select Sum(NaSklade) as numberOfGoods from tovar

select count(id_sotrud) as numberOfEmployees from sotrudnik

 select count(id_postach) as numberOfSuppliers from postachalnik

select sum(zakaz_tovar.Kilkist)
		, tovar.Nazva
	from zakaz_tovar 
		join tovar
			on zakaz_tovar.id_tovar=tovar.id_tovar
		join zakaz
			on zakaz_tovar.id_zakaz=zakaz.id_zakaz
where
	date_rozm between '2017-07-01' and '2017-07-31'
	and(
	tovar.Nazva='Молоко'
	or tovar.Nazva = 'Кефир'
	or tovar.Nazva = 'Творог'
	or tovar.Nazva = 'Сметана')
group by tovar.Nazva

select NameOfSuppliers, NazvaTovar, sum(suma) from(select postachalnik.Nazva as NameOfSuppliers
		, tovar.Nazva as NazvaTovar
		, sum((zakaz_tovar.Kilkist * tovar.Price
	- (zakaz_tovar.Znigka * tovar.Price * zakaz_tovar.Kilkist))) as 'suma'
from zakaz_tovar 
	join tovar 
		on tovar.id_tovar=zakaz_tovar.id_tovar
	join postachalnik 
		on postachalnik.id_postach=tovar.id_postav
group by postachalnik.Nazva, tovar.Nazva
union
select postachalnik.Nazva as NameOfSuppliers
		, tovar.Nazva as NazvaTovar
		, sum(tovar.Price * tovar.NaSklade) as 'suma'
from tovar 
	join postachalnik 
		on postachalnik.id_postach=tovar.id_postav
Group by postachalnik.Nazva,tovar.Nazva) t
group by NameOfSuppliers,NazvaTovar

select postachalnik.Nazva,
		sum(zakaz_tovar.Kilkist)
from postachalnik join tovar on tovar.id_postav=postachalnik.id_postach
	join zakaz_tovar on zakaz_tovar.id_tovar = tovar.id_tovar
where tovar.Nazva = 'Молоко'
group by postachalnik.Nazva

select tovar.Nazva, 
		CAST(AVG(zakaz_tovar.Kilkist * tovar.Price
	- (zakaz_tovar.Znigka * tovar.Price * zakaz_tovar.Kilkist))AS decimal(10,2)) as FinalPrice
from zakaz_tovar
	join tovar on tovar.id_tovar = zakaz_tovar.id_tovar
group by tovar.Nazva

select klient.Nazva, sum(zakaz_tovar.Kilkist * tovar.Price
	- (zakaz_tovar.Znigka * tovar.Price * zakaz_tovar.Kilkist)) as FinalPrice
from klient join zakaz on zakaz.id_klient=klient.id_klient
			join zakaz_tovar on zakaz_tovar.id_zakaz = zakaz.id_zakaz
			join tovar on tovar.id_tovar = zakaz_tovar.id_tovar
where klient.City='Житомир'
group by klient.Nazva

select klient.Nazva, sum(zakaz_tovar.Kilkist * tovar.Price
	- (zakaz_tovar.Znigka * tovar.Price * zakaz_tovar.Kilkist)) as FinalPrice,
	date_naznach
from klient join zakaz on zakaz.id_klient=klient.id_klient
			join zakaz_tovar on zakaz_tovar.id_zakaz = zakaz.id_zakaz
			join tovar on tovar.id_tovar = zakaz_tovar.id_tovar
where klient.City='Житомир'
group by klient.Nazva,date_naznach

select postachalnik.Nazva, cast(avg(tovar.Price)as decimal(6,2))
		from tovar join postachalnik
 on tovar.id_postav = postachalnik.id_postach
	group by postachalnik.Nazva	
