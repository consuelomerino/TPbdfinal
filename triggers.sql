-- triggers
-- funcion que agrega si o si como iniciado el estado del torneo
CREATE OR REPLACE FUNCTION f_tbi_torneo() 
RETURNS TRIGGER 
AS $$
    BEGIN
		new.estado='inicio';
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tbi_torneo before insert on torneo for each row
execute procedure f_tbi_torneo();

-- funcion de error para que hora no sea null
CREATE OR REPLACE FUNCTION f_tbi_calendario()
RETURNS TRIGGER 
AS $$
    BEGIN
	if new.hora IS NULL then
		raise exception 'Debe especificar hora';
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
		new.puntaje1=0;
		new.puntaje2=0;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tbi_partido before insert on partido for each row
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
	equipo:=(select distinct p.id_equipo from planilla p join jugador j 
					on j.ci_jugador = new.ci_jugador and p.id_equipo = j.id_equipo);
	if new.id_equipo != equipo then
		raise exception 'Jugador no válido, no asociado a algún equipo';
	end if;
	RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tbi_planilla before insert on planilla for each row
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
				join planilla p on g.id_planilla=p.id_planilla
				join partido pa on p.id_partido=pa.id_partido
				join ronda r on r.id_ronda=pa.id_ronda limit 1);
		if p_fecha IS NULL then
			raise exception 'No se pueden agregar goles fuera de fecha';
		end if;
		--ver si el jugador está inscripto en el partido
		p_jugador:=(select distinct p.ci_jugador from planilla p
					join goles_x_jugador g on p.id_planilla=g.id_planilla
					where p.ci_jugador=1);
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
		--agrega goles del equipo1 al puntaje1 que son a favor
		update partido p set puntaje1=puntaje1+new.a_favor 
						where id_partido=(select distinct p.id_partido from planilla p
											join goles_x_jugador g on g.id_planilla=p.id_planilla
											where p.id_planilla=new.id_planilla)
						and id_equipo1=(select distinct id_equipo from jugador j
											join goles_x_jugador g on j.ci_jugador = g.ci_jugador where g.ci_jugador=new.ci_jugador);
		--agrega goles del equipo1 al puntaje2, goles en contra
		update partido p set puntaje2=puntaje2+new.contra 
						where id_partido=(select distinct p.id_partido from planilla p
											join goles_x_jugador g on g.id_planilla=p.id_planilla
											where p.id_planilla=new.id_planilla)
						and id_equipo1=(select distinct id_equipo from jugador j
										join goles_x_jugador g on j.ci_jugador = g.ci_jugador where g.ci_jugador=new.ci_jugador);
		--agrega goles del equipo2 al puntaje2 que son a favor
		update partido p set puntaje2=puntaje2+new.a_favor
						where id_partido=(select distinct p.id_partido from planilla p
											join goles_x_jugador g on g.id_planilla=p.id_planilla
											where p.id_planilla=new.id_planilla) 
						and id_equipo2=(select distinct id_equipo from jugador j
										join goles_x_jugador g on j.ci_jugador = g.ci_jugador where g.ci_jugador=new.ci_jugador);
		--agrega goles del equipo1 al puntaje2, goles en contra
		update partido p set puntaje1=puntaje1+new.contra 
						where id_partido=(select distinct p.id_partido from planilla p
											join goles_x_jugador g on g.id_planilla=p.id_planilla
											where p.id_planilla=new.id_planilla)
						and id_equipo2=(select distinct id_equipo from jugador j
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
	update partido p set puntaje1=puntaje1-old.a_favor 
						where id_partido=(select distinct p.id_partido from planilla p
											join goles_x_jugador g on g.id_planilla=p.id_planilla
											where p.id_planilla=old.id_planilla)
						and id_equipo1=(select distinct id_equipo from jugador j
											join goles_x_jugador g on j.ci_jugador = g.ci_jugador 
											where g.ci_jugador=old.ci_jugador);
		--agrega goles del equipo1 al puntaje2, goles en contra
		update partido p set puntaje2=puntaje2-old.contra 
						where id_partido=(select distinct p.id_partido from planilla p
											join goles_x_jugador g on g.id_planilla=p.id_planilla
											where p.id_planilla=old.id_planilla)
						and id_equipo1=(select distinct id_equipo from jugador j
										join goles_x_jugador g on j.ci_jugador = g.ci_jugador 
										where g.ci_jugador=old.ci_jugador);
		--agrega goles del equipo2 al puntaje2 que son a favor
		update partido p set puntaje2=puntaje2-old.a_favor
						where id_partido=(select distinct p.id_partido from planilla p
											join goles_x_jugador g on g.id_planilla=p.id_planilla
											where p.id_planilla=old.id_planilla) 
						and id_equipo2=(select distinct id_equipo from jugador j
										join goles_x_jugador g on j.ci_jugador = g.ci_jugador 
										where g.ci_jugador=old.ci_jugador);
		--agrega goles del equipo1 al puntaje2, goles en contra
		update partido p set puntaje1=puntaje1-old.contra 
						where id_partido=(select distinct p.id_partido from planilla p
											join goles_x_jugador g on g.id_planilla=p.id_planilla
											where p.id_planilla=old.id_planilla)
						and id_equipo2=(select distinct id_equipo from jugador j
										join goles_x_jugador g on j.ci_jugador = g.ci_jugador 
										where g.ci_jugador=old.ci_jugador);										

    RETURN NULL;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tad_goles after delete on goles_x_jugador for each row
execute procedure f_tad_goles();
