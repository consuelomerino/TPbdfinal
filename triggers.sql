-- triggers
-- funcion que agrega si o si como iniciado el estado del torneo
CREATE OR REPLACE FUNCTION f_tbi_torneo() 
RETURNS TRIGGER 
AS $$
DECLARE 
pnombretorneo character varying(30);
    BEGIN
	--no se puede agregar un torneo si algun otro está en proceso
	pnombretorneo:=(select distinct nombre_torneo from torneos where estado='Iniciado' or estado='EnProceso' limit 1);
	if pnombretorneo is not NULL then
		raise exception 'No pueden haber mas de dos torneos en proceso al mismo tiempo';
	end if;
	new.estado:='Iniciado';
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tbi_torneo before insert on torneos for each row
execute procedure f_tbi_torneo();

-- funcion de error para que hora no sea null
CREATE OR REPLACE FUNCTION f_tbi_calendario()
RETURNS TRIGGER 
AS $$
DECLARE 
chora integer;
coincidencia time;
intervalo interval;
    BEGIN
	--no pueden haber dos con el mismo lugar y la misma hora en la misma fecha
	--los partidos duran 3 HORAS cada uno
	--tiene que tener horario si o si
	if new.hora IS NULL then
		raise exception 'Debe especificar hora';
	end if;
	--guarda la cantidad de veces que encuentra partidos en la cancha en una ronda especifica
	chora=(select count(hora) from calendario where id_ronda=new.id_ronda and id_cancha=new.id_cancha); 
	--si es que existen dos o mas coincidencias, no se pueden agregar mas partidos a la misma cancha
	if chora >= 2 then
		raise exception 'solo se pueden jugar dos partidos por cancha';
	end if;
	--guarda la hora que coincide si es que hay una hora con la que puede coincidir
	if chora=1 then
		coincidencia=(select hora from calendario where id_ronda=new.id_ronda and id_cancha=new.id_cancha);
		--calcula el intervalo
		intervalo=coincidencia - new.hora;
		--si es que el intervalo es negativo, lo vuelve positivo
		if intervalo < INTERVAL '0 hours' then
			intervalo=intervalo*-1;
		end if;
		--si es que el intervalo entre los dos partidos es menor de tres horas
		--entonces no se puede agregar
		if intervalo < INTERVAL '3 hours' then
			raise exception 'partidos se solapan en horario!';
		end if;
	end if; 
	RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tbi_calendario before insert on calendario for each row
execute procedure f_tbi_calendario();

CREATE OR REPLACE FUNCTION f_tbi_partido()
RETURNS TRIGGER 
AS $$
    BEGIN
		--cera los puntajes
		new.puntaje1=0;
		new.puntaje2=0;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tbi_partido before insert on partidos for each row
execute procedure f_tbi_partido();

CREATE OR REPLACE FUNCTION f_tbi_planilla()
RETURNS TRIGGER 
AS $$
DECLARE 
equipo integer;
    BEGIN
	--si o si tiene que ser titular (true) o suplente (false)
	if new.fue_titular IS NULL then
		raise exception 'Debe especificar si es Titular, "1" o Suplente, "0"';
	end if;
	--corroborar que el jugador es del equipo
	equipo:=(select distinct p.id_equipo from planillas p join jugadores j 
					on j.ci_jugador = new.ci_jugador and p.id_equipo = j.id_equipo);
	if new.id_equipo != equipo then
		raise exception 'Jugador no válido, no asociado al equipo ingresado';
	end if;
	RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tbi_planilla before insert on planillas for each row
execute procedure f_tbi_planilla();

CREATE OR REPLACE FUNCTION f_tbi_goles()
RETURNS TRIGGER 
AS $$
DECLARE
p_fecha date;
p_jugador integer;
    BEGIN
		--ver que los goles que se inserten son de la fecha actual
		p_fecha:=(select r.fecha from goles_x_jugador g
				join planillas p on g.id_planilla=p.id_planilla
				join partidos pa on p.id_partido=pa.id_partido
				join rondas r on r.id_ronda=pa.id_ronda limit 1);
		if p_fecha IS NULL then
			raise exception 'No se pueden agregar goles fuera de fecha';
		end if;
		--ver si el jugador está inscripto en el partido
		p_jugador:=(select distinct p.ci_jugador from planillas p
					join goles_x_jugador g on p.id_planilla=g.id_planilla
					where p.ci_jugador=new.ci_jugador);
		if p_jugador is NULL then
			raise exception 'Jugador no inscripto en el partido!!!';
		end if;
		--cerar los resultados de los goles del jugador si es que no se pasa algún parámetro
		if new.a_favor IS NULL then
			new.a_favor=0;
		end if;
		if new.contra IS NULL then
			new.contra=0;
		end if;

		--ver que el jugador este en planilla!!!
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tbi_goles before insert on goles_x_jugador for each row
execute procedure f_tbi_goles();

CREATE OR REPLACE FUNCTION f_tai_goles()
RETURNS TRIGGER 
AS $$
    BEGIN
		--arreglar p q no sea a fuerza bruta
		--agrega goles del equipo1 al puntaje1 que son a favor
		update partidos p set puntaje1=puntaje1+new.a_favor 
						where id_partido=(select distinct p.id_partido from planillas p
											join goles_x_jugador g on g.id_planilla=p.id_planilla
											where p.id_planilla=new.id_planilla)
						and id_equipo1=(select distinct id_equipo from jugadores j
											join goles_x_jugador g on j.ci_jugador = g.ci_jugador where g.ci_jugador=new.ci_jugador);
		--agrega goles del equipo1 al puntaje2, goles en contra
		update partidos p set puntaje2=puntaje2+new.contra 
						where id_partido=(select distinct p.id_partido from planillas p
											join goles_x_jugador g on g.id_planilla=p.id_planilla
											where p.id_planilla=new.id_planilla)
						and id_equipo1=(select distinct id_equipo from jugadores j
										join goles_x_jugador g on j.ci_jugador = g.ci_jugador where g.ci_jugador=new.ci_jugador);
		--agrega goles del equipo2 al puntaje2 que son a favor
		update partidos p set puntaje2=puntaje2+new.a_favor
						where id_partido=(select distinct p.id_partido from planilla p
											join goles_x_jugador g on g.id_planilla=p.id_planilla
											where p.id_planilla=new.id_planilla) 
						and id_equipo2=(select distinct id_equipo from jugadores j
										join goles_x_jugador g on j.ci_jugador = g.ci_jugador where g.ci_jugador=new.ci_jugador);
		--agrega goles del equipo1 al puntaje2, goles en contra
		update partidos p set puntaje1=puntaje1+new.contra 
						where id_partido=(select distinct p.id_partido from planilla p
											join goles_x_jugador g on g.id_planilla=p.id_planilla
											where p.id_planilla=new.id_planilla)
						and id_equipo2=(select distinct id_equipo from jugadores j
										join goles_x_jugador g on j.ci_jugador = g.ci_jugador where g.ci_jugador=new.ci_jugador);										

    RETURN NULL;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tai_goles after insert on goles_x_jugador for each row
execute procedure f_tai_goles();

CREATE OR REPLACE FUNCTION f_tad_goles()
RETURNS TRIGGER 
AS $$
    BEGIN
	--restan los valores a los resultados del partido
	--que no sea tan a la fuerza bruta
	update partidos p set puntaje1=puntaje1-old.a_favor 
						where id_partido=(select distinct p.id_partido from planillas p
											join goles_x_jugador g on g.id_planilla=p.id_planilla
											where p.id_planilla=old.id_planilla)
						and id_equipo1=(select distinct id_equipo from jugadores j
											join goles_x_jugador g on j.ci_jugador = g.ci_jugador 
											where g.ci_jugador=old.ci_jugador);
		--agrega goles del equipo1 al puntaje2, goles en contra
		update partidos p set puntaje2=puntaje2-old.contra 
						where id_partido=(select distinct p.id_partido from planillas p
											join goles_x_jugador g on g.id_planilla=p.id_planilla
											where p.id_planilla=old.id_planilla)
						and id_equipo1=(select distinct id_equipo from jugadores j
										join goles_x_jugador g on j.ci_jugador = g.ci_jugador 
										where g.ci_jugador=old.ci_jugador);
		--agrega goles del equipo2 al puntaje2 que son a favor
		update partidos p set puntaje2=puntaje2-old.a_favor
						where id_partido=(select distinct p.id_partido from planillas p
											join goles_x_jugador g on g.id_planilla=p.id_planilla
											where p.id_planilla=old.id_planilla) 
						and id_equipo2=(select distinct id_equipo from jugadores j
										join goles_x_jugador g on j.ci_jugador = g.ci_jugador 
										where g.ci_jugador=old.ci_jugador);
		--agrega goles del equipo1 al puntaje2, goles en contra
		update partidos p set puntaje1=puntaje1-old.contra 
						where id_partido=(select distinct p.id_partido from planillas p
											join goles_x_jugador g on g.id_planilla=p.id_planilla
											where p.id_planilla=old.id_planilla)
						and id_equipo2=(select distinct id_equipo from jugadores j
										join goles_x_jugador g on j.ci_jugador = g.ci_jugador 
										where g.ci_jugador=old.ci_jugador);										

    RETURN NULL;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tad_goles after delete on goles_x_jugador for each row
execute procedure f_tad_goles();
