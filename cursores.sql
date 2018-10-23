create table planillames(
anio number(4),
mes number(2),
deptno number(2),
emps number(2) not null,
planilla number(10,2) not null,
constraint pk_planillames primary key(anio,mes,deptno)
);

/*Ahora desarrollaremos un procedimiento para generar 
la planilla de un determinado mes. Este procedimiento 
debe verificar si la planilla ya fue generada.*/
create or replace procedure pplanilla(p_anio number,p_mes number)
is
 cursor c_dept is select deptno from dept;
 v_deptno dept.deptno%type; /*la variable local es del tipo de la variable deptno de la tabla DEPT*/
 contar number; /*Es una variable que cuenta si la planilla ya se proceso*/
 v_emps number;/*Variable local numerica que contendra el numero de empleados por depto*/
 v_planilla number;/*Variable local numerica que contendra la suma del salario de los empleados por depto*/
begin
 select count(*) into contar/*cuenta segun lo que hay */
 from planillames /*En la tabla planillames*/
 where anio=p_anio and mes=p_mes;/*Y segun el anio y mes en las que esta siendo procesada y esto lo introduce en la variable contar*/
 if(contar>0)/*Valida si hay o no datos en la planilla segun sentencia anterior*/
  then
   dbms_output.put_line('La planilla del año '||p_anio||' y mes '||p_mes||' ya fue procesada');
   return;
 end if;
 open c_dept;/*Cursor que contiene los numeros de dept*/
 fetch c_dept into v_deptno;/*recorre el cursor e introduce el numero de dept en la variable local*/
 while c_dept%found/*Mientras la ultima sentencia del fetch tiene exito el entrara al loop*/
  loop
   select count(*),sum(sal) into v_emps,v_planilla/*contara los empleados y sumara el salario por dept*/
   from emp/*v_emps almacena el contador de empleados y v_planilla acumula el salario por dept*/
   where deptno=v_deptno;/*Evalua el deptno donde esta para conar segun el depto donde se encuentra*/
   insert into planillames/*Insercion de datos en la planillames*/
   values (p_anio,p_mes,v_deptno,v_emps,nvl(v_planilla,0));
   fetch c_dept into v_deptno;/*recorre nuevamente para pasar al siguiente valor e introducirlo en la variable local*/
  end loop;
  close c_dept;
  commit;
  dbms_output.put_line('Procesado');
end;



create or replace procedure MuestraEmail
is
 cursor c_email is select * from emp;
 email emp%rowtype;
begin
 open c_email;
 loop
  fetch c_email into email;
  exit when c_email%notfound;
  dbms_output.put_line('Correo:'||email.ename||'@'||email.job||'.SST.com.sv');
 end loop;
end;

set serveroutput on;
execute  Muestraemail;

/*Crear de todos automaticamente email*/
create or replace procedure crearEmail(codigo number)
is
 cursor c_email is select ename from emp;
 v_ename emp.ename%type;
 v_user varchar2(15);
 v_email varchar2(50);
 contador number;
begin
  select ename into v_ename from emp where empno=codigo;
  select count(*) into contador
  from email
  where nombreuser =v_ename ;
 if (contador > 0) then
  dbms_output.put_line('Ya esta procesado');
 return;
 end if;
 open c_email;
 fetch c_email into v_ename;
 while c_email%found 
  loop
   select ename,ename||'@'||job||'.SST.com.sv' "Email" into v_user,v_email
   from emp where ename=v_ename;
   insert into email
   values(v_user,v_email,v_user||'123');
    fetch c_email into v_ename ;
  end loop;
  close c_email;
  commit;
  dbms_output.put_line('Proceso ok.');
end;








set serveroutput on;
execute crearEmailUser(1234)
select * from email
select * from emp

/*Crear email segun trabajado*/


create or replace procedure crearEmailUser(codigo number)
is
 cursor c_email is select ename from emp where empno=codigo;
 v_ename emp.ename%type;
 v_user varchar2(15);
 v_email varchar2(50);
begin
   select ename into v_ename from emp where empno=codigo;
   open c_email;
   fetch c_email into v_ename;
   select ename,ename||'@'||nvl(job,ename)||'.SST.com.sv' "Email" into v_user,v_email
   from emp where ename=v_ename;
   insert into email
   values(v_user,v_email,v_user||'123');
   fetch c_email into v_ename ;
  close c_email;
  commit;
  dbms_output.put_line('Su email se ha creado con exito');
   Exception
  When No_Data_Found Then
  DBMS_Output.Put_Line('Codigo de empleado no existe' );
  When DUP_VAL_ON_INDEX then
  dbms_output.put_line('Ya existe registro');
end;



set serveroutput on;

/*Muestra de una mejor forma la informacion de los 
empleados con salarios mayores o iguales a lo indicado*/
declare 
 cursor c1(salario number) is select *
 from emp where sal>=salario;
 copiaemp emp%rowtype;
begin
 if not c1%isopen
  then open c1(3000);
 end if;
  loop
   fetch c1 into copiaemp;
   exit when c1%notfound;
   dbms_output.put_line('Numero de empleado:'||copiaemp.empno);
   dbms_output.put_line('Nombre:'||copiaemp.ename);
   dbms_output.put_line('Puesto:'||copiaemp.job);
   dbms_output.put_line('Salario:$'||copiaemp.sal);
   dbms_output.put_line('-------------------------');
  end loop;
  close c1;
end;


/*Mostrarme la informacion de los empleados*/
declare
 cursor informacion is 
  select empno,ename,job,sal
  from emp
  where sal>=2000;
 numero emp.empno%type;
 nombre emp.ename%type;
 puesto emp.job%type;
 salario emp.sal%type;
begin
 if not informacion%isopen
 then
  open informacion;
 end if;
 loop
 fetch informacion into numero,nombre,puesto,salario;
 exit when informacion%notfound or informacion%notfound is null;
  dbms_output.put_line('-------------------------');
  dbms_output.put_line('Numero de empleado:'||numero);
   dbms_output.put_line('Nombre:'||nombre);
   dbms_output.put_line('Puesto:'||puesto);
   dbms_output.put_line('Salario:$'||salario);
   dbms_output.put_line('-------------------------');
 end loop;
end;


/*Informacion de todos los empleados*/
declare
 cursor infor is select empno,ename,job,sal,dname
 from emp inner join dept on emp.deptno=dept.deptno
 /*where sal>2000*/;
 registro infor%rowtype;
begin
 if not infor%isopen
  then
   open infor;
 end if;
 loop
  fetch infor into registro;
  exit when infor%notfound;
  dbms_output.put_line('--------------------------');
  dbms_output.put_line('Numero:'||registro.empno);
  dbms_output.put_line('Nombre:'||registro.ename);
  dbms_output.put_line('Departamento:'||registro.dname);
  dbms_output.put_line('Puesto:'||registro.job);
  dbms_output.put_line('Salario:$'||registro.sal);
  /*dbms_output.put_line('--------------------------');*/
 end loop;
 close infor;
end;


/*Mostrar el nombre del dept,numero,cantidad empleados,salario total por depto*/
declare
 cursor consolidado is select dept.deptno,dname,count(empno) as cantidad,sum(sal) as SalarioAcum
 from emp inner join dept on dept.deptno=emp.deptno
 group by dept.deptno,dname;
 registro consolidado%rowtype;
begin
 if not consolidado%isopen
  then
   open consolidado;
 end if;
 loop
  fetch consolidado into registro;
  exit when consolidado%notfound;
  dbms_output.put_line('-----------------------------------');
  dbms_output.put_line('Departamento:'||registro.dname);
  dbms_output.put_line('Nº:'||registro.deptno);
  dbms_output.put_line('Cantidad de empleados:'||registro.cantidad);
  dbms_output.put_line('Salario total:$'||registro.SalarioAcum);
 end loop;
 close consolidado;
end;



set serveroutput on;

/*Procedimiento almacenado en donde me diga segun el depto,
Mostrar el nombre del dept,numero,cantidad empleados,salario 
total por depto*/
create or replace procedure informacion(codigo dept.deptno%type)
is
 nombred dept.dname%type;
 numerod dept.deptno%type;
 cantidad number;
 salario number;
begin
 cantidad:=0;
 salario:=0;
 select dname,dept.deptno,count(empno) as cantidad,sum(sal) as SalarioAcum
 into nombred,numerod,cantidad,salario 
 from emp inner join dept on dept.deptno=emp.deptno
 where dept.deptno=codigo group by dept.deptno,dname;
 dbms_output.put_line('Departamento:'||nombred);
 dbms_output.put_line('Nº:'||numerod);
 dbms_output.put_line('Cantidad de empleados:'||cantidad);
 dbms_output.put_line('Salario total del departamento:$'||salario);
 exception 
 when No_Data_Found Then
  DBMS_Output.Put_Line('Codigo de departamento no existe' );
end;


/*/*Procedimiento almacenado en donde me diga segun el depto,
Mostrar el nombre del dept,numero,cantidad empleados,salario 
total por depto con un cursor*/
create or replace procedure info(codigo dept.deptno%type)
is
 cursor informacion(codigo dept.deptno%type) is
 select dname,dept.deptno,count(empno) as cantidad,sum(sal) as salario
 from emp inner join dept on emp.deptno=dept.deptno
 where dept.deptno=codigo group by dname,dept.deptno;
 registro informacion%rowtype;
begin
 if not informacion%isopen
 then
 open informacion(codigo);
 end if;
  fetch informacion into registro;
  if informacion%notfound
  then
    dbms_output.put_line('No existe departamento');
 -- exit when informacion%notfound;
 else
  dbms_output.put_line('------------------------');
  dbms_output.put_line('Departamento:'||registro.dname);
  dbms_output.put_line('N:'||registro.deptno);
  dbms_output.put_line('Cantidad de empleado:'||registro.cantidad);
  dbms_output.put_line('Salario total en el departamento:$'||registro.salario);
 close informacion;
 end if;
 exception
 when NO_DATA_FOUND then
 dbms_output.put_line('No existe departamento');
end;


/*Mostrar el nombre del dept,numero,cantidad empleados,salario total por depto sin CURSOR*/
create or replace procedure datosDepto
is
 nombre dept.dname%type;
 codigo dept.deptno%type;
 cantidad number;
 salarioT number;
begin
 select dname,dept.deptno,count(empno) as cantidad,sum(sal) as salario
 --into nombre,codigo,cantidad,salarioT
 from emp inner join dept on emp.deptno=dept.deptno
 group by dept.deptno,dname;
 dbms_output.put_line('Departamento:'||nombre);
 dbms_output.put_line('Nº:'||codigo);
 dbms_output.put_line('Cantidad de empleados:'||cantidad);
 dbms_output.put_line('Salario:$'||salarioT);
 end loop;
end;




set serveroutput on;
execute datosDepto

execute informacion(0);
execute info(30);








select * from emp join email on ename=nombreuser
delete from emp where empno=1234
rollback

/*Disparador que hace copia de los datos eliminados y la hora de eliminacion*/
create or replace trigger Eliminar
before delete on emp
referencing old as old
for each row

declare

begin
 if deleting then
  insert into empdelete values(:old.empno,:old.ename,user,sysdate);
  delete from email where nombreuser=:old.ename;
 end if;
end;

create table EmpDelete(
empno number not null,
ename varchar2(20),
rol varchar2(20),
fecha date,
constraint pk_empno primary key(empno)
);


alter session set nls_date_format='dd-Mon-YYYY HH24:MI:SS';
select sysdate from dual
select * from emp



/*Me muestra los empleados contratados entre los años 80 y 89*/

select 
(select count(empno) from emp where to_char(hiredate,'YY')= '80') "Año 80",
(select count(empno) from emp where to_char(hiredate,'YY')='81') "Año 81",
(select count(empno) from emp where to_char(hiredate,'YY')='82') "Año 82",
(select count(empno) from emp where to_char(hiredate,'YY')='83') "Año 83",
(select count(empno) from emp where to_char(hiredate,'YY')='84') "Año 84",
(select count(empno) from emp where to_char(hiredate,'YY')='85') "Año 85",
(select count(empno) from emp where to_char(hiredate,'YY')='86') "Año 86",
(select count(empno) from emp where to_char(hiredate,'YY')='87') "Año 87",
(select count(empno) from emp where to_char(hiredate,'YY')='88') "Año 88",
(select count(empno) from emp where to_char(hiredate,'YY')='89') "Año 89",
(select count(empno) from emp) "TOTAL EMPLEADOS"
from dual;

/*Cantidad de empleados segun año de contratacion */
declare
 cursor fechas is
 select to_char(hiredate,'YYYY') as Año , count(empno) as Cantidad from emp
 group by to_char(hiredate,'YYYY')
 order by to_char(hiredate,'YYYY') asc;
 v_fechas fechas%rowtype;

begin
 open fechas;
 loop
 fetch fechas into v_fechas;
 exit when fechas%notfound;
 dbms_output.put_line('Año '||v_fechas.Año||' cantidad: '||v_fechas.cantidad);
 end loop;
 close fechas;
end;

/*Proceso almacenado que me muestra la cantidad de empleados segun año de contratacion que se le envia*/

create or replace procedure CantidadEmpleados(fecha varchar2)
is
 cursor c_fecha is 
 select to_char(hiredate,'YYYY') as anio 
 from emp where to_char(hiredate,'YYYY')=fecha; 
 v_fecha varchar2(10);
 v_ani varchar2(10);
 v_cantidad number;
 
begin
 if not c_fecha%isopen
 then
  open c_fecha;
 end if;
 fetch c_fecha into v_fecha;
 select to_char(hiredate,'YYYY') as ano,count(empno) as cantidad
 into v_ani,v_cantidad
 from emp
 where to_char(hiredate,'YYYY')=v_fecha
 group by to_char(hiredate,'YYYY');
 dbms_output.put_line('Año '||v_ani||' cantidad:'||v_cantidad);
 close c_fecha;
end;




/**/
set serveroutput on;
execute cantidadEmpleados('1987')


declare
 cursor fechas is
 select to_char(hiredate,'YYYY') as Año from emp
 where to_char(hiredate,'YYYY')='1980';
 v_fechas fechas%rowtype;

begin
 open fechas;
 loop
 fetch fechas into v_fechas;
 exit when fechas%notfound;
 dbms_output.put_line('Año '||v_fechas.Año);
 end loop;
 close fechas;
end;


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




/*Paquetes*/
create or replace package empleados
as
cursor ma return emp%rowtype;
end empleados;

create or replace package body empleados
as
cursor ma return emp%rowtype 
is select * from emp where sal>=2000;
end empleados;




/*Paquete con la funcion suma*/
CREATE OR REPLACE PACKAGE testpackage as 
function suma( n1 in number, n2 in number ) return number; 
END testpackage; 
 
CREATE OR REPLACE PACKAGE BODY testpackage as 
function suma( n1 in number, n2 in number ) return number 
as 
rtn number; 
begin 
rtn := n1 + n2; 
return rtn; 
end; 
END testpackage; 
 
select testpackage.suma( 12,13) from dual;  
