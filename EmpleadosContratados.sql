/*Procedimiento en el cual hace una lista de los empleados y el puesto que poseen, segun
el anio de contratacion y la cantidad de ellos que se contrataron ese anio*/
create or replace procedure EmpleadosAnio(anio number)
is
 cursor contratado is select to_char(hiredate,'YYYY') as Anio, ename,job
 from emp where to_char(hiredate,'YYYY')=anio;
 copiaempe contratado%rowtype;
begin
 if not contratado%isopen then
 open contratado;
 end if;
 
 loop
  fetch contratado into copiaempe;
  exit when contratado%notfound;
  dbms_output.put_line('---------------------');
  dbms_output.put_line('Empleado: '||copiaempe.ename);
  dbms_output.put_line('Puesto: '||copiaempe.job);

 end loop;
   dbms_output.put_line('');
   dbms_output.put_line('Total de empleados contratados en el anio '||anio|| ': '||contratado%rowcount);
 close contratado;
end;

set serveroutput on;
execute EmpleadosAnio(1981);
