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


create table formInscription (
	"inscriptionKey" integer REFERENCES inscription_info,
	"formKey" integer REFERENCES formulaic_keywords,
	PRIMARY KEY ("inscriptionKey", "formKey")
);

insert into formInscription("inscriptionKey", "formKey")
select "inscriptionKey", cast(s.token as integer) from inscription_info, unnest(string_to_array("Formulaic keywords", '|')) s(token) where "Formulaic keywords" is not null;

alter table inscription_info drop column "Formulaic keywords";

create table honorInscription (
	"inscriptionKey" integer REFERENCES inscription_info,
	"honorKey" integer REFERENCES honorific_keywords,
	PRIMARY KEY ("inscriptionKey", "honorKey")
);

insert into honorInscription("inscriptionKey", "honorKey")
select "inscriptionKey", cast(s.token as integer) from inscription_info, unnest(string_to_array("Honorific keywords", '|')) s(token) where "Honorific keywords" is not null;

alter table inscription_info drop column "Honorific keywords";


create table religInscription (
	"inscriptionKey" integer REFERENCES inscription_info,
	"religKey" integer REFERENCES religious_keywords,
	PRIMARY KEY ("inscriptionKey", "religKey")
);

insert into religInscription("inscriptionKey", "religKey")
select "inscriptionKey", cast(s.token as integer) from inscription_info, unnest(string_to_array("Religious keywords", '|')) s(token) where "Religious keywords" is not null;

alter table inscription_info drop column "Religious keywords";


create table epithetInscription (
	"inscriptionKey" integer REFERENCES inscription_info,
	"epithetKey" integer REFERENCES epithet,
	PRIMARY KEY ("inscriptionKey", "epithetKey")
);

insert into epithetInscription("inscriptionKey", "epithetKey")
select "inscriptionKey", cast(s.token as integer) from inscription_info, unnest(string_to_array("Epithet >", '|')) s(token) where "Epithet >" is not null;

alter table inscription_info drop column "Epithet >";

create table locInscription (
	"inscriptionKey" integer REFERENCES inscription_info,
	"locKey" integer REFERENCES location,
	PRIMARY KEY ("inscriptionKey", "locKey")
);

insert into locInscription("inscriptionKey", "locKey")
select "inscriptionKey", cast(s.token as integer) from inscription_info, unnest(string_to_array("Location >", '|')) s(token) where "Location >" is not null;

alter table inscription_info drop column "Location >";



create table geoInscription (
	"inscriptionKey" integer REFERENCES inscription_info,
	"geoKey" integer REFERENCES geographic_name,
	PRIMARY KEY ("inscriptionKey", "geoKey")
);

insert into geoInscription("inscriptionKey", "geoKey")
select "inscriptionKey", cast(s.token as integer) from inscription_info, unnest(string_to_array("Geographic names", '|')) s(token) where "Geographic names" is not null;

alter table inscription_info drop column "Geographic names";

select i."Corpus name", i."Corpus ID number", a."Geographic name", a."Geographic Type"
  from inscription_info i
  JOIN geoInscription USING ("inscriptionKey")
  JOIN geographic_name a USING ("geoKey")
  limit 5;

create table collectiveInscription (
	"inscriptionKey" integer REFERENCES inscription_info,
	"collectiveKey" integer REFERENCES collective_name,
	PRIMARY KEY ("inscriptionKey", "collectiveKey")
);

insert into collectiveInscription("inscriptionKey", "collectiveKey")
select "inscriptionKey", cast(s.token as integer) from inscription_info, unnest(string_to_array("Collective group names", '|')) s(token) where "Collective group names" is not null;

alter table inscription_info drop column "Collective group names";



alter table inscription_info add column mapLocText text;

update inscription_info set mapLocText = "Geolocation";

alter table inscription_info drop column "Geolocation";

alter table inscription_info add column "Geolocation" geometry;

update inscription_info set "Geolocation" = ST_GeomFromText(mapLocText, 4326);

alter table inscription_info drop column mapLocText;




select i."Corpus name", i."Corpus ID number", a."Administrative keywords", a."Short summary"
  from inscription_info i
  JOIN adminInscription USING ("inscriptionKey")
  JOIN administrative_keywords a USING ("adminKey")
  limit 5;


select i."Corpus name", i."Corpus ID number", a."Formulaic category", a."Short summary"
  from inscription_info i
  JOIN formInscription USING ("inscriptionKey")
  JOIN formulaic_keywords a USING ("formKey")
  limit 5;


select i."Corpus name", i."Corpus ID number", a."Honorific keyword", a."Short summary"
  from inscription_info i
  JOIN honorInscription USING ("inscriptionKey")
  JOIN honorific_keywords a USING ("honorKey")
  limit 5;


select i."Corpus name", i."Corpus ID number", a."Religious keyword", a."Short summary"
  from inscription_info i
  JOIN religInscription USING ("inscriptionKey")
  JOIN religious_keywords a USING ("religKey")
  limit 5; 


select i."Corpus name", i."Corpus ID number", a."Epithet", a."Short summary"
  from inscription_info i
  JOIN epithetInscription USING ("inscriptionKey")
  JOIN epithet a USING ("epithetKey")
  limit 5;


select i."Corpus name", i."Corpus ID number", a."Modern Location", a."Ancient Site"
  from inscription_info i
  JOIN locInscription USING ("inscriptionKey")
  JOIN location a USING ("locKey")
  limit 5;


select i."Corpus name", i."Corpus ID number", a."Ethnic name", a."Group Name Category"
  from inscription_info i
  JOIN collectiveInscription USING ("inscriptionKey")
  JOIN collective_name a USING ("collectiveKey")
  limit 5;


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
