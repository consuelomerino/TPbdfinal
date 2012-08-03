CREATE OR REPLACE FUNCTION f_tbu_torneo() RETURNS TRIGGER AS $$
    BEGIN
	if old.anho != new.anho then
		raise exception 'no se puede cambiar el año';
	end if;

	if old.estado = 'terminado' then
		raise exception 'no se puede hacer cambios una ves finalizado';
	end if;
	
	if old.estado = 'en proceso' then
		if old.nombre_torneo != new.nombre_torneo then
			raise exception 'no se puede modificar una vez iniciado';
		end if;
		if old.fecha_actual>new.fecha_actual then
			raise exception 'no se puede retroceder en el tiempo';
		end if;
	end if;

	return new;
    END;
$$ LANGUAGE plpgsql;

create trigger tbu_torneo before update on torneo
for each row execute procedure f_tbu_torneo();


CREATE OR REPLACE FUNCTION f_tau_partido() RETURNS TRIGGER AS $$
    BEGIN

		update tabla t set puntaje=puntaje+new.puntaje1
			where id_equipo=new.id_equipo1;
		update tabla t set puntaje=puntaje+new.puntaje2
			where id_equipo=new.id_equipo2;
	return NULL;
    END;
$$ LANGUAGE plpgsql;

create trigger tau_partido before update on partido
for each row execute procedure f_tau_partido();

CREATE OR REPLACE FUNCTION f_tau_goles() RETURNS TRIGGER AS $$
    BEGIN

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
	return NULL;
    END;
$$ LANGUAGE plpgsql;

create trigger tau_goles before update on goles_x_jugador
for each row execute procedure f_tau_goles();


CREATE OR REPLACE FUNCTION f_tbu_goles() RETURNS TRIGGER AS $$
DECLARE
p_fecha date;
    BEGIN
		p_fecha:=(select r.fecha from goles_x_jugador g
				join planilla p on g.id_planilla=p.id_planilla
				join partido pa on p.id_partido=pa.id_partido
				join ronda r on r.id_ronda=pa.id_ronda limit 1);
		if p_fecha IS NULL then
			raise exception 'No se pueden actualizar goles fuera de fecha';
		end if; 
	return new;
    END;
$$ LANGUAGE plpgsql;

create trigger tbu_goles before update on goles_x_jugador
for each row execute procedure f_tbu_goles();

CREATE OR REPLACE FUNCTION f_tbu_planilla() RETURNS TRIGGER AS $$

    BEGIN

		raise exception 'No se pueden actuliazar la planilla';
 
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
	p_anho:= (select extract (year from current_date));
	p_estado := (select estado from torneo where anho = p_anho);
	if p_estado !="iniciado" then
		raise exception 'No se pueden realizar cambios mientras el torneo esta en curso';
	end if;
	return new;
    END;
$$ LANGUAGE plpgsql;

create trigger tbu_jugador before update on jugador
for each row execute procedure f_tbu_jugador();

CREATE OR REPLACE FUNCTION f_tbu_calendario() RETURNS TRIGGER AS $$

    BEGIN
	
	if new.id_calendario!=old.id_calendario then
		raise exception 'No se puede cambiar primary key';
	end if;
	if new.id_cancha!= old.id_cancha then
		raise exception 'No se puede cambiar cambiar la cancha';
	end if;
	if new.fecha!= old.fecha then
		raise exception 'No se puede cambiar cambiar la fecha';
	end if;
	return new;
    END;
$$ LANGUAGE plpgsql;

create trigger tbu_calendario before update on calendario
for each row execute procedure f_tbu_calendario();

CREATE OR REPLACE FUNCTION f_tbu_ronda() RETURNS TRIGGER AS $$

    BEGIN
	
	if new.id_ronda!=old.id_ronda then
		raise exception 'No se puede cambiar primary key';
	end if;
	if new.anho!= old.anho then
		raise exception 'No se puede cambiar el anho';
	end if;
	if new.numero_ronda!= old.numero_ronda then
		raise exception 'No se puede cambiar cambiar el numero de ronda';
	end if;
	return new;
    END;
$$ LANGUAGE plpgsql;

create trigger tbu_ronda before update on ronda
for each row execute procedure f_tbu_ronda();


CREATE OR REPLACE FUNCTION f_tbu_tabla() RETURNS TRIGGER AS $$

    BEGIN
	
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

