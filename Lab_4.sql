--Lab Exercise 4
-- Note: before creating the stored procedure make sure that the query worked

-- create stored procedure without any parameter

USE Dreamhome

GO

--Q1
CREATE PROC SPstaff
AS 
(SELECT * FROM staff)

-- execute the stored procedure SPstaff
Select fname from Staff;
EXECUTE SPstaff

-- If this procedure is the first statement within a batch
SPstaff

--Q2
-- alter procedure SPstaff
ALTER PROC SPstaff
AS 
SELECT fname,lname
 FROM staff

 --Execute the stored procedure
 EXEC SPstaff

 --Q3
-- Drop procedure SPstaff
DROP PROC SPstaff

--Q4
-- Returning more than one result set
CREATE PROCEDURE SPmulti
AS
SELECT * FROM BRANCH 
SELECT * FROM STAFF

-- Execute procedure SPmulti
EXEC SPmulti

--Q5
-- Create procedure with 1 parameter

CREATE PROC SPstaff_name 
@fname1 varchar(20)
AS
SELECT * 
FROM Staff
WHERE fname = @fname1;

-- execute proc SPstaff_name
EXEC SPstaff_name 'mary'

--Q6
-- Create procedure with 2 parameters
-- position and salary

CREATE PROC SPstaff_Pos_Sal 
@pos varchar(20), @sal  int
AS
(SELECT fname,position, salary, gender
 FROM staff
 WHERE position = @pos AND salary > @sal)
 
			
-- execute the SPstaff_Pos_Sal
-- I can execute this procedure in many ways

EXEC SPstaff_Pos_Sal 'manager', 8000 --follow the sequence

EXECUTE SPstaff_Pos_Sal @sal = 8000 ,@pos = 'manager' 
--or not following the sequence but need to specify the variable name


--Q7
-- sp_depends 'sys stored procedure' to get information about objects in Database
-- get info about SPstaff_Pos_Sal stored procedure

-- get info about object related to staff table
EXEC sp_depends @objname = 'Staff'

-- get info about object related to Branch table
EXEC sp_depends @objname = 'Branch'



--Q8
-- Create Procedure Branch_Insert_Update
-- this procedure checks for the existance of branch, in case that
-- the branch exists it will update it otherwise a new row will be inserted

CREATE PROC Branch_Insert_Update
@branchNo varchar (20),
@street varchar (20),
@city varchar (20),
@postcode varchar (20)

AS

If EXISTS (Select * from Branch Where branchNo = @branchNo)
    Begin
	UPDATE Branch
	set street = @street,
	    city = @city,
	    postcode = @postcode
	WHERE branchno = @branchNo
	Print (@branchno)+ ' row updated' 
	End
ELSE
   Begin
   INSERT into Branch 
	values (@branchNo ,
			@street ,
			@city ,
			@postcode)
    Print ' New row inserted' 
    END
    
   

-- exec Branch_Insert_Update

EXEC Branch_Insert_Update 'B015', '63 Maxwel Rd', 'Liverpool', 'BCN6029'
Select * From Branch;
-- drop Branch_Insert_Update

DROP PROC Branch_Insert_Update

--Q9
-- Create procedure with OUTPUT parameter

CREATE PROCEDURE sum_salary
@SUM_SAL money OUTPUT
AS
SELECT @SUM_SAL = SUM(salary)
FROM staff;


-- Execute sum_salary procedure

DECLARE @SUM_SAL1 money
EXECUTE sum_salary @SUM_SAL1 OUTPUT

IF @SUM_SAL1 < 130000
	BEGIN
	Print (@sum_sal1)
	PRINT 'Salary sum is less than 130000'
	END
ELSE
	BEGIN
	Print (@sum_sal1)
	PRINT 'Salary sum is more than 130000'
	END

--Q10
-- Create stored procedures with input and output
--Sum the salary of staff where salary is more than @sal (input)
Create PROCEDURE sum_salary2
@SUM_SAL money OUTPUT,
@sal money
AS
SELECT @SUM_SAL = SUM(salary)
FROM staff
Where salary > @sal;

-- Execute sum_salary procedure

DECLARE @SUM_SAL1 money
EXECUTE sum_salary2 @SUM_SAL1 OUTPUT, 20000

IF @SUM_SAL1 < 130000
	BEGIN
	Print (@sum_sal1)
	PRINT 'Salary sum is less than 130000'
	END
ELSE
	BEGIN
	Print (@sum_sal1)
	PRINT 'Salary sum is more than 130000'
	END
	

--Q11
--Write a stored procedure to calculate the average salary of staff where gender
--is 'F', if the average is more than 20000, then print 'average is more than 20000'
--else if the average is less than 20000, then print 'average is less than 20000'
--modify Q9

Create PROCEDURE AVG_salary
@AVG_SAL money OUTPUT
AS
SELECT @AVG_SAL = AVG(salary)
FROM staff
where gender = 'f';

 

IF @AVG_SAL < 20000
    BEGIN
    Print (@AVG_SAL)
    PRINT 'Average is less than 20000'
    END
ELSE
    BEGIN
    Print (@AVG_SAL)
    PRINT 'Average is more than 20000'
    END

DECLARE @AVG_SAL1 money
EXECUTE AVG_salary @AVG_SAL1 OUTPUT


--Q12
--Write a stored procedure to return 'how many' property available where its rent 
--is more than 400, if there are more than or equal to 2 properties, then print 'there are 
--more than or equal to 2 properties with rent more than 400'
--else print 'there are less than 2 properties with rent more than 400'
--this question need to use 'count'
--modify Q9

Select * from PropertyForRent where rent >= 400;

Create PROCEDURE PropertySP
@PropSP int OUTPUT
AS
SELECT @PropSP = count(*)
FROM PropertyForRent
where rent >= 400;

 

IF @PropSP >= 2
    BEGIN
    Print (@PropSP)
    PRINT 'There are more than or equal than 2 property with rent more than 400'
    END
ELSE
    BEGIN
    Print (@PropSP)
    PRINT 'There are less than 2 property with rent more than 400'
    END

 


