--select * from partidos;
--select * from calendario;
--select * from rondas;
--insert into rondas (fecha, anho, numero_ronda) values ('12-11-2001', 2001, 3);
--insert into calendario(id_ronda, id_cancha, hora) values (currval('rondas_id_ronda_seq'), 1, '18:00');
--insert into partidos (id_calendario, id_equipo1, id_equipo2) values (currval('calendario_id_calendario_seq'),16,18);
--select * from rondas where id_ronda=currval('rondas_id_ronda_seq');
--select * from f_ronda1();
CREATE OR REPLACE FUNCTION f_ronda1()
RETURNS void AS
$BODY$
declare
a record;
b record;
begin
	for a in(select id_partido, id_equipo1, id_equipo2 from partidos p
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
