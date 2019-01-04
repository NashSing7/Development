set transaction isolation level read uncommitted;

--Dirty Read

select * from tb_employeeinfo

-- Non repeatable read

update tb_employeeinfo set salary=500 where id=1 

-- Phantom read

insert into tb_employeeinfo values ('Jonty', 'Sing', 'M', null);

-----------------------------------------------------------------------------------------

set transaction isolation level read committed;

--Dirty Read(Not a problem)

select * from tb_employeeinfo

-- Non repeatable read

update tb_employeeinfo set salary=100 where id=3 

-- Phantom read

insert into tb_employeeinfo values ('Diesel', 'Sing', 'M', null);

-----------------------------------------------------------------------------------------

set transaction isolation level repeatable read;

--Dirty Read(Not a problem)

select * from tb_employeeinfo

-- Non repeatable read(Not a problem)

update tb_employeeinfo set salary=1000 where id=4

-- Phantom read

insert into tb_employeeinfo values ('Duke', 'Sing', 'M', null);

-----------------------------------------------------------------------------------------

set transaction isolation level serializable;

--Dirty Read(Not a problem)

select * from tb_employeeinfo

-- Non repeatable read(Not a problem)

update tb_employeeinfo set salary=1000 where id=5

-- Phantom read

insert into tb_employeeinfo values ('Duke', 'Sing', 'M', null);


update tb_employeeinfo set gender='F' where id=5

-----------------------------------------------------------------------------------------

set transaction isolation level snapshot;

--Dirty Read(Not a problem)

select * from tb_employeeinfo

-- Non repeatable read(Not a problem)

update tb_employeeinfo set salary=1000 where id=5

-- Phantom read

insert into tb_employeeinfo values ('Duke', 'Sing', 'M', null);


update tb_employeeinfo set gender='F' where id=5