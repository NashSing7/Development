set transaction isolation level read uncommitted;
--Dirty Read


begin tran

 insert into tb_employeeinfo values ('Duke', 'Sing', 'M');

 waitfor delay '00:00:10';
 select * from tb_employeeinfo ;
rollback tran


-- non repeatable read

begin tran

 select * from tb_employeeinfo where id=1;

 waitfor delay '00:00:10';

 select * from tb_employeeinfo where id=1;

Commit tran

-- phantom read

begin tran

 select * from tb_employeeinfo where gender='M';

 waitfor delay '00:00:10';

 select * from tb_employeeinfo where gender='M';

Commit tran

---------------------------------------------------------------------------------------------

set transaction isolation level read committed;
--Dirty Read


begin tran

 insert into tb_employeeinfo values ('Duke', 'Sing', 'M', null);

 waitfor delay '00:00:10';

rollback tran
 select * from tb_employeeinfo ;

 -- non repeatable read

begin tran

 select * from tb_employeeinfo where id=2;

 waitfor delay '00:00:10';

 select * from tb_employeeinfo where id=2;

Commit tran

-- phantom read

begin tran

 select * from tb_employeeinfo where gender='M';

 waitfor delay '00:00:10';

 select * from tb_employeeinfo where gender='M';

Commit tran

---------------------------------------------------------------------------------------------


set transaction isolation level repeatable read;
--Dirty Read


begin tran

 insert into tb_employeeinfo values ('Duke', 'Sing', 'M', null);

 waitfor delay '00:00:10';

rollback tran
 select * from tb_employeeinfo ;

 -- non repeatable read

begin tran

 select * from tb_employeeinfo where id=4;

 waitfor delay '00:00:10';

 select * from tb_employeeinfo where id=4;

Commit tran

-- phantom read

begin tran

 select * from tb_employeeinfo where gender='M';

 waitfor delay '00:00:10';

 select * from tb_employeeinfo where gender='M';

Commit tran


---------------------------------------------------------------------------------------------


set transaction isolation level serializable;
--Dirty Read


begin tran

 insert into tb_employeeinfo values ('Duke', 'Sing', 'M', null);

 waitfor delay '00:00:10';

rollback tran
 select * from tb_employeeinfo ;

 -- non repeatable read

begin tran

 select * from tb_employeeinfo where id=5;

 waitfor delay '00:00:10';

 select * from tb_employeeinfo where id=5;

Commit tran

-- phantom read

begin tran

 select * from tb_employeeinfo  where gender='M';

 waitfor delay '00:00:10';

 select * from tb_employeeinfo  where gender='M';

Commit tran

sp_help 'tb_employeeinfo'

---------------------------------------------------------------------------------------------


set transaction isolation level snapshot;
--Dirty Read


begin tran

 insert into tb_employeeinfo values ('Duke', 'Sing', 'M', null);

 waitfor delay '00:00:10';

rollback tran
 select * from tb_employeeinfo ;

 -- non repeatable read

begin tran

 select * from tb_employeeinfo where id=5;

 waitfor delay '00:00:10';

 select * from tb_employeeinfo where id=5;

Commit tran

-- phantom read

begin tran

 select * from tb_employeeinfo  where gender='M';

 waitfor delay '00:00:10';

 select * from tb_employeeinfo  where gender='M';

Commit tran