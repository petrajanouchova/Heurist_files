\c mq20151400
drop database hat;
create database hat;
\c hat

create extension "postgis";

create table administrative_keywords (
"Record ID"	integer primary key,
"Administrative keywords" text,
"Category Admin keyword" text,
"Origin" text,
"Short summary" text,
"Author or Creator >" text
);

COPY administrative_keywords 
FROM '/home/petra/Github/Heurist_files/Administrative_keywords.txt'
WITH DELIMITER ',' CSV HEADER;

create table collective_name (
"Record ID" integer primary key,
"Ethnic name" text,
"Group Name Category" text,
"Origin" text,
"Typology of ethnic name" text,
"Short summary" text,
"Mappable location" text,
"Author or Creator" text
);

COPY collective_name 
FROM '/home/petra/Github/Heurist_files/Collective_Name.txt'
WITH DELIMITER ',' CSV HEADER;

alter table collective_name add column mapLocText text;

update collective_name set mapLocText = "Mappable location";

alter table collective_name drop column "Mappable location";

alter table collective_name add column "Mappable location" geometry;

update collective_name set "Mappable location" = ST_GeomFromText(mapLocText, 4326);

alter table collective_name drop column mapLocText;

create table epigraphic_person (
"Record ID" integer primary key,
"Personal name" text,
"Parent's name" text,
"Ethnic name" text,
"Partner's name" text,
"Grand[arent's name" text,
"Comments" text
);

COPY epigraphic_person
FROM '/home/petra/Github/Heurist_files/Epigraphic_Person.txt'
WITH DELIMITER ',' CSV HEADER;

create table epithet (
"Record ID" integer primary key,
"Epithet" text,
"Author or Creator" text,
"Short summary" text
);

COPY epithet
FROM '/home/petra/Github/Heurist_files/Epithet.txt'
WITH DELIMITER ',' CSV HEADER;

create table formulaic_keywords (
"Record ID"	integer primary key,
"Formulae" text,
"Formulaic category" text,
"Origin" text,
"Short summary" text,
"Author or Creator >" text
);

COPY formulaic_keywords 
FROM '/home/petra/Github/Heurist_files/Formulaic_keywords.txt'
WITH DELIMITER ',' CSV HEADER;

create table honorific_keywords (
"Record ID"	integer primary key,
"Honorific keyword" text,
"Origin" text,
"Honorific category" text,
"Short summary" text,
"Author or Creator >" text
);

COPY honorific_keywords 
FROM '/home/petra/Github/Heurist_files/Honorific_keywords.txt'
WITH DELIMITER ',' CSV HEADER;
 
create table religious_keywords (
"Record ID"	integer primary key,
"Religious keyword" text,
"Origin" text,
"Religious Category" text,
"Short summary" text,
"Author or Creator >" text
);

COPY religious_keywords 
FROM '/home/petra/Github/Heurist_files/Religious_keywords.txt'
WITH DELIMITER ',' CSV HEADER;

create table location (
"Record ID"	integer primary key,
"Modern Location" text,
"Ancient Site" text,
"Ancient site - region" text,
"Temporal horizon" text,
"Author or Creator >" text
);

COPY location 
FROM '/home/petra/Github/Heurist_files/Location.txt'
WITH DELIMITER ',' CSV HEADER;

Record ID,Personal name,Gender,Ethnicity,Roman onomastics,LPGN date,Parissaki date,Author or Creator

create table personal_name (
"Record ID"	integer primary key,
"Personal name" text,
"Gender" text,
"Ethnicity" text,
"Roman onomastics" text,
"LPGN date" text,
"Parissaki date" text,
"Author or Creator >" text
);

COPY personal_name 
FROM '/home/petra/Github/Heurist_files/Personal_Name.txt'
WITH DELIMITER ',' CSV HEADER;

create table geographic_name (
"Record ID"	integer primary key,
"Geographic name" text,
"Type of geographical entity" text,
"Short summary" text,
"Mappable location" text,
"Date" text,
"Author or Creator >" text
);

COPY geographic_name 
FROM '/home/petra/Github/Heurist_files/Geographic_Name.txt'
WITH DELIMITER ',' CSV HEADER;

Record ID,Geographic name,Geographic Type,Type of geographical entity,Short summary,Mappable location,Date,Author or Creator

select * from administrative_keywords;
select *, st_astext("Mappable location") from collective_name;
select * from formulaic_keywords;
select * from honorific_keywords;
select * from religious_keywords;
select * from epithet;
select * from epigraphic_person;
select * from geographic_name;
select * from location;
select * from personal_name;