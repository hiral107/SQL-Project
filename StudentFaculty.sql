CREATE DATABASE IF NOT EXISTS StuDB;
USE StuDB;

CREATE TABLE Student(
StudentID int,
SName VARCHAR(50),
Email VARCHAR(50),
Percentage INT,
DepartmentID INT);

CREATE TABLE Department(
DepartmentID INT,
DepartmentName VARCHAR(50));

CREATE TABLE Faculty(
DepartmentID INT,
FacultyName VARCHAR(50));

INSERT INTO Student VALUES(1001, "Ajay", "ajay@xyz.com", 65, 1), (1002, "Babloo", "babloo@xyz.com", 67, 2),
(1003, "Chhavi", "chhavi@xyz.com", 89, 3), (1004, "Dheeraj", "dheeraj@xyz", 75, 4),
(1005, "Evina", "evina@xyz.com", 91, 1), (1006, "Krishna", "krishna@xyz.com", 99, 5);

INSERT INTO Department VALUES(1, "Mathematics"), (2, "Physics"), (3, "English");

INSERT INTO Faculty VALUES(1, "Piyush"), (2, "Namita"), (3, "Ashneer"), (4, "Gazhal"),
(5, "Anupam");

SELECT * FROM Student;
SELECT * FROM Department;
SELECT * FROM Faculty;

SELECT Student.StudentID, Student.SName, Student.Email, Student.Percentage, Student.DepartmentID,
Faculty.FacultyName FROM Student
LEFT JOIN Faculty
ON Student.DepartmentID = Faculty.DepartmentID;

SELECT Student.StudentID, Student.SName, Student.DepartmentID, Faculty.FacultyName FROM Student
LEFT JOIN Faculty
ON Student.DepartmentID = Faculty.DepartmentID
WHERE Faculty.FacultyName IN ("Piyush", "Ashneer");

SELECT Student.StudentID, Student.SName, Student.Email, Student.DepartmentID, Faculty.FacultyName
FROM Student
LEFT JOIN Faculty
ON Student.DepartmentID = Faculty.DepartmentID;