use animedb;
DROP  PROCEDURE IF EXISTs add_anime;
DELIMITER $$
CREATE PROCEDURE animedb.add_anime(in atitle varchar(100),in ayear INT, in adirector varchar(100), in fname varchar(100),in lname varchar(100), in gname varchar(100), out answer varchar(200)) 

BEGIN
	DECLARE voiceid Integer;
    DECLARE anime_id Integer;
    DECLARE genre_id Integer;
    DECLARE part1 varchar(100);
    DECLARE part2 varchar(100);
    DECLARE part3 varchar(100);

IF (select count(*) from voice_actors where first_name = fname and last_name = lname) = 0 THEN
    insert into voice_actors(first_name, last_name) values(fname, lname);
    set voiceid = (select id from voice_actors where first_name = fname and last_name = lname limit 1);
	set part1 = 'voice_actors inserted |';
 ELSE
    set voiceid = (select id from voice_actors where first_name = fname and last_name = lname limit 1);
    set part1 = ' this voice actor has already existed |';
 END IF;
IF (select count(*) from genres where name = gname) = 0 THEN
    insert into genres(name) values(gname);
    set genre_id = (select id from genres where name = gname limit 1);
    set part2 = ' genre inserted |';
 ELSE
    set genre_id = (select id from genres where name = gname limit 1);
    set part2 = ' this genre has alreay existed |';
 END IF;
 
 IF (select count(*) from animes where title = atitle and director = adirector and year = ayear) = 0 THEN
    insert into animes(title, year, director) values(atitle, ayear, adirector);
    set anime_id = (select id from animes where title = atitle and director = adirector and year = ayear limit 1);
    set part3 = ' anime inserted |';
 ELSE
    set anime_id = (select id from animes where title = atitle and director = adirector and year = ayear limit 1);
    set part3 = ' this anime has already existed |';
 END IF;
 IF (select count(*) from genres_in_animes where anime_id = anime_id and genre_id = genre_id) = 0 THEN
 insert into genres_in_animes(anime_id, genre_id) values (anime_id, genre_id);
 END IF;
 IF (select count(*) from voice_actors_in_animes where voice_actor_id = voiceid and anime_id = anime_id) = 0 THEN
 insert into voice_actors_in_animes(anime_id, voice_actor_id) values (anime_id, voiceid);
 END IF;
 set answer = concat(concat(part1, part2), part3);
 END;
 $$ 
 
 call add_anime('patirck at dallas1', 1995, 'Ywj','bruce1', 'tan', 'smart1',@a);
 select @a;
