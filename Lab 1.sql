--LAB 1

--Q1

--Select * From PropertyForRent Where (rooms = 3 OR rooms = 4) AND rent < 600;

-- Q2 
--Select * From Branch where city in ('London', 'Glasgow', 'Bristol', 'Aberdeen');

-- Q3
--Select * from staff s inner join Branch b on s.branchNo	= b.branchNo where city = 'Glasgow';

--Q4 
--Select Count(*) from PropertyForRent where type = 'flat';
--OR
--Select Count(propertyNo) from PropertyForRent where type = 'flat';

--Q5
--select * from PropertyForRent p inner join Branch b ON p.branchNo = b.branchNo Where b.city ='Glasgow' Order By p.type ASC, p.rent DESC;

--Q6
--Select branchNo, count (staffNo) as StaffAmount from Staff group by branchNo;

-- Q7 
--Select * from Viewing where comment is null;

--Q8 
--Select * from staff where salary > (Select AVG (salary) from staff);

--Q9 
--Select * from PropertyForRent r where not exists (select * from Viewing v where r.propertyNo = v.propertyNo);
--OR
--Select * from PropertyForRent where propertyNo not in (select propertyNo from Viewing);

--Q10
--Select * FROM Branch where branchNo in (select branchNo FROM PropertyForRent GROUP BY branchNo HAVING COUNT (branchNo) > 2);
 
--Q11

--SELECT propertyNo, COUNT(*) AS Views FROM Viewing GROUP BY propertyNo HAVING COUNT(*) > 1;

--12
--INSERT INTO Client (clientNo, fname, lname, telno, preftype, maxrent) VALUES 
--('CR88', 'John', 'Smith', '0207-774-5633', 'House', 850),
--('CR89', 'Jane', 'Doe', '0141-848-1826', 'Flat', 400);

--13
--UPDATE Client SET maxrent = 600 WHERE fname = 'Ellen' AND lname = 'Smith';

--14
--SELECT MIN(rent) from PropertyForRent;

--15
--SELECT COUNT(*) AS 'Properties Owned' FROM Client WHERE fname = 'Carol' AND lname = 'Farrel';

--16
--INSERT INTO Registration(clientNo, branchNo, staffNo, datejoined) VALUES ('CR76', 'B005', 'SG5', 1945-03-01);

--17