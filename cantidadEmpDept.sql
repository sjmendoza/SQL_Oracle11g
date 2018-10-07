/*Correr cursor y procedimiento, con esquema SCOTT */

/*Para permitir salida estandar y mostrar la informacion al ejecutar el cursor*/
set serveroutput on;

/*Cursor para mostrar cantidad de empleados en cada departamento de la empresa*/
declare
 cursor candep is select initcap(dname) "Nombre",count(empno) as Cantidad from emp e join dept d on e.deptno=d.deptno
 group by dname;
 v_nombre varchar2(30);
 v_cantidad number;
 
begin
 open candep;
 fetch candep into v_nombre,v_cantidad;
 dbms_output.put_line('CANTIDAD DE EMPLEADOS POR DEPARTAMENTO EN LA EMPRESA');
 while candep%found 
 loop
 exit when candep%notfound;
 dbms_output.put_line('Departamento '||v_nombre||': '||v_cantidad||' empleados');
 fetch candep into v_nombre,v_cantidad;
 end loop;
 close candep;
end;


/*Procedimiento con cursor para mostrar cantidad de empleados en cada departamento de la empresa*/
create or replace procedure deptCant
is 
 cursor candep is select initcap(dname) "Nombre",count(empno) as Cantidad from emp e join dept d on e.deptno=d.deptno
 group by dname;
 v_nombre varchar2(30);
 v_cantidad number;
 
begin
open candep;
 fetch candep into v_nombre,v_cantidad;
 dbms_output.put_line('Cantidad de empleados por departamento');
 while candep%found 
 loop
 exit when candep%notfound;
 dbms_output.put_line('Departamento '||v_nombre||': '||v_cantidad||' empleados');
 fetch candep into v_nombre,v_cantidad;
 end loop;
 close candep;
end;

/*Para permitir salida estandar y mostrar la informacion al ejecutar el procedimiento*/
set serveroutput on;

/*Ejecutar el procedimiento*/
execute deptcant;