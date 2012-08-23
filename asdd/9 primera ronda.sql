

--inserta todos los jugadores en las planillas de una de todos los equipos que participan en esa ronda
CREATE OR REPLACE FUNCTION f_ronda1()
RETURNS void AS
$BODY$
declare
a record;
b record;
begin
	for a in (select id_partido, id_equipo1, id_equipo2 from partidos p
			join calendario c on p.id_calendario=c.id_calendario
			where c.id_ronda=currval('rondas_id_ronda_seq'))
	loop
		perform f_insertar_jugador(a.id_partido, 1, a.id_equipo1);
		perform f_insertar_jugador(a.id_partido, 2, a.id_equipo1);
		perform f_insertar_jugador(a.id_partido, 3, a.id_equipo1);
		perform f_insertar_jugador(a.id_partido, 4, a.id_equipo1);
		perform f_insertar_jugador(a.id_partido, 5, a.id_equipo1);
		perform f_insertar_jugador(a.id_partido, 6, a.id_equipo1);
		perform f_insertar_jugador(a.id_partido, 7, a.id_equipo1);
		perform f_insertar_jugador(a.id_partido, 8, a.id_equipo1);
		perform f_insertar_jugador(a.id_partido, 9, a.id_equipo1);
		perform f_insertar_jugador(a.id_partido, 10, a.id_equipo1);
		perform f_insertar_jugador(a.id_partido, 11, a.id_equipo1);
		perform f_insertar_jugador(a.id_partido, 1, a.id_equipo2);
		perform f_insertar_jugador(a.id_partido, 2, a.id_equipo2);
		perform f_insertar_jugador(a.id_partido, 3, a.id_equipo2);
		perform f_insertar_jugador(a.id_partido, 4, a.id_equipo2);
		perform f_insertar_jugador(a.id_partido, 5, a.id_equipo2);
		perform f_insertar_jugador(a.id_partido, 6, a.id_equipo2);
		perform f_insertar_jugador(a.id_partido, 7, a.id_equipo2);
		perform f_insertar_jugador(a.id_partido, 8, a.id_equipo2);
		perform f_insertar_jugador(a.id_partido, 9, a.id_equipo2);
		perform f_insertar_jugador(a.id_partido, 10, a.id_equipo2);
		perform f_insertar_jugador(a.id_partido, 11, a.id_equipo2);
	end loop;
	end;
$BODY$
LANGUAGE plpgsql VOLATILE;

--busca el ci del enesimo jugador en el equipo que se le pasa como parametro

CREATE OR REPLACE FUNCTION f_jugador(numero integer, equipo integer)
RETURNS integer AS
$BODY$
declare
ci integer;
begin
	ci:=(select ci_jugador from jugadores where id_equipo=equipo limit 1 offset numero-1);
	return ci;
end;
$BODY$
LANGUAGE plpgsql VOLATILE;








CREATE OR REPLACE FUNCTION f_golesronda1()
RETURNS void AS
$BODY$
declare
a record;
begin
	for a in (select id_partido, id_equipo1, id_equipo2 from partidos p
			join calendario c on p.id_calendario=c.id_calendario
			where c.id_ronda=currval('rondas_id_ronda_seq'))
	loop
		--insertar goles, tiene 4 parametros:
		--el numero de jugador, el numero de equipo, goles a favor, goles en contra
		perform f_insertar_goles(1, a.id_equipo1, 1, 0);
		perform f_insertar_goles(3, a.id_equipo2, 2, 0);
	end loop;
	end;
$BODY$
LANGUAGE plpgsql VOLATILE;








--inserta los jugadores en la planilla de juego
--drop function f_insertar_jugador(integer, integer, integer);
CREATE OR REPLACE FUNCTION f_insertar_jugador(partido integer, numero integer, equipo integer)
RETURNS void AS
$BODY$
declare
ci integer;
begin
		ci:=(select * from f_jugador(numero, equipo));
		insert into planillas 
		(id_partido, ci_jugador, fue_titular, id_equipo)
		values (partido, ci, TRUE, equipo);
end;
$BODY$
LANGUAGE plpgsql VOLATILE;

--inserta los datos de los goles


--drop function f_insertar_goles(integer, integer, integer);
CREATE OR REPLACE FUNCTION f_insertar_goles(numero integer, equipo integer, favor integer, encontra integer)
RETURNS void AS
$BODY$
declare
	p_cijugador integer;
	p_idplanilla integer;
	p_partido integer;
begin
	
		--busca un jugador con tal numero del equipo y le inserta goles	
		p_cijugador:=(select j.ci_jugador from jugadores j
			where j.id_equipo = equipo offset numero-1 limit 1);
		p_partido:=(select p.id_partido from partidos p
				join calendario c on p.id_calendario=c.id_calendario
				join rondas r on c.id_ronda=r.id_ronda
				where r.id_ronda=currval('rondas_id_ronda_seq') and (p.id_equipo1=equipo or p.id_equipo2=equipo));
		p_idplanilla:=(select p.id_planilla from planillas p
				where p.ci_jugador=p_cijugador and p.id_partido=p_partido);
		--inserta goles en la la casilla del jugador correspondiente
		insert into goles_x_jugador 
			(id_planilla, a_favor, contra)
			values (p_idplanilla, favor, encontra);
end;
$BODY$
LANGUAGE plpgsql VOLATILE;

