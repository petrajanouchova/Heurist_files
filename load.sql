\c mq20151400
drop database hat;
create database hat;
\c hat

create table administrative_keywords (
"Record ID"	integer primary key,
"Administrative keywords" text,
"Category Admin keyword" text,
"Origin" text,
"Short summary" text,
"Author or Creator >" text
);

create table colective_name (
"Record ID" integer primary key,
"Ethnic name" text,
"Group Name Category" text,
"Origin" text,
"Typology of ethnic name" text,
"Short summary" text,
"Mappable location" point,
"Author or Creator" text
);


COPY administrative_keywords 
FROM '/home/mq20151400/Heurist_files/Administrative_keywords.txt'
'/home/petra/Github/Heurist_files/Administrative_keywords.txt'
'/home/petra/Github/Heurist_files/Collective_Name.txt'

WITH DELIMITER ',' CSV HEADER;

select * from administrative_keywords;
select * from collective_name;