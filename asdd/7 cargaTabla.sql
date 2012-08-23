
create or replace function f_cargaTabla(p_anho entero)
returns void
as $$
declare
	r record;
begin

	for r in (select id_equipo from equipos order by random() limit 12)
	loop
		insert into tabla_puntuaciones (id_equipo, anho, posicion, puntaje) 
		values (r.id_equipo, p_anho, 0, 0);
	end loop;
end;
$$ language plpgsql;

--select f_cargaTabla(2001);