/* 
Lab Exercise 6
Title: Triggers
Database: DreamHome
*/

-- Use DreamHome Database

USE Dreamhome

-- Q1
-- ADD constraint on Salary Table (Domain Constraint)

ALTER TABLE Staff 
     ADD CONSTRAINT chk_sal CHECK ( Salary <= 90000) -- add constrain to the column to inforce the constrain


-- Drop constraint to avoid conflict with triggers below
ALTER TABLE Staff
     DROP CONSTRAINT chk_sal 

Insert into Staff Values('SL64', 'Leo','Smith','Assistant','M','2 January 2000','10000', 'B003','Active')

Select * from Staff;
-- Q2     
-- Create Domian constraint using trigger
CREATE TRIGGER ChkSal
ON STAFF
AFTER UPDATE  --trigger will fire after an update is made on the staff table
AS
	SELECT * FROM inserted --inserted is a temporary table created during the execution of the trigger, to store the inserted data
	IF EXISTS ( SELECT salary FROM inserted WHERE Salary >= 30000 )
	BEGIN 
		PRINT 'Salary Must be Less than 30000'
		ROLLBACK -- if the condition did not meet, then rollback (undo) from the inserted (temp table)
	END

-- test the trigger
-- Update Staff 'SL41' Salary to be 35000

UPDATE Staff
SET salary = 35000
WHERE Staffno = 'SA9' -- since the salary is higher than the condtion, the update will not be done. 


-- Show Staff table details

SELECT * FROM STAFF


-- Q3
-- Alter trigger to remove the rollback statement
-- altering the trigger that has been made in Q2

ALTER TRIGGER ChkSal 
ON STAFF
AFTER UPDATE
AS
	IF EXISTS ( SELECT salary FROM inserted WHERE  Salary >= 30000 )
	BEGIN
		Select * From Inserted
		PRINT 'Salary Must be Less than 30000'
	END

Select * from Inserted -- Inserted table is not accessible oustide the trigger

-- Use drop command to delete the trigger
-- Drop trigger to avoid conflict with other triggers below
DROP TRIGGER ChkSal

-- Q4
-- Create a trigger to ensure that the salary of a manager will not
-- exceed 30000

CREATE TRIGGER sal_pos_check
ON Staff
AFTER UPDATE-- Can be more than one trigger ex. UPDATE, Insert, Delete but usually each one should be written separatley to avoid confusion and easier to contorl
AS

IF EXISTS (SELECT * FROM inserted WHERE position = 'manager' AND Salary > 30000) 
	BEGIN
		PRINT 'Manager Salary must not exceed 30000'
		ROLLBACK
	END
	
-- test the trigger
-- Update Staff Susan's salary to be 28000 rather than 24000
-- Hint: the trigger will not fire because it didn't meet the criteria

UPDATE Staff
SET salary = 28000
WHERE Staffno = 'SG5' --this is a manager, can update because salary is <30000


UPDATE Staff
SET  salary = 50000
Where staffno = 'SG37' --this is not a manager, so can update even though salary is >30000


-- Update Staff Susan's salary to be 35000 rather than 28000
-- Hint: the trigger will be fired and no action will happen as a result of the 
-- rollback statement

UPDATE Staff
SET salary = 35000
WHERE staffno = 'SG5' --this is a manager, cannot update because salary is >30000


-- Q5
-- get triggers information using sys.triggers

SELECT * FROM sys.triggers

-- Q6
-- Using INSTEAD OF to Prevent Staff member from being deleted

CREATE TRIGGER STAFF_DEL1235
ON STAFF
INSTEAD OF DELETE
AS
BEGIN
	SELECT * FROM deleted --delete is a temporary table created during the execution of the trigger to store the deleted data
	RAISERROR('Staff Can''t be deleted', 16,10) --16 is the severity, 10 is the state
END

-- cannot call deleted outside the trigger
-- deleted can only be called inside the trigger
SELECT * FROM deleted

-- test the trigger
-- Use delete statement to delete staff 'SG5'

DELETE FROM Staff
WHERE staffno = 'SG5'

SELECT * FROM Staff

-- Q7
-- Add column status to staff table to check If Staff is active or Inactive

ALTER TABLE Staff
	ADD status VARCHAR(10)
	
-- Drop trigger STAFF_DEL1235
-- Drop trigger to avoid conflict with other triggers
DROP TRIGGER STAFF_DEL1235

-- Q8
-- Create a new INSTEAD OF trigger to include the staff status
-- instead of deleting the staff, set the status to inactive
CREATE TRIGGER STAFF_DEL
ON STAFF
INSTEAD OF DELETE
AS
BEGIN
	RAISERROR ('Staff cant''t be deleted.  Staff
	changed to inactive status.', 14, 11)
	 
	SELECT * FROM deleted -- this statement to show the deleted records in the deleted table
	
	UPDATE Staff
	SET status = 'Inactive'
	FROM Staff AS s INNER JOIN deleted AS d   
	ON s.Staffno = d.Staffno
END

-- test the trigger
-- Delete the Staff who holds the staffno SG5

DELETE FROM Staff
WHERE Staffno = 'SG14'

SELECT * FROM Staff

-- Try to show the deleted table info outside the trigger
-- this will fail since inserted/updated/deleted is only accesssible inside the trigger
SELECT * FROM deleted

-- Q9
-- Create Audit Table ClientAudit
-- this will be used as a log record

CREATE TABLE ClientAudit
(
ClientNo VARCHAR(50) not null,
fname VARCHAR(50) ,
lname VARCHAR(50) ,
telno VARCHAR(50) ,
preftype VARCHAR(50),
maxrent INT,
InsDelDate DATE,
flag CHAR(1)
)


-- Create ClientAud trigger to save the inserted and deleted rows 
-- from the Client table to the ClientAudit table

CREATE TRIGGER ClientAud
ON Client
AFTER INSERT, DELETE
AS

INSERT INTO ClientAudit 
SELECT ClientNo, fname, lname, telno, preftype, maxrent , getdate(), 'I' -- 'I' is a tag to represent inserted
FROM inserted

SELECT * FROM inserted

INSERT INTO ClientAudit 
SELECT ClientNo, fname, lname, telno, preftype, maxrent , getdate(), 'D' -- 'D' is a tag to represent deleted
FROM deleted

SELECT * FROM deleted

-- test the trigger
-- Insert new row to Client table

INSERT INTO Client
VALUES ('CR95','Alex', 'Max','01498-22222', 'House', 500)

-- Delete the previously inserted record

DELETE FROM Client
WHERE Clientno = 'CR95'

 
 -- Q10
 -- this will be your homework
 -- add a new column 'status' to PropertyForRent table
 -- create an 'instead of' trigger
 -- if someone attempt to delete a property, 
 -- disallow that then set its status to 'not available'
--modify Q8

ALTER TABLE PropertyForRent
ADD status VARCHAR(20) NOT NULL DEFAULT 'available';

CREATE TRIGGER PropertyForRent_DEL
ON PropertyForRent
INSTEAD OF DELETE
AS
BEGIN
	RAISERROR ('Property cannot be deleted.', 14, 11)
	 
	SELECT * FROM deleted
	
	UPDATE PropertyForRent
	SET status = 'not available'
	FROM PropertyForRent AS p INNER JOIN deleted AS d   
	ON p.propertyNo = d.propertyNo
END

Drop trigger PropertyForRent_DEL

DELETE FROM PropertyForRent
WHERE propertyNo = 'PA14'

Select * From PropertyForRent