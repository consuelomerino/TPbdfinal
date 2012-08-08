--primero el torneo (anho, estado, nombre_torneo)
insert into torneo values (2001, 'Iniciado', 'Copa America');
--equipo (id_equipo, nombre_equipo)
insert into equipo (nombre_equipo) values ('Olimpia');
insert into equipo (nombre_equipo) values ('Cerro');
insert into equipo (nombre_equipo) values ('Manchester');

--jugadores (ci_jugadores, id_equipo, apellido, edad, nombre)
insert into jugadores values (2346547, 1, 'Lopez', 23, 'Juan');
insert into jugadores values (2346447, 1, 'Merino', 22, 'Jose');
--canchas (id_cancha, nombre_cancha, lugar, veces_x_fecha)

--rondas (id_ronda, fecha, anho, numero_ronda)

--calendario (id_calendario, id_ronda, id_cancha, hora)

--partidos (id_partido, id_calendario, id_equipo1, puntaje1, id_equipo2, puntaje2)

--planillas (id_planilla, id_partido, ci_jugador, fue_titular, id_equipo)

--goles_x_jugador (id_goles, id_planilla, ci_jugador, a_favor, contra)

--tabla_puntuaciones (id_tabla, id_equipo, anho, posicion, puntaje)


