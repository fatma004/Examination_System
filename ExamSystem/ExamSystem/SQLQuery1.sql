create database ExamSystem
go
create type ID from int not null 
create type CustomString from nvarchar(50)
go
create table Class
(
	ID ID primary key,
	Number varchar(3)
)
go
create table CourseTeachingYear
(
	ClassID ID ,
	CourseID ID ,
	InstructorID ID ,
	year int
	PRIMARY KEY (ClassID ,CourseID ,InstructorID )
)
go
create table Instructor
(
	ID ID primary key,
	Name CustomString,
	UserName CustomString,
	Password CustomString,
	ManagerId ID
)
go
create table StudentCourse
(
	studentID ID ,
	CourseID ID 
	 PRIMARY KEY (CourseID ,StudentID )
)
go
create table Course
(
	ID ID primary key,
	Title CustomString,
	Description nvarchar(150),
	MinDegree int,
	MaxDegree int,
	instructorID ID
)
go
create table Student
(
	ID ID primary key,
	Name CustomString,
	Email CustomString,
	UserName CustomString,
	Password CustomString,	
)




