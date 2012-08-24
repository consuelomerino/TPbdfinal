--TRIGGER INSERT DE TABLA TORNEOS
CREATE OR REPLACE FUNCTION f_tbi_torneo() 
RETURNS TRIGGER 
AS $$
DECLARE 
pnombretorneo character varying(30);
panho integer;
    BEGIN
	--no se puede agregar un torneo si algun otro está en proceso
	pnombretorneo:=(select distinct nombre_torneo from torneos where estado='Iniciado' or estado='EnProceso' limit 1);
	if pnombretorneo is not NULL then
		raise exception 'No pueden haber mas de dos torneos en proceso al mismo tiempo';
	end if;
	panho:=(select MAX(anho) from torneos);
	if panho >= new.anho then
		raise exception 'ERROR! Anho menor que el maximo jugado. El torneo no se puede jugar antes de uno ya jugado!!';
	end if;
	new.estado:='Iniciado';
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tbi_torneo before insert on torneos for each row
execute procedure f_tbi_torneo();




--TRIGGER INSERT DE TABLA EQUIPOS
CREATE OR REPLACE FUNCTION f_tbi_equipos()
RETURNS TRIGGER 
AS $$
declare
p_estado estados;
    BEGIN
	--solo se puede agregar si no hay algun torneo que este en Proceso ni iniciado
	p_estado:=(select estado from torneos where estado='EnProceso' limit 1);
	if p_estado = 'EnProceso' then
		raise exception 'No se pueden agregar equipos mientras el torneo esté en curso';
	end if;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tbi_equipos before insert on equipos for each row
execute procedure f_tbi_equipos();





--TABLA TRIGGER INSERT TABLA JUGADORES
CREATE OR REPLACE FUNCTION f_tbi_jugadores()
RETURNS TRIGGER 
AS $$
declare
p_estado estados;
p_count integer;
    BEGIN
	--solo se puede insertar si es que no hay torneos en proceso
	p_estado:=(select estado from torneos where estado='EnProceso' limit 1);
	if p_estado = 'EnProceso' then
		raise exception 'No se pueden agregar equipos mientras el torneo esté en curso';
	end if;
	--se pueden insertar maximo 22 jugadores por equipo
	p_count:=(select count(*) from jugadores where id_equipo=new.id_equipo);
	if p_count = 22 then
		raise exception 'Solo se admiten 22 jugadores por equipo';
	end if;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tbi_jugadores before insert on jugadores for each row
execute procedure f_tbi_jugadores();


--TRIGGER INSERT TABLA PUNTUACION
CREATE OR REPLACE FUNCTION f_tbi_puntuacion()
RETURNS TRIGGER 
AS $$
declare
	p_estado estados;
    BEGIN
	--si el estado del torneo es iniciado, se puede insertar, luego ya no
	p_estado:=(select estado from torneos where anho=new.anho);
	if p_estado != 'Iniciado' then
		raise exception 'Una vez iniciado el torneo, no se pueden agregar nuevos registros';
	end if;
	new.posicion:=0;
	new.puntaje:=0;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tbi_puntuacion before insert on tabla_puntuaciones for each row
execute procedure f_tbi_puntuacion();



--TRIGGER INSERT TABLA RONDAS
CREATE OR REPLACE FUNCTION f_tbi_rondas()
RETURNS TRIGGER 
AS $$
declare
	p_estado estados;
	p_fecha fechas;
    BEGIN
	p_estado:=(select estado from torneos where anho=new.anho);
	if p_estado='Terminado' then
		raise exception 'Torneo ya terminado, no se pueden agregar nuevas rondas!';
	end if;
	p_fecha:=(select MAX(fecha) from rondas where anho=new.anho);
	if p_fecha > new.fecha then
		raise exception 'Fecha menor a la ultima jugada';
	end if;
	if extract(year from new.fecha)!=new.anho then
		raise exception 'Los anhos deben coincidir';
	end if;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tbi_rondas before insert on rondas for each row
execute procedure f_tbi_rondas();



--TABLA INSERT CALENDARIO
CREATE OR REPLACE FUNCTION f_tbiu_calendario()
RETURNS TRIGGER 
AS $$
DECLARE 
chora integer;
coincidencia time;
intervalo interval;
r_canchas record;
c_canchas integer;
n_anho integer;
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
	n_anho:=(select distinct t.anho from torneos t
				join rondas r on t.anho=r.anho
				join calendario c on r.id_ronda=new.id_ronda);
	--solo se pueden agregar hasta 6 canchas
	c_canchas:=(with r_canchas as (select distinct id_cancha from calendario c
				join rondas r on c.id_ronda=r.id_ronda
				join torneos t on r.anho=t.anho
				where t.anho=n_anho) select count(*) from r_canchas);
	if c_canchas>=6 then
		raise exception 'solo se pueden hasta 6 canchas';
	end if;
	RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tbiu_calendario before insert or update on calendario for each row
execute procedure f_tbiu_calendario();



--TRIGGER INSERT PARTIDO
CREATE OR REPLACE FUNCTION f_tbi_partido()
RETURNS TRIGGER 
AS $$
declare
rondaactual integer;
ultimaronda integer;
estado estados;
    BEGIN
		--cera los puntajes
		new.puntaje1=0;
		new.puntaje2=0;
		--busca el valor de la ronda actual
		rondaactual:=(select r.id_ronda from rondas r
				join calendario c on r.id_ronda=c.id_ronda
				where c.id_calendario=new.id_calendario);
		--busca el valor de la ultima ronda jugada
		ultimaronda:=(select MAX(id_ronda) from rondas);
		--no deja agregar si es que no coincide con la ultima ronda jugada
		if rondaactual!=ultimaronda then
			raise exception 'No se puede insertar un partido de otra ronda que no sea la actual';
		end if;		
		--si el torneo esta en terminado, no deja agregar mas
		estado:=(select distinct t.estado from torneos t
					join rondas r on t.anho=r.anho
					join calendario c on r.id_ronda=c.id_ronda
					join partidos p on c.id_calendario=new.id_calendario);
		if estado = 'Terminado' then
			raise exception 'No se pueden agregar partidos una vez terminado el torneo';
		end if;		
		if new.id_equipo1=new.id_equipo2 then
			raise exception 'Equipo no puede competir contra si mismo';
		end if;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tbi_partido before insert on partidos for each row
execute procedure f_tbi_partido();



--TRIGGER INSERT TABLA PLANILLA
CREATE OR REPLACE FUNCTION f_tbi_planilla()
RETURNS TRIGGER 
AS $$
DECLARE 
equipo integer;
estado estados;
rondaactual integer;
ultimaronda integer;
canttitular integer;
    BEGIN
	--si o si tiene que ser titular (true) o suplente (false)
	if new.fue_titular IS NULL then
		raise exception 'Debe especificar si es Titular, "1" o Suplente, "0"';
	end if;
	--corroborar que el jugador es del equipo
	equipo:=(select distinct j.id_equipo from planillas p join jugadores j 
					on j.ci_jugador = new.ci_jugador);
	if new.id_equipo != equipo or equipo = NULL then
		raise exception 'Jugador no válido, no asociado al equipo ingresado';
	end if;
	estado:=(select distinct t.estado from torneos t
					join rondas r on t.anho=r.anho
					join calendario c on r.id_ronda=c.id_ronda
					join partidos p on c.id_calendario=p.id_calendario
					where p.id_partido=new.id_partido);
	--si el torneo ya termino, no se puede insertar
	if estado = 'Terminado' then
		raise exception 'No se pueden agregar partidos una vez terminado el torneo';
	end if;		
	--valor de la ronda actual
	rondaactual:=(select r.id_ronda from rondas r
			join calendario c on r.id_ronda=c.id_ronda
			join partidos p on c.id_calendario=p.id_calendario
			where p.id_partido=new.id_partido);
	--busca el valor de la ultima ronda jugada
	ultimaronda:=(select MAX(id_ronda) from rondas);
	--no deja agregar si es que no coincide con la ultima ronda jugada
	if rondaactual!=ultimaronda then
		raise exception 'No se puede insertar un partido de otra ronda que no sea la actual';
		end if;	
	--solo puede haber un maximo de 11 titulares en el partido
	canttitular:=(select count(*) from planillas 
			where id_equipo=equipo and fue_titular=true
				and id_partido=new.id_partido);
	if canttitular>11 then
		raise exception 'No pueden haber más de 11 titulares en el equipo en el mismo partido';
	end if;
	RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tbi_planilla before insert on planillas for each row
execute procedure f_tbi_planilla();


--TRIGGER INSERT TABLA GOLES_X_JUGADOR
CREATE OR REPLACE FUNCTION f_tbiu_goles()
RETURNS TRIGGER 
AS $$
DECLARE
	equipo integer;
	p_fecha date;
	p_jugador integer;
	a_fecha date;
	p_partido record;
	rondaactual integer;
	estado estados;
	p_titulares integer;
    BEGIN
	if TG_OP='INSERT' or TG_OP='UPDATE' then
		--ver que los goles que se inserten son de la fecha actual
		new.id_goles:=(select nextval('goles_x_jugador_id_goles_seq'));
		p_fecha:=(select r.fecha from planillas p
				join partidos pa on p.id_partido=pa.id_partido
				join calendario c on pa.id_calendario=c.id_calendario
				join rondas r on c.id_ronda=r.id_ronda 
				and p.id_planilla=new.id_planilla limit 1);
		rondaactual:=(select MAX(id_ronda) from rondas);
		a_fecha:=(select fecha from rondas where id_ronda=rondaactual);

		if not(p_fecha = a_fecha) then
			raise exception 'No se pueden agregar goles fuera de fecha';
		end if;
		--cerar los resultados de los goles del jugador si es que no se pasa algún parámetro
	end if;
	if TG_OP='INSERT' then
		--se cera a favor y en contra si es que los campos estan como null
		if new.a_favor IS NULL then
			new.a_favor=0;
		end if;
		if new.contra IS NULL then
			new.contra=0;
		end if;
		--si es que no tiene al menos 11 jugadores titulares, no se puede comenzar a asignar los goles
		p_jugador:=(select ci_jugador from planillas where id_planilla=new.id_planilla); 
		equipo:=(select distinct j.id_equipo from planillas p join jugadores j 
					on j.ci_jugador = p_jugador);
		p_titulares:=(select count(*) from planillas 
				where fue_titular=TRUE and id_equipo=equipo);
		if p_titulares < 11 then
			raise exception 'ERROR!! La cantidad de titulares debe ser al menos 11';
		end if;
	end if;
	--si es un update, se restringe el cambio de id_goles e id_planilla
	if TG_OP='UPDATE' then
		if new.id_goles!=old.id_goles and new.id_planilla!=old.id_planilla then
			raise exception 'NO se puede cambiar el id de goles y id de planilla';
		end if;
	end if;
	--si torneo finalizado, no se puede insertar ni actualizar
	estado:=(select distinct t.estado from torneos t
					join rondas r on t.anho=r.anho
					join calendario c on r.id_ronda=c.id_ronda
					join partidos p on c.id_calendario=p.id_calendario
					join planillas pa on p.id_partido=pa.id_partido
					where pa.id_planilla=new.id_planilla);
	if estado = 'Terminado' then
		raise exception 'No se pueden agregar partidos una vez terminado el torneo';
	end if;		
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER tbi_goles before insert or update on goles_x_jugador for each row
execute procedure f_tbiu_goles(); 


CREATE OR REPLACE FUNCTION f_taiu_goles()
RETURNS TRIGGER 
AS $$
DECLARE
	p_cijugador integer;
	p_idpartido integer;
	p_idequipo integer;
	p_equipo1 integer;
	p_equipo2 integer;

BEGIN

		--rescata el id del jugador que metio el gol
		p_cijugador:=(select distinct p.ci_jugador from planillas p
				where p.id_planilla=new.id_planilla);
		--rescata el id de partido a la que se esta asociando los goles
		p_idpartido:=(select distinct p.id_partido from planillas p
				join goles_x_jugador g on g.id_planilla=p.id_planilla
				where p.id_planilla=new.id_planilla);
		--rescata el id de equipo del jugador
		p_idequipo:=(select distinct j.id_equipo from jugadores j
				join planillas p on j.ci_jugador=p.ci_jugador
				where j.ci_jugador=p_cijugador and p.id_planilla=new.id_planilla);
		--rescata el id de equipo que esta en la columna id_equipo1
		p_equipo1:=(select id_equipo1 from partidos where id_partido=p_idpartido);
		--guarda el id de equipo que esta en la columna id_equipo2
		p_equipo2:=(select id_equipo2 from partidos where id_partido=p_idpartido);
	
		--si el id del equipo asociado al jugador esta en la columna id_equipo1
		if p_equipo1=p_idequipo then
			--agrega goles del equipo 1 al puntaje 1, goles a favor
			update partidos p set puntaje1=puntaje1+new.a_favor 
						where id_partido=p_idpartido;
			--agrega goles del equipo1 al puntaje2, goles en contra
			update partidos p set puntaje2=puntaje2+new.contra 
						where id_partido=p_idpartido;
		else 
		--si el id del equipo asociado al jugador esta en la columna id_equipo2
			--agrega goles del equipo2 al puntaje2 que son a favor
			update partidos p set puntaje2=puntaje2+new.a_favor
					where id_partido=p_idpartido;
			--agrega goles del equipo1 al puntaje2, goles en contra
			update partidos p set puntaje1=puntaje1+new.contra 
					where id_partido=p_idpartido;

		end if;
	if TG_OP='UPDATE' then --faltan restar los valores de update
		--restan los valores a los resultados del partido
		--rescata el id de partido a la que se esta asociando los goles
		p_idpartido:=(select distinct p.id_partido from planillas p
				join goles_x_jugador g on g.id_planilla=p.id_planilla
				where p.id_planilla=old.id_planilla);
		--rescata el id de equipo del jugador
		p_idequipo:=(select distinct id_equipo from jugadores j
				join goles_x_jugador g on j.ci_jugador = g.ci_jugador 
				where g.ci_jugador=old.ci_jugador);
		--rescata el id de equipo que esta en la columna id_equipo1
		p_equipo1:=(select id_equipo1 from partidos where id_partido=p_idpartido);
		--guarda el id de equipo que esta en la columna id_equipo2
		p_equipo2:=(select id_equipo2 from partidos where id_partido=p_idpartido);
		--si el id del equipo asociado al jugador esta en la columna id_equipo1
		if p_equipo1=p_idequipo then
			--borra los goles del equipo 1 al puntaje 1, goles a favor
			update partidos p set puntaje1=puntaje1-old.a_favor 
						where id_partido=p_idpartido;
			--borra los goles del equipo1 al puntaje2, goles en contra
			update partidos p set puntaje2=puntaje2-old.contra 
						where id_partido=p_idpartido;
		else 
		--si el id del equipo asociado al jugador esta en la columna id_equipo2
			--borra los del equipo2 al puntaje2 que son a favor
			update partidos p set puntaje2=puntaje2-old.a_favor
					where id_partido=p_idpartido;
			--borra los goles del equipo1 al puntaje2, goles en contra
			update partidos p set puntaje1=puntaje1-old.contra 
					where id_partido=p_idpartido;
		end if;
	end if;
    RETURN NULL;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER taiu_goles after insert on goles_x_jugador for each row
execute procedure f_taiu_goles();

CREATE OR REPLACE FUNCTION f_tad_goles()
RETURNS TRIGGER 
AS $$
DECLARE
p_idpartido integer;
p_idequipo integer;
p_equipo1 integer;
p_equipo2 integer;
    BEGIN


	--restan los valores a los resultados del partido
		--rescata el id de partido a la que se esta asociando los goles
		p_idpartido:=(select distinct p.id_partido from planillas p
				join goles_x_jugador g on g.id_planilla=p.id_planilla
				where p.id_planilla=old.id_planilla);
		--rescata el id de equipo del jugador
		p_idequipo:=(select distinct id_equipo from jugadores j
				join goles_x_jugador g on j.ci_jugador = g.ci_jugador 
				where g.ci_jugador=old.ci_jugador);
		--rescata el id de equipo que esta en la columna id_equipo1
		p_equipo1:=(select id_equipo1 from partidos where id_partido=p_idpartido);
		--guarda el id de equipo que esta en la columna id_equipo2
		p_equipo2:=(select id_equipo2 from partidos where id_partido=p_idpartido);
		--si el id del equipo asociado al jugador esta en la columna id_equipo1
		if p_equipo1=p_idequipo then
			--borra los goles del equipo 1 al puntaje 1, goles a favor
			update partidos p set puntaje1=puntaje1-old.a_favor 
						where id_partido=p_idpartido;
			--borra los goles del equipo1 al puntaje2, goles en contra
			update partidos p set puntaje2=puntaje2-old.contra 
						where id_partido=p_idpartido;
		else 
		--si el id del equipo asociado al jugador esta en la columna id_equipo2
			--borra los del equipo2 al puntaje2 que son a favor
			update partidos p set puntaje2=puntaje2-old.a_favor
					where id_partido=p_idpartido;
			--borra los goles del equipo1 al puntaje2, goles en contra
			update partidos p set puntaje1=puntaje1-old.contra 
					where id_partido=p_idpartido;
		end if;
										

    RETURN OLD;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tad_goles after delete on goles_x_jugador for each row
execute procedure f_tad_goles();

