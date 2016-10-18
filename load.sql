\c template1
drop database hat;
create database hat;
\c hat

create extension "postgis";

create table administrative_keywords (
"adminKey"	integer primary key,
"Administrative keywords" text,
"Category Admin keyword" text,
"Origin" text,
"Short summary" text,
"Author or Creator >" text
);

\COPY administrative_keywords FROM 'Administrative_keywords.txt' WITH DELIMITER ',' CSV HEADER

create table collective_name (
"collectiveKey" integer primary key,
"Ethnic name" text,
"Group Name Category" text,
"Origin" text,
"Typology of ethnic name" text,
"Short summary" text,
"Mappable location" text,
"Author or Creator" text
);

\COPY collective_name FROM 'Collective_Name.txt' WITH DELIMITER ',' CSV HEADER

alter table collective_name add column mapLocText text;

update collective_name set mapLocText = "Mappable location";

alter table collective_name drop column "Mappable location";

alter table collective_name add column "Mappable location" geometry;

update collective_name set "Mappable location" = ST_GeomFromText(mapLocText, 4326);

alter table collective_name drop column mapLocText;

create table epigraphic_person (
"personKey" integer primary key,
"Personal name" text,
"Parent's name" text,
"Ethnic name" text,
"Partner's name" text,
"Grandparent's name" text,
"Comments" text
);

\COPY epigraphic_person FROM 'Epigraphic_Person.txt' WITH DELIMITER ',' CSV HEADER

create table epithet (
"epithetKey" integer primary key,
"Epithet" text,
"Author or Creator" text,
"Short summary" text
);

\COPY epithet FROM 'Epithet.txt' WITH DELIMITER ',' CSV HEADER

create table formulaic_keywords (
"formKey"	integer primary key,
"Formulae" text,
"Formulaic category" text,
"Origin" text,
"Short summary" text,
"Author or Creator >" text
);

\COPY formulaic_keywords FROM 'Formulaic_keywords.txt' WITH DELIMITER ',' CSV HEADER

create table honorific_keywords (
"honorKey"	integer primary key,
"Honorific keyword" text,
"Origin" text,
"Honorific category" text,
"Short summary" text,
"Author or Creator >" text
);

\COPY honorific_keywords FROM 'Honorific_keywords.txt' WITH DELIMITER ',' CSV HEADER
 
create table religious_keywords (
"religKey"	integer primary key,
"Religious keyword" text,
"Origin" text,
"Religious Category" text,
"Short summary" text,
"Author or Creator >" text
);

\COPY religious_keywords FROM 'Religious_keywords.txt' WITH DELIMITER ',' CSV HEADER

create table location (
"locKey"	integer primary key,
"Modern Location" text,
"Ancient Site" text,
"Ancient site - region" text,
"Temporal horizon" text,
"Author or Creator >" text
);

\COPY location FROM 'Location.txt' WITH DELIMITER ',' CSV HEADER

create table personal_name (
"nameKey"	integer primary key,
"Personal name" text,
"Gender" text,
"Ethnicity" text,
"Roman onomastics" text,
"LPGN date" text,
"Parissaki date" text,
"Author or Creator >" text
);

\COPY personal_name FROM 'Personal_Name.txt' WITH DELIMITER ',' CSV HEADER

create table geographic_name (
"geoKey"	integer primary key,
"Geographic name" text,
"Geographic Type" text,
"Type of geographical entity" text,
"Short summary" text,
"Mappable location" text,
"Date" text,
"Author or Creator >" text
);



\COPY geographic_name FROM 'Geographic_Name.txt' WITH DELIMITER ',' CSV HEADER

alter table geographic_name add column mapLocText text;

update geographic_name set mapLocText = "Mappable location";

alter table geographic_name drop column "Mappable location";

alter table geographic_name add column "Mappable location" geometry;

update geographic_name set "Mappable location" = ST_GeomFromText(mapLocText, 4326);

alter table geographic_name drop column mapLocText;

create table inscription_info (
"inscriptionKey" integer PRIMARY KEY,
"Creator of the record" text,
"Checked" text,
"Corpus name" text,
"Corpus ID number" text,
"Corpus ID numeric" numeric,
"SEG number" text,
"Location >" text,
"Geolocation" text,
"Position certainty" text,
"Geography notes" text,
"Reuse" text,
"Archaeological context" text,
"Mound" text,
"Material category" text,
"Stone" text,
"Origin of stone" text,
"Object category" text,
"Preservation" text,
"Decoration" text,
"Relief decoration" text,
"Architectural relief" text,
"Figural relief" text,
"Decoration notes" text,
"Visual record availability" text,
"Start Year" numeric,
"End Year" numeric,
"Relative Date" text,
"Century" text,
"Dialect" text,
"Latin" text,
"Language form" text,
"Script" text,
"Layout" text,
"Document typology" text,
"Public documents" text,
"Private documents" text,
"Document typology notes" text,
"Extent of lines" text,
"Administrative keywords" text,
"Formulaic keywords" text,
"Honorific keywords" text,
"Religious keywords" text,
"Epithet >" text,
"Collective group names" text,
"Geographic names" text,
"Imperial titulature" text,
"Currency" text,
"Person >" text,
"Visual documentation" text
);

\COPY inscription_info FROM 'Inscription_Info.txt' WITH DELIMITER ',' CSV HEADER


create table adminInscription (
	"inscriptionKey" integer REFERENCES inscription_info,
	"adminKey" integer REFERENCES administrative_keywords,
	PRIMARY KEY ("inscriptionKey", "adminKey")
);

insert into adminInscription("inscriptionKey", "adminKey")
select "inscriptionKey", cast(s.token as integer) from inscription_info, unnest(string_to_array("Administrative keywords", '|')) s(token) where "Administrative keywords" is not null;

alter table inscription_info drop column "Administrative keywords";

select i."Corpus name", i."Corpus ID number", a."Administrative keywords", a."Short summary"
  from inscription_info i
  JOIN adminInscription USING ("inscriptionKey")
  JOIN administrative_keywords a USING ("adminKey")
  limit 5;

create table formInscription (
	"inscriptionKey" integer REFERENCES inscription_info,
	"formKey" integer REFERENCES formulaic_keywords,
	PRIMARY KEY ("inscriptionKey", "formKey")
);

insert into formInscription("inscriptionKey", "formKey")
select "inscriptionKey", cast(s.token as integer) from inscription_info, unnest(string_to_array("Formulaic keywords", '|')) s(token) where "Formulaic keywords" is not null;

alter table inscription_info drop column "Formulaic keywords";

select i."Corpus name", i."Corpus ID number", a."Formulaic category", a."Short summary"
  from inscription_info i
  JOIN formInscription USING ("inscriptionKey")
  JOIN formulaic_keywords a USING ("formKey")
  limit 5;

--Brian, what have I done wrong?

select * from epigraphic_person limit 5;



alter table inscription_info add column mapLocText text;

update inscription_info set mapLocText = "Geolocation";

alter table inscription_info drop column "Geolocation";

alter table inscription_info add column "Geolocation" geometry;

update inscription_info set "Geolocation" = ST_GeomFromText(mapLocText, 4326);

alter table inscription_info drop column mapLocText;

-- select * from administrative_keywords;
-- select *, st_astext("Mappable location") from collective_name;
-- select * from formulaic_keywords;
-- select * from honorific_keywords;
-- select * from religious_keywords;
-- select * from epithet;
-- select * from epigraphic_person;
-- select * from location;
-- select * from personal_name;
-- select *, st_astext("Mappable location") from geographic_name;
-- select *, st_astext("Geolocation") from inscription_info;