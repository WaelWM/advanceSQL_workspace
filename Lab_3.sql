/*	Lab Exercise 3
	Title: Integrity Enhancement Feature & Constraints
	Database: DreamHome

If need to delete values from a table but it has related data in other table, 
it can be done by making the related value as null, as a defult value, or delete the related data in the (PK) 

*/
--Q1
-- Required Data
-- Example, every member of staff must have an associated job position 
-- (for example, Manager, Assistant, and so on)

ALTER TABLE Staff 
	ALTER column position varchar (50) Not Null -- the constrain enforcment can by done during the creation of the table or can be done as on this using "Alter"

--Q2
-- Domain Constraints
-- example, the gender of a member of staff is either 'M' or 'F', 
-- so the domain of the column gender of the Staff table is 
-- a single character string consisting of either 'M' or 'F'
-- The column has a value that violates the constraint. Therefore, 
-- WITH NOCHECK is used to prevent the constraint from being validated 
-- against existing rows, and to allow for the constraint to be added.


ALTER TABLE Staff WITH NOCHECK 
	ADD CONSTRAINT CK_gender check (gender = 'm' OR gender = 'f')

-- OR 

ALTER TABLE Staff WITH NOCHECK 
	ADD CONSTRAINT CK_gender check (gender in ('f','m'))

--Try executing this, it will generate an error

Insert into Staff values 
('S02','Kelly','Lee','Clerk','Male','15 November 2000', 20000, 'B005');

-- DROP CK_gender constraint

ALTER TABLE Staff 
	DROP CONSTRAINT CK_gender

--Q3
-- Entity Integrity
-- Defining Primary Key
-- use unique keyword

-- ADD Unique constraint to DOB column

ALTER  TABLE Staff 
	ADD UNIQUE (dob)
	
--Q4	
-- add new column with check constraint 

ALTER  TABLE staff
	ADD status varchar(10) 
	constraint CK_status check (status in ('active','inactive'))

--Q5
-- add new "default" constrain for existing column position
-- Hint: the default value will appear when the user insert new row 

ALTER TABLE Staff
	ADD CONSTRAINT DEF_job default 'manager' FOR Position


Select * From staff;

--test the constraints
Insert into Staff (staffNo, fname, lname, gender, dob, salary,branchNo) values 
('S093', 'Helen', 'lenn', 'F','1 October 2000', '48573','B005'); -- no value added for the postions thus it will be the defualt value "Manager" which has been set
																-- on the Q5

--Q6
-- Referential action 
-- specified using ON UPDATE and ON DELETE subclauses:
-- NO ACTION (defalut settings), SET NULL, 
-- CASCADE(if the pk is updated, the pk will be update), 
-- SET DEFAULT (if changed the pk, the fk will get the default value)
-- the Two tables used are PrivateOwner and PropertyForRent

Select * from PrivateOwner
Select * from PropertyForRent

-- show all foreign keys (FK) information

SELECT * FROM sys.foreign_keys

-- drop foreign key FK_PropertyForRent_PrivateOwner

ALTER TABLE PropertyForRent
      drop constraint [FK__PropertyF__owner__403A8C7D]

--Q6(a)
-- Add foreign key constraint with 'NO ACTION' option
-- Hint: no action will change the defualt setting
--the performed update or delete operation in the parent table will fail with an error.

Select * From PrivateOwner;
Select * From PropertyForRent;


ALTER TABLE PropertyForRent
	ADD constraint FK_NoAction foreign key (ownerNo) references PrivateOwner(ownerNo) 
	ON DELETE NO ACTION ON UPDATE NO ACTION

--Q6(b)
-- Alter foreign key constraint with 'SET NULL' option
-- Hint: all the related rows in the child table will be set to NULL

ALTER TABLE PropertyForRent
	ADD constraint FK_SetNull foreign key (ownerNo) references PrivateOwner(ownerNo) 
	ON DELETE SET NULL ON UPDATE SET NULL

	Delete From PrivateOwner Where ownerNo = 'CO46';
	
--Q6(c)
-- Alter foreign key constraint with 'SET DEFAULT' option
-- Hint: all the related rows in the child table will be set to Default
-- Default value: is the auto value that will be inserted in the column in case that the 
-- user didn't fill it.

Select * From PropertyForRent;

-- 1) the default value must be specificed

ALTER TABLE PropertyForRent
	ADD CONSTRAINT DEF_ownerNo default 'CO87' FOR ownerNo

-- 2) set the referential action to Default on update and delete

ALTER TABLE PropertyForRent
	ADD constraint FK_SetDefault foreign key (ownerNo) references PrivateOwner(ownerNo) 
	ON DELETE SET DEFAULT ON UPDATE SET DEFAULT

	Delete From PrivateOwner Where ownerNo = 'CO46';

--Q6(d)	
-- Alter foreign key constraint with 'CASCADE' option
-- Hint: all the related rows in the child table will be deleted

ALTER TABLE PropertyForRent
	ADD constraint FK_Cascade foreign key (ownerNo) references PrivateOwner(ownerNo) 
	ON DELETE CASCADE ON UPDATE CASCADE

Update PrivateOwner set ownerNo = 'C090' where ownerNo= 'C040';


--Q7 Your Task
/*
Write an Alter statement to add a foreign key constraint to 
branchNo in staff&Registration&PropertyForRent tables. 
When a branch is deleted from the branch table (such as B005), 
then the branchNo in staff&Registration&PropertyForRent tables 
will be set to a default value of B002 (assuming that branch B002 will never be deleted)
*/
