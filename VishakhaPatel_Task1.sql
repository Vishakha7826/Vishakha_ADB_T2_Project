-----CREATING DATABASE-------
create database LibraryManagmentDB;

use LibraryManagmentDB
go



CREATE TABLE MemberDetails(
MemberId int NOT NULL IDENTITY(1,1) PRIMARY KEY,
FirstName nvarchar(50) NOT NULL,
MiddleName nvarchar(50) NULL,
LastName nvarchar(50) NOT NULL,
Address1 nvarchar(50) NOT NULL,
Address2 nvarchar(50) NULL,
Postcode nvarchar(50) NOT NULL,
DateOfBirth date NOT NULL,
Email nvarchar(100) NULL,
Telephone bigint NULL,
Username nvarchar(50) NOT NULL,
Password nvarchar(50) NOT NULL,
MembershipStartDate date NOT NULL,
MembershipEndDate date NULL
);


CREATE TABLE CategoryItems(
ItemId int NOT NULL IDENTITY(1000,1) PRIMARY KEY,
ItemTitle nvarchar(100) NOT NULL,
ItemType nvarchar(50) NOT NULL,
AuthorName nvarchar(100) NOT NULL,
YearOfPublication date NOT NULL,
AddedDate date NOT NULL,
AvailabilityStatus nvarchar(20) NOT NULL,
LostDate date NULL,
ISBN tinyint NULL);


CREATE TABLE Loan(
LoanId int NOT NULL IDENTITY(10000,1) PRIMARY KEY,
MemberId int NOT NULL,
ItemId int NOT NULL,
IssueDate date NOT NULL,
DueDate date NOT NULL,
ReturnedDate date NOT NULL,
OverdueStatus nvarchar(20) NOT NULL,
Fine money NOT NULL);


CREATE TABLE Overdue(
OverdueId int NOT NULL IDENTITY(100,1) PRIMARY KEY,
MemberId int NOT NULL,
Itemid int NOT NULL,
AmountRepaid money NOT NULL,
ModeOfPayment char NOT NULL,
RepaymentDate date NOT NULL,
Balance money NOT NULL,
OverDueAmount money NOT NULL);

ALTER TABLE Loan
ADD CONSTRAINT FK_Member
FOREIGN KEY (MemberId) REFERENCES MemberDetails(MemberId);

ALTER TABLE Loan
ADD CONSTRAINT FK_Item
FOREIGN KEY (ItemId) REFERENCES CategoryItems(ItemId);

 ALTER TABLE Overdue
ADD CONSTRAINT FK_Overdue_Member
FOREIGN KEY (MemberId) REFERENCES MemberDetails(MemberId);

ALTER TABLE Overdue
ADD CONSTRAINT FK_Overdue_Item
FOREIGN KEY (ItemId) REFERENCES CategoryItems(ItemId);

 ALTER TABLE Loan
ALTER COLUMN ReturnedDate date NULL;

ALTER TABLE Loan
ALTER COLUMN OverdueStatus nvarchar(25) NULL;

ALTER TABLE Loan
ALTER COLUMN Fine money NULL;

ALTER TABLE CategoryItems
ALTER COLUMN ISBN nvarchar(20) NULL;

ALTER TABLE CategoryItems
ALTER COLUMN LostDate date NULL;



----------------------------1.2a------------------------------------------

go
CREATE PROCEDURE SearchCatalogue
    @itemname VARCHAR(50)
as
BEGIN
    SELECT * 
    FROM CategoryItems
    WHERE @itemname LIKE '%' + @itemname + '%'
    ORDER BY YearOfPublication DESC;
END
go




----------------------------1.2b------------------------------------------

GO
CREATE FUNCTION LoanDetailFunction()
RETURNS TABLE AS
RETURN(SELECT ci.ItemTitle,ci.ItemType,ln.DueDate,ci.AuthorName,ci.YearOfPublication as Year_of_Publication,md.Username
FROM Loan ln
INNER JOIN CategoryItems ci
ON ci.ItemId = ln.ItemId
INNER JOIN MemberDetails md
ON md.MemberId = ln.MemberId
WHERE DATEDIFF(day, GETDATE(),ln.DueDate) BETWEEN 0 AND 5
  AND ln.ReturnedDate IS NULL)
GO

Select * from LoanDetailFunction();


---------------------------------1.2c-----------------------------------------------

GO
CREATE PROCEDURE MemberInfo
@FirstName nvarchar(50),
@MiddleName nvarchar(50) = NULL,
@LastName nvarchar(50),
@Address1 nvarchar(50),
@Address2 nvarchar(50) = NULL,
@Postcode nvarchar(50),
@DOB date,
@Email nvarchar(100) = NULL,
@Telephone bigint = NULL,
@Username nvarchar(50),
@Password nvarchar(50),
@MembershipStartDate date,
@MembershipEndDate date = NULL
AS
BEGIN
INSERT INTO MemberDetails
VALUES(@FirstName,@MiddleName,@LastName,@Address1,@Address2,@Postcode,@DOB,@Email,@Telephone,@Username,@Password,@MembershipStartDate,@MembershipEndDate)
END

EXEC MemberInfo 
@FirstName = 'Lily',@MiddleName='Deborah',@LastName='Smith', @Address1 = '3 Croxton Close', 
@Address2 ='Sale', @Postcode = 'M33 4WF',@DOB ='1991-12-12',@Username ='Smith12',
@Password='Lily334',
@MembershipStartDate = '2011-10-07';

EXEC MemberInfo 
@FirstName = 'Ramon',@MiddleName='Vicki',@LastName='Brown', @Address1 = '68 Silk Street', 
@Address2 ='Salford', @Postcode = 'M4 6BJ',@DOB ='1995-07-09',@Username ='Brown07',
@Password='Ramon46',
@MembershipStartDate = '2009-12-10';

EXEC MemberInfo 
@FirstName = 'Lucy',@LastName='Jamson', @Address1 = '79 Ducie Street', 
@Address2 ='Cheethamil', @Postcode = 'M1 2JQ',@DOB ='1989-05-09',@Username ='Brown07',
@Password='Ramon46',
@MembershipStartDate = '2015-10-01';

EXEC MemberInfo 
@FirstName = 'Harvey',@LastName='Graham', @Address1 = '61 Blacknorn Street', 
@Address2 ='Salford', @Postcode = 'M3 44F',@DOB ='1999-08-02',@Username ='Graham08',
@Password='Harvey44',
@MembershipStartDate = '2013-05-04';

select * from [dbo].[MemberDetails]

INSERT INTO CategoryItems
Values('Whereabouts','Book','Jhumpa Lahiri','2020-06-28','2021-04-15','Lost','2022-05-05','BNFI4458');

select * from CategoryItems

--------------------------1.2d----------------------------------
GO
CREATE PROCEDURE updateMemberDetail
    @value NVARCHAR(100),
    @memberId INT,
    @columnName VARCHAR(50)
AS
BEGIN
    IF @columnName = 'FirstName'
    BEGIN
    UPDATE MemberDetails
    SET FirstName = @value
    WHERE MemberId = @memberId
    END
    ELSE IF @columnName = 'MiddleName'
        BEGIN
        UPDATE MemberDetails
        SET MiddleName = @value
        WHERE MemberId = @memberId
        END
    ELSE IF @columnName = 'LastName'
    BEGIN
    UPDATE MemberDetails
    SET LastName = @value
    WHERE MemberId = @memberId
    END
    ELSE IF @columnName = 'Address1'
        BEGIN
        UPDATE MemberDetails
        SET Address1 = @value
        WHERE MemberId = @memberId
        END
    ELSE IF @columnName = 'Address2'
    BEGIN
    UPDATE MemberDetails
    SET Address2 = @value
    WHERE MemberId = @memberId
    END
    ELSE IF @columnName = 'Postcode'
    BEGIN
    UPDATE MemberDetails
    SET Postcode = @value
    WHERE MemberId = @memberId
    END
    ELSE IF @columnName = 'Email'
        BEGIN
        UPDATE MemberDetails
        SET Email = @value
        WHERE MemberId = @memberId
        END
ELSE IF @columnName = 'Username'
        BEGIN
        UPDATE MemberDetails
        SET Username = @value
        WHERE MemberId = @memberId
        END
    ELSE IF @columnName = 'Password'
    BEGIN
    UPDATE MemberDetails
    SET Password = @value
    WHERE MemberId = @memberId
    END  
END

 

GO
CREATE PROCEDURE updateMembershipDetail
    @dateValue date,
    @memberId INT,
    @columnName VARCHAR(50)
AS
BEGIN
IF @columnName = 'DateOfBirth'
    BEGIN
    UPDATE MemberDetails
    SET DateOfBirth = @dateValue
    WHERE MemberId = @memberId
    END
    ELSE IF @columnName = 'MembershipStartDate'
        BEGIN
        UPDATE MemberDetails
        SET MembershipStartDate = @dateValue
        WHERE MemberId = @memberId
        END
    ELSE IF @columnName = 'MembershipEndDate'
    BEGIN
    UPDATE MemberDetails
    SET MembershipEndDate = @dateValue
    WHERE MemberId = @memberId
    END
END

EXEC updateMemberDetail @value = 'Jamson79', @memberId = 3, @columnName = 'Username';

select * from MemberDetails

EXEC updateMemberDetail @value = 'Lucy12', @memberId = 3, @columnName = 'Password';

select * from MemberDetails

EXEC updateMembershipDetail @dateValue = '2021-05-29', @memberId = 3, @columnName = 'MembershipEndDate';

select * from MemberDetails


----------------------------------1.3-----------------------------------------------------
GO
CREATE VIEW Get_Loan_History AS
SELECT ln.*,md.Username,md.FirstName,ci.ItemTitle,ci.ItemType from Loan ln
INNER JOIN CategoryItems ci
ON ci.ItemId = ln.ItemId
INNER JOIN MemberDetails md
ON md.MemberId = ln.MemberId;
GO

Select * from Get_Loan_History;

----------------------------------1.4-----------------------------------------------------
GO
CREATE OR ALTER TRIGGER statusUpdate on Loan FOR UPDATE
AS
BEGIN
    DECLARE @id int;
    DECLARE @returnDate date;
    SET @id=(Select ItemId from INSERTED)
    SET @returnDate = (Select ReturnedDate from INSERTED)
    IF(@returnDate IS NOT NULL)
        BEGIN
        Update LibraryItems SET AvailabilityStatus = 'Available' Where ItemId = @id;
        END
END
GO
----------------------------------1.5-----------------------------------------------------


GO
CREATE FUNCTION CountLoanDetails(@getDate AS date)
RETURNS INT
AS
BEGIN
RETURN(Select COUNT(*) AS Loan_Count from Loan
Where IssueDate = @getDate)
END
GO

Select dbo.CountLoanDetails('2021-12-10') AS Loan_History

----------------------------------1.6-----------------------------------------------------

GO
CREATE PROCEDURE InsertLoanData
@memberId int,
@itemId int,
@issueDate date,
@dueDate date,
@returnedDate date,
@overdueStatus nvarchar(20),
@fine money
AS
BEGIN
INSERT INTO Loan
VALUES(@memberId,@itemId,@issueDate,@dueDate,@returnedDate,@overdueStatus,@fine)
END
GO

EXEC InsertLoanData @memberId = 1, @itemId = 1000, @issueDate = '2022-01-04', @dueDate = '2022-01-30', @returnedDate = '2022-01-30', @overdueStatus = NULL,
@fine = NULL;

 select * from Loan



GO
CREATE PROCEDURE InsertOverdueTableData
@memberId int,
@itemId int,
@amountRepaid money,
@paymentMode char,
@repaymentDate date,
@balance money,
@overdueAmount money
AS
BEGIN
INSERT INTO Overdue
VALUES(@memberId,@itemId,@amountRepaid,@paymentMode,@repaymentDate,@balance,@overdueAmount)
END
GO

 

GO
CREATE PROCEDURE InsertCategoryItems
@itemTitle nvarchar(100),
@type nvarchar(50),
@authorname nvarchar(100),
@publicationYear date,
@addedDate date,
@status nvarchar(20),
@lostDate date,
@isbn nvarchar(17)
AS
BEGIN
INSERT INTO CategoryItems
VALUES(@itemTitle,@type,@authorname,@publicationYear,@addedDate,@status,@lostDate,@isbn)
END
GO


 




