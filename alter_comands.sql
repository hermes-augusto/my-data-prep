ALTER table datawarehouse.teste
ADD column email  varchar(255);

ALTER table datawarehouse.teste
DROP column email;

ALTER TABLE datawarehouse.teste
ALTER COLUMN email TYPE varchar(200);


