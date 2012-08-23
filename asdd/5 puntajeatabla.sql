

create or replace function f_puntaje_a_tabla (p_anho entero, p_ronda entero)
returns void
as $$
declare
	r record;
	v_idr entero;
begin
	v_idr:= (select id_ronda from rondas where anho=p_anho and numero_ronda=p_ronda);
	for r in (select * from partidos 
		inner join calendario on (partidos.id_calendario=calendario.id_calendario)
		where calendario.id_ronda=v_idr)
	loop
		if r.puntaje1<r.puntaje2 then
			update tabla_puntuaciones set puntaje=puntaje+2 where id_equipo=r.id_equipo2;
		elsif r.puntaje1>r.puntaje2 then
			update tabla_puntuaciones set puntaje=puntaje+2 where id_equipo=r.id_equipo1;
		else
			update tabla_puntuaciones set puntaje=puntaje+1 where id_equipo=r.id_equipo2;
			update tabla_puntuaciones set puntaje=puntaje+1 where id_equipo=r.id_equipo1;
		end if;
	end loop;

end;
$$language plpgsql;