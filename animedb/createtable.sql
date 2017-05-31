		drop schema if exists animedb;
        create schema animedb;
		use animedb;
		create table animes(
		id integer auto_increment,
		title varchar(100) not null,
		ja_title varchar(100),
		director varchar(100) not null,
		year integer not null,
		rating float(4),
		picture_url varchar(200),
		description varchar(6000),
		primary key(id))DEFAULT CHARACTER SET=utf8;

		alter table animes add fulltext(title);
	
		create table voice_actors(
		id integer auto_increment,
		first_name varchar(50),
		last_name varchar(50),
		picture_url varchar(200),
		primary key(id))DEFAULT CHARACTER SET=utf8;
	
		create table voice_actors_in_animes(
		anime_id integer not null,
		voice_actor_id integer not null,
		foreign key(voice_actor_id) references voice_actors(id),
		foreign key(anime_id) references animes(id))DEFAULT CHARACTER SET=utf8;
	
		create table genres(
		id integer auto_increment,
		name varchar(60) not null,
		primary key (id))DEFAULT CHARACTER SET=utf8;
	
		create table genres_in_animes(
		anime_id integer not null,
		genre_id integer not null,
		foreign key(genre_id) references genres(id),
		foreign key(anime_id) references animes(id))DEFAULT CHARACTER SET=utf8;
	
		create table creditcards(
		id varchar(20),
		first_name varchar(50) not null,
		last_name varchar(50) not null,
		expiration date not null,
		primary key(id))DEFAULT CHARACTER SET=utf8;
	
		create table customers(
		id integer auto_increment,
		first_name varchar(50) not null,
		last_name varchar(50) not null,
		cc_id varchar(20) not null,
		address varchar(200) not null,
		email varchar(50) not null,
		password varchar(20) not null,
		primary key(id),
		foreign key (cc_id) references creditcards(id))DEFAULT CHARACTER SET=utf8;


		create table sales(
		id integer auto_increment,
		customer_id integer not null,
		anime_id integer not null,
		sale_date date not null,
		primary key(id),
		foreign key(customer_id) references customers(id),
		foreign key(anime_id) references animes(id))DEFAULT CHARACTER SET=utf8;

		create table employees(
		email varchar(50) primary key,
		password varchar(20) not null,
		fullname varchar(100)
		)DEFAULT CHARACTER SET=utf8;