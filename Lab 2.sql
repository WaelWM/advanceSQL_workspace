Use DreamHome;

--LAB 2

-- Table1 is always on the left
-- Forigen key can contain null values but should be avoided becasue the result might be inaccurate because of the null values, instead a defualt value should be put

--Q1 Cross Join 'cartesian product'
--this will produce 30 rows in the result
--6 rows from staff table multiply by 5 rows from Branch table
SELECT Branch.branchNo, branch.city, Staff.Staffno, Staff.fname
FROM Branch CROSS JOIN Staff
-------------------------------------------------------------------------------------------
--Q2 Simple Join

SELECT Branch.branchNo, Branch.city, Staff.Staffno, Staff.fname
FROM Branch, staff
WHERE Branch.branchNo = Staff.branchno;
-------------------------------------------------------------------------------------------

----Q3 Simple Join using alias

SELECT b.branchNo, b.city, s.Staffno, s.fname
FROM Branch b, staff s
WHERE b.branchNo = s.branchno;
-------------------------------------------------------------------------------------------

----Q4 using 'Inner Join'

SELECT b.branchNo, b.city, s.Staffno, s.fname
FROM Branch b INNER JOIN staff s 
ON b.branchNo = s.branchno;
-------------------------------------------------------------------------------------------

--Q5 Three Tables join

SELECT b.branchno, b.city, S.Staffno, S.fname, p.propertyNo, p.city
FROM Branch b, Staff s, PropertyForRent p
WHERE b.branchNo = s.branchno AND s.Staffno = p.StaffNo 
-------------------------------------------------------------------------------------------

--Q6 Three Tables Join (INNER JOIN)

SELECT b.branchno, b.city, S.Staffno, S.fname, p.propertyNo, p.city
FROM Branch b , Staff s ,PropertyForRent p 
WHERE b.branchNo = s.branchno AND s.Staffno = p.StaffNo 

--OR 

SELECT b.branchno, b.city, S.Staffno, S.fname, p.propertyNo, p.city
FROM Branch b INNER JOIN Staff s 
ON b.branchNo = s.branchno
INNER JOIN PropertyForRent p 
ON s.Staffno = p.StaffNo 
-------------------------------------------------------------------------------------------

--Q7 Outer Join
-- This is INNER JOIN to show the result

SELECT b.branchNo, b.city, p.PropertyNo, p.city
FROM Branch b, PropertyForRent p
WHERE b.City = p.City; -- Can also join using common attrubite (both tables got same attrubite eg.city column)
-------------------------------------------------------------------------------------------

--Q7.1 Left Outer Join
-- Note: update table property for rent branchno "PL94" city column from "London" to "KL"

SELECT b.branchNo, b.city, p.PropertyNo, p.city
FROM Branch b LEFT JOIN PropertyForRent p
ON b.City = p.City
-------------------------------------------------------------------------------------------

--Q7.2 Right Outer Join

SELECT b.branchNo, b.city, p.PropertyNo, p.city
FROM Branch b right JOIN PropertyForRent p
ON b.City = p.City;
-------------------------------------------------------------------------------------------

--Q7.3 Full Outer Join

SELECT b.branchNo, b.city, p.PropertyNo, p.city
FROM Branch b FULL OUTER JOIN PropertyForRent p
ON b.City = p.City;
-------------------------------------------------------------------------------------------

--Q7.4 LEFT JOIN EXCLUDING INNER JOIN

SELECT b.branchNo, b.city, p.PropertyNo, p.city
FROM Branch b LEFT JOIN PropertyForRent p
ON b.City = p.City
where p.city is null
-------------------------------------------------------------------------------------------

--compare this result with the one in Q7.1
--no result because none of the property is not assigned to a branch
--Q7.5 RIGHT JOIN EXCLUDING INNER JOIN

SELECT b.branchNo, b.city, p.PropertyNo, p.city
FROM Branch b Right JOIN PropertyForRent p
ON b.City = p.City
where b.city is null
-------------------------------------------------------------------------------------------

--compare this result with the one in Q7.

--this query is to show the property which is not assigned to any branch
--this will show the branch which doesn't have property 
--Q7.6 OUTER JOIN EXCLUDING INNER JOIN

SELECT b.branchNo, b.city, p.PropertyNo, p.city
FROM Branch b FULL OUTER JOIN PropertyForRent p
ON b.City = p.City
WHERE b.city is Null OR p.city is NULL;
-------------------------------------------------------------------------------------------

--Q8 Show the client who doesn't have any viewing (this client is not in the viewing table)
SELECT c.clientNo, c.fname, c.lname, v.propertyNo, v.viewdate FROM Client c FULL OUTER JOIN Viewing v ON c.clientNo = v.clientNo
Where v.viewdate is NULL;
-------------------------------------------------------------------------------------------