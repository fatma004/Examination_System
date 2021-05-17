--@noor
--student schema
--as view               
alter view  ShowAllCourses as
select cr.Title as course ,i.[Name]as instructorName,
t.[Name]as track,cl.Number as class,b.Name as branch
from CourseData.Course cr,Person.Instructor i,StudentData.Track t,CourseData.Class cl,
StudentData.Branch b,
CourseData.CourseTeachingYear cty,
StudentData.DIBT 
where
cr.ID=cty.CourseID and
cr.IsDeleted=0 and
cl.ID=cty.ClassID and
i.ID=cty.InstructorID and
DIBT.CourseID=cr.ID and
DIBT.TrackID=t.ID and
DIBT.BranchID=b.ID
--select * from ShowAllCourses
--as func
alter function AvailableCourses() 
returns @AvailableCourses table
  (
   CourseTitle SmallCustomString,
   InstructorName SmallCustomString,
   TrackName  SmallCustomString,
   ClassNumber varchar(3),
   BranchName SmallCustomString
   )
as
begin
  insert into @AvailableCourses
  select cr.Title ,i.[Name],
	t.[Name],cl.Number,b.Name as branch
	from 	CourseData.Course cr,Person.Instructor i,StudentData.Track t,CourseData.Class cl,
StudentData.Branch b,
CourseData.CourseTeachingYear cty,
StudentData.DIBT where
	cr.ID=cty.CourseID and
	cr.IsDeleted=0 and
	cl.ID=cty.ClassID and
	i.ID=cty.InstructorID and
	DIBT.CourseID=cr.ID and
	DIBT.TrackID=t.ID and
	DIBT.BranchID=b.ID
return
end

--select * from AvailableCourses()
----------------------------------
alter PROCEDURE ShowStudentCourses
@UserName SmallCustomString
as
begin
select  distinct cr.Title as course ,i.[Name]as instructorName,t.[Name]as track,cl.Number as class,b.Name as branch
from CourseData.Course cr,Person.Instructor i,StudentData.Track t,CourseData.Class cl,
StudentData.Branch b,
CourseData.CourseTeachingYear cty,StudentData.DIBT ,Person.Student
where
cr.ID=cty.CourseID and
cr.IsDeleted=0 and
cl.ID=cty.ClassID and
i.ID=cty.InstructorID and
DIBT.CourseID=cr.ID and
DIBT.TrackID=t.ID and
DIBT.BranchID=b.ID and
cr.ID=DIBT.CourseID and
DIBT.StudentID=(select ID from Person.Student where UserName=@UserName)
end
ShowStudentCourses 'NadaUser'
--!!repeated records

create PROCEDURE EditUserName
@OldUserName SmallCustomString,@newUserName SmallCustomString
as update Person.Student set UserName=@newUserName where UserName=@OldUserName

EditUserName 'NoorUser' ,'NoorUser1'

create PROCEDURE EditPassWord
@UserName SmallCustomString,@newPassword SmallCustomString
as update Person.Student set Password=@newPassword where UserName=@UserName
EditPassWord 'NoorUser','NoorPass'



create PROCEDURE AddStudentToCourse
@UserName SmallCustomString,@Title SmallCustomString
as
declare @courseID int;
select @courseID=ID from CourseData.Course where Title=@Title;
declare @studentID SmallCustomString;
select @studentID=ID from Person.Student where UserName=@UserName;
Update StudentData.DIBT set CourseID =@courseID where StudentID=@studentID  

-- AddStudentToCourse 'NoorUser1','SQL'
--insert into DIBT values (1,1,1,2,null,2)
--AddStudentToCourse 'NawalUser','SQL'

alter PROCEDURE RemoveStudentFromCourse
@UserName SmallCustomString,@Title SmallCustomString
as
declare @courseID int;
select @courseID=ID from CourseData.Course where Title=@Title;
declare @studentID SmallCustomString;
select @studentID=ID from Person.Student where UserName=@UserName;
Update StudentData.DIBT set IsDeleted =1 where StudentID=@studentID and CourseID=@courseID

--RemoveStudentFromCourse 'NoorUser1','SQL'

create or alter procedure DoExam 
@UserName SmallCustomString,@ExamID SmallCustomString
as
begin
declare @studentID SmallCustomString;
select @studentID=ID from Person.Student where UserName=@UserName;
  if exists(select* from Exam.StudentExamResult where ExamID=@ExamID and StudentID=@studentID)
  begin
    if(DATEDIFF (second,getdate(),(select EndTime from Exam.Exam where ID=@ExamID))>50)
	begin
       print 'your Exam is running '
	end
	else  print 'the Exam closed '
 end
 else  print 'this exam is not for you '
end
DoExam 'NoorUser','1'
insert into Exam.Exam values(getDate(),dateAdd(hour,1,getDate()),1,0)
insert into Exam.StudentExamResult values(1,5,null)
---------------------------------------------------
---------------------------------------------------
--select*from MCQ
--select* from ExamQuestion
--update Questions.ExamQuestion set StudentAnswerResult=0
--CalculateQuestionResult 'NoorUser',1,1,'MCQ'

create or alter procedure CalculateQuestionResult 
(@UserName SmallCustomString,@QuestionID int,@ExamID int ,@QuestionType char(3))
as
begin
declare @studentID int;
select @studentID=ID from Person.Student where UserName=@UserName;
		declare @studentAnswer BigCustomString
		declare @correctAnswer BigCustomString
		declare @FullDegree int
		declare @StudentAnswerResult int
		select @StudentAnswerResult=0
		if (@QuestionType='MCQ')
		begin
		    select  @QuestionID = MCQID from Questions.ExamQuestion where ExamID=@ExamID
			select @correctAnswer=CorrectChoice from Questions.MCQ where ID=@QuestionID
			select @FullDegree =FullDegree from Questions.MCQ where ID=@QuestionID
			select  @studentAnswer =StudentAnswer from Questions.ExamQuestion where @QuestionID=MCQID
			if(@studentAnswer=@correctAnswer)
				select @StudentAnswerResult+=@FullDegree
            update Questions.ExamQuestion set StudentAnswerResult=@StudentAnswerResult where MCQID=@QuestionID
		end
		else if(@QuestionType='TXQ')
		begin
		    select  @QuestionID = TXQID from Questions.ExamQuestion where ExamID=@ExamID
			select @correctAnswer=BestAnswer from Questions.TextQuestion where ID=@QuestionID
			select @FullDegree =FullDegree from Questions.TextQuestion where ID=@QuestionID
			select  @studentAnswer =StudentAnswer from Questions.ExamQuestion where @QuestionID=TXQID
			if(DIFFERENCE(@studentAnswer,@correctAnswer)>=2)
				select @StudentAnswerResult+=@FullDegree/2
           else if(DIFFERENCE(@studentAnswer,@correctAnswer)>=3)
		        select @StudentAnswerResult+=@FullDegree
		  update Questions.ExamQuestion set StudentAnswerResult=@StudentAnswerResult where TXQID=@QuestionID
		end
		else if(@QuestionType ='TFQ')
	   begin
	        select  @QuestionID = TFQID from Questions.ExamQuestion where ExamID=@ExamID
			select @correctAnswer=CorrectAnswer from Questions.TrueFalseQuestion where ID=@QuestionID
			select @FullDegree =FullDegree from Questions.TrueFalseQuestion where ID=@QuestionID
			select  @studentAnswer =StudentAnswer from Questions.ExamQuestion where @QuestionID=TFQID
			if(@studentAnswer=@correctAnswer)
				select @StudentAnswerResult+=@FullDegree
        	update Questions.ExamQuestion set StudentAnswerResult=@StudentAnswerResult where TFQID=@QuestionID
		end
    end
-----------------------------------------------------------------------

update StudentExamResult set Result=0 where StudentID=1 and ExamID=1
create or alter  procedure CalculateFinalResult 
(@UserName SmallCustomString,@ExamID SmallCustomString )
as

declare @studentID int
select @studentID = ID from Person.Student where UserName=@UserName 
declare @FinalResult int
declare s_cur cursor
 for select MCQID,TFQID,TXQID ,QuestionType from Questions.ExamQuestion
 for read only  --read only or Update
declare @MCQID int
declare @TFQID int
declare @TXQID int
declare @QuestionType char(3)
open s_cur 
begin
 fetch s_cur into   @MCQID ,
					 @TFQID ,
					@TXQID ,
					@QuestionType
 While @@fetch_status=0  
 begin
  if(@QuestionType='MCQ')

   exec CalculateQuestionResult @UserName ,@MCQID ,@ExamID ,@QuestionType 
   
  else if(@QuestionType='TXQ')
  
 exec   CalculateQuestionResult @UserName ,@TXQID ,@ExamID ,@QuestionType 
	
 else if(@QuestionType='TFQ')
  exec CalculateQuestionResult @UserName ,@TFQID ,@ExamID ,@QuestionType 
  
 fetch s_cur into   @MCQID ,
					 @TFQID ,
					@TXQID ,
					@QuestionType
end
end
close s_cur
deallocate s_cur

Select @FinalResult = sum(StudentAnswerResult) from Questions.ExamQuestion where ExamID=@ExamID and StudentID=@studentID
update Exam.StudentExamResult set Result= @FinalResult where ExamID=@ExamID and StudentID=@studentID
--CalculateFinalResult  'NoorUser',1
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--@nawal
                 /*EditInstructor*/
Create PROCEDURE EditInstructor (@ID ID,@Name SmallCustomString,@UserName SmallCustomString,@Password SmallCustomString,@StatementType NVARCHAR(20) = '')  
AS  
  BEGIN  
      IF @StatementType = 'Insert'  
        BEGIN  
            INSERT INTO  Person.[Instructor]
                        (Name,UserName,Password,ManagerId,IsDeleted)  
            VALUES     (@Name,@UserName,@Password,1,0)  
        END  
     ELSE IF @StatementType = 'Update'  
        BEGIN  
            UPDATE  Person.[Instructor]
            SET    Name = @Name,  
                   UserName = @UserName,  
                   Password = @Password
            WHERE  ID = @ID  
        END     
  END
  
  exec EditInstructor @ID=0,@Name='nawalZaki',@UserName='NonaUser',@Password='1234',@StatementType='Insert'
  exec EditInstructor @ID=4,@Name='nawall',@UserName='Nona4040',@Password='1234',@StatementType='Update'
                /*Show Data Of Instructors*/
create function ShowInstructors(@UserName SmallCustomString) 
returns @ShowInstructors table
		(
		 ID ID primary key,
		Name SmallCustomString,
		UserName SmallCustomString
		)
as
begin
	insert into @ShowInstructors
	select ID,Name,UserName
	from Person.Instructor 
	where UserName=@UserName and IsDeleted=0

return
end

Select * from ShowInstructors('NonaUser')
                    /*Delete Instructor*/
Create PROCEDURE DeleteInstructor (@UserName SmallCustomString)  
AS  
  BEGIN 
        declare @InstructorID AS int ,@CourseID AS int
		set @InstructorID= (select ID from Person.[Instructor] where UserName=@UserName)
		set @CourseID= (select ID from CourseData.[Course] where instructorID=@InstructorID)
		 UPDATE  [CourseData].[CourseTeachingYear]
            SET IsDeleted = 1
			WHERE  CourseID=@CourseID 
            DELETE FROM Person.[Instructor]
            WHERE  UserName = @UserName 
 END  

 exec  DeleteInstructor @UserName='AlyUser'
                 /*Fuction For Get ID's Manager */
Create function ShowManagers() 
returns @ShowManagers table
		(
		 ID ID primary key,
		Name SmallCustomString,
		UserName SmallCustomString
		)
as
begin
	insert into @ShowManagers
	select ID,Name,UserName
	from Person.Instructor 
	where ManagerId IS NULL

return
end
Select * from ShowManagers()
                     /*EditCourse*/
Create PROCEDURE EditCourse (@ID int,@Title SmallCustomString,@Description  BigCustomString,@MinDegree int,@MaxDegree int,@InstructorID int,@StatementType NVARCHAR(20) = '')  
AS  
  BEGIN  
      IF @StatementType = 'Insert'  
        BEGIN  
            INSERT INTO  CourseData..[Course]
                        (Title,Description,MinDegree,MaxDegree,instructorID,IsDeleted)  
            VALUES     (@Title,@Description,@MinDegree,@MaxDegree,@InstructorID,0)  
        END  
  
      IF @StatementType = 'Update'  
        BEGIN  
            UPDATE  CourseData.[Course]
            SET    Title = @Title,  
                   Description = @Description,  
                   MinDegree = @MinDegree,
				   MaxDegree=@MaxDegree,
				    instructorID=@InstructorID
            WHERE  ID = @Id  
        END   
  END 
  
  exec EditCourse @Id=0,@Title='Html5',@Description='More featured from Html',@MinDegree=50,@MaxDegree=100,@InstructorID=3,@StatementType='Insert'
   exec EditCourse @Id=4,@Title='Html',@Description='More featured from Html',@MinDegree=50,@MaxDegree=100,@InstructorID=3,@StatementType='Update'



   /*Delete Courses*/ 
  create PROCEDURE DeleteCourse (@Title SmallCustomString)  
AS  
  BEGIN 
    
            DELETE FROM  CourseData.Course
            WHERE  Title=@Title 
 END
 exec DeleteCourse @Title='Html' 


                     /*EditInsructorInCourse*/
create PROCEDURE EditInsructorInCourse (@Title SmallCustomString,@UserName SmallCustomString)
AS
BEGIN
 declare @InstructorID AS ID
 set @InstructorID = (select ID from Person.Instructor where UserName=@UserName);
      UPDATE  CourseData.[Course]
            SET    instructorID=@InstructorID 
            WHERE  Title = @Title  
End

exec EditInsructorInCourse @Title='XML',@UserName='Nona4040';

                       /*EditDepartment*/
Create PROCEDURE EditDepartment (@DepartmentName SmallCustomString,@TrackName SmallCustomString,@BranchName SmallCustomString)
AS
BEGIN
declare @DepartmentID AS ID , @TrackID AS ID , @BranchID AS ID
    set @DepartmentID = (select ID from StudentData.[Department] where Name=@DepartmentName);
	set @TrackID = (select ID from StudentData.[Track] where Name=@TrackName);
	set @BranchID = (select ID from StudentData.[Branch] where Name=@BranchName);

    UPDATE StudentData.[DIBT]
            SET    BranchID=@BranchID , TrackID=@TrackID
            WHERE   DeptID= @DepartmentID  
End

exec EditDepartment @DepartmentName='InformationSystem',@TrackName='Testing',@BranchName='Assuit'
                        /*View About Department*/
create View DetailsAboutDepartment AS
		select d.name As NameOfDepartment,t.name As NameOfTrack ,b.name AS NameOfBranch
		from StudentData.Department d, StudentData.Track t,StudentData.Branch b ,StudentData.DIBT x
		where x.BranchID=b.ID and x.DeptID=d.ID and x.TrackID=t.ID

select * from DetailsAboutDepartment

						   /*and new track*/
create PROCEDURE AddNewTrack (@Name SmallCustomString)  
AS  
  BEGIN  
            INSERT INTO  StudentData.Track 
            VALUES     (@Name,0)  
 END 

exec AddNewTrack @Name='Mobile'

                  /*EditQuestionPool*/
create PROCEDURE EditQuestionPool(@ID int,@InstructorName SmallCustomString,@content BigCustomString,@CorrectAnswer nvarchar(5),@FullDegree int,@CorrectChoice char(1),@Choice1 nvarchar(10),@Choice2 nvarchar(10),@Choice3 nvarchar(10),@BestAnswer BigCustomString,@TypeOfQuestion NVARCHAR(20) = '',@StatmentType NVARCHAR(20) = '')
AS
BEGIN
    declare @CourseID AS ID ,@InstructorID as ID;
	set @InstructorID=(select ID from Person.[Instructor] where Name=@InstructorName )
	set @CourseID=(select c.ID from CourseData.[Course] c where instructorID=@InstructorID )
	IF @TypeOfQuestion = 'MCQ'  
        BEGIN  
            exec EditMQC @ID1=@ID,@Content1=@content,@CorrectChoice1=@CorrectChoice,@FullDegree1=@FullDegree,@Choice11=@Choice1,@Choice21=@Choice2,@Choice31=@Choice3,@CourseID1=@CourseID,@StatementType1=@StatmentType 
        END
	IF @TypeOfQuestion = 'TrueFalse'  
        BEGIN  
          exec  EditTrueFalse @ID1=@ID,@Content1=@content,@CorrectAnswer1=@CorrectAnswer, @FullDegree1=@FullDegree, @CourseID1=@CourseID,@StatementType1=@StatmentType

        END
	IF @TypeOfQuestion = 'Text'  
        BEGIN  
            exec EditText @ID1=@ID,@Content1=@content,@BestAnswer1=@BestAnswer,@FullDegree1=@FullDegree,@CourseID1=@CourseID,@StatementType1=@StatmentType
       
        END	
END

exec EditQuestionPool @ID=0,@InstructorName='Aly',@content='what is My name ?',@CorrectAnswer='Nawal',@FullDegree=10,@CorrectChoice='A',@Choice1='Nawal',@Choice2='Zaki',@Choice3='Ahmed',@BestAnswer=' ',@TypeOfQuestion='MCQ',@StatmentType = 'insert'
		/*Fuction for Show ID's Queation*/
Create function ShowMCQQuestions(@TitleCourse SmallCustomString) 
returns @ShowMCQQuestions table
		(
		 ID int,
		Content BigCustomString,
		CorrectChoice char(1),
		FullDegree int,
		Choice1 nvarchar(100),
		Choice2 nvarchar(100),
		Choice3 nvarchar(100)
		)
as
begin
	insert into @ShowMCQQuestions
	select m.ID,m.Content,m.CorrectChoice,m.FullDegree,m.Choice1,m.Choice2,m.Choice3
	from Questions.MCQ m
	where m.CourseID in
	(
	   select c.ID
	   from CourseData.Course c
	   where Title=@TitleCourse and c.ID=m.CourseID
	)

return
end
Select * from ShowMCQQuestions('SQL')
           /*Fuction To Get ID'S TextQuestions*/
Create function ShowTextQuestions(@TitleCourse SmallCustomString) 
returns @ShowTextQuestions table
		(
		 ID int,
		Content BigCustomString,
		BestAnswer BigCustomString,
		FullDegree int
		)
as
begin
	insert into @ShowTextQuestions
	select txt.ID,txt.Content,txt.BestAnswer,txt.FullDegree
	from Questions.TextQuestion txt
	where txt.CourseID in
	(
	   select c.ID
	   from CourseData.Course c
	   where Title=@TitleCourse and c.ID=txt.CourseID
	)

return
end

Select * from ShowTextQuestions('SQL')
                      /*Fuction To Get ID'S TrueFalseQuestions*/   
Create function ShowTFQuestions(@TitleCourse SmallCustomString) 
returns @ShowTFQuestions table
		(
		 ID int,
		Content BigCustomString,
		CorrectAnswer nvarchar(5),
		FullDegree int
		)
as
begin
	insert into @ShowTFQuestions
	select TF.ID,TF.Content,TF.CorrectAnswer,TF.FullDegree
	from Questions.TrueFalseQuestion TF
	where TF.CourseID in
	(
	   select c.ID
	   from CourseData.Course c
	   where Title=@TitleCourse and c.ID=TF.CourseID
	)

return
end

Select * from ShowTFQuestions('SQL')					  
	                      /*EditMQC*/
create PROCEDURE EditMQC (@ID1 int,@Content1 BigCustomString,@CorrectChoice1 char(1),@FullDegree1 int,@Choice11 nvarchar(10),@Choice21 nvarchar(10),@Choice31 nvarchar(10),@CourseID1 ID,@StatementType1 NVARCHAR(20) = '')  
AS  
  BEGIN  
      IF @StatementType1 = 'Insert'  
        BEGIN  
            INSERT INTO  Questions.[MCQ]
                        (Content,CorrectChoice,FullDegree,Choice1,Choice2,Choice3,CourseID,IsDeleted)  
            VALUES     (@Content1,@CorrectChoice1,@FullDegree1,@Choice11,@Choice21,@Choice31,@CourseID1,0)  
        END  
      IF @StatementType1 = 'Update'  
        BEGIN  
            UPDATE   Questions.[MCQ]
            SET    Content=@Content1,
			       CorrectChoice=@CorrectChoice1,
				   FullDegree=@FullDegree1,
				   Choice1=@Choice11,
				   Choice2=@Choice21,
				   Choice3=@Choice31
            WHERE  ID = @Id1
			
        END  
      ELSE IF @StatementType1 = 'Delete'  
        BEGIN  
            DELETE FROM  Questions.[MCQ]
            WHERE  ID = @Id1  
        END  
  END   
                       /*EditText*/
Create PROCEDURE EditText (@Id1 ID,@Content1 BigCustomString,@BestAnswer1 BigCustomString,@FullDegree1 int,@CourseID1 ID,@StatementType1 NVARCHAR(20) = '')  
AS  
  BEGIN  
      IF @StatementType1 = 'Insert'  
        BEGIN  
            INSERT INTO  Questions.[TextQuestion]
                        (Content,BestAnswer,FullDegree,CourseID,IsDeleted)  
            VALUES     ( @Content1,@BestAnswer1,@FullDegree1,@CourseID1,0)  
        END  
      IF @StatementType1 = 'Update'  
        BEGIN  
            UPDATE  Questions.[TextQuestion]
            SET    Content=@Content1,
			       BestAnswer=@BestAnswer1,
				   FullDegree=@FullDegree1
            WHERE  ID = @Id1
			
        END  
      ELSE IF @StatementType1 = 'Delete'  
        BEGIN  
            DELETE FROM Questions.[TextQuestion]
            WHERE  ID = @Id1  
        END  
  END   
                        /*EditTrueFalse*/
 Create PROCEDURE EditTrueFalse (@Id1 ID,@Content1 BigCustomString,@CorrectAnswer1 nvarchar(5),@FullDegree1 int,@CourseID1 ID,@StatementType1 NVARCHAR(20) = '')  
AS  
  BEGIN  
      IF @StatementType1 = 'Insert'  
        BEGIN  
            INSERT INTO Questions.[TrueFalseQuestion]
                        (Content,CorrectAnswer,FullDegree,CourseID,IsDeleted)  
            VALUES     (@Content1,@CorrectAnswer1,@FullDegree1,@CourseID1,0)  
        END  
      IF @StatementType1 = 'Update'  
        BEGIN  
            UPDATE  Questions.[TrueFalseQuestion]
            SET    Content=@Content1,
			       CorrectAnswer=@CorrectAnswer1,
				   FullDegree=@FullDegree1
            WHERE  ID = @Id1
			
        END  
      ELSE IF @StatementType1 = 'Delete'  
        BEGIN  
            DELETE FROM  Questions.[TrueFalseQuestion]
            WHERE  ID = @Id1  
        END  
  END   

  /* add students and their information*/
create or Alter PROCEDURE AddNewStudent (@Name SmallCustomString,@Email SmallCustomString,@UserName SmallCustomString,@Password SmallCustomString,@IntakeNumber int,@BranchName SmallCustomString,@TrackName SmallCustomString,@DepartmentName SmallCustomString)  
AS  
  BEGIN  
          declare @IntakeID AS int ,@BranchID AS int ,@TrackID AS int,@DepartmentID AS int,@StudentID AS int 
		  set @IntakeID=(select ID from StudentData.Intake where IntakeNumber=@IntakeNumber);
		  set @BranchID=(select ID from StudentData.Branch where Name=@BranchName);
		  set @TrackID=(select ID from StudentData.Track where Name=@TrackName);
		  set @DepartmentID=(select ID from StudentData.Department where Name=@DepartmentName);

		 INSERT INTO Person.[Student]
                        (Name,Email,UserName,Password,IsDeleted)  
            VALUES     (@Name,@Email,@UserName,@Password,0)
            set @StudentID=(select ID from Person.Student where UserName=@UserName);/**************where UserName*********************/
			INSERT INTO StudentData.[DIBT]
                        (DeptID,IntakeID,BranchID,TrackID,CourseID,StudentID,IsDeleted)  
            VALUES     (@DepartmentID,@IntakeID,@BranchID,@TrackID,null,@StudentID,0)
  END 
	exec AddNewStudent @Name='Nona',@Email='NoNa@gmail.com',@UserName='Nona11',@Password='1234',@IntakeNumber=41,@BranchName='Assuit',@TrackName='Testing',@DepartmentName='InformationSystem'

                                     /*views*/
create VIEW DetailsofDepartment AS
select d.name As NameOfDepartment,t.name As NameOfTrack ,b.name AS NameOfBranch,i.IntakeNumber AS NumberOfIntake
from StudentData.Department d,StudentData. Track t,StudentData.Branch b ,
StudentData.DIBT x,StudentData.Intake i
where x.BranchID=b.ID and x.DeptID=d.ID and x.TrackID=t.ID and x.IntakeID=i.ID ;
select * from DetailsofDepartment

create or Alter VIEW DetailsInstructor AS
select ins.Name As InstructorName,c.Title AS CourseTitle
from Person.Instructor ins,CourseData.CourseTeachingYear cty,CourseData.Course c
where ins.ID=cty.InstructorID and c.ID=cty.CourseID 
select * from DetailsInstructor





--------------------------------------------------------------------------------------
--@fatema
--Courses that he teachs
create proc InstructorCourses(@UserName SmallCustomString)
as
begin
	select [Title],[Description] 
from Course
where [instructorID] in 
(
select [ID] from Person.[Instructor]
where [UserName]=@UserName
)
end

---exec InstructorCourses 'AlyUser'

-----------------------------------------------------------

--number of student in each course 

create or alter proc NumOfStudentInEachCourse(@UserName SmallCustomString)
as
begin
	select [Title] as courseTitle,count(*) as numberOfStudent from CourseData.[Course]
     where [ID] in (
select [ID] from CourseData.[Course]
where [instructorID] in
(
select ID from Person.[Instructor]
where [UserName]=@UserName
)
)
group by [Title]

end		

--exec NumOfStudentInEachCourse 'AlyUser'

--------------------------------------------------------------------------

--Shows Questions of a specific course 

create or alter proc CourseQuestion(@courseTitle SmallCustomString)
as
begin

declare @courseID int;
set @courseID=(select [ID] from CourseData.[Course] where [Title] =@courseTitle);
select [Content] as 'Question' ,[CorrectAnswer] as 'CorrectAnswer' from Questions.[TrueFalseQuestion] 
where [CourseID] = @courseID
union 
select [Content] as 'Question' ,[BestAnswer] as 'CorrectAnswer' from  Questions.[TextQuestion]
where [CourseID] = @courseID
union
select [Content] as 'Question',[CorrectChoice] as 'CorrectAnswer' from Questions.[MCQ]
where [CourseID] = @courseID

end

exec CourseQuestion 'XML'

----------------------------------------------------------------------------------


----------------------------------------------------------------------------------------

--Show Questions of a specific course 

create or alter proc QuestionOfCourse(@courseTitle SmallCustomString)
as
begin

declare @courseID int;
set @courseID=(select [ID] from CourseData.[Course] where [Title] =@courseTitle);
select [Content] as 'Question' ,[CorrectAnswer] as 'CorrectAnswer' from Questions.[TrueFalseQuestion] 
where [CourseID] = @courseID
union 
select [Content] as 'Question' ,[BestAnswer] as 'CorrectAnswer' from  Questions.[TextQuestion]
where [CourseID] = @courseID
union
select [Content] as 'Question',[CorrectChoice] as 'CorrectAnswer' from Questions.[MCQ]
where [CourseID] = @courseID

end

--exec QuestionOfCourse 'SQL'

-------------------------------------------------------------------------------------
--Edit Instructor UserName 

create or alter proc EditInstructorUserName(@oldUserName SmallCustomString ,@NewUserName SmallCustomString)
as
begin

declare @InstructorID int;
set @InstructorID=(select [ID] from Person.[Instructor] where [UserName]=@oldUserName);
update Person.[Instructor]
set [UserName]=@NewUserName
where [ID]= @InstructorID 

end

--exec EditInstructorUserName 'AlyUser','AlyUser2'


--------------------------------------------------------------------------------------------

--Edit Instructor's Password  --> this operation needs UserName & Newpass

create or alter proc EditInstructorPass(@UserName SmallCustomString,@NewPass SmallCustomString)
as
begin

declare @InstructorID int;
set @InstructorID=(select [ID] from Person.[Instructor] where [UserName]=@UserName);
update Person.[Instructor]
set [Password]=@NewPass
where [ID]= @InstructorID 

end

--exec EditInstructorPass 'AlyUser','AlyPass'

-------------------------------------------------------------------------------------
--Shows Students' Names (who Enrrolled in Instructor's Courses) , and CourseTitle

create or alter proc StudentsOfCourses(@UserName SmallCustomString)
as
begin
declare @InstructorID int;
set @InstructorID=(select [ID] from Person.[Instructor] where [UserName]=@UserName)
select stu.[Name],cors.[Title]
from Person.[Student] stu,CourseData.[Course] cors ,StudentData.[DIBT] dp
where stu.[ID] =dp.[studentID] and dp.CourseID=cors.ID and cors.ID in
(
select [ID] from CourseData.[Course]
where [instructorID]=@InstructorID
)

end

--exec  StudentsOfCourses'AlyUser2'

-----------------------------------------------------------------

--Insert / make Exam  for a specific Course 

create or alter proc MakeCourseExam(@CourseTitle SmallCustomString ,@ExamID int)
as
begin
declare @sum int;
set @sum=0;
declare @courseID int;
set @courseID=(select [ID] from CourseData.[Course] where [Title] =@CourseTitle);
print @courseID
declare @MaxDegree int;
set @MaxDegree =(select [MaxDegree] from CourseData.[Course] where [Title] =@CourseTitle);
print @MaxDegree
create table #MCQ
(
 ID int 
)
insert into #MCQ select ID from Questions.[MCQ] where CourseID=@courseID 
--
create table #TF
(
ID int
)
insert into #TF select ID from Questions.[TrueFalseQuestion] where CourseID=@courseID 
--
create table #TXT
(
ID int
)
insert into #TXT select ID from Questions.[TextQuestion] where CourseID=@courseID 

---

declare ss1_cur cursor
	for select ID from #MCQ
	for read only  
declare @id1 int
open ss1_cur 
begin
	print @@Fetch_status
	
	fetch ss1_cur into @id1
	While @@fetch_status=0  
	begin
		declare @fullDegree int
		set @fullDegree =(select [FullDegree] from Questions.[MCQ] where ID=@id1)
		if(@FullDegree is not null and @FullDegree >0 and @FullDegree+@sum <= @MaxDegree)
          begin
           set @sum+=@fullDegree
           insert into Questions.[ExamQuestion]([ExamID],[MCQID],[QuestionType]) values (@ExamID,@id1,'MCQ');
           end
		fetch ss1_cur into @id1
	end
end
---

declare ss2_cur cursor
	for select ID from #TF
	for read only  
declare @id2 int
open ss2_cur 
begin
	print @@Fetch_status
	
	fetch ss2_cur into @id2
	While @@fetch_status=0  
	begin
		declare @fullDegree2 int
		set @fullDegree2 =(select [FullDegree] from Questions.[TrueFalseQuestion] where ID =@id2)
		if(@FullDegree2 is not null and @FullDegree2 >0 and @FullDegree2+@sum <= @MaxDegree)
          begin
           set @sum+=@fullDegree2
           insert into Questions.[ExamQuestion]([ExamID],[TFQID],[QuestionType]) values (@ExamID,@id2,'TFQ');
           end
		fetch ss2_cur into @id2
	end
end
------
declare ss3_cur cursor
	for select ID from #TF
	for read only  
declare @id3 int
open ss3_cur 
begin
	print @@Fetch_status
	
	fetch ss3_cur into @id3
	While @@fetch_status=0  
	begin
		declare @fullDegree3 int
		set @fullDegree3 =(select [FullDegree] from Questions.[TrueFalseQuestion] where ID =@id3)
		if(@FullDegree3 is not null and @FullDegree3 >0 and @FullDegree3+@sum <= @MaxDegree)
          begin
           set @sum+=@fullDegree3
           insert into Questions.[ExamQuestion]([ExamID],[TXQID],[QuestionType]) values (@ExamID,@id3,'TXQ');
           end
		fetch ss3_cur into @id3
	end
end
end

--exec MakeCourseExam 'SQL',@ExamID=3


------------------------------------------------------------------------------------

--Shows Questions Of an Exam 

create or alter proc ShowQuestionsExam(@ExamID int)
as
begin

select distinct [Content]  as 'Question' ,[CorrectChoice] as 'CorrectAnswer'
from Questions.[MCQ] mcq ,Questions.[ExamQuestion] EQ
where EQ.[ExamID]=@ExamID and EQ.MCQID is not null and EQ.MCQID =mcq.ID
union 
select distinct [Content] as 'Question' ,[BestAnswer] as 'CorrectAnswer'
from Questions.[TextQuestion] TXQ,Questions.[ExamQuestion] EQ
where EQ.[ExamID]=@ExamID and EQ.TXQID is not null and EQ.TXQID =TXQ.ID
union 
select distinct [Content] as 'Question' ,[CorrectAnswer] as 'CorrectAnswer'
from Questions.[TrueFalseQuestion] TFQ,Questions.[ExamQuestion] EQ
where EQ.[ExamID]=@ExamID and EQ.TFQID is not null and EQ.TFQID =TFQ.ID

end

--exec ShowQuestionsExam @ExamID =3

---------------------------------------------------------------------
-- Shows Students's Results in a specific Exam  

create or alter proc StudentsResultExam (@ExamID int)
as
begin
select [StudentID] as 'StudentName' , [Result] 
from Exam.[StudentExamResult]
where [ExamID]=@ExamID
end

----
--exec StudentsResultExam @ExamID=3

---------------------------------------------------------------------------

--Add Exam Scedule .. define its starttime , EndTime , Total time and Exam Type (Corrective or not) ..

create or alter proc AddExam(@StartTime datetime ,@EndTime datetime ,@TotalTime int,@ExamType bit )
as
begin
insert into Exam.[Exam] values(@StartTime,@EndTime,@TotalTime,@ExamType)
end








----------------------------------------------------------------
----------------------------------------------------------------
fatma
--permession
nawal
--filegroup
--schema
--index 
--bulk insert from excel
noor
--backup& snapshot
--transaction
--trigger
--sequence
