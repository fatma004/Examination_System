--admin
USE [ExamSystem7]
GO

/****** Object:  User [Admin]    Script Date: 17/01/2021 11:27:37 ã ******/
CREATE USER [Admin] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO


--manager
USE [ExamSystem7]
GO
CREATE USER [TrainingManager] WITHOUT LOGIN
GO
use [ExamSystem7]
GO
GRANT ALTER ON [dbo].[DeleteInstructor] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT CONTROL ON [dbo].[DeleteInstructor] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT EXECUTE ON [dbo].[DeleteInstructor] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT TAKE OWNERSHIP ON [dbo].[DeleteInstructor] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT VIEW DEFINITION ON [dbo].[DeleteInstructor] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT ALTER ON [dbo].[AddNewStudent] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT CONTROL ON [dbo].[AddNewStudent] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT EXECUTE ON [dbo].[AddNewStudent] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT TAKE OWNERSHIP ON [dbo].[AddNewStudent] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT VIEW DEFINITION ON [dbo].[AddNewStudent] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT ALTER ON [dbo].[EditCourse] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT CONTROL ON [dbo].[EditCourse] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT EXECUTE ON [dbo].[EditCourse] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT TAKE OWNERSHIP ON [dbo].[EditCourse] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT VIEW DEFINITION ON [dbo].[EditCourse] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT ALTER ON [dbo].[AddStudentToCourse] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT CONTROL ON [dbo].[AddStudentToCourse] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT EXECUTE ON [dbo].[AddStudentToCourse] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT TAKE OWNERSHIP ON [dbo].[AddStudentToCourse] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT VIEW DEFINITION ON [dbo].[AddStudentToCourse] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT ALTER ON [dbo].[EditInsructorInCourse] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT CONTROL ON [dbo].[EditInsructorInCourse] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT EXECUTE ON [dbo].[EditInsructorInCourse] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT TAKE OWNERSHIP ON [dbo].[EditInsructorInCourse] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT VIEW DEFINITION ON [dbo].[EditInsructorInCourse] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT ALTER ON [dbo].[DeleteCourse] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT CONTROL ON [dbo].[DeleteCourse] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT EXECUTE ON [dbo].[DeleteCourse] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT TAKE OWNERSHIP ON [dbo].[DeleteCourse] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT VIEW DEFINITION ON [dbo].[DeleteCourse] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT ALTER ON [dbo].[RemoveStudentFromCourse] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT CONTROL ON [dbo].[RemoveStudentFromCourse] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT EXECUTE ON [dbo].[RemoveStudentFromCourse] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT TAKE OWNERSHIP ON [dbo].[RemoveStudentFromCourse] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT VIEW DEFINITION ON [dbo].[RemoveStudentFromCourse] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT ALTER ON [dbo].[EditDepartment] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT CONTROL ON [dbo].[EditDepartment] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT EXECUTE ON [dbo].[EditDepartment] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT TAKE OWNERSHIP ON [dbo].[EditDepartment] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT VIEW DEFINITION ON [dbo].[EditDepartment] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT ALTER ON [dbo].[CalculateFinalResult] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT CONTROL ON [dbo].[CalculateFinalResult] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT EXECUTE ON [dbo].[CalculateFinalResult] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT TAKE OWNERSHIP ON [dbo].[CalculateFinalResult] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT VIEW DEFINITION ON [dbo].[CalculateFinalResult] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT ALTER ON [dbo].[AddNewTrack] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT CONTROL ON [dbo].[AddNewTrack] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT EXECUTE ON [dbo].[AddNewTrack] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT TAKE OWNERSHIP ON [dbo].[AddNewTrack] TO [TrainingManager]
GO
use [ExamSystem7]
GO
GRANT VIEW DEFINITION ON [dbo].[AddNewTrack] TO [TrainingManager]
GO
--------------------------------------------------
student
use [ExamSystem7]
GO
GRANT UPDATE ON [dbo].[ShowAllCourses] TO [student]
GO
use [ExamSystem7]
GO
GRANT VIEW CHANGE TRACKING ON [dbo].[ShowAllCourses] TO [student]
GO
use [ExamSystem7]
GO
GRANT VIEW DEFINITION ON [dbo].[ShowAllCourses] TO [student]
GO
use [ExamSystem7]
GO
GRANT VIEW DEFINITION ON [dbo].[DetailsAboutDepartment] TO [student]
GO
use [ExamSystem7]
GO
GRANT EXECUTE ON [dbo].[DoExam] TO [student]
GO
use [ExamSystem7]
GO
GRANT TAKE OWNERSHIP ON [dbo].[DoExam] TO [student]
GO
use [ExamSystem7]
GO
GRANT VIEW DEFINITION ON [dbo].[DoExam] TO [student]
GO
-------------------------------------
--instructor
use [ExamSystem7]
GO
GRANT EXECUTE ON [dbo].[CalculateQuestionResult] TO [instructor]
GO
use [ExamSystem7]
GO
GRANT EXECUTE ON [dbo].[CourseQuestion] TO [instructor]
GO
use [ExamSystem7]
GO
GRANT EXECUTE ON [dbo].[EditMQC] TO [instructor]
GO
use [ExamSystem7]
GO
GRANT EXECUTE ON [dbo].[StudentsOfCourses] TO [instructor]
GO
use [ExamSystem7]
GO
GRANT EXECUTE ON [dbo].[AddStudentToCourse] TO [instructor]
GO
use [ExamSystem7]
GO
GRANT EXECUTE ON [dbo].[EditQuestionPool] TO [instructor]
GO
use [ExamSystem7]
GO
GRANT EXECUTE ON [dbo].[QuestionOfCourse] TO [instructor]
GO
use [ExamSystem7]
GO
GRANT EXECUTE ON [dbo].[EditText] TO [instructor]
GO
use [ExamSystem7]
GO
GRANT EXECUTE ON [dbo].[InstructorCourses] TO [instructor]
GO
use [ExamSystem7]
GO
GRANT VIEW DEFINITION ON [dbo].[DetailsInstructor] TO [instructor]
GO
use [ExamSystem7]
GO
GRANT EXECUTE ON [dbo].[EditTrueFalse] TO [instructor]
GO
use [ExamSystem7]
GO
GRANT EXECUTE ON [dbo].[AddExam] TO [instructor]
GO
use [ExamSystem7]
GO
GRANT EXECUTE ON [dbo].[NumOfStudentInEachCourse] TO [instructor]
GO
use [ExamSystem7]
GO
GRANT EXECUTE ON [dbo].[ShowQuestionsExam] TO [instructor]
GO
use [ExamSystem7]
GO
GRANT EXECUTE ON [dbo].[EditInstructorUserName] TO [instructor]
GO
use [ExamSystem7]
GO
GRANT EXECUTE ON [dbo].[MakeCourseExam] TO [instructor]
GO

