--como se jugaron las rondas, hasta una fecha dada	
--desde la primera a la ultima
--fecha, cancha, partido, equipos, goles de cada equipo
--y jugadores que hicieron el gol ordenado por ronda
select r.numero_ronda, r.fecha, pa.id_partido, e1.nombre_equipo, pa.puntaje1,
	e2.nombre_equipo, pa.puntaje2, j.nombre, j.apellido
	
	from rondas r
	join calendario ca on r.id_ronda=ca.id_ronda
	join partidos pa on ca.id_calendario=pa.id_calendario
	join equipos e1 on pa.id_equipo1=e1.id_equipo
	join equipos e2 on pa.id_equipo2=e2.id_equipo 
	join jugadores j on e1.id_equipo=j.id_equipo
	join planillas p on pa.id_partido=p.id_partido
	join goles_x_jugador gxj on p.id_planilla=gxj.id_planilla
	where r.anho=extract(year from p_fecha) and r.fecha<p_fecha;
