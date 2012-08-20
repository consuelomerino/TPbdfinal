--domains
CREATE DOMAIN nombres as character varying(30);
CREATE DOMAIN estados as character varying(20)
	check( value='Iniciado'
	or value='EnProceso'
	or value='Terminado');
CREATE DOMAIN dir as character varying(50);
CREATE DOMAIN ronda_num as integer
	check(Value between 1 and 10);
CREATE DOMAIN entero as integer;
CREATE DOMAIN fechas as date;

CREATE DOMAIN count as integer
	check(value between 0 and 2);



--TABLAS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

-- 
-- DROP TABLE goles_x_jugador;
-- DROP TABLE planillas;
-- DROP TABLE tabla_puntuaciones;
-- DROP TABLE partidos;
-- DROP TABLE calendario;
-- DROP TABLE rondas;
-- DROP TABLE canchas;
-- DROP TABLE torneos;
-- DROP TABLE jugadores;
-- DROP TABLE equipos;

--- Table: equipo
CREATE TABLE equipos
(
  id_equipo serial NOT NULL,
  nombre_equipo nombres,
  CONSTRAINT pk_equipo PRIMARY KEY (id_equipo )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE equipos
  OWNER TO uca;


-- Table: jugador
CREATE TABLE jugadores
(
  ci_jugador entero NOT NULL,
  id_equipo entero,
  apellido nombres,
  edad entero,
  nombre nombres,
  CONSTRAINT pk_jugador PRIMARY KEY (ci_jugador ),
  CONSTRAINT pk_equipos_x_jugadores FOREIGN KEY (id_equipo)
      REFERENCES equipos (id_equipo) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE jugadores
  OWNER TO uca;
-- Table: planilla




-- Table: torneo

CREATE TABLE torneos
(
  anho entero NOT NULL,
  estado estados,
  nombre_torneo nombres,
  --fecha_actual fechas,
  CONSTRAINT torneo_pkey PRIMARY KEY (anho )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE torneos
  OWNER TO uca;


-- Table: cancha


CREATE TABLE canchas
(
  id_cancha serial NOT NULL,
  nombre_cancha nombres,
  lugar dir,
  veces_x_fecha count,
  CONSTRAINT pk_cancha PRIMARY KEY (id_cancha )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE canchas
  OWNER TO uca;

  
-- Table: ronda


CREATE TABLE rondas
(
  id_ronda serial NOT NULL UNIQUE,
  fecha fechas NOT NULL UNIQUE,
  anho entero,
  numero_ronda ronda_num,
  CONSTRAINT pk_anho_numero_ronda PRIMARY KEY (anho, numero_ronda ),
  CONSTRAINT fk_rondas_x_torneo FOREIGN KEY (anho)
      REFERENCES torneos (anho) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE rondas
  OWNER TO uca;

-- Table: calendario


CREATE TABLE calendario
(
  id_calendario serial NOT NULL,
  id_ronda entero,
  --fecha date,
  --id_partido integer,
  id_cancha entero,
  hora time without time zone,
  CONSTRAINT pk_calendario PRIMARY KEY (id_calendario ),
  CONSTRAINT fk_canchas_x_calendario FOREIGN KEY (id_cancha)
      REFERENCES canchas (id_cancha) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT pk_rondas_x_calendario FOREIGN KEY (id_ronda)
      REFERENCES rondas (id_ronda) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE calendario
  OWNER TO uca;


-- Table: partido
CREATE TABLE partidos
(
  id_partido serial NOT NULL,
  id_calendario entero,
  id_equipo1 entero,
  puntaje1 entero,
  id_equipo2 entero,
  puntaje2 entero,
  CONSTRAINT pk_partido PRIMARY KEY (id_partido ),
  CONSTRAINT fk_calendario_x_partido FOREIGN KEY (id_calendario)
      REFERENCES calendario (id_calendario) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT pk_equipo1_x_equipo FOREIGN KEY (id_equipo1)
      REFERENCES equipos (id_equipo) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT pk_equipo2_equipo FOREIGN KEY (id_equipo2)
      REFERENCES equipos (id_equipo) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE partidos
  OWNER TO uca;



-- Table: tabla


CREATE TABLE tabla_puntuaciones
(
  id_tabla serial NOT NULL,
  id_equipo entero,
  anho entero,
  posicion entero,
  puntaje entero,
  CONSTRAINT pk_id_tabla PRIMARY KEY (id_tabla ),
  CONSTRAINT pk_equipos_x_tablas FOREIGN KEY (id_equipo)
      REFERENCES equipos (id_equipo) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT pk_torneo_x_tablas FOREIGN KEY (anho)
      REFERENCES torneos (anho) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE tabla_puntuaciones
  OWNER TO uca;

CREATE TABLE planillas
(
  id_planilla serial NOT NULL,
  id_partido entero,
  ci_jugador entero,
  fue_titular boolean,
  id_equipo entero,
  CONSTRAINT pk_planilla PRIMARY KEY (id_planilla ),
  CONSTRAINT pk_jugadores_x_planillas FOREIGN KEY (ci_jugador)
      REFERENCES jugadores (ci_jugador) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT pk_partido_x_planillas FOREIGN KEY (id_partido)
      REFERENCES partidos (id_partido) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  UNIQUE (id_partido, ci_jugador)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE planillas
  OWNER TO uca;
  
CREATE TABLE goles_x_jugador
(
  id_goles serial NOT NULL,
  id_planilla entero,
  a_favor entero,
  contra entero,
  CONSTRAINT pk_goles PRIMARY KEY (id_goles ),
  CONSTRAINT pk_planilla_x_goles FOREIGN KEY (id_planilla)
      REFERENCES planillas (id_planilla) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE goles_x_jugador
  OWNER TO uca;
  
  
--Alterar la secuencia de torneo para que empiece del año 1901

-- DROP SEQUENCE torneo_anho_seq;
/*
ALTER SEQUENCE torneo_anho_seq
  INCREMENT 1900
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1900
  CACHE 1;
ALTER TABLE torneo_anho_seq
  OWNER TO uca;

 */

