
/*
Family name inheritance:
How many people have the same ethnicity with their parents? public.inscriptionperson has Personal name and Parent's name of identic Ethnicity (e.g., when personal name is Greek and Parent's name is Greek). There are only four values: Greek, Roman, Thracian, Uncertain.
How many people have the same ethnicity as their grandparents?
How many people have the same ethnicity as their partners?
How many people have different ethnicity as their parents, grandparents, partners. I guess I need one example and then I will play with it.
What is the name Ethnicity in cases when the CollectiveGroup is not null? See github DB_queries for my SQL. https://github.com/petrajanouchova/Heurist_files/tree/master/DB_queries
Personal name of individual person:
How many personal names has individual person (public.inscriptionperson). See github DB_queries for my SQL - it looks right, but I am not sure about the join. https://github.com/petrajanouchova/Heurist_files/tree/master/DB_queries
What ethnicity are all personal names of individual person, for example if individual person has three personal names, I need to know ethnicity of all of them (e.g., Roman, Roman, Thracian).
What is the gender of individual person (public.inscriptionperson). Similar as with the ethnicity above.
*/

select 'Family name inheritance';

--How many people have the same ethnicity with their parents? public.inscriptionperson has Personal name and Parent's name of identic Ethnicity 
-- (e.g., when personal name is Greek and Parent's name is Greek). There are only four values: Greek, Roman, Thracian, Uncertain.

select count(*)
from (
select * 
  from personPersonalName 
    JOIN personal_name USING (nameKey)

  where class = 'Personal name'

  ) personal join (

select *
from personPersonalName
  JOIN personal_name USING (nameKey)

   where class = 'Parent name') parent using (personkey)
  where parent.ethnicity = personal.ethnicity
  ;


--How many people have the same ethnicity as their grandparents?




select count(*)
from (
select * 
  from personPersonalName 
    JOIN personal_name USING (nameKey)

  where class = 'Personal name'

  ) personal join (

select *
from personPersonalName
  JOIN personal_name USING (nameKey)

   where class = 'Grandparent name') parent using (personkey)
  where parent.ethnicity = personal.ethnicity
  ;



  

--How many people have the same ethnicity as their grandparents?




select count(*)
from (
select * 
  from personPersonalName 
    JOIN personal_name USING (nameKey)

  where class = 'Personal name'

  ) personal join (

select *
from personPersonalName
  JOIN personal_name USING (nameKey)

   where class = 'Partner name') parent using (personkey)
  where parent.ethnicity = personal.ethnicity
  ;



 -- How many people have different ethnicity as their parents, grandparents, partners. I guess I need one example and then I will play with it.

select count(*)
from (
select * 
  from personPersonalName 
    JOIN personal_name USING (nameKey)

  where class = 'Personal name'

  ) personal join (

select *
from personPersonalName
  JOIN personal_name USING (nameKey)

   where class = 'Partner name') parent using (personkey)
  where parent.ethnicity != personal.ethnicity
  ;

-- What is the name Ethnicity in cases when the CollectiveGroup is not null? 
-- See github DB_queries for my SQL. https://github.com/petrajanouchova/Heurist_files/tree/master/DB_queries


select class, personalname, ethnicity, ethnicname, groupnamecategory
  from personPersonalName 
    JOIN personal_name USING (nameKey)
    JOIN personCollectiveName USING (personKey)
    JOIN collective_name USING (collectiveKey) 
      where class = 'Personal name'
      ;

select 'Personal name of individual person:';

--How many personal names has individual person (public.inscriptionperson). See github DB_queries for my SQL - it looks right, but I am not sure about the join. https://github.com/petrajanouchova/Heurist_files/tree/master/DB_queries




select personkey, count(*) as total
  from inscriptionperson 
  join personPersonalName using (personkey)
  where class = 'Personal name'
  group by personkey
  order by total desc
  ;  

-- Explain this, please. ^^ doesn't feel right. What are you trying to prove?

--What ethnicity are all personal names of individual person, for example if individual person has three personal names, I need to know ethnicity of all of them (e.g., Roman, Roman, Thracian).

select personkey, class, personalname, ethnicity
  from inscriptionperson 
  join personPersonalName using (personkey)
  JOIN personal_name USING (nameKey)
  where class = 'Personal name'  
  ;  

--What is the gender of individual person (public.inscriptionperson). Similar as with the ethnicity above.
select personkey, class, personalname, gender
  from inscriptionperson 
  join personPersonalName using (personkey)
  JOIN personal_name USING (nameKey)
  where class = 'Personal name'  
  ;  
