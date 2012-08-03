 
--TABLAS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


--DROP TABLE goles_x_jugador;
--DROP TABLE planilla;
--DROP TABLE tabla;
--DROP TABLE partido;
--DROP TABLE calendario;
--DROP TABLE ronda;
--DROP TABLE cancha;
--DROP TABLE torneo;
--DROP TABLE jugador;
--DROP TABLE equipo;

--- Table: equipo
CREATE TABLE equipo
(
  id_equipo serial NOT NULL,
  nombre_equipo character varying(30),
  CONSTRAINT pk_equipo PRIMARY KEY (id_equipo )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE equipo
  OWNER TO postgres;


-- Table: jugador
CREATE TABLE jugador
(
  ci_jugador integer NOT NULL,
  id_equipo integer,
  apellido character varying(30),
  edad integer,
  nombre character varying(30),
  CONSTRAINT pk_jugador PRIMARY KEY (ci_jugador ),
  CONSTRAINT pk_equipos_x_jugadores FOREIGN KEY (id_equipo)
      REFERENCES equipo (id_equipo) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE jugador
  OWNER TO postgres;
-- Table: planilla




-- Table: torneo

CREATE TABLE torneo
(
  anho serial NOT NULL,
  estado character varying(20),
  nombre_torneo character varying(30),
  fecha_actual date,
  CONSTRAINT torneo_pkey PRIMARY KEY (anho )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE torneo
  OWNER TO postgres;


-- Table: cancha


CREATE TABLE cancha
(
  id_cancha serial NOT NULL,
  nombre_cancha character varying(25),
  lugar character varying(50),
  CONSTRAINT pk_cancha PRIMARY KEY (id_cancha )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE cancha
  OWNER TO postgres;

  
-- Table: ronda


CREATE TABLE ronda
(
  id_ronda serial NOT NULL UNIQUE,
  fecha date NOT NULL UNIQUE,
  anho integer,
  numero_ronda integer,
  CONSTRAINT pk_anho_numero_ronda PRIMARY KEY (anho, numero_ronda ),
  CONSTRAINT fk_rondas_x_torneo FOREIGN KEY (anho)
      REFERENCES torneo (anho) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE ronda
  OWNER TO postgres;

-- Table: calendario



CREATE TABLE calendario
(
  id_calendario serial NOT NULL,
  fecha date,
  --id_partido integer,
  id_cancha integer,
  hora time without time zone,
  CONSTRAINT pk_calendario PRIMARY KEY (id_calendario ),
  CONSTRAINT fk_canchas_x_calendario FOREIGN KEY (id_cancha)
      REFERENCES cancha (id_cancha) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT pk_rondas_x_calendario FOREIGN KEY (fecha)
      REFERENCES ronda (fecha) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE calendario
  OWNER TO postgres;


-- Table: partido
CREATE TABLE partido
(
  id_partido serial NOT NULL,
  id_ronda integer,
  id_equipo1 integer,
  puntaje1 integer,
  id_equipo2 integer,
  puntaje2 integer,
  CONSTRAINT pk_partido PRIMARY KEY (id_partido ),
  CONSTRAINT fk_ronda_x_partido FOREIGN KEY (id_ronda)
      REFERENCES ronda (id_ronda) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT pk_equipo1_x_equipo FOREIGN KEY (id_equipo1)
      REFERENCES equipo (id_equipo) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT pk_equipo2_equipo FOREIGN KEY (id_equipo2)
      REFERENCES equipo (id_equipo) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE partido
  OWNER TO postgres;



-- Table: tabla


CREATE TABLE tabla
(
  id_tabla serial NOT NULL,
  id_equipo integer,
  anho integer,
  posicion integer,
  puntaje integer,
  CONSTRAINT pk_id_tabla PRIMARY KEY (id_tabla ),
  CONSTRAINT pk_equipos_x_tablas FOREIGN KEY (id_equipo)
      REFERENCES equipo (id_equipo) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT pk_torneo_x_tablas FOREIGN KEY (anho)
      REFERENCES torneo (anho) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE tabla
  OWNER TO postgres;

CREATE TABLE planilla
(
  id_planilla serial NOT NULL,
  id_partido integer,
  ci_jugador integer,
  fue_titular boolean,
  id_equipo integer,
  CONSTRAINT pk_planilla PRIMARY KEY (id_planilla ),
  CONSTRAINT pk_jugadores_x_planillas FOREIGN KEY (ci_jugador)
      REFERENCES jugador (ci_jugador) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT pk_partido_x_planillas FOREIGN KEY (id_partido)
      REFERENCES partido (id_partido) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  UNIQUE (id_partido, ci_jugador)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE planilla
  OWNER TO postgres;
  
CREATE TABLE goles_x_jugador
(
  id_goles serial NOT NULL,
  id_planilla integer,
  ci_jugador integer,
  a_favor integer,
  contra integer,
  CONSTRAINT pk_goles PRIMARY KEY (id_goles ),
  CONSTRAINT pk_planilla_x_goles FOREIGN KEY (id_planilla)
      REFERENCES planilla (id_planilla) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT pk_jugador_x_goles FOREIGN KEY (ci_jugador)
      REFERENCES jugador (ci_jugador) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  UNIQUE (id_planilla, ci_jugador)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE goles_x_jugador
  OWNER TO postgres;
  
  
--Alterar la secuencia de torneo para que empiece del año 1901

-- DROP SEQUENCE torneo_anho_seq;

ALTER SEQUENCE torneo_anho_seq
  INCREMENT 1900
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1900
  CACHE 1;
ALTER TABLE torneo_anho_seq
  OWNER TO postgres;

 

