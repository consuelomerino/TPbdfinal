--querys de prueba de consistencia
--TABLA TORNEO
insert into torneos (anho, estado, nombre_torneo) values (2001, 'Iniciado', 'Ala');
--da error por que hay uno con iniciado 
insert into torneos (anho, estado, nombre_torneo) values (2002, 'Iniciado', 'Ala');
update torneos set estado='Terminado' where anho=2001;
--da error anho anterior
insert into torneos (anho, estado, nombre_torneo) values (2000, 'Iniciado', 'Ala');
select * from torneos;
insert into torneos (anho, estado, nombre_torneo) values (2003, 'Iniciado', 'Ala1');
--TABLA EQUIPO
--no se puede insertar porque hay un torneo Iniciado
insert into equipos (nombre_equipo) values ('Olimpia');

--TABLA CANCHA
insert into canchas (nombre_cancha, lugar) values ('la O', 'Avda. Eusebio');
insert into canchas (nombre_cancha, lugar) values ('la 1', 'Avda. Eusebio');
insert into canchas (nombre_cancha, lugar) values ('la 2', 'Avda. Eusebio');
insert into canchas (nombre_cancha, lugar) values ('la 3', 'Avda. Eusebio');
insert into canchas (nombre_cancha, lugar) values ('la 4', 'Avda. Eusebio');
insert into canchas (nombre_cancha, lugar) values ('la 5', 'Avda. Eusebio');
insert into canchas (nombre_cancha, lugar) values ('la 6', 'Avda. Eusebio');
select * from canchas;
--TABLA JUGADORES
--error por torneo que está en curso
insert into jugadores (ci_jugador, id_equipo, apellido, edad, nombre) values 
			(12353, 1, 'Gonzalez', 18, 'Pedro');
update torneos set estado='Iniciado' where anho=2003;
insert into jugadores (ci_jugador, id_equipo, apellido, edad, nombre) values 
			(12353, 1, 'Gonzalez', 18, 'Pedro');
--TABLA PUNTUACIONES
--no se puede insertar si el torneo a la que se le asignan las puntuaciones no esta en iniciado
insert into tabla_puntuaciones (id_equipo, anho) values
			(1, 2001);
insert into tabla_puntuaciones (id_equipo, anho) values
			(1, 2003);
--TABLA RONDAS
insert into rondas (fecha, anho, numero_ronda) values ('12-13-2003', 2003, 1);
--no acepta que los anhos no coincidan
insert into rondas (fecha, anho, numero_ronda) values ('12-13-2004', 2003, 2);
--no acepta una fecha anterior a la ya jugada
insert into rondas (fecha, anho, numero_ronda) values ('12-13-2002', 2003, 2);
select * from rondas;
--TABLA CALENDARIO
insert into calendario (id_ronda, id_cancha, hora) values (4,1,'12:00');
insert into calendario (id_ronda, id_cancha, hora) values (4,1,'18:00');
--solo se pueden jugar dos partidos por cancha
insert into calendario (id_ronda, id_cancha, hora) values (4,1,'17:00');
insert into calendario (id_ronda, id_cancha, hora) values (4,2,'17:00');
--se solapan en horario
insert into calendario (id_ronda, id_cancha, hora) values (11,2,'18:00');
insert into calendario (id_ronda, id_cancha, hora) values (11,5,'17:00');
insert into calendario (id_ronda, id_cancha, hora) values (11,6,'17:00');
insert into calendario (id_ronda, id_cancha, hora) values (11,7,'17:00');
insert into calendario (id_ronda, id_cancha, hora) values (11,3,'17:00');
insert into calendario (id_ronda, id_cancha, hora) values (11,4,'20:00');
--no pueden haber mas de 6 canchas en utilizacion por ronda
insert into calendario (id_ronda, id_cancha, hora) values (11,1,'20:00');
--TABLE PARTIDO
--no puede competir contra si mismo
insert into partidos (id_calendario, id_equipo1, id_equipo2) values
			(31, 1, 1);
--no puede insertar un partido de una ronda que no sea la actual
insert into partidos (id_calendario, id_equipo1, id_equipo2) values
			(3, 1, 2);
update torneos set estado='Terminado' where anho=2003;
--no se pueden agregar partidos una vez terminado el torneo
insert into partidos (id_calendario, id_equipo1, id_equipo2) values
			(31, 1, 1);
--TABLE PLANILLAS
select * from jugadores;
select * from partidos;
--no se puede agregar un jugador cuando termina el torneo
insert into planillas (id_partido, ci_jugador, fue_titular, id_equipo) values
			(8, 12353, TRUE, 1);
update torneos set estado='EnProceso' where anho=2004;
--no se puede agregar un jugador que no pertenece a dicho equipo
insert into planillas (id_partido, ci_jugador, fue_titular, id_equipo) values
			(8, 12353, TRUE, 1);
--no se puede agregar un jugador en la ronda que no es actual
insert into planillas (id_partido, ci_jugador, fue_titular, id_equipo) values
			(2, 12353, TRUE, 1);
update torneos set estado='Iniciado' where anho=2004;
insert into jugadores (ci_jugador, id_equipo, apellido, edad, nombre) values 
			(1, 1, 'Gonzalez', 18, 'Pedro');
insert into jugadores (ci_jugador, id_equipo, apellido, edad, nombre) values 
			(2, 1, 'Gonzalez', 18, 'Pedro');
insert into jugadores (ci_jugador, id_equipo, apellido, edad, nombre) values 
			(3, 1, 'Gonzalez', 18, 'Pedro');
insert into jugadores (ci_jugador, id_equipo, apellido, edad, nombre) values 
			(4, 1, 'Gonzalez', 18, 'Pedro');
insert into jugadores (ci_jugador, id_equipo, apellido, edad, nombre) values 
			(5, 1, 'Gonzalez', 18, 'Pedro');
insert into jugadores (ci_jugador, id_equipo, apellido, edad, nombre) values 
			(6, 1, 'Gonzalez', 18, 'Pedro');
insert into jugadores (ci_jugador, id_equipo, apellido, edad, nombre) values 
			(7, 1, 'Gonzalez', 18, 'Pedro');
insert into jugadores (ci_jugador, id_equipo, apellido, edad, nombre) values 
			(8, 1, 'Gonzalez', 18, 'Pedro');
insert into jugadores (ci_jugador, id_equipo, apellido, edad, nombre) values 
			(9, 1, 'Gonzalez', 18, 'Pedro');
insert into jugadores (ci_jugador, id_equipo, apellido, edad, nombre) values 
			(10, 1, 'Gonzalez', 18, 'Pedro');
insert into jugadores (ci_jugador, id_equipo, apellido, edad, nombre) values 
			(11, 1, 'Gonzalez', 18, 'Pedro');
insert into jugadores (ci_jugador, id_equipo, apellido, edad, nombre) values 
			(12, 1, 'Gonzalez', 18, 'Pedro');
insert into planillas (id_partido, ci_jugador, fue_titular, id_equipo) values
			(8, 1, TRUE, 1);
insert into planillas (id_partido, ci_jugador, fue_titular, id_equipo) values
			(8, 2, TRUE, 1);
insert into planillas (id_partido, ci_jugador, fue_titular, id_equipo) values
			(8, 3, TRUE, 1);
insert into planillas (id_partido, ci_jugador, fue_titular, id_equipo) values
			(8, 4, TRUE, 1);
insert into planillas (id_partido, ci_jugador, fue_titular, id_equipo) values
			(8, 5, TRUE, 1);
insert into planillas (id_partido, ci_jugador, fue_titular, id_equipo) values
			(8, 6, TRUE, 1);
insert into planillas (id_partido, ci_jugador, fue_titular, id_equipo) values
			(8, 7, TRUE, 1);
insert into planillas (id_partido, ci_jugador, fue_titular, id_equipo) values
			(8, 8, TRUE, 1);
insert into planillas (id_partido, ci_jugador, fue_titular, id_equipo) values
			(8, 9, TRUE, 1);
insert into planillas (id_partido, ci_jugador, fue_titular, id_equipo) values
			(8, 10, TRUE, 1);
--no se puede agregar más de 11 titulares
insert into planillas (id_partido, ci_jugador, fue_titular, id_equipo) values
			(8, 11, TRUE, 1);
insert into planillas (id_partido, ci_jugador, fue_titular, id_equipo) values
			(8, 12, TRUE, 1);
select * from planillas
--TABLA GOLES
--no se pueden agregar goles de otra ronda
insert into goles_x_jugador (id_planilla, a_favor, contra) values
			(11, 0, 0);
--si es que tiene menos de 11, no agrega
insert into goles_x_jugador (id_planilla, a_favor, contra) values
			(7, 0, 0);



--UPDATES






