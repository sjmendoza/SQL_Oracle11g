 
/*Funcion de Saludo desde X lugar que reciba como mensaje*/
CREATE OR REPLACE FUNCTION 
fmensaje(place_in IN VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   RETURN '¡Hola ' || place_in;
END fmensaje;

set serveroutput on;

/*Ejecucion de funcion*/
declare
 mensaje varchar2(50);
begin
mensaje:=fmensaje('desde El Salvador te saludamos!');
dbms_output.put_line(mensaje);
end;
