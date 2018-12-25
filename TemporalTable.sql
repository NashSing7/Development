use Development

--Temporal Table

-- Link - https://www.red-gate.com/simple-talk/sql/sql-training/sql-server-temporal-tables-recipes/


select * from sys.tables

CREATE TABLE dbo.tb_SystemSetting
    (
    SettingId INT NOT NULL PRIMARY KEY CLUSTERED,
    SettingName VARCHAR(50) NOT NULL,
    IntValue INT NULL,
    StringValue VARCHAR(100) NULL,
    SysStartTime DATETIME2 GENERATED ALWAYS AS ROW START
      CONSTRAINT DF_SystemSetting_SysStartTime DEFAULT SYSUTCDATETIME() NOT NULL,
    SysEndTime DATETIME2 GENERATED ALWAYS AS ROW END
      CONSTRAINT DF_SystemSetting_SysEndTime 
  	DEFAULT CONVERT( DATETIME2, '9999-12-31 23:59:59' ) NOT NULL,
    PERIOD FOR SYSTEM_TIME(SysStartTime, SysEndTime)
    )
  WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.SystemSettingAudit));

  -- Show the different ways to select, between, for system time , as of etc
  select * from dbo.tb_SystemSetting
  Select * from dbo.SystemSettingAudit

  sp_help 'dbo.tb_SystemSetting'


  --No data will be inserted into history table
  insert into dbo.tb_SystemSetting (SettingId,SettingName,IntValue,StringValue) values (1,'Activate Bluetooth',0, Null)

  --Data will now be inserted into the history table, look at dates
  update dbo.tb_SystemSetting set IntValue = 1 where SettingId = 1
