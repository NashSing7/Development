/*
-- Link - https://www.red-gate.com/simple-talk/sql/sql-training/sql-server-temporal-tables-recipes/

Temporal, or system-versioned, tables were introduced as a database feature in SQL Server 2016. This gives us a type of table that can provide information about the data that was stored at any specified time rather than just the data that is current. ANSI SQL 2011 first specified a temporal table as a database feature and this is now supported in SQL Server.

The most common business uses for temporal tables are:

Slowly changing dimensions.
The temporal tables provide a simpler way to querying data that is current for a specified period of time, such as time slicing data, that well-known problem on Data Warehousing databases.

Data Auditing. 
The temporal tables provide an audit trail to determine when data was modified in the “parent” table. This helps to meet the requirements of regulatory compliance and to do data forensics when needed by tracking and auditing data changes over time.

Repairing or recovering record level corruptions.
Establishing a way of ‘undoing’ a data change on a table’s row without downtime in case a record is accidentally deleted or updated. Therefore, the previous version of the data can be retrieved from the history table and inserted back into the ‘parent’ table. – This helps when someone (or because of some application errors) accidentally deletes data and you want to revert to it or recover it.

Reproducing financial reports, invoices and statements 
with the correct data for the date of issue of the document. Temporal tables allow you to query data as it was at a particular point in time to examine the state of the data as it was then.

Analyzing trends by understanding how the data changes over time with the ongoing business activity, and to calculate trends in the way that data changes over time.


How can this benefit us ?
In the dark days before SQL Server 2016 was introduced, the data-logging mechanism had to be established explicitly in a trigger. We still use triggers to do this for us.

The temporal tables feature of SQL Server 2016 can dramatically simplify the logging mechanism. This article provides step-by-step instructions on how to accomplish system-versioned tables.

To migrate a table into the temporal table, a temporal table option can be set on an existing table. 
To create a new temporal table, you just need to set the temporal table option to ON (for example, SYSTEM_VERSIONING = ON). When the temporal table option is enabled, SQL Server 2016 generates the “historical” table automatically, and internally maintains both parent and historical tables, one for storing the actual data and the other for the historical data. The temporal table’s SYSTEM_TIME period columns (for example SysStartTime and SysEndTime) enables the mechanism to query data for a different time slice more efficiently. The updated or deleted data moves into the “historical” table, whilst the “parent” table keeps the latest row version for updated records.


What is the catch?
The most important considerations, restrictions and limitations of Temporal Tables are:

In order to relate records between the Temporal Table and the history table, you must have a primary key in the Temporal Table. However, the history table cannot have a primary key.
The datetime2 datatype must be set for the SYSTEM_TIME period columns (for example SysStartTime and SysEndTime).
When you create a history table, you must always specify both the schema and table name of the temporal table in the history table.
The PAGE compression is the default setting for the history table.
The Temporal Tables support blob data types, (nvarchar(max), varchar(max), varbinary(max), ntext, text, and image), that could affect the storage costs and have performance issues.
Both temporal and history tables must be created in the same database. You cannot use a Linked Server to provide the Temporal Tables.
You cannot use constraints, primary key, foreign keys or column constraints for the history tables.
You cannot reference Temporal Tables in indexed views that have queries that use the FOR SYSTEM_TIME clause
The SYSTEM_TIME period columns cannot be directly referenced in INSERT and UPDATE statements.
You cannot use TRUNCATE TABLE while SYSTEM_VERSIONING is ON.
You are not allowed to directly modify the data in a history table.

*/

/*

Pc Setup

Running Docker
-- https://nexxtjump.com/2017/12/12/step-by-step-guide-to-run-sql-server-in-a-windows-docker-container/

Docker Commands
-- https://docs.docker.com/engine/reference/commandline/start/

Have to use PS or get UI (KiteMatic)

*/

/*

Resources 

Itzik Ben-Gen
http://tsql.solidq.com/resources/



*/