/*Mendoza Guardado,Sharyl Jeannine MG11013 C:20 Hora: 6:30-8:15pm Lcomp2*/
/*Ejercicio 1*/
select channel_desc, co.COUNTRY_ISO_CODE, trunc(sum(amount_sold)) "sales"
from CHANNELS cha
inner join
Sales sa on sa.CHANNEL_ID = cha.CHANNEL_ID
inner join customers cl on cl.CUST_ID=sa.CUST_ID
inner join countries co on cl.COUNTRY_ID=co.COUNTRY_ID
inner join TIMES t on t.TIME_ID=sa.TIME_ID
where CHANNEL_DESC in('Internet','Direct Sales') and co.COUNTRY_ISO_CODE in ('FR','US')
and t.CALENDAR_MONTH_NAME='September' and t.CALENDAR_YEAR='2000'
group by cube(cha.CHANNEL_DESC,co.COUNTRY_ISO_CODE)
;


/*ejercicio 2*/
grant all on "HR"."EMPLOYEES" to "SH";
grant all on "HR"."DEPARTMENTS" to "SH" ;
grant all on "HR"."JOBS" to "SH" ;

select department_name,cantidad from(
select d.department_name, MIN(salary) as "menor",sum(salary) as "pro",count(employee_id) as cantidad
from HR.DEPARTMENTS d inner join HR.employees e
on d.DEPARTMENT_ID = e.DEPARTMENT_ID
inner join HR.JOBS j on j.JOB_ID = e.JOB_ID
where j.JOB_title like '%Representative%' group by d.DEPARTMENT_name
having MIN(salary)<sum(salary) and count(employee_id)>5);

/*Ejercicio 3*/
select em.employee_id,em.first_name||' '||em.last_name "Nombre Completo",em.manager_id "Jefe",
(case em.manager_id when 100 then 2
when 101 then 3
when 102 then 2
when 103 then 4
when 114 then 3
when 108 then 4
end) as Nivel
from HR.EMPLOYEES em,HR.EMPLOYEES je
where je.EMPLOYEE_ID=em.MANAGER_ID
order by em.employee_id asc; union



select emp.employee_id,em.first_name||' '||emp.last_name "Nombre Completo",emp.manager_id "Jefe",
1 as Nivel
from HR.EMPLOYEES emp
where emp.manager_id is null

;

