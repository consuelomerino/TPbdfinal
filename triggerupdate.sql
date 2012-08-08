CREATE OR REPLACE FUNCTION f_tbu_torneo() RETURNS TRIGGER AS $$
    BEGIN
	--no se puede modificar el anho
	if old.anho != new.anho then
		raise exception 'no se puede cambiar el año';
	end if;
	--no se puede cambiar nada una vez que el torneo este finalizado
	if old.estado = 'terminado' then
		raise exception 'no se puede hacer cambios una vez finalizado';
	end if;
	--no se puede modificar el nombre
	if old.estado = 'en proceso' then
		if old.nombre_torneo != new.nombre_torneo then
			raise exception 'no se puede modificar una vez iniciado';
		end if;
	end if;
	--solamente se puede cambiar el nombre cuando el torneo esta iniciando 
	return new;
    END;
$$ LANGUAGE plpgsql;

create trigger tbu_torneo before update on torneos
for each row execute procedure f_tbu_torneo();


CREATE OR REPLACE FUNCTION f_tbu_partido() RETURNS TRIGGER AS $$
DECLARE
a_fecha date;
fechatrigger date;
ronda integer;
rondactual integer;
    BEGIN
	--no se puede cambiar la cancha a menos que no se haya jugado todavia
	--se puede cambiar solo si el estado se esta jugando la ronda en si
	if old.id_partido!=new.id_partido or old.id_equipo1!=new.id_equipo1 or
		old.id_equipo2!=new.id_equipo2 then
		raise exception 'No se pueden modificar otros campos que no sean los puntajes';
	end if;
	a_fecha:=(select fecha from rondas where id_ronda=currval('rondas_id_ronda_seq'));
	fechatrigger:=(select fecha from rondas r 
			join calendario c on r.id_ronda=c.id_ronda
			where c.id_calendario=old.id_calendario);
	rondactual:=(select id_ronda from rondas where id_ronda=currval('rondas_id_ronda_seq'));
	--si el nuevo tiene la misma ronda, entonces se puede cambiar!
	ronda:=(select id_ronda from calendario c
			where c.id_calendario=new.id_calendario); 
	if a_fecha!=fechatrigger then
		if old.id_calendario!=new.id_calendario then
			raise exception 'No se puede modificar el calendario una vez que se haya jugado el partido';
		end if;
	else if ronda!=rondactual then
		raise exception 'No se puede modificar el calendario a una ronda anterior';
		end if;
	end if;
	return NEW;
    END;
$$ LANGUAGE plpgsql;

create trigger tbu_goles before update on goles_x_jugador
for each row execute procedure f_tbu_goles();

CREATE OR REPLACE FUNCTION f_tbu_planilla() RETURNS TRIGGER AS $$

    BEGIN
		--no se puede cambiar nada de la tabla planillas
		raise exception 'No se puede actualizar la planilla';
 
	return new;
    END;
$$ LANGUAGE plpgsql;

create trigger tbu_planilla before update on planilla
for each row execute procedure f_tbu_planilla();

CREATE OR REPLACE FUNCTION f_tbu_jugador() RETURNS TRIGGER AS $$
DECLARE
  p_estado character varying(20);
  p_anho integer;
    BEGIN
	--no se pueden realizar cambios en la tabla jugador si el torneo del anho no esta en estado iniciado
	p_anho:= (select extract (year from current_date));
	p_estado := (select estado from torneo where anho = p_anho);
	if p_estado !="Iniciado" then
		raise exception 'No se pueden realizar cambios mientras el torneo esta en curso';
	end if;
	return new;
    END;
$$ LANGUAGE plpgsql;

create trigger tbu_jugador before update on jugador
for each row execute procedure f_tbu_jugador();

CREATE OR REPLACE FUNCTION f_tbu_calendario() RETURNS TRIGGER AS $$
DECLARE
coincidencia time;
a_ronda integer;
    BEGIN
	--no se puede modificar el primary key, la cancha ni la ronda
	if new.id_calendario!=old.id_calendario then
		raise exception 'No se puede cambiar primary key';
	end if;
	if new.id_cancha!= old.id_cancha then
		raise exception 'No se puede cambiar la cancha';
	end if;
	if new.id_ronda!= old.id_ronda then
		raise exception 'No se puede cambiar la ronda';
	end if;
	--solamente se puede modificar si es que la ronda se esta jugando todavia
	a_ronda:=(currval('rondas_id_ronda_seq'));
	if a_ronda=old.id_roda then
		coincidencia=(select hora from calendario 
				where id_ronda=new.id_ronda and id_cancha=new.id_cancha);
		--calcula el intervalo
		intervalo=coincidencia - new.hora;
		--si es que el intervalo es negativo, lo vuelve positivo
		if intervalo < INTERVAL '0 hours' then
			intervalo=intervalo*-1;
		end if;
		--si es que el intervalo entre los dos partidos es menor de tres horas
		--entonces no se puede agregar
		if intervalo < INTERVAL '3 hours' then
			raise exception 'Partidos se solapan en horario!';
		end if;
	end if;

	return new;
    END;
$$ LANGUAGE plpgsql;

create trigger tbu_calendario before update on calendario
for each row execute procedure f_tbu_calendario();

CREATE OR REPLACE FUNCTION f_tbu_ronda() RETURNS TRIGGER AS $$

    BEGIN
	--no se puede modificar alguna cosa en esta tabla
	if new.id_ronda!=old.id_ronda then
		raise exception 'No se puede cambiar primary key';
	end if;
	if new.anho!= old.anho then
		raise exception 'No se puede cambiar el anho';
	end if;
	if new.numero_ronda!= old.numero_ronda then
		raise exception 'No se puede cambiar cambiar el numero de ronda';
	end if;
	if new.fecha!= old.fecha then
		raise exception 'No se puede cambiar la fecha de ronda';
	end if;
	return new;
    END;
$$ LANGUAGE plpgsql;

create trigger tbu_ronda before update on ronda
for each row execute procedure f_tbu_ronda();


CREATE OR REPLACE FUNCTION f_tbu_tabla() RETURNS TRIGGER AS $$

    BEGIN
	--solo se puede cambiar posicion y puntaje
	if new.id_tabla!=old.id_tabla then
		raise exception 'No se puede cambiar primary key';
	end if;
	if new.id_equipo!= old.id_equipo then
		raise exception 'No se puede cambiar el equipo';
	end if;
	if new.anho!= old.anho then
		raise exception 'No se puede cambiar cambiar el anho';
	end if;
	return new;
    END;
$$ LANGUAGE plpgsql;

create trigger tbu_talba before update on tabla
for each row execute procedure f_tbu_tabla();

