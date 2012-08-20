

create or replace function f_querry1 (p_anho integer, p_ronda integer)
returns void
as $$
declare
	v_fecha fechas;
begin
	v_fecha:=(select r.fecha from rondas r where r.anho=p_anho and r.numero_ronda=p_ronda);
	

	create or replace view query1 as
		(select r.fecha as fecha, ca.nombre_cancha as cancha, e1.nombre_equipo as equipo1, e2.nombre_equipo as equipo2 
			from rondas r 
			inner join calendario cal on r.id_ronda=cal.id_ronda
			inner join partidos p on cal.id_calendario=p.id_calendario
			inner join canchas ca on cal.id_cancha=ca.id_cancha
			inner join equipos e1 on e1.id_equipo=p.id_equipo1
			inner join equipos e2 on e2.id_equipo=p.id_equipo2
			where r.anho=p_anho and r.fecha=v_fecha);

	select * from query1;
end;
 $$ language plpgsql;

create or replace function f_query2 (p_idpar entero)
returns void
as $$
begin
	create or replace view query2 as
		(select j.nombre as nombre, j.apellido as apellido, e.nombre_equipo as equipo
		from jugadores j
		inner join planillas pl on (j.ci_jugador=pl.ci_jugador)
		inner join equipos e on (pl.id_equipo=e.id_equipo)
		inner join partidos p on (pl.id_partido=p.id_partido)
		where p.id_partido=p_idpar and pl.fue_titular is true
		order by equipo);

	select * from query2;
end;
 $$ language plpgsql;

create or replace function f_query3 (p_anho integer, p_ronda integer)
returns void
as $$
declare
	v_pos entero;

begin
	case p_ronda
		when 1,2 then
			v_pos:=12;
		when 3 then
			v_pos:=10;
		when 4 then
			v_pos:=8;
		when 5 then
			v_pos:=6;
		when 6 then
			v_pos:=4;
		when 7 then
			v_pos:=2;
	end case;

	create or replace view query3 as
		(select e.nombre_equipo as nombre
		from equipos e
		inner join tabla_puntuaciones t on (e.id_equipo=t.id_equipos)
		where t.anho=p_anho and t.posicion<=v_pos);

	select * from query3;


end;
$$ language plpgsql;

create or replace function f_query5 (p_anho integer, p_fecha fechas)
returns void
as $$
begin

	create or replace view query5 as 
		(select j.ci_jugador as cedula, j.nombre as nombre, j.apellido as apellido, e.nombre_equipo as equipo,
		(select sum(a_favor) from goles_x_jugador where ci_jugador=j.ci_jugador) as goles
		from jugadores j inner join equipos e on (j.id_equipo=e.id_equipo)
		where j.ci_jugador in (select pl.id_jugador from planillas pl
					inner join partidos p on (pl.id_partido=p.id_partido)
					inner join calendario c on (p.id_calendario=c.id_calendario)
					inner join rondas r on (c.id_ronda=r.id_ronda)
					where r.anho=p_anho and r.fecha<=p_fecha)
		order by goles desc limit 5);

	select * from query5;

end;
$$ language plpgsql;

create or replace function f_query6 (p_anho integer, p_fecha fechas)
returns void
as $$
declare

begin

	create or replace view query6 as
	(select 

end;
$$ language plpgsql;