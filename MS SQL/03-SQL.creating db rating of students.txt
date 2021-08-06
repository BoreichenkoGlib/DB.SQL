SELECT dbo_student.Name_ini, predmet.Nazva_skor, reiting from Rozklad_pids join Predmet_plan on Rozklad_pids.K_predm_pl=Predmet_plan.K_predm_pl
join predmet on predmet.K_predmet = Predmet_plan.K_predmet join reiting on reiting.K_zapis= Rozklad_pids.K_zapis
join dbo_student on dbo_student.Kod_stud = reiting.Kod_student
order by Name_ini

select dbo_student.Name_ini, avg(Reiting.Reiting) from dbo_student join Reiting on dbo_student.Kod_stud = Reiting.Kod_student
group by Name_ini

SELECT count(Kod_stud), Kod_group FROM dbo.dbo_student
group by Kod_group

SELECT Kod_group, Count(K_predmet) from dbo_groups join Predmet_plan on dbo_groups.K_navch_plan = Predmet_plan.K_navch_plan
group by Kod_group

SELECT Kod_group, SUM(Chas_all) from Rozklad_pids join Predmet_plan on Rozklad_pids.K_predm_pl = Predmet_plan.K_predm_pl
GROUP by Kod_group

SELECT dbo_student.Kod_group, avg(Reiting.reiting) from dbo_student join Reiting on dbo_student.Kod_stud = Reiting.Kod_student
group by dbo_student.Kod_group

SELECT Predmet.Nazva, AVG(Reiting) as 'avarage' FROM dbo.Reiting join Rozklad_pids on Reiting.K_zapis = Rozklad_pids.K_zapis
join Predmet_plan on Rozklad_pids.K_predm_pl= Predmet_plan.K_predm_pl
join predmet on predmet.K_predmet = Predmet_plan.K_predmet
Group by Predmet.Nazva

SELECT dbo_student.Name_ini, predmet.Nazva_skor, reiting from Rozklad_pids join Predmet_plan on Rozklad_pids.K_predm_pl=Predmet_plan.K_predm_pl
join predmet on predmet.K_predmet = Predmet_plan.K_predmet join reiting on reiting.K_zapis= Rozklad_pids.K_zapis
join dbo_student on dbo_student.Kod_stud = reiting.Kod_student
order by Name_ini

SELECT Predmet.Nazva, Min(Reiting) FROM dbo.Reiting join Rozklad_pids on Reiting.K_zapis = Rozklad_pids.K_zapis
join Predmet_plan on Rozklad_pids.K_predm_pl= Predmet_plan.K_predm_pl
join predmet on predmet.K_predmet = Predmet_plan.K_predmet
Group by Predmet.Nazva

SELECT predmet.Nazva, Max(reiting) from Rozklad_pids join Predmet_plan on Rozklad_pids.K_predm_pl=Predmet_plan.K_predm_pl
join predmet on predmet.K_predmet = Predmet_plan.K_predmet join reiting on reiting.K_zapis= Rozklad_pids.K_zapis
join dbo_student on dbo_student.Kod_stud = reiting.Kod_student
group by Nazva

SELECT predmet.Nazva, SUM(Chas_Labor) as 'lab',
SUM(Chas_Lek) as lect, SUM(Chas_sem) as sem, SUM(Chas_all) as 'all' 
from Predmet_plan join predmet on predmet.K_predmet = Predmet_plan.K_predmet
group by Nazva

SELECT Nazva, COUNT(distinct dbo_groups.Kod_group) FROM Spetsialnost
join Navch_plan on Navch_plan.K_spets = Spetsialnost.K_spets
join Predmet_plan on Predmet_plan.K_navch_plan = Navch_plan.K_navch_plan
join dbo_groups on dbo_groups.K_navch_plan = Predmet_plan.K_navch_plan
Group by Nazva

delete FROM Reiting
WHERE EXISTS (SELECT * FROM dbo_student WHERE Reiting.Kod_student = dbo_student.Kod_stud and dbo_student.Sname = 'Базелюк');

delete FROM Predmet_plan
WHERE EXISTS (SELECT * FROM predmet WHERE predmet.K_predmet = Predmet_plan.K_predmet and predmet.Nazva = 'Вища математика');

update reiting 
set Reiting *=1.15

update reiting 
set Reiting /=1.15

	declare @predCount int;
	set @predCount = (select count(K_predmet) from predmet where Nazva Like 'М%');
	declare @pred int;
	while @predcount >0
	begin
	set @pred = (select K_predmet from predmet where Nazva Like 'М%' order by K_predmet  offset @predCount-1 rows fetch next 1 rows only)
	
	insert into Predmet_plan( Predmet.K_predmet, K_navch_plan,Chas_all, Semestr, k_fk)
	values(395, 13, 77, 2,2)
	set @predCount = @predCount-1
	end


