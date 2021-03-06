/*Correr procedimiento, con esquema SCOTT; el siguiente proceso
lo que realiza es insertar datos a la tabla dept, si los datos no
son duplicados; se procesan e insertan, sino muestra mensaje de duplicacion
de datos*/
create or replace procedure insercion(cod number,nom varchar2,loc varchar2)
is
 copiadep dept%rowtype;

begin
 insert into dept values(cod,nom,loc);
 commit;
 select * into copiadep from dept
 where deptno = cod;
 
 dbms_output.put_line('Datos procesados con exito');
 dbms_output.put_line('Se insertaron los siguientes datos:');
 dbms_output.put_line('Codigo:'||copiadep.deptno);
 dbms_output.put_line('Depto: '||copiadep.dname);
 dbms_output.put_line('Ubicación: '||copiadep.loc);
 exception
 when Dup_Val_ON_INDEX 
 then
 dbms_output.put_line('Datos duplicados, no se procesaran');
end;

/*Estos datos sirven de prueba para el procedimiento almacenado
Si intenta correr por segunda vez cualquiera de los 2
lanzara mensaje de duplicado de datos*/
set serveroutput on;

execute insercion(60,'TI','El Salvador');
execute insercion(70,'Gerencia','El Salvador');
