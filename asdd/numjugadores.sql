CREATE OR REPLACE FUNCTION f_equipodejugador(jugador integer)
RETURNS integer AS
$BODY$
declare
	id integer;
	numero integer;
begin
	id:=(select id_equipo from jugadores 
			where ci_jugador=jugador);
	numero:=(select count(*) from jugadores 
			where id_equipo=id);
	return numero;
	end;
$BODY$
LANGUAGE plpgsql VOLATILE;

CREATE OR REPLACE FUNCTION f_countequipo(equipo integer)
RETURNS integer AS
$BODY$
declare
	numero integer;
begin
	numero:=(select count(*) from jugadores 
			where id_equipo=equipo);
	return numero;
	end;
$BODY$
LANGUAGE plpgsql VOLATILE;

