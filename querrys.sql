

create or replace function f_querry1 (p_anho integer, p_ronda integer)
returns void
as $$
declare
	v_eq1 nombres;
	v_eq2 nombres;
	r_aux record;
begin

	r_aux:=	select r.fecha as fecha, ca.nombre_cancha as cancha, p.id_equipo1 as equipo1, p.id_equipo2 as equipo2 
			from rondas r 
			inner join calendario cal on r.id_ronda=cal.id_ronda
			inner join partidos p on cal.id_calendario=p.id_calendario
			inner join canchas ca on cal.id_cancha=ca.id_cancha
			where r.anho=p_anho and r.fecha=p_fecha;
	v_eq1:=select e.nombre_equipo from equipos e where e.id_equipo=r_aux.equipo1;
	v_eq2:=select e.nombre_equipo from equipos e where e.id_equipo=r_aux.equipo2;

	create or replace view querry1 as
		select fecha, cancha, v_eq1, v_eq2 from r_aux;

end;
 $$ language plpgsql;

create or replace function f_querry2 (p_anho integer, p_ronda integer)
returns void
as $$
declare

begin



end;
 $$ language plpgsql;