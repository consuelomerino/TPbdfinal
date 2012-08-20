select * from equipos;
--primero el torneo (anho, estado, nombre_torneo)
insert into torneos values (2001, 'Iniciado', 'Copa America');
--equipo (id_equipo, nombre_equipo)











insert into equipos (nombre_equipo) values ('Albirroja');
--jugadores (ci_jugadores, id_equipo, apellido, edad, nombre)
select * from jugadores;

insert into equipos (nombre_equipo) values ('Olimpia');

insert into jugadores values (2346547, currval(equipos_id_equipo_seq), 'Lopez', 23, 'Juan');
insert into jugadores values (2346447,currval(equipos_id_equipo_seq), 'Merino', 22, 'Jose');
insert into jugadores values (2349521,currval(equipos_id_equipo_seq), 'Gimenez', 24, 'Joaquin');
insert into jugadores values (1234567,currval(equipos_id_equipo_seq), 'Fulano', 21, 'Herminio');
insert into jugadores values (1234568,currval(equipos_id_equipo_seq), 'Gonzalez', 22, 'Emilio');
insert into jugadores values (12345679,currval(equipos_id_equipo_seq), 'Dominguez', 20, 'Hernan');
insert into jugadores values (1231234,currval(equipos_id_equipo_seq), 'Perez', 23, 'Rolando');
insert into jugadores values (1234123,currval(equipos_id_equipo_seq), 'Manini', 22, 'Marcelo');
insert into jugadores values (3213211,currval(equipos_id_equipo_seq), 'Rodriguez', 20, 'Fernando');
insert into jugadores values (3211231,currval(equipos_id_equipo_seq), 'Estigarribia', 18, 'Carlos');
insert into jugadores values (4324322,currval(equipos_id_equipo_seq), 'Rubilar', 19, 'Jorge');
insert into jugadores values (1230982,currval(equipos_id_equipo_seq), 'Cernuzzi', 20, 'Luca');

insert into equipos (nombre_equipo) values ('Cerro');

insert into jugadores values(123227	,currval(equipos_id_equipo_seq),	'Kelley	 '	, 	20	, 			'Dolan');
insert into jugadores values(123641	,currval(equipos_id_equipo_seq),	'	Mclean	 '	, 	21	, 	'	Sawyer	 '	);
insert into jugadores values(123387	,currval(equipos_id_equipo_seq),	'	Dillon	 '	, 	22	, 	'	Craig	 '	);
insert into jugadores values(123241	,currval(equipos_id_equipo_seq),	'	Keith	 '	, 	23	, 	'	Fritz	 '	);
insert into jugadores values(123416	,currval(equipos_id_equipo_seq),	'	Lyons	 '	, 	24	, 	'	Arsenio	 	');
insert into jugadores values(123263	,currval(equipos_id_equipo_seq),	'	Fisher	 '	, 	25	, 	'	Reed	 	');
insert into jugadores values(123187	,currval(equipos_id_equipo_seq),	'	Dickson	 '	, 	20	, 	'	Buckminster	' 	);
insert into jugadores values(123326	,currval(equipos_id_equipo_seq),	'	French	 '	, 	21	, 	'	Tarik	 '	);
insert into jugadores values(123398	,currval(equipos_id_equipo_seq),	'	Velazquez'	 	, 	22	,' 	Addison	 '	);
insert into jugadores values(123471	,currval(equipos_id_equipo_seq),	'	Suarez	 '	, 	23	, 	'	Brett	 '	);
insert into jugadores values(123441	,currval(equipos_id_equipo_seq),	'	Blake	 '	, 	24	, 	'	Leroy	 '	);
insert into jugadores values(123597	,currval(equipos_id_equipo_seq),	'	Barry	 '	, 	25	, 	'	Colt	 '	);
insert into jugadores values(123516	,currval(equipos_id_equipo_seq),	'	Little	 '	, 	20	, 	'	Hu	 '	);
insert into jugadores values(123643	,currval(equipos_id_equipo_seq),	'	Reed	 '	, 	21	, 	'	Wayne	 '	);

insert into equipos (nombre_equipo) values ('Manchester');

insert into jugadores values(123306	,currval(equipos_id_equipo_seq),	'	Foster	 '	, 	22	, 	'	Jason	 '	);
insert into jugadores values(123341	,currval(equipos_id_equipo_seq),	'	Marks	 '	, 	23	, 	'	Raphael	 '	);
insert into jugadores values(123240	,currval(equipos_id_equipo_seq),	'	Ochoa	 '	, 	24	, 	'	Allistair'	 	);
insert into jugadores values(123317	,currval(equipos_id_equipo_seq),	'	Becker	 '	, 	25	, 	'	Ferris	 	');
insert into jugadores values(123257	,currval(equipos_id_equipo_seq),	'	Mathis	 '	, 	20	, 	'	Denton	 	');
insert into jugadores values(123265	,currval(equipos_id_equipo_seq),	'	Dalton	 '	, 	21	, 	'	Caleb	 	');
insert into jugadores values(123335	,currval(equipos_id_equipo_seq),	'	Sandoval'	 	, 	22	,' 		Cruz'	 	);
insert into jugadores values(123135	,currval(equipos_id_equipo_seq),	'	Page	 '	, 	23	, 	'	Devin	 	');
insert into jugadores values(123256	,currval(equipos_id_equipo_seq),	'	Holland	 '	, 	24	, 	'	Ronan	 	');
insert into jugadores values(123508	,currval(equipos_id_equipo_seq),	'	Henderson'	 	, 	25	,' 		Kennan'	 	);
insert into jugadores values(123486	,currval(equipos_id_equipo_seq),	'	Ramos	 '	, 	20	, 	'	Talon	 '	);
insert into jugadores values(123226	,currval(equipos_id_equipo_seq),	'	Case	 '	, 	21	, 	'	Hayden	 '	);
insert into jugadores values(123653	,currval(equipos_id_equipo_seq),	'	Guthrie	 '	, 	22	, 	'	Brandon	 '	);
insert into jugadores values(123142	,currval(equipos_id_equipo_seq),	'	Poole	 '	, 	23	, 	'	Carter	 '	);
insert into jugadores values(123331	,currval(equipos_id_equipo_seq),	'	Winters	 '	, 	24	, 	'	Otto	 '	);
insert into jugadores values(123481	,currval(equipos_id_equipo_seq),	'	Dixon	 '	, 	25	, 	'	Wylie	 '	);
insert into jugadores values(123569	,currval(equipos_id_equipo_seq),	'	Moore	' 	, 	20	, 	'	Quentin	 '	);

insert into equipos (nombre_equipo) values ('Albatroz');

insert into jugadores values(123171	 ,currval(equipos_id_equipo_seq),	'	Joyner	'	, 	20	, 	'	Kieran	'	);
insert into jugadores values(123236	 ,currval(equipos_id_equipo_seq),	'	Landry	'	, 	21	, 	'	Elmo	'	);
insert into jugadores values(12331	 ,currval(equipos_id_equipo_seq),	'	Townsend'		, 	22	,' 		Driscoll'		);
insert into jugadores values(123197	 ,currval(equipos_id_equipo_seq),	'	Maxwell	'	, 	23	, 	'	Julian	'	);
insert into jugadores values(123181	 ,currval(equipos_id_equipo_seq),	'	Hebert	'	, 	24	, 	'	Chadwick'		);
insert into jugadores values(1232597	 ,currval(equipos_id_equipo_seq),	'	Jones	'	, 	25	, 	'	Samson	'	);
insert into jugadores values(123321	 ,currval(equipos_id_equipo_seq),	'	Sheppard'		, 	20	,' 		Otto'		);
insert into jugadores values(123276	 ,currval(equipos_id_equipo_seq),	'	Austin	'	, 	21	, 	'	Fulton		');
insert into jugadores values(123448	 ,currval(equipos_id_equipo_seq),	'	Rodriquez'		, 	22	,' 		Mason'		);
insert into jugadores values(123485	 ,currval(equipos_id_equipo_seq),	'	Holcomb	'	, 	23	, 	'	Calvin	'	);
insert into jugadores values(123604	 ,currval(equipos_id_equipo_seq),	'	Landry	'	, 	24	, 	'	Macaulay'		);
insert into jugadores values(1233387	 ,currval(equipos_id_equipo_seq),	'	Phillips'		, 	25	,' 	Calvin	'	);
insert into jugadores values(123560	 ,currval(equipos_id_equipo_seq),	'	Buck	'	, 	20	, 	'	Ashton	'	);
insert into jugadores values(123189	 ,currval(equipos_id_equipo_seq),	'	Douglas	'	, 	21	, 	'	Lucius	'	);

insert into equipos (nombre_equipo) values ('Comanger');

insert into jugadores values(1233481	 ,currval(equipos_id_equipo_seq),	'	Gould	'	, 	22	, 	'	Amos	'	);
insert into jugadores values(123579	 ,currval(equipos_id_equipo_seq),	'	Dixon	'	, 	23	, 	'	Joel	'	);
insert into jugadores values(123495	 ,currval(equipos_id_equipo_seq),	'	Meadows	'	, 	24	, 	'	Fuller	'	);
insert into jugadores values(123361	 ,currval(equipos_id_equipo_seq),	'	Terry	'	, 	25	, 	'	Geoffrey'		);
insert into jugadores values(123559	 ,currval(equipos_id_equipo_seq),	'	Kirk	'	, 	20	, 	'	Castor	'	);
insert into jugadores values(123386	 ,currval(equipos_id_equipo_seq),	'	Clemons	'	, 	21	, 	'	Lars	'	);
insert into jugadores values(123475	 ,currval(equipos_id_equipo_seq),	'	Blankenship'		, 	22	,' 	Brennan	'	);
insert into jugadores values(123290	 ,currval(equipos_id_equipo_seq),	'	Mathis	'	, 	23	, 	'	Seth	'	);
insert into jugadores values(123379	 ,currval(equipos_id_equipo_seq),	'	Hardy	'	, 	24	, 	'	Wing	'	);
insert into jugadores values(123418	 ,currval(equipos_id_equipo_seq),	'	Knowles	'	, 	25	, 	'	Clinton	'	);
insert into jugadores values(123228	 ,currval(equipos_id_equipo_seq),	'	Clayton	'	, 	20	, 	'	Keefe	'	);
insert into jugadores values(123255	 ,currval(equipos_id_equipo_seq),	'	Baldwin	'	, 	21	, 	'	Reuben	'	);
insert into jugadores values(123538	 ,currval(equipos_id_equipo_seq),	'	Pickett	'	, 	22	, 	'	Hamilton'		);
insert into jugadores values(123203	 ,currval(equipos_id_equipo_seq),	'	Cherry	'	, 	23	, 	'	Elijah	'	);
insert into jugadores values(123413	 ,currval(equipos_id_equipo_seq),	'	Woodard		', 	24	, 	'	Ronan	'	);
insert into jugadores values(123510	 ,currval(equipos_id_equipo_seq),	'	Jimenez		', 	25	, 	'	Abbot	'	);
insert into jugadores values(123302	 ,currval(equipos_id_equipo_seq),	'	Callahan	'	, 	20	,' 		Baker'		);
insert into jugadores values(123370	 ,currval(equipos_id_equipo_seq),	'	Horne		', 	21	, 	'	Macon		');

insert into equipos (nombre_equipo) values ('Niupi');

insert into jugadores values(123292	 ,currval(equipos_id_equipo_seq), 	'	Vazquez	'	, 	22	, 		'Allistair'		);
insert into jugadores values(123274	 ,currval(equipos_id_equipo_seq), 	'	Jenkins	'	, 	23	, 	'	Justin	'	);
insert into jugadores values(123389	 ,currval(equipos_id_equipo_seq), 	'	Nielsen	'	, 	24	, 	'	Nolan	'	);
insert into jugadores values(123161	 ,currval(equipos_id_equipo_seq), 	'	Valdez	'	, 	25	, 	'	Paul	'	);
insert into jugadores values(123594	 ,currval(equipos_id_equipo_seq), 	'	Orr	'	, 	20	, 	'	Isaac	'	);
insert into jugadores values(123288	 ,currval(equipos_id_equipo_seq), 	'	Shaw	'	, 	21	, 	'	Magee	'	);
insert into jugadores values(123460	 ,currval(equipos_id_equipo_seq), 	'	Hamilton'		, 	22	,' 	Lucas	'	);
insert into jugadores values(123366	 ,currval(equipos_id_equipo_seq), 	'	Briggs	'	, 	23	, 	'	Brady	'	);
insert into jugadores values(123368	 ,currval(equipos_id_equipo_seq), 	'	Holloway'		, 	24	,' 	Damian	'	);
insert into jugadores values(123412	 ,currval(equipos_id_equipo_seq), 	'	Terry	'	, 	25	, 	'	Murphy	'	);
insert into jugadores values(1232226	 ,currval(equipos_id_equipo_seq), 	'	Crosby	'	, 	20	, 	'	Leonard	'	);
insert into jugadores values(123248	 ,currval(equipos_id_equipo_seq), 	'	Kelly	'	, 	21	, 	'	Beau	'	);
insert into jugadores values(123540	 ,currval(equipos_id_equipo_seq), 	'	Woodward'		, 	22	,' 	Peter	'	);
insert into jugadores values(123395	 ,currval(equipos_id_equipo_seq), 	'	Beck	'	, 	23	, 	'	Mason	'	);

insert into equipos (nombre_equipo) values ('Addario');

insert into jugadores values(123266	 ,currval(equipos_id_equipo_seq),	'	Walsh		', 	24	, 		'Forrest	'	);
insert into jugadores values(123524	 ,currval(equipos_id_equipo_seq),	'	Donaldson	'	, 	25	, 	'	Chester	'	);
insert into jugadores values(123340	 ,currval(equipos_id_equipo_seq),	'	Stephenson	'	, 	20	, 	'	Kennedy'		);
insert into jugadores values(123149	 ,currval(equipos_id_equipo_seq),	'	Gardner	'	, 	21	, 		'Melvin	'	);
insert into jugadores values(123212	 ,currval(equipos_id_equipo_seq),	'	Rodgers	'	, 	22	, 		'Bradley'		);
insert into jugadores values(123347	 ,currval(equipos_id_equipo_seq),	'	Galloway'		, 	23	, '		Adam'		);
insert into jugadores values(123186	 ,currval(equipos_id_equipo_seq),	'	Lambert	'	, 	24	, 	'	Cole		');
insert into jugadores values(123517	 ,currval(equipos_id_equipo_seq),	'	Quinn	'	, 	25	, 	'	Nicholas	'	);
insert into jugadores values(123567	 ,currval(equipos_id_equipo_seq),	'	Le	'	, 	20	, 	'	Nathan	'	);
insert into jugadores values(123440	 ,currval(equipos_id_equipo_seq),	'	Ball	'	, 	21	, 	'	Peter	'	);
insert into jugadores values(123267	 ,currval(equipos_id_equipo_seq),	'	Flynn	'	, 	22	, 	'	Nash	'	);
insert into jugadores values(123462	 ,currval(equipos_id_equipo_seq),	'	Bass	'	, 	23	, 	'	Vladimir'		);
insert into jugadores values(123570	 ,currval(equipos_id_equipo_seq),	'	Hubbard	'	, 	24	, 	'	Rigel	'	);
insert into jugadores values(123346	 ,currval(equipos_id_equipo_seq),	'	Kidd	'	, 	25	, 	'	Burke	'	);

insert into equipos (nombre_equipo) values ('Arquitna');

insert into jugadores values(123177	 ,currval(equipos_id_equipo_seq), 	'	Nelson	'	, 	20	, 	'	Uriah	'	);
insert into jugadores values(123239	 ,currval(equipos_id_equipo_seq), 	'	Blevins	'	, 	21	, 	'	Damian	'	);
insert into jugadores values(123246	 ,currval(equipos_id_equipo_seq), 	'	Conner	'	,	22	, 	'	Phillip	'	);
insert into jugadores values(1233266	 ,currval(equipos_id_equipo_seq), 	'	Vinson	'	,	23	, 	'	Jasper	'	);
insert into jugadores values(1233727	 ,currval(equipos_id_equipo_seq), 	'	Nelson	'	, 	20	, 	'	Uriah	'	);
insert into jugadores values(123388	 ,currval(equipos_id_equipo_seq), 	'	Blevins	'	, 	21	, 	'	Damian	'	);
insert into jugadores values(234567	 ,currval(equipos_id_equipo_seq), 	'	Conner	'	,	22	, 	'	Phillip	'	);
insert into jugadores values(231234	 ,currval(equipos_id_equipo_seq), 	'	Vinson	'	,	23	, 	'	Jasper	'	);
insert into jugadores values(293727	 ,currval(equipos_id_equipo_seq), 	'	Nelson	'	, 	20	, 	'	Uriah	'	);
insert into jugadores values(208263	 ,currval(equipos_id_equipo_seq), 	'	Blevins	'	, 	21	, 	'	Damian	'	);
insert into jugadores values(218383	 ,currval(equipos_id_equipo_seq), 	'	Conner	'	,	22	, 	'	Phillip	'	);
insert into jugadores values(223938	 ,currval(equipos_id_equipo_seq), 	'	Vinson	'	,	23	, 	'	Jasper	'	);
insert into jugadores values(231282	 ,currval(equipos_id_equipo_seq), 	'	Nelson	'	, 	20	, 	'	Uriah	'	);
insert into jugadores values(248231	 ,currval(equipos_id_equipo_seq), 	'	Blevins	'	, 	21	, 	'	Damian	'	);

insert into equipos (nombre_equipo) values ('Rogela');

insert into jugadores values(258273	 ,currval(equipos_id_equipo_seq), 	'	Conner	'	,	22	, 	'	Phillip	'	);
insert into jugadores values(349127	 ,currval(equipos_id_equipo_seq), 	'	Vinson	'	,	23	, 	'	Jasper	'	);
insert into jugadores values(317273	 ,currval(equipos_id_equipo_seq), 	'	Nelson	'	, 	20	, 	'	Uriah	'	);
insert into jugadores values(301272	 ,currval(equipos_id_equipo_seq), 	'	Blevins	'	, 	21	, 	'	Damian	'	);
insert into jugadores values(328383	 ,currval(equipos_id_equipo_seq), 	'	Conner	'	,	22	, 	'	Phillip	'	);
insert into jugadores values(332837	 ,currval(equipos_id_equipo_seq), 	'	Vinson	'	,	23	, 	'	Jasper	'	);
insert into jugadores values(348282	 ,currval(equipos_id_equipo_seq), 	'	Nelson	'	, 	20	, 	'	Uriah	'	);
insert into jugadores values(352928	 ,currval(equipos_id_equipo_seq), 	'	Blevins	'	, 	21	, 	'	Damian	'	);
insert into jugadores values(368292	 ,currval(equipos_id_equipo_seq), 	'	Conner	'	,	22	, 	'	Phillip	'	);
insert into jugadores values(372029	 ,currval(equipos_id_equipo_seq), 	'	Vinson	'	,	23	, 	'	Jasper	'	);
insert into jugadores values(387282	 ,currval(equipos_id_equipo_seq), 	'	Nelson	'	, 	20	, 	'	Uriah	'	);
insert into jugadores values(392728	 ,currval(equipos_id_equipo_seq), 	'	Blevins	'	, 	21	, 	'	Damian	'	);
insert into jugadores values(401282	 ,currval(equipos_id_equipo_seq), 	'	Conner	'	,	22	, 	'	Phillip	'	);
insert into jugadores values(418822	 ,currval(equipos_id_equipo_seq), 	'	Vinson	'	,	23	, 	'	Jasper	'	);
insert into jugadores values(429283	 ,currval(equipos_id_equipo_seq), 	'	Nelson	'	, 	20	, 	'	Uriah	'	);

insert into equipos (nombre_equipo) values ('Espanha');

insert into jugadores values(431928	 ,currval(equipos_id_equipo_seq), 	'	Blevins	'	, 	21	, 	'	Damian	'	);
insert into jugadores values(442332	 ,currval(equipos_id_equipo_seq), 	'	Conner	'	,	22	, 	'	Phillip	'	);
insert into jugadores values(459922	 ,currval(equipos_id_equipo_seq), 	'	Vinson	'	,	23	, 	'	Jasper	'	);
insert into jugadores values(462932	 ,currval(equipos_id_equipo_seq), 	'	Blevins	'	, 	21	, 	'	Damian	'	);
insert into jugadores values(472819	 ,currval(equipos_id_equipo_seq), 	'	Conner	'	,	22	, 	'	Phillip	'	);
insert into jugadores values(483749	 ,currval(equipos_id_equipo_seq), 	'	Vinson	'	,	23	, 	'	Jasper	'	);
insert into jugadores values(493738	 ,currval(equipos_id_equipo_seq), 	'	Blevins	'	, 	21	, 	'	Damian	'	);
insert into jugadores values(503844	 ,currval(equipos_id_equipo_seq), 	'	Conner	'	,	22	, 	'	Phillip	'	);
insert into jugadores values(513849	 ,currval(equipos_id_equipo_seq), 	'	Vinson	'	,	23	, 	'	Jasper	'	);
insert into jugadores values(529182	 ,currval(equipos_id_equipo_seq), 	'	Blevins	'	, 	21	, 	'	Damian	'	);
insert into jugadores values(539828	 ,currval(equipos_id_equipo_seq), 	'	Conner	'	,	22	, 	'	Phillip	'	);
insert into jugadores values(547273	 ,currval(equipos_id_equipo_seq), 	'	Vinson	'	,	23	, 	'	Jasper	'	);

insert into equipos (nombre_equipo) values ('Libertad');

insert into jugadores values(552833	 ,currval(equipos_id_equipo_seq),	'	Hebert	'	, 	24	, 	'	Chadwick'		);
insert into jugadores values(562732	 ,currval(equipos_id_equipo_seq),	'	Jones	'	, 	25	, 	'	Samson	'	);
insert into jugadores values(572639	 ,currval(equipos_id_equipo_seq),	'	Sheppard'		, 	20	,' 		Otto'		);
insert into jugadores values(582638	 ,currval(equipos_id_equipo_seq),	'	Austin	'	, 	21	, 	'	Fulton		');
insert into jugadores values(597834	 ,currval(equipos_id_equipo_seq),	'	Rodriquez'		, 	22	,' 		Mason'		);
insert into jugadores values(603834	 ,currval(equipos_id_equipo_seq),	'	Holcomb	'	, 	23	, 	'	Calvin	'	);
insert into jugadores values(618283	 ,currval(equipos_id_equipo_seq),	'	Landry	'	, 	24	, 	'	Macaulay'		);
insert into jugadores values(629821	 ,currval(equipos_id_equipo_seq),	'	Phillips'		, 	25	,' 	Calvin	'	);
insert into jugadores values(639819	 ,currval(equipos_id_equipo_seq),	'	Buck	'	, 	20	, 	'	Ashton	'	);
insert into jugadores values(642873	 ,currval(equipos_id_equipo_seq),	'	Douglas	'	, 	21	, 	'	Lucius	'	);
insert into jugadores values(652823	 ,currval(equipos_id_equipo_seq),	'	Gould	'	, 	22	, 	'	Amos	'	);
insert into jugadores values(662823	 ,currval(equipos_id_equipo_seq),	'	Dixon	'	, 	23	, 	'	Joel	'	);
insert into jugadores values(677233	 ,currval(equipos_id_equipo_seq),	'	Meadows	'	, 	24	, 	'	Fuller	'	);

insert into equipos (nombre_equipo) values ('Rodeo');

insert into jugadores values(682723	 ,currval(equipos_id_equipo_seq),	'	Terry	'	, 	25	, 	'	Geoffrey'		);
insert into jugadores values(692727	 ,currval(equipos_id_equipo_seq),	'	Kirk	'	, 	20	, 	'	Castor	'	);
insert into jugadores values(702283	 ,currval(equipos_id_equipo_seq),	'	Clemons	'	, 	21	, 	'	Lars	'	);
insert into jugadores values(719282	 ,currval(equipos_id_equipo_seq),	'	Blankenship'		, 	22	,' 	Brennan	'	);
insert into jugadores values(729182	 ,currval(equipos_id_equipo_seq),	'	Mathis	'	, 	23	, 	'	Seth	'	);
insert into jugadores values(739183	 ,currval(equipos_id_equipo_seq),	'	Hardy	'	, 	24	, 	'	Wing	'	);
insert into jugadores values(749183	 ,currval(equipos_id_equipo_seq),	'	Knowles	'	, 	25	, 	'	Clinton	'	);
insert into jugadores values(759283	 ,currval(equipos_id_equipo_seq),	'	Clayton	'	, 	20	, 	'	Keefe	'	);
insert into jugadores values(752839	 ,currval(equipos_id_equipo_seq),	'	Baldwin	'	, 	21	, 	'	Reuben	'	);
insert into jugadores values(768238	 ,currval(equipos_id_equipo_seq),	'	Pickett	'	, 	22	, 	'	Hamilton'		);
insert into jugadores values(782837	 ,currval(equipos_id_equipo_seq), 	'	Nelson	'	, 	20	, 	'	Uriah	'	);
insert into jugadores values(792383	 ,currval(equipos_id_equipo_seq), 	'	Blevins	'	, 	21	, 	'	Damian	'	);
--canchas (id_cancha, nombre_cancha, lugar, veces_x_fecha)
insert into canchas (nombre_cancha, lugar) values ('Defensores del Chaco', 'Avda. Eusebio Ayala');
insert into canchas (nombre_cancha, lugar) values('Quidditch','Hogwarts');
insert into canchas (nombre_cancha, lugar) values('Comuneros','Chacarita');
insert into canchas (nombre_cancha, lugar) values('Leon Condou','Deportivo San Jose');
insert into canchas (nombre_cancha, lugar) values('San Juan','Avda. Peron');
insert into canchas (nombre_cancha, lugar) values('San Luis','Gral. Diaz');
insert into canchas (nombre_cancha, lugar) values('San Roque','San Roque');
insert into canchas (nombre_cancha, lugar) values('Rogelio Ayala','Avda. Mcal. Lopez');
--rondas (id_ronda, fecha, anho, numero_ronda) generado
--calendario (id_calendario, id_ronda, id_cancha, hora) generado
--partidos (id_partido, id_calendario, id_equipo1, puntaje1, id_equipo2, puntaje2) generado
--planillas (id_planilla, id_partido, ci_jugador, fue_titular, id_equipo) manual
--goles_x_jugador (id_goles, id_planilla, ci_jugador, a_favor, contra) manual
--tabla_puntuaciones (id_tabla, id_equipo, anho, posicion, puntaje)


