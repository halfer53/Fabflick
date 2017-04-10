		drop schema if exists moviedb;
        create schema moviedb;
		use moviedb;
		drop table if exists sales;
	    drop table if exists customers;
	    drop table if exists creditcards;
		drop table if exists genres_in_movies;
		drop table if exists stars_in_movies;
		drop table if exists movies;
		drop table if exists stars;
		drop table if exists genres;
	
	
		create table movies(
		id integer auto_increment,
		title varchar(100) not null,
		year integer not null,
		director varchar(100),
		banner_url varchar(200) not null,
		trailer_url varchar(200),
		primary key(id));
	
		create table stars(
		id integer auto_increment,
		first_name varchar(50),
		last_name varchar(50),
		dob date,
		photo_url varchar(200),
		primary key(id));
	
		create table stars_in_movies(
		star_id integer not null,
		movie_id integer not null,
		foreign key(star_id) references stars(id),
		foreign key(movie_id) references movies(id));
	
		create table genres(
		id integer auto_increment,
		name varchar(32),
		primary key (id));
	
		create table genres_in_movies(
		genre_id integer not null,
		movie_id integer not null,
		foreign key(genre_id) references genres(id),
		foreign key(movie_id) references movies(id));
	
		create table creditcards(
		id varchar(20),
		first_name varchar(50) not null,
		last_name varchar(50) not null,
		expiration date not null,
		primary key(id));
	
		create table customers(
		id integer auto_increment,
		first_name varchar(50) not null,
		last_name varchar(50) not null,
		cc_id varchar(20) not null,
		address varchar(200) not null,
		email varchar(50) not null,
		password varchar(20) not null,
		primary key(id),
		foreign key (cc_id) references creditcards(id));


		create table sales(
		id integer auto_increment,
		customer_id integer not null,
		movie_id integer not null,
		sale_date date,
		primary key(id),
		foreign key(customer_id) references customers(id),
		foreign key(movie_id) references movies(id));