--@noor
--daily backup
USE [msdb]
GO
/****** Object:  Job [dailyBackup]    Script Date: 17/01/2021 04:35:04 ã ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 17/01/2021 04:35:04 ã ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'dailyBackup', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'DESKTOP-5VBV4FQ\noorulhoda', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [backup]    Script Date: 17/01/2021 04:35:04 ã ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'backup', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'BACKUP DATABASE [ExamSystem5] TO  DISK = N''C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\ExamSystem5.bak'' WITH NOFORMAT, NOINIT,  NAME = N''ExamSystem5-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'backupSchedule', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20210117, 
		@active_end_date=99991231, 
		@active_start_time=170000, 
		@active_end_time=235959, 
		@schedule_uid=N'eb18402e-15d1-4b5c-8f9f-471cb46445c8'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO
----coming doesnt runned
--snapshot
create database ExamSystemSShot
on
(name='ExamSysytem',filename='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\ExamSysytem.mdf'),
(name='df1',filename='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\df1.mdf'),
(name='df2',filename='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\df2.mdf')
as snapshot of ExamSystem5
----------------------------------------------------------------------------------------------------
--@nawal
/*File and File Groups made by Nawal zaki*/

Alter database ExamSystem7
Add filegroup SeconderyFG 

alter database ExamSystem7 
Add file
(
	Name = df1,
	FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\df1.mdf',
	Size = 5,
	MaxSize = 20,
	FileGrowth = 2
)to filegroup SeconderyFG

alter database ExamSystem7
Add file
(
	Name =df2,
	FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\df22.mdf',
	Size = 5,
	MaxSize = 20,
	FileGrowth = 2
)to filegroup SeconderyFG

         /*BULK INSERT made by Nawal zaki*/
BULK INSERT [Person].[Student]
FROM 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\StudentData.csv'
WITH (FIRSTROW = 1,
    FIELDTERMINATOR = ',',
	ROWTERMINATOR='\n' ,
	 MAXERRORS=5)
	    /*SCHEMAS made by Nawal zaki*/
CREATE SCHEMA Questions;
ALTER SCHEMA Questions TRANSFER dbo.MCQ;
ALTER SCHEMA Questions TRANSFER dbo.ExamQuestion;
ALTER SCHEMA Questions TRANSFER dbo.TextQuestion;
ALTER SCHEMA Questions TRANSFER dbo.TruefalseQuestion;

CREATE SCHEMA Person;
ALTER SCHEMA Person TRANSFER dbo.Instructor;
ALTER SCHEMA Person TRANSFER dbo.Student;

CREATE SCHEMA StudentData;
ALTER SCHEMA StudentData TRANSFER [dbo].[Branch];
ALTER SCHEMA StudentData TRANSFER [dbo].[Department];
ALTER SCHEMA StudentData TRANSFER [dbo].[DIBT];
ALTER SCHEMA StudentData TRANSFER [dbo].[Intake];
ALTER SCHEMA StudentData TRANSFER [dbo].[Track];

CREATE SCHEMA Exam;
ALTER SCHEMA Exam TRANSFER [dbo].[Allowance];
ALTER SCHEMA Exam TRANSFER [dbo].[Exam];
ALTER SCHEMA Exam TRANSFER [dbo].[StudentExamResult];

CREATE SCHEMA CourseData;
ALTER SCHEMA CourseData TRANSFER [dbo].[Class];
ALTER SCHEMA CourseData TRANSFER [dbo].[Course];
ALTER SCHEMA CourseData TRANSFER [dbo].[CourseTeachingYear];
              /*NONClustered Indexs and Clustered Index made by Nawal zaki*/
create nonclustered index  Nonclustered1
on [Person].[Student](Name)
create nonclustered index  Nonclustered2
on [Person].[Instructor](Name)

                /*Read from XML made by Nawal zaki*/
select * from [Person].[Student]
for xml path

CREATE TABLE XMLwithOpenXML
(
Id INT IDENTITY(1,1) PRIMARY KEY,
XMLData XML,
LoadedDateTime DATETIME
)

INSERT INTO XMLwithOpenXML(XMLData, LoadedDateTime)
SELECT CONVERT(XML, BulkColumn) AS BulkColumn, GETDATE() 
FROM OPENROWSET(BULK 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Student.xml', SINGLE_BLOB) AS x;

SELECT * FROM XMLwithOpenXML
----------------------------------------------------------------------------------------------
--@fatema
