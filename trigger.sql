/*Crear una funcion para que en la tabla salario total por depto cada vez que se ingrese un nuevo empleado
se actualice ahi, segun codigo*/
create or replace function costo(cod in number) return number
is
 v_sal number;
 v_deptno number;
begin
 select deptno,sum(sal) as Salario into v_deptno,v_sal from emp where deptno=cod group by deptno;
 return v_sal;
end costo ;


set serveroutput on;
declare
salario number;
begin
 salario:=costo(10);
 dbms_output.put_line(salario);
end;


create or replace trigger ActualizarCosto
after insert on emp
referencing old as old new as new
for each row

declare
filas number;
salario number;
begin
 salario:=costo(:old.deptno);
 if inserting then

    insert into costodepto values(:new.deptno,salario);
    dbms_output.put_line('Exito, procesado');

 end if;
end;
