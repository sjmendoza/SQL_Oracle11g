/*El siguiente procedimiento almacenado, aumenta el salario de los empleados
siempre y cuando ese salario sea mayor o igual el salario que usted decida aumentar
y cuanto mas de lo que posee, por ejemplo aqui mas abajo se define que sean mayor
o igual $3000 y que a esos se les aumente $200; por lo tanto todos esos empleados
con dicha condicion, seran afectados */
create or replace 
procedure aumentar(salario emp.sal%type,salNuevo emp.sal%type)
is
 cursor empleado is select * from emp where sal>=salario;
  salAnterior emp%rowtype;
  --salNuevo number;
  i number;
begin
 if not empleado%IsOpen
 then
 open empleado;
 end if;
 --salNuevo:=100;
 i:=1;
 loop
  fetch empleado into salAnterior;
  exit when empleado%notfound;
  update emp set sal=salAnterior.sal+salNuevo
  where sal=salAnterior.sal;
  i:=i+1;
 
 end loop;
  dbms_output.put_line('¡Actualizado! '||empleado%rowcount||' empleados han sido afectados');
  dbms_output.put_line('Los empleados con salario arriba o igual a $'||salario||' tendra un aumento de $'||salNuevo||' mas');
 close empleado;
 dbms_output.put_line('Operacion con éxito');
end;

set serveroutput on;

/*Ejecutar procedimiento*/
execute aumentar(3000,200);



