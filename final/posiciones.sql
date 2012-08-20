
create or replace function f_posicion ( p_anho entero, p_ronda entero)
returns void
as $$
declare
	v_pos entero;
	r record;
	j entero;
begin
	case p_ronda
		when 1,2,3 then
			v_pos:=12;
		when 4 then
			v_pos:=10;
		when 5 then
			v_pos:=8;
		when 6 then
			v_pos:=6;
		when 7 then
			v_pos:=4;
		when 8 then
			v_pos:=2;
		else 
	end case;

	raise notice '%',p_ronda;	
			
/*
	drop view eliminacion;
	create view eliminacion as
		select t.id_equipo, t.puntaje, (count(p1.id_partido)+count(p2.id_partido)) as perdidos, trunc(random() * 23 + 1) as aleatorio
		from tabla_puntuaciones t inner join torneos on (t.anho=torneos.anho)
		inner join rondas r on (torneos.anho=r.anho)
		inner join calendario c on (r.id_ronda=c.id_ronda)
		inner join partidos p1 on (c.id_calendario=p1.id_calendario)
		inner join partidos p2 on (c.id_calendario=p2.id_calendario)
		where t.anho=p_anho and t.posicion<=v_pos and
		((t.id_equipo=p1.id_equipo1 and p1.puntaje1<p1.puntaje2)
		or (t.id_equipo=p2.id_equipo2 and p2.puntaje2<p2.puntaje1))
		order by t.puntaje desc, perdidos asc, aleatorio asc;
*/

	drop table if exists eliminacion;
	create temp table eliminacion as
		select t.id_equipo, t.puntaje, 
		(select count(*) from partidos p
			inner join calendario on (p.id_calendario=calendario.id_calendario)
			inner join rondas on (calendario.id_ronda=rondas.id_ronda)
			where rondas.anho=p_anho and
			((p.id_equipo1=t.id_equipo and p.puntaje1<p.puntaje2)or
			(p.id_equipo2=t.id_equipo and p.puntaje2<p.puntaje1))) as perdidos,
		
		trunc(random() * 23 + 1) as aleatorio
		from tabla_puntuaciones t
		where t.anho=p_anho and t.posicion<=v_pos
		order by t.puntaje desc, perdidos asc, aleatorio asc;
		
	j:=1;
	for r in select * from eliminacion loop
		update tabla_puntuaciones set posicion=j
		where tabla_puntuaciones.id_equipo=r.id_equipo;
		j:=j+1;
	end loop;

end;
$$ language plpgsql;