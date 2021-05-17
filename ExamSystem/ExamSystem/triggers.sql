/*soft delete triggers*/
create trigger softDelete1 
on  [StudentData].[Branch]
instead of delete
as 
begin
	 update [StudentData].[Branch]
	 set IsDeleted=1
 where [ID] = (select [ID] from deleted);
end

create trigger softDelete2 
on  [CourseData].[Class]
instead of delete
as 
begin
	 update [CourseData].[Class]
	 set IsDeleted=1
	  where [ID] = (select [ID] from deleted);
end

create trigger softDelete3 
on [CourseData].[Course]
instead of delete
as 
begin
	 update [CourseData].[Course]
	 set IsDeleted=1
	 where [ID] = (select [ID] from deleted);
end

create trigger softDelete4 
on [StudentData].[Department]
instead of delete
as 
begin
	 update [StudentData].[Department]
	 set IsDeleted=1
 where [ID] = (select [ID] from deleted);
end

create trigger softDelete5 
on [Exam].[Exam]
instead of delete
as 
begin
	 update [Exam].[Exam]
	 set IsDeleted=1
 where [ID] = (select [ID] from deleted);
end
create trigger softDelete6 
on [Person].[Instructor]
instead of delete
as 
begin
	 update [Person].[Instructor]
	 set IsDeleted=1
 where [ID] = (select [ID] from deleted);
end

create trigger softDelete7 
on [StudentData].[Track]
instead of delete
as
begin
	 update [StudentData].[Track]
	 set IsDeleted=1
	 where [ID] = (select [ID] from deleted);
end

create trigger softDelete8 
on [Questions].[MCQ]
instead of delete
as 
begin
	 update [Questions].[MCQ]
	 set IsDeleted=1
	 where [ID] = (select [ID] from deleted);
end

create trigger softDelete9 
on [Person].[Student]
instead of delete
as 
begin
	 update [Person].[Student]
	 set IsDeleted=1
 where [ID] = (select [ID] from deleted);
end



create trigger softDelete10 
on [Questions].[TextQuestion]
instead of delete
as 
begin
	 update [Questions].[TextQuestion]
	 set IsDeleted=1
 where [ID] = (select [ID] from deleted);
end

create trigger softDelete11 
on [StudentData].[Track]
instead of delete
as 
begin
	 update [StudentData].[Track]
	 set IsDeleted=1
 where [ID] = (select [ID] from deleted);
end

create trigger softDelete12 
on [Questions].[TrueFalseQuestion]
instead of delete
as
begin
	 update  [Questions].[TrueFalseQuestion]
	 set IsDeleted=1
 where [ID] = (select [ID] from deleted);
end