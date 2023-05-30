
--Lab Exercise 5 – Stored Procedures

--Question 1

/*Write a stored procedure (on the DreamHome database) that reads the branch number entered by the user and displays the details of the staff at that branch
as well as the total number of properties handled by each of those staff. 
Include appropriate validation messages to alert the user if an invalid branch number is given as the input.  (check exists)
Format for Stored Procedure Call is given below:
EXEC spStaffDetails ‘B005’
	-Need to join 3 tables (staff, branch, propertyForRent)
	-Need to use Count, group by
	-Need to use ‘If…Else’, if branch EXISTS then show result, else print message

Sample output:
branchno	staffno	fname	lname	totalProperties
B005	SL21	John	White	0
B005	SL41	Julie	Lee	1
B005	SL42	James	Brown	0 */


Select COUNT(Branch.branchNo) from branch INNER JOIN Staff ON branch.branchNo = staff.branchNo INNER JOIN PropertyForRent ON Staff.branchNo = PropertyForRent.branchNo WHERE Branch.branchNo = 'B005';

CREATE PROCEDURE spStaffDetails
    @branchNumber VARCHAR(10)
AS
BEGIN
    -- Check if the branch number exists
    IF NOT EXISTS(SELECT * FROM Branch WHERE branchNo = @branchNumber)
    BEGIN
        PRINT 'Invalid branch number. Please enter a valid branch number.'
        RETURN
    END
 
    -- If Branch number valid, show staff details and property
    SELECT s.staffNo, s.fname, s.lname, s.position, COUNT(p.propertyNo) AS propertyCount
    FROM Staff s
    LEFT JOIN PropertyForRent p ON s.staffNo = p.staffNo
    WHERE s.branchNo = @branchNumber
    GROUP BY s.staffNo, s.fname, s.lname, s.position
END
 
EXEC spStaffDetails 'B003';






--Question 2

/*Write a stored procedure which takes 2 inputs and returned 2 outputs.
When the user provide input such as rooms is 5 and rent is 200, 
the server should query PropertyForRent table and return the message: The property you look for is located at street ‘18 Dale Dr’ and city is ‘Glasgow’.*/

SELECT street,city FROM PropertyForRent WHERE rooms = 5 AND rent = 200;

Create PROCEDURE RoomRent
@RoomSP varchar(15), @RentSP varchar(15)
As
BEGIN
SELECT street, city FROM PropertyForRent WHERE rooms = @RoomSP AND rent = @RentSP
END 

EXEC RoomRent 5,200 

Create PROCEDURE RoomLocation
@RoomSP varchar(15), @RentSP varchar(15)
As
BEGIN
IF EXISTS(SELECT street, city FROM PropertyForRent WHERE rooms = @RoomSP AND rent = @RentSP)
BEGIN
PRINT 'The values exist'
SELECT street, city FROM PropertyForRent WHERE rooms = @RoomSP AND rent = @RentSP
END
ELSE 
BEGIN
PRINT 'The Values do not exist'
END
END

DROP PROC RoomLocation

EXEC RoomLocation 5,200

Create proc PropertyDetails
@rooms int,
@rents int,
@streets nvarchar(50) output,
@citys nvarchar(50) output
as
select @streets = street, @citys = city from PropertyForRent 
where rooms = @rooms and rent = @rents



if exists (select * from PropertyForRent where rooms = @rooms and rent = @rents)
    begin
    print 'The Property You Look For Is Located At Street "'+(@streets)+
    '" And City Is "'+(@citys)+'"'
    return
    end
else
    begin
    print 'no property records with mentioned details'
    return
    end

declare @street nvarchar(50),@city nvarchar(50) 
EXEC PropertyDetails 5, 200, @street output, @city output


	


