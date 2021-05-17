--@noorulhoda
/*create database ExamSystem7
on
(
		 Name=ExamSysytem, 
		 FileName='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\ExamSystem7.mdf',
		 size=10, 
		 MaxSize=50,
		 FileGrowth=10
)
Log On
(
		Name = ExamSystemLog,
		FileName='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\ExamSystem7.ldf',
		Size=5, 
		MaxSize= 40,
		FileGrowth= 10
		
)
go*/
create type ID from int not null 
create type SmallCustomString from nvarchar(50)
create type BigCustomString from nvarchar(200)
--create sequence QuestionSequence START WITH 1 INCREMENT BY 1

go
create table Class
(
	ID ID primary key identity(1,1),
	Number varchar(3),
	IsDeleted int not null default 0
)
go
insert into Class values('C1',0),('C2',0),('C3',0) 
create table Instructor
(
	ID ID primary key identity(1,1),
	[Name] SmallCustomString,
	UserName SmallCustomString unique,
	[Password] SmallCustomString,
	ManagerId int default 0,
	IsDeleted int not null ,
	FOREIGN KEY (ManagerId) REFERENCES Instructor(ID)	
)

go 
insert into Instructor values('Ahmad','AhmadUser','AhmadPass',null,0)
insert into Instructor values ('Aly','AlyUser','AlyPass',1,0),
							 ('Mohammad','MohammadUser','MohammadPass',1,0)
create table Course
(
	ID ID primary key identity(1,1),
	Title SmallCustomString,
	Description BigCustomString,
	MinDegree int not null,
	MaxDegree int not null,
	instructorID ID default 0,
	IsDeleted ID default 0
	FOREIGN KEY(InstructorID) REFERENCES Instructor(ID)
)
go

insert into Course values('SQL','SQLDescription',50,100,1,0),
							('XML','XMLLDescription',60,100,2,0),
							('OOP','OOPDescription',50,100,3,0)

create table CourseTeachingYear
( 
    ID ID primary key identity(1,1),
	ClassID ID default 0,
	CourseID ID default 0 ,
	InstructorID ID default 0 ,
	year int,
	FOREIGN KEY (ClassID) REFERENCES Class(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(CourseID) REFERENCES Course(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(InstructorID) REFERENCES Instructor(ID) ON DELETE CASCADE ON UPDATE CASCADE,
)
alter table [CourseData].[CourseTeachingYear] add IsDeleted int not null default 0
go

insert into [CourseData].[CourseTeachingYear] values(1,1,1,2018,0),(2,2,2,2019,0),(3,3,3,2020,0)


create table Student
(
	ID ID primary key identity(1,1),
	Name SmallCustomString,
	Email SmallCustomString,
	UserName SmallCustomString unique,
	Password SmallCustomString,
	IsDeleted ID default 0
)

insert into Student values ('Noorulhoda','Noor@gmail.com','NoorUser','NoorPass',0),
							('Nawal','Nawal@gmail.com','NawalUser','NawalPass',0),
							('Nada','Nada@gmail.com','NadaUser','NadaPass',0)



--@fatema

create table MCQ(
ID ID primary key identity(1,1),
Content BigCustomstring,
CorrectChoice char,
FullDegree int,
Choice1 nvarchar(100),
Choice2 nvarchar(100),
Choice3 nvarchar(100),
CourseID ID default 0,
IsDeleted ID default 0
FOREIGN KEY (CourseID) REFERENCes [CourseData].[Course](ID)
)
go
--alter table Questions.MCQ
--drop constraint PK__MCQ__3214EC2727C73132
--select CONSTRAINT_NAME
--from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
--where TABLE_NAME = 'MCQ'
insert into Questions.MCQ values('The ____ clause is used to list the attributes desired in the result of a query.',1,3,'1) Where','2) Select
','3) From',1,0);
insert into Questions.MCQ values('Which of the following statements contains an error?',3,3,'1) Select * from emp where empid = 10003;
','2) Select empid from emp;
','3) Select empid where empid = 1009 and lastname = ‘GELLER’;
View Answer',2,0);
insert into Questions.MCQ values('The clause allows us to select only those rows in the result relation of the clause that satisfy a specified predicate.'
,1,4,'1) Where, from','2) From, select','3) Select, from',2,0);

create table Department(
ID ID primary key identity(1,1),
[Name] SmallCustomString,
IsDeleted ID default 0
)
GO
insert into Department values('ComputerScience',0),('InformationSystem',0),('MultiMedia',0);

create table Track(
ID  ID primary key identity(1,1),
[Name] SmallCustomString ,
IsDeleted ID default 0
)
GO
insert into Track values('Testing',0),('UI/UX',0),('SoftwareDevelopment',0);

create table Intake(
ID ID primary key identity(1,1),
IntakeNumber int,
IsDeleted ID default 0
)
GO
insert into Intake values(39,0),(40,0),(41,0);



create table Branch(
ID ID primary key identity(1,1),
[Name] SmallCustomString,
IsDeleted ID default 0
)
GO
insert into Branch values('Assuit',0),('Smart Village',0),('Alexandria',0);


create table DIBT(
ID ID primary key identity(1,1),
DeptID ID default 0,
IntakeID ID default 0,
BranchID ID default 0,
TrackID ID default 0,
CourseID ID default 0,
StudentID ID default 0,
FOREIGN KEY (DeptID)REFERENCES Department(ID) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (IntakeID)REFERENCES Intake(ID)ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (BranchID)REFERENCES Branch(ID)ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (TrackID)REFERENCES Track(ID)ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (CourseID)REFERENCES Course(ID)ON DELETE CASCADE ON UPDATE CASCADE,
)
alter table [StudentData].[DIBT] add IsDeleted int not null default 0
go
insert into DIBT values(1,1,1,1,1,1),(2,2,2,2,2,2),(3,3,3,3,3,3);


--@nawal
create table Exam 
(
  ID ID primary key identity(1,1),
  StartTime   datetime not null,
  EndTime   datetime not null,
  TotalTime   int not null,
  IsCorrective bit not null default 0 ,
  IsDeleted ID default 0
)
go
insert into Exam values(getDate(),dateAdd(hour,1,getDate()),1,0,0);
insert into Exam values(getDate(),dateAdd(hour,1,getDate()),1,0,0);
insert into Exam values(getDate(),dateAdd(hour,1,getDate()),1,0,0);
go
create table StudentExamResult --@nawalzaki
( 
  ID ID primary key identity(1,1),
  StudentID ID default 0,
  ExamID   ID default 0,
  Result int not null  default -1,
   FOREIGN KEY (StudentID) REFERENCES Student(ID)ON DELETE CASCADE ON UPDATE CASCADE,
   FOREIGN KEY (ExamID) REFERENCES Exam(ID)ON DELETE CASCADE ON UPDATE CASCADE,
)
go

insert into StudentExamResult values(1,1,100);
insert into StudentExamResult values(2,3,70);
insert into StudentExamResult values(3,3,90);
go

create table Allowance 
(  
  OpenBook bit not null default 0 ,
  InternetBrowsing bit not null default 0,
  Calculator bit not null default 0,
  ExamID ID default 0,
  FOREIGN KEY (ExamID) REFERENCES Exam(ID) ON DELETE CASCADE ON UPDATE CASCADE,
)
go

insert into Allowance values(1,1,0,1);
insert into Allowance values(1,0,1,2);
insert into Allowance values(0,1,0,3);
go
create table TrueFalseQuestion 
(
  ID ID primary key identity(1,1),
  Content BigCustomString,
  CorrectAnswer nvarchar(5),
  FullDegree int,
  CourseID ID default 0 ,
  FOREIGN KEY (CourseID) REFERENCES course(ID),
  IsDeleted ID default 0
)
go
insert into TrueFalseQuestion values('The condition in a WHERE clause can refer to only one value.','False',10,1,0);
insert into TrueFalseQuestion values('The ADD command is used to enter one row of data or to add multiple rows as a result of a query','False',10,1,0);
insert into TrueFalseQuestion values('SQL provides the AS keyword, which can be used to assign meaningful column names to the results of queries using the SQL built-in functions','True',10,1,0);
go

create table TextQuestion 
(
  ID ID primary key identity(1,1),
  Content BigCustomString,
  BestAnswer BigCustomString,
  FullDegree int,
  CourseID ID default 0,
  FOREIGN KEY (CourseID) REFERENCES course(ID),
  IsDeleted ID default 0
)
go

insert into TextQuestion values('Write an SQL query to fetch the EmpId and FullName of all the employees working under Manager with id – ‘986’.','SELECT  EmpId, FullName FROM EmployeeDetails WHERE ManagerId = 986;',10,1,0);
insert into TextQuestion values('Write an SQL query to fetch the different projects available from the EmployeeSalary table.','SELECT DISTINCT(Project) FROM EmployeeSalary;',10,1,0);
insert into TextQuestion values('Write an SQL query to fetch the count of employees working in project ‘P1’','SELECT COUNT(*) FROM EmployeeSalary WHERE Project = ‘P1’ ;',10,1,0);


create table Questions.ExamQuestion 
(ID ID primary key identity(1,1),
  ExamID ID default 0 ,
  MCQID int ,
  TFQID int ,
  TXQID int ,
  StudentAnswer varchar(200) ,
  StudentAnswerResult int,
  QuestionType char(3),
  StudentID ID default 0,
  FOREIGN KEY (ExamID) REFERENCES Exam.Exam(ID)ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (TFQID) REFERENCES Questions.TrueFalseQuestion(ID)ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (TXQID) REFERENCES Questions.TextQuestion(ID)ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (MCQID) REFERENCES Questions.MCQ(ID)ON DELETE CASCADE ON UPDATE CASCADE,
  foreign key (StudentID)  references Person.Student(ID) ON DELETE CASCADE ON UPDATE CASCADE,
)

go
insert into Questions.ExamQuestion  values(1,1,null,null,'1',10,'MCQ',1); 
insert into Questions.ExamQuestion (ExamID,TFQID,StudentAnswer,StudentAnswerResult,QuestionType,StudentID)values(2,2,'True',10,'TFQ',1);
insert into Questions.ExamQuestion (ExamID,TXQID,StudentAnswer,StudentAnswerResult,QuestionType,StudentID)values(3 ,3,'SELECT DISTINCT(Project) FROM EmployeeSalary;',10,'TXQ',1);
go
----drop foreign key withou constraint name
ALTER TABLE [Questions].[ExamQuestion]
drop CONSTRAINT FK__ExamQuest__MCQID__30C33EC3
select CONSTRAINT_NAME
from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where TABLE_NAME = 'ExamQuestion'
-----
