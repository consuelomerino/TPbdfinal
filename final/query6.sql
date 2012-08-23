--como se jugaron las rondas, hasta una fecha dada	
--desde la primera a la ultima
--fecha, cancha, partido, equipos, goles de cada equipo
--y jugadores que hicieron el gol ordenado por ronda

create or replace function f_query6 (p_fecha fechas)
returns void
as $$
begin

	drop table if exists query6aux cascade;
	create TEMP table query6aux as(
	select r.numero_ronda, r.fecha, pa.id_partido, e1.nombre_equipo as equipo1, pa.puntaje1 as goles_equipo1,
		e2.nombre_equipo as equipo2, pa.puntaje2 as goles_equipo2, j.nombre, j.apellido, gxj.a_favor as anoto, e3.nombre_equipo as porEquipo
		from rondas r
		join calendario ca on r.id_ronda=ca.id_ronda
		join partidos pa on ca.id_calendario=pa.id_calendario
		join equipos e1 on pa.id_equipo1=e1.id_equipo
		join equipos e2 on pa.id_equipo2=e2.id_equipo 
		join planillas p on pa.id_partido=p.id_partido
		join equipos e3 on e3.id_equipo=p.id_equipo
		join jugadores j on p.ci_jugador=j.ci_jugador
		join goles_x_jugador gxj on p.id_planilla=gxj.id_planilla
		where r.anho=extract(year from p_fecha) and r.fecha<p_fecha);

	create or replace view query6 as (select * from query6aux order by numero_ronda, id_partido);

end;
$$ language plpgsql;

