-----QUESTION 1--------
-----CREATING DATABASE-------
create database PrescriptionsDB;

use PrescriptionsDB
go


--------CREATING TABLE-----------
create table Medical_Practice( 
PRACTICE_CODE NVARCHAR(10) PRIMARY KEY NOT NULL,
PRACTICE_NAME NVARCHAR(50) NOT NULL,
ADDRESS_1 NVARCHAR(50) NOT NULL,
ADDRESS_2 NVARCHAR(50),
ADDRESS_3 NVARCHAR(50),
ADDRESS_4 NVARCHAR(30),
POSTCODE NVARCHAR(15) NOT NULL);



create table Drugs( 
BNF_CODE NVARCHAR(100) PRIMARY KEY NOT NULL,
CHEMICAL_SUBSTANCE_BNF_DESCR NVARCHAR(100) NOT NULL,
BNF_DESCRIPTION NVARCHAR(100) NOT NULL,
BNF_CHAPTER_PLUS_CODE NVARCHAR(100) NOT NULL);




create table Prescriptions( 
PRESCRIPTION_CODE INT NOT NULL PRIMARY KEY ,
PRACTICE_CODE NVARCHAR(10) NOT NULL FOREIGN KEY(PRACTICE_CODE) references Medical_Practice (PRACTICE_CODE),
BNF_CODE NVARCHAR(100) NOT NULL FOREIGN KEY (BNF_CODE) references Drugs (BNF_CODE),
QUANTITY INT NOT NULL,
ITEMS INT NOT NULL,
ACTUAL_COST FLOAT NOT NULL);





-------IMPORT DATA FROM CSV FILE THAT WE ALREADY IMPORT IN THAT DATABASE-----

INSERT INTO Drugs(BNF_CODE,CHEMICAL_SUBSTANCE_BNF_DESCR,BNF_DESCRIPTION,BNF_CHAPTER_PLUS_CODE)
SELECT DISTINCT BNF_CODE,CHEMICAL_SUBSTANCE_BNF_DESCR,BNF_DESCRIPTION,BNF_CHAPTER_PLUS_CODE
FROM [dbo].[Drugs_Data]





INSERT INTO Medical_Practice(PRACTICE_CODE,PRACTICE_NAME,ADDRESS_1,ADDRESS_2,ADDRESS_3,ADDRESS_4,POSTCODE)
SELECT DISTINCT PRACTICE_CODE,PRACTICE_NAME,ADDRESS_1,ADDRESS_2,ADDRESS_3,ADDRESS_4,POSTCODE
FROM [dbo].[Medical_Practice_Data]






INSERT INTO Prescriptions(PRESCRIPTION_CODE,PRACTICE_CODE,BNF_CODE,QUANTITY,ITEMS,ACTUAL_COST)
SELECT DISTINCT PRESCRIPTION_CODE,PRACTICE_CODE,BNF_CODE,QUANTITY,ITEMS,ACTUAL_COST
FROM [dbo].[Prescriptions_Data]



----QUESTION2-------
SELECT BNF_CODE,CHEMICAL_SUBSTANCE_BNF_DESCR,BNF_DESCRIPTION,BNF_CHAPTER_PLUS_CODE
FROM Drugs
WHERE BNF_DESCRIPTION LIKE '%tablets%' or BNF_DESCRIPTION LIKE '%capsules%'








----QUESTION3--------
SELECT DISTINCT PRACTICE_CODE, round(QUANTITY,1)*ITEMS AS TOTAL_QUANTITY
FROM Prescriptions





-----QUESTION4--------
select distinct CHEMICAL_SUBSTANCE_BNF_DESCR from Drugs







-------QUESTION5--------
Select COUNT(BNF_CHAPTER_PLUS_CODE) AS Total_Prescription_Count,
ds.BNF_CHAPTER_PLUS_CODE,
MAX(ps.ACTUAL_COST) AS Max_Cost,
MIN(ps.ACTUAL_COST) AS Min_Cost,
AVG(ps.ACTUAL_COST) AS Average_Cost
from Drugs ds
INNER JOIN Prescriptions ps ON ds.BNF_CODE = ps.BNF_CODE
GROUP BY ds.BNF_CHAPTER_PLUS_CODE;


	 
---------QUESTION6--------
SELECT 
    mp.PRACTICE_NAME, 
    MAX(p.ACTUAL_COST) AS max_cost
FROM 
    Prescriptions p
	inner join Medical_Practice mp on
	p.PRACTICE_CODE=mp.PRACTICE_CODE
GROUP BY 
    mp.PRACTICE_NAME
HAVING 
    MAX(p.ACTUAL_COST) > 4000
ORDER BY 
    max_cost DESC;



----------QUESTION7--------
----in this code i will try to return few columns from the prescription table and also get some details from the drug table 
-----and i show the data in prescription_code order and it will be in the descending order
SELECT 
P.PRESCRIPTION_CODE,P.PRACTICE_CODE,P.QUANTITY,P.ITEMS,d.BNF_CODE,d.BNF_DESCRIPTION
FROM 
    Prescriptions p join Drugs d on p.BNF_CODE=d.BNF_CODE
ORDER BY p.PRESCRIPTION_CODE desc;





------use exists and in------
select PRACTICE_NAME,ADDRESS_1+ ',' +ADDRESS_2+ ',' +ADDRESS_3+ ',' +ADDRESS_4+ ',' +POSTCODE as Full_Address
from Medical_Practice
where exists
(select PRESCRIPTION_CODE,QUANTITY
from Prescriptions where QUANTITY in (50 , 28))






-------use group by and having------

select MAX(QUANTITY) as Maximum_Quantity,PRESCRIPTION_CODE
from Prescriptions 
Group by PRESCRIPTION_CODE
having MAX(QUANTITY ) > 50;






-------System define Function------

select LEN(PRACTICE_NAME) AS length_of_PracticeName from Medical_Practice










select ADDRESS_3,	 LOWER(ADDRESS_3) AS Town from Medical_Practice


