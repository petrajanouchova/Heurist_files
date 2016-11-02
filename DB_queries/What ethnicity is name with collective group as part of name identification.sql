SELECT 
  inscriptionperson.inscriptionkey, 
  inscription_info.corpusname, 
  inscription_info.corpusidnumber, 
  inscription_info.corpusidnumeric, 
  personpersonalname.personkey, 
  personal_name.personalname, 
  personal_name.ethnicity, 
  collective_name.ethnicname
FROM 
  public.inscription_info, 
  public.personal_name, 
  public.inscriptionperson, 
  public.personpersonalname, 
  public.personcollectivename, 
  public.collective_name
WHERE 
  inscription_info.inscriptionkey = inscriptionperson.inscriptionkey AND
  inscriptionperson.personkey = personpersonalname.personkey AND
  personpersonalname.namekey = personal_name.namekey AND
  personpersonalname.personkey = personcollectivename.personkey AND
  personcollectivename.collectivekey = collective_name.collectivekey;
