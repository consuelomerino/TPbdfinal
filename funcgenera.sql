
create or replace function f_generar_ronda (dia fechas)
returns void
as $$
declare
	v_anho entero;
	j entero;
	x entero;
	v_valron entero;
	v_dia2 fechas;
	r_aux1 record;
	r_aux2 record;
	v_n_par entero;
	v_par_agreg entero;
begin
	v_anho:=(select torneos.anho from torneos where torneos.estado="Iniciado");

	if v_anho then

		drop view sorteo;
		-- crea un view con los equipos desornedados
		create view sorteo as
			select id_equipo from tablas
				where tablas.anho=v_anho order by random();
		if (select count (*) from sorteo)!=12 then
			raise exception 'error en equipos participantes';
		end if;
		update torneos set estado='EnProceso' where anho=v_anho;
		update canchas set veces_x_fecha=2; --para controlar que no se use mas de 2 veces una cancha
		insert into rondas (fehca, anho, numero_ronda) values (dia, v_anho, 1); --crea la primera ronda 
		for j in 0 .. 5 loop
			--elige una cancha random
			r_aux1 = (select * from canchas where veces_x_fecha>0 order by random() limit 1);
			--decrementa la cantidad de veces usadas
			update canchas c set c.veces_x_fecha=c.veces_x_fecha-1 where c.id_cancha=r_aux1.id_canhca;
			--crea la entrada en calendario con la hora de acuerdo a si ya hay o no otro partido en esa cancha
			if r_aux1.veces_x_fecha == 2 then
				insert into calendario (fecha, id_cancha, hora) values (dia, r_aux1.id_cancha, '16:30');
			else
				insert into calendario (fecha, id_cancha, hora) values (dia, r_aux1.id_cancha, '19:30');
			end if;
			-- crea las entradas en partidos tomando de a 2 los equipos del view
			--controlar select si toma como dos int o no
			insert into partidos (id_calendario, id_equipo1, id_equipo2, puntaje1, puntaje2) 
				values (currval(calendario_id_calendario_seq1),
				(select id_equipo from sorteo limit 1 offset (j*2)),
				(select id_equipo from sorteo limit 1 offset ((j*2)+1)),
				0,0);
		end loop;
	else
			v_anho:=(select torneos.anho from torneos where torneos.estado="EnProceso");
			if v_anho then

				update canchas set veces_x_fecha=2;
				v_valron:= currval(rondas_id_ronda_seq);
				x:=(select numero_ronda from rondas where id_ronda=v_valron);
				v_dia2:=(select fehca from rondas where id_ronda=v_valron);
				--ejecutar funcion que calcula posicion se le pasa anho ronda
				if x < 8 then
					insert into rondas (fehca, anho, numero_ronda) values (dia, v_anho, x+1);
					if x <3 then
						v_n_par := 6;
					else
						v_n_par := 8-x;
					end if;
					v_par_agreg :=0;
					
					while(v_par_agreg < v_n_par) loop
						for r_aux2 in (select t1.id_equipo as eq1, t2.id_equipo as eq2
							from tabla t1 cross join tabla t2
							where t1.anho=v_anho and t2.anho=v_anho
							and t1.id_equipo != t2.id_equipo
							and t1.posicion <= (2*v_n_par)
							and t2.posicion <= (2*v_n_par)
							order by random())
						loop
							if (select count(*) from partidos p
								join calendario c on p.id_calendario=c.id_calendario
								where (p.id_equipo1=r_aux2.eq1 and c.fecha=dia)
								or (p.id_equipo2=r_aux2.eq1 and c.fecha=dia)
								or (p.id_equipo1=r_aux2.eq2 and c.fecha=dia)
								or (p.id_equipo2=r_aux2.eq2 and c.fecha=dia)
								or (p.id_equipo1=r_aux2.eq1 and p.id_equipo2=r_aux2.eq2 and c.fehca=v_dia2)
								or (p.id_equipo1=r_aux2.eq2 and p.id_equipo2=r_aux2.eq1 and c.fehca=v_dia2)
							) = 0 then
								r_aux1 = (select * from canchas where veces_x_fecha>0 order by random() limit 1);
								update canchas c set c.veces_x_fecha=c.veces_x_fecha-1 where c.id_cancha=r_aux1.id_canhca;
								if r_aux1.veces_x_fecha == 2 then
									insert into calendario (fecha, id_cancha, hora) values (dia, r_aux1.id_cancha, '16:30');
								else
									insert into calendario (fecha, id_cancha, hora) values (dia, r_aux1.id_cancha, '19:30');
								end if;
								insert into partidos (id_calendario, id_equipo1, id_equipo2, puntaje1, puntaje2) 
									values (currval(calendario_id_calendario_seq1),
									r_aux2.eq1, r_aux2.eq2, 0, 0);
								v_par_agreg:=v_par_agreg+1;
							end if;
							exit when v_par_agreg=v_n_par;
						end loop;
						v_dia2:=dia;
					end loop;
				else
					update torneos set estado='Terminado' where anho=v_anho;
				end if;
			else
				raise exception 'no hay torneo activo';
			end if;
	end if;
end;
$$ language plpgsql;