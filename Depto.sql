/*Correr procedimiento, con esquema SCOTT */
/*Busca segun el codigo de depto, el nombre y ubicacion de dicho departamento*/
create or replace procedure Depto(cod dept.deptno%type)
is
 r dept%rowtype;
 contador number;
 
begin
 select * into r 
 from dept 
 where deptno=cod;
 
 select count(*) into contador 
 from dept 
 where deptno=cod;
 
 if contador=1 then
 --dbms_output.put_line('Codigo: '||r.deptno);
 dbms_output.put_line('DEPARTAMENTO '||r.deptno);
 dbms_output.put_line('Nombre: '||r.dname);
 dbms_output.put_line('Localizacion: '||r.loc);
 end if;
 exception
 when NO_DATA_FOUND then
 dbms_output.put_line('NO EXISTE DEPARTAMENTO');
end;

set serveroutput on;

execute depto(11); --Ver funcionamiento
execute depto(10); --Ver funcionamiento
