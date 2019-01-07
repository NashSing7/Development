use Development

--Temporal Table

-- You cannot drop a table that has system versioning on, first have to turn it off
ALTER TABLE dbo.tb_SystemSetting SET (SYSTEM_VERSIONING = OFF);
DROP TABLE dbo.tb_SystemSetting
DROP TABLE dbo.SystemSettingAudit


-- Requirements for creating temporal tables (NEW)
CREATE TABLE dbo.tb_SystemSetting
    (
    SettingId INT NOT NULL PRIMARY KEY CLUSTERED, -- Need a PK
    SettingName VARCHAR(50) NOT NULL,
    IntValue INT NULL,
    StringValue VARCHAR(100) NULL,
    SysStartTime DATETIME2 GENERATED ALWAYS AS ROW START, --[HIDDEN] --Required to show validity period
    SysEndTime DATETIME2 GENERATED ALWAYS AS ROW END, --[HIDDEN] -- Required to show validity period
    PERIOD FOR SYSTEM_TIME(SysStartTime, SysEndTime) -- Required as designation period for columns
    )
  WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.SystemSettingAudit)); -- Required to set system versioning on as well as a linked history table
       -- HISTORY_RETENTION_PERIOD = 2 YEARS , this is only available in SQL 2017+


  -- Show the different ways to select, between, for system time , as of etc
  select * from dbo.tb_SystemSetting
  Select * from dbo.SystemSettingAudit -- There is no PK created as it is not allowed and there is a Clustered index created on SysEndTime, SysStartTime

  sp_help 'dbo.tb_SystemSetting'
  sp_help 'dbo.SystemSettingAudit'

  
  --Modifying Data

  --No data will be inserted into history table
  insert into dbo.tb_SystemSetting (SettingId, SettingName, IntValue, StringValue) 
                            values (1,'Activate Bluetooth', 0 , Null);

  select * from dbo.tb_SystemSetting -- SysStartTime is inserted as UTC and EndTime is set to max time
  Select * from dbo.SystemSettingAudit -- No data inserted here 

  --Data will now be inserted into the history table, look at dates
  update dbo.tb_SystemSetting set IntValue = 1 where SettingId = 1;

  select * from dbo.tb_SystemSetting -- SysStartTime is updated as UTC and EndTime is set to max time, new value shows up
  Select * from dbo.SystemSettingAudit -- Old value is now inserted in here, SysStartTime shows the time this was first instered into parent table and SysEndTime shows the time the update occurred , this shows the period in whic this record was valid for

  -- Data will now be deleted from parent table and inserted into history table
  Delete from dbo.tb_SystemSetting where SettingId = 1;

  select * from dbo.tb_SystemSetting -- Row is removed
  Select * from dbo.SystemSettingAudit -- Shows the record that was deleted along with the time it was valid for (UTC) 


  -- Querying Data (Will automatically query the parent table as well as the history table)
  -- Use SYSTEM_TIME clause with one of the following subclauses against the table
  -- 4 ways:
  
  -- This shows you what the data looked like at a certain point in time
  select * from dbo.tb_SystemSetting for system_time as of '2019-01-07 09:09:38.9124921' -- This can be a varaible
  -- SysStartTime <= @DT and SysEndTime > @DT


  -- This shows you what the data looked like from a certain point in time To a certain point in time (Not inclusive)
   select * from dbo.tb_SystemSetting for system_time from '2019-01-07' to '2019-01-08'  -- This can be a varaible
   -- SysStartTime < @End and SysEndTime > @Start

   -- This shows you what the data looked like from a certain point in time To a certain point in time (End Inclusive)
   select * from dbo.tb_SystemSetting for system_time between '2019-01-07' and '2019-01-08'  -- This can be a varaible
   -- SysStartTime <= @End and SysEndTime > @Start

   -- This shows you what the data looked like from a certain point in time To a certain point in time (Both Inclusive)
   select * from dbo.tb_SystemSetting for system_time contained in ( '2019-01-07','2019-01-08')  -- This can be a varaible
   -- SysStartTime >= @Start and SysEndTime <= @End

   -- To get all versions
   SELECT *
   FROM dbo.tb_SystemSetting  FOR SYSTEM_TIME ALL;


   --Note
   -- If you start a transaction and affect multiple rows and that tran runs for 5 mins , the time will be taken as transaction start time

   Begin

   Begin Tran

     insert into dbo.tb_SystemSetting (SettingId, SettingName, IntValue, StringValue) 
                            values (2,'Activate Brake', 0 , Null);

							waitfor delay '00:00:10'

							     insert into dbo.tb_SystemSetting (SettingId, SettingName, IntValue, StringValue) 
                            values (3,'Activate Indicator', 0 , Null);


   commit tran

   End

   --Query and check the start times will be the same
   select * from dbo.tb_SystemSetting


   -- You can also add system versioning to existing tables(gets more complicated if tables have data in them)

   CREATE TABLE dbo.tb_City
  (
  	CityId INT NOT NULL PRIMARY KEY CLUSTERED,
  	CityName varchar(32) NULL,
  	CityPopulation INT NULL
  )

  select * from dbo.tb_City
  -- We need to add the temporal requirements before any data is required

  ALTER TABLE dbo.tb_City
  ADD SysStartTime datetime2 GENERATED ALWAYS AS ROW START  ,
  SysEndTime datetime2 GENERATED ALWAYS AS ROW END ,
         PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime)
  GO
   
  ALTER TABLE dbo.tb_City
      SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.tb_City_History))
  GO

  select * from tb_City_History