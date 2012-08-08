
create or replace function f_generar_ronda (dia fechas)
returns void
as $$
declare
	v_anho entero;
	j entero;
	x entero;
	r_aux1 record;
	r_aux2 record;
begin
	v_anho:=(select torneos.anho from torneos where torneos.estado="Iniciado");

	if v_anho then
		update canchas set veces_x_fecha=2; --para controlar que no se use mas de 2 veces una cancha
		insert into rondas (fehca, anho, numero_ronda) values (dia, v_anho, 1); --crea la primera ronda

		drop view sorteo;
		-- crea un view con los equipos desornedados
		create view sorteo as
			select id_equipo from tablas
				where tablas.anho=v_anho order by random();
		if (select count (*) from sorteo)!=12 then
			raise exception 'error en equipos participantes';
		end if;
		for j in 0 .. 5 loop
			--elige una cancha random
			r_aux1 = select * from canchas where veces_x_fecha>0 order by random() limit 1;
			--decrementa la cantidad de veces usadas
			update canchas c set c.veces_x_fecha=c.veces_x_fecha-1 where c.id_cancha=r_aux1.id_canhca;
			--crea la entrada en calendario con la hora de acuerdo a si ya hay o no otro partido en esa cancha
			if r_aux1.veces_x_fecha == 2 then
				insert into calendario ca (ca.fecha, ca.id_cancha, ca.hora) values (dia, r_aux1.id_cancha, '16:30');
			else
				insert into calendario ca (ca.fecha, ca.id_cancha, ca.hora) values (dia, r_aux1.id_cancha, '19:30');
			end if;
			-- crea las entradas en partidos tomando de a 2 los equipos del view
			--controlar select si toma como dos int o no
			insert into partidos p (id_calendario, id_equipo1, id_equipo2, puntaje1, puntaje2) 
				values (currval(calendario_id_calendario_seq1),
				(select id_equipo from sorteo limit 1 offset (j*2)),
				(select id_equipo from sorteo limit 1 offset ((j*2)+1)),
				0,0);
		end loop;
		else
			v_anho:=(select torneos.anho from torneos where torneos.estado="EnProceso");
			if v_anho then

				update canchas set veces_x_fecha=2;
				x:=(select numero_ronda from rondas where id_ronda=currval(rondas_id_ronda_seq));
				--ejecutar funcion que calcula posicion se le pasa anho ronda
				insert into rondas (fehca, anho, numero_ronda) values (dia, v_anho, x+1);
				



