--select f_querry4('4-4-2010')
create or replace function f_querry4 (fecha date)
returns void
as $$
declare
red record;
isitnull integer;
begin
	--puntos ganados a una fecha dada
	--me da una fecha y busca la ronda mas aproximada, suma los puntos de las planillas que estan en todas esas rondas de ese anho hasta la fecha
	create temporary table posiciones_dadafecha(
		id_equipo integer,
		puntaje integer
	);
	for red in (select * from partidos p
				join calendario c on p.id_calendario=c.id_calendario
				join rondas r on c.id_ronda=r.id_ronda
				where r.fecha<p_fecha and r.anho=extract(year from r.fecha))
	loop
		--si es que el puntaje del primer equipo es mejor que del seguro, lo guarda en la tabla temporal
		if r.puntaje1<r.puntaje2 then
			--si no existia ese equipo, lo guarda
			isitnull:=(select id_equipo from posiciones_dadafecha pp join rondas r on pp.id_equipo=r.id_equipo2);
			if isitnull is null then
				insert into posiciones_dadafecha values (r.id_equipo2, 2);
			else 
				update posiciones_dadafecha pp set pp.puntaje=pp.puntaj-e+2 
					where pp.id_equipo=r.id_equipo2;
			end if;
			isitnull:=(select id_equipo from posiciones_dadafecha pp join rondas r on pp.id_equipo=r.id_equipo1);
			--para que agregue tambien al contrincante que perdio pero sin puntaje \
			if isitnull is null then
				insert into posiciones_dadafecha values (r.id_equipo2, 0);
			end if;
		--si es que el puntaje del primer equipo es peor que del segundo, lo guarda en la tabla temporal
		elsif r.puntaje1>r.puntaje2 then
			isitnull:=(select id_equipo from posiciones_dadafecha pp join rondas r on pp.id_equipo=r.id_equipo1);
			--busca si ya existia el record de este equipo en la tabla, lo guarda si es que es null y lo actualiza si no es null
			if isitnull is null then
				insert into posiciones_dadafecha values (r.id_equipo1, 2);
			else 
				update posiciones_dadafecha pp set pp.puntaje=pp.puntaje+2 
					where pp.id_equipo=r.id_equipo1;
			end if;
			isitnull:=(select id_equipo from posiciones_dadafecha pp join rondas r on pp.id_equipo=r.id_equipo2);
			--Tambien guarda al que pierde pero sin puntaje
			if isitnull is null then
				insert into posiciones_dadafecha values(r.id_equipo1, 0);
			end if;
		else
			--si no se cumplen las condiciones anteriores, entonces fue un empate
			isitnull:=(select id_equipo from posiciones_dadafecha pp join rondas r on pp.id_equipo=r.id_equipo2);
			--guarda los respectivos puntos
			if isitnull is null then
				insert into posiciones_dadafecha values (r.id_equipo, 1);
			else 
				update posiciones_dadafecha pp set pp.puntaje=pp.puntaje+1 
					where pp.id_equipo=r.id_equipo2;
			end if;
			isitnull:=(select id_equipo from posiciones_dadafecha pp join rondas r on pp.id_equipo=r.id_equipo1);
			if isitnull is null then
				insert into posiciones_dadafecha values (r.id_equipo, 1);
			else 
				update posiciones_dadafecha pp set pp.puntaje=pp.puntaje+1 
					where pp.id_equipo=r.id_equipo1;
			end if;
			update posiciones_dadafecha pp set pp.puntaje=pp.puntaje+1 
				where pp.id_equipo=r.id_equipo1;
			update posiciones_dadafecha pp set pp.puntaje=pp.puntaje+1 
				where pp.id_equipo=r.id_equipo1;
		end if;
	end loop;
end;
 $$ language plpgsql;
