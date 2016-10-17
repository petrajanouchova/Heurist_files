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
FROM '/home/mq20151400/Heurist_files/Administrative_keywords.txt'
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
FROM '/home/mq20151400/Heurist_files/Collective_Name.txt'
WITH DELIMITER ',' CSV HEADER;

alter table collective_name add column mapLocText text;

update collective_name set mapLocText = "Mappable location";

alter table collective_name drop column "Mappable location";

alter table collective_name add column "Mappable location" geometry;

update collective_name set "Mappable location" = ST_GeomFromText(mapLocText, 4326);

alter table collective_name drop column mapLocText;


















select * from administrative_keywords;
select *, st_astext("Mappable location") from collective_name;