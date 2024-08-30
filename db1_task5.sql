create database db1
use db1
-----------------------------------------
CREATE TABLE tb_task5 (
    TaskId INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    Mobile NVARCHAR(20),
    Email NVARCHAR(30),
    StateId NVARCHAR(50),
    CityId NVARCHAR(50),
    StateName NVARCHAR(100),
    CityName NVARCHAR(100)
);
ALTER TABLE tb_task5
ADD CreatedOn DATETIME DEFAULT GETDATE();

------------------------------------------
CREATE TABLE State (
    StateId NVARCHAR(50) PRIMARY KEY,
    StateName NVARCHAR(100) NOT NULL
);
------------------------------------------
CREATE TABLE City (
    CityId NVARCHAR(50) PRIMARY KEY,
    CityName NVARCHAR(100) NOT NULL,
    StateId NVARCHAR(50) NOT NULL,
    FOREIGN KEY (StateId) REFERENCES State(StateId)
);
----------------------------------------------
CREATE PROCEDURE InsertTask
    @Name NVARCHAR(50),
    @Mobile NVARCHAR(20),
    @Email NVARCHAR(30),
    @StateId NVARCHAR(50),
    @CityId NVARCHAR(50)
AS
BEGIN
    DECLARE @CityName NVARCHAR(100);
    DECLARE @StateName NVARCHAR(100);

  
    SELECT @CityName = CityName
    FROM City
    WHERE CityId = @CityId;

   
    SELECT @StateName = StateName
    FROM State
    WHERE StateId = @StateId;

    
    INSERT INTO tb_task5 (Name, Mobile, Email, StateId, CityId, StateName, CityName)
    VALUES (@Name, @Mobile, @Email, @StateId, @CityId, @StateName, @CityName);
END;
select * from tb_task5
alter PROCEDURE InsertTask
    @Name NVARCHAR(50),
    @Mobile NVARCHAR(20),
    @Email NVARCHAR(30),
    @StateId NVARCHAR(50),
    @CityId NVARCHAR(50),
    @CreatedOn DATETIME
AS
BEGIN
    DECLARE @CityName NVARCHAR(100);
    DECLARE @StateName NVARCHAR(100);

    
    SELECT @CityName = CityName
    FROM City
    WHERE CityId = @CityId;

   
    SELECT @StateName = StateName
    FROM State
    WHERE StateId = @StateId;

    
    INSERT INTO tb_task5 (Name, Mobile, Email, StateId, CityId, StateName, CityName, CreatedOn)
    VALUES (@Name, @Mobile, @Email, @StateId, @CityId, @StateName, @CityName, @CreatedOn);
END;

-------------------------------------------
INSERT INTO State (StateId, StateName) VALUES
(1, 'Telangana'),
(2, 'AP'),
(3, 'Kerala'),
(4, 'TN');

--------------------------------------------
INSERT INTO City (CityId, CityName, StateId) VALUES
(1, 'Hyderabad', 1),
(2, 'Warangal', 1),
(3, 'Nalgonda', 1),
(4, 'Khammam', 1),
(5, 'Amalapuram', 2),
(6, 'Vijayawada', 2),
(7, 'Guntur', 2),
(8, 'Rajahmundry', 2),
(9, 'Bapatla', 2),
(10, 'Visakhapatnam', 2),
(11, 'Kochi', 3),
(12, 'Kollam', 3),
(13, 'Kozhikode', 3),
(14, 'Thiruvananthapuram', 3),
(15, 'Chennai', 4),
(16, 'Coimbatore', 4),
(17, 'Madurai', 4),
(18, 'Tiruchirappalli', 4);
-----------------------------------
create PROCEDURE PageTask1
    @PageSize INT = 10,
    @PageNumber INT,
    @TotalCount INT OUT
AS
BEGIN
    SET NOCOUNT ON;
 IF @PageSize = 0 OR @PageSize IS NULL
    BEGIN
        SET @PageSize = 10;
    END
 DECLARE @Offset INT;
    SET @Offset = (@PageNumber - 1) * @PageSize;
 SELECT @TotalCount = COUNT(*)
    FROM  tb_task5
 SELECT *
    FROM tb_task5
    ORDER BY Name
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
declare @totalcount int
exec [dbo].[PageTask1]
@PageSize=10,@PageNumber=2,@totalcount=@totalcount output;
select @totalcount as totalcount;
----------------------------------------------
CREATE PROCEDURE PROC_CHECKBOX1
@StateName varchar(50)
as begin
select * from tb_task5 where statename=@statename
end
------------------------------------------------------
alter PROCEDURE UpdateTask
    @Id INT,
    @Name NVARCHAR(50),
    @Mobile NVARCHAR(20),
    @Email NVARCHAR(30),
	 @StateId NVARCHAR(50),
    @CityId NVARCHAR(50),
    @StateName NVARCHAR(100),
    @CityName NVARCHAR(100)
AS
BEGIN
    UPDATE tb_task5
    SET
        Name = @Name,
        Mobile = @Mobile,
        Email = @Email,
		CityId=@CityId,
		StateId=@StateId,
        StateName=@StateName,
        CityName=@CityName
    WHERE TaskId = @Id;
END
EXEC UpdateTask 
    @Id = 1,                
    @Name = 'alekhya',    
    @Mobile = '9874561230', 
    @Email = 'alex@example.com', 
    @StateName = 'AP', 
    @CityName = 'Bapatla'; 
	---------------------------------------------
alter procedure selecttask2(@id int)
as begin
select * from tb_task5 where(TaskId=@id)
end
exec selecttask2 1
----------------------------------------
create procedure selecttask1
as begin
select * from tb_task5
end
-----------------------------
CREATE PROCEDURE PROC_CHECKBOX5
    @StateName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT c.CityName
    FROM City c
    INNER JOIN State s ON c.StateId = s.StateId
    WHERE s.StateName = @StateName;
END;
------------------------
create procedure proc_delete(@id int)
as begin
delete from tb_task5 where TaskId=@id
END
--------------------------------------
alter PROCEDURE UpdateTask
    @Id INT,
    @Name NVARCHAR(50),
    @Mobile NVARCHAR(20),
    @Email NVARCHAR(30),
    @StateId NVARCHAR(50),
    @CityId NVARCHAR(50)
AS
BEGIN
    DECLARE @CityName NVARCHAR(100);
    DECLARE @StateName NVARCHAR(100);

    
    SELECT @CityName = CityName
    FROM City
    WHERE CityId = @CityId;

   
    SELECT @StateName = StateName
    FROM State
    WHERE StateId = @StateId;

  
    UPDATE tb_task5
    SET 
        Name = @Name,
        Mobile = @Mobile,
        Email = @Email,
        StateId = @StateId,
        CityId = @CityId,
        StateName = @StateName,
        CityName = @CityName
    WHERE TaskId = @Id;
END;
------------------------------------
CREATE PROCEDURE GetDetailsByCities
    @CityNames NVARCHAR(MAX) 
AS
BEGIN
    SELECT * 
    FROM tb_task5
    WHERE CityName IN (SELECT value FROM STRING_SPLIT(@CityNames, ','))
END
-------------execution--------------
DECLARE @CityNames NVARCHAR(MAX);
SET @CityNames = 'Guntur,Amalapuram,Madurai'; 

EXEC GetDetailsByCities @CityNames;

---------------------------------
alter PROCEDURE GetDetailsByStates
    @StateNames NVARCHAR(MAX) 
AS
BEGIN
    SELECT * 
    FROM tb_task5
    WHERE StateName IN (SELECT value FROM STRING_SPLIT(@StateNames, ','))
END
-----execution---------
DECLARE @StateNames NVARCHAR(MAX);
SET @StateNames = 'Telangana,AP'; 

EXEC  GetDetailsByStates @StateNames;
----------------------------
ALTER PROCEDURE PageTask
    @PageSize INT = 0,
    @PageNumber INT,
    @TotalCount INT OUT,
    @SearchTerm NVARCHAR(100) = NULL
	
	
AS
BEGIN
    SET NOCOUNT ON;

   
    IF @PageSize = 0 OR @PageSize IS NULL
    BEGIN
        SET @PageSize = 2;
    END

    DECLARE @Offset INT;
    SET @Offset = (@PageNumber - 1) * @PageSize;

    
    SELECT @TotalCount = COUNT(*)
    FROM tb_task5
    WHERE (@SearchTerm IS NULL OR Name LIKE '%' + @SearchTerm + '%');  

	

   
    SELECT  TaskId, 
        Name, 
        Mobile, 
        Email, 
        StateId, 
        CityId, 
        StateName, 
        CityName,
        CreatedOn
    FROM tb_task5
    WHERE (@SearchTerm IS NULL OR Name LIKE '%' + @SearchTerm + '%')  
    ORDER BY Name
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END

DECLARE @totalcount INT;
EXEC [dbo].[PageTask]
    @PageSize = 2,
    @PageNumber = 1,
    @TotalCount = @totalcount OUTPUT,
    @SearchTerm = 'acer'; 

SELECT @totalcount AS totalcount;
--alter PROCEDURE PageTask
--    @PageSize INT = 10,
--    @PageNumber INT,
--    @TotalCount INT OUT,
--    @CityNames NVARCHAR(MAX) = NULL,
--    @SearchTerm NVARCHAR(100) = NULL
--AS
--BEGIN
--    SET NOCOUNT ON;

--    IF @PageSize = 0 OR @PageSize IS NULL
--    BEGIN
--        SET @PageSize = 10; 
--    END

--    DECLARE @Offset INT;
--    SET @Offset = (@PageNumber - 1) * @PageSize;

    
--    SELECT @TotalCount = COUNT(*)
--    FROM tb_task5
--    WHERE (@SearchTerm IS NULL OR Name LIKE '%' + @SearchTerm + '%')
--      AND (@CityNames IS NULL OR CityName IN (SELECT value FROM STRING_SPLIT(@CityNames, ',')));

    
--    SELECT TaskId, 
--        Name, 
--        Mobile, 
--        Email, 
--        StateId, 
--        CityId, 
--        StateName, 
--        CityName,
--        CreatedOn
--    FROM tb_task5
--    WHERE (@SearchTerm IS NULL OR Name LIKE '%' + @SearchTerm + '%')
--      AND (@CityNames IS NULL OR CityName IN (SELECT value FROM STRING_SPLIT(@CityNames, ',')))
--    ORDER BY Name
--    OFFSET @Offset ROWS
--    FETCH NEXT @PageSize ROWS ONLY;
--END
ALTER PROCEDURE PageTask
    @PageSize INT = 10,
    @PageNumber INT,
    @TotalCount INT OUT,
    @CityNames NVARCHAR(MAX) = NULL,
    @SearchTerm NVARCHAR(100) = NULL,
    @StartDate DATETIME = NULL,
    @EndDate DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;

  
    IF @PageSize = 0 OR @PageSize IS NULL
    BEGIN
        SET @PageSize = 10; 
    END

    
    DECLARE @Offset INT;
    SET @Offset = (@PageNumber - 1) * @PageSize;

   
    SELECT @TotalCount = COUNT(*)
    FROM tb_task5
    WHERE (@SearchTerm IS NULL OR Name LIKE '%' + @SearchTerm + '%')
      AND (@CityNames IS NULL OR CityName IN (SELECT value FROM STRING_SPLIT(@CityNames, ',')))
      AND (@StartDate IS NULL OR CreatedOn >= @StartDate)
      AND (@EndDate IS NULL OR CreatedOn <= @EndDate);

   
    SELECT TaskId, 
        Name, 
        Mobile, 
        Email, 
        StateId, 
        CityId, 
        StateName, 
        CityName,
        CreatedOn
    FROM tb_task5
    WHERE (@SearchTerm IS NULL OR Name LIKE '%' + @SearchTerm + '%')
      AND (@CityNames IS NULL OR CityName IN (SELECT value FROM STRING_SPLIT(@CityNames, ',')))
      AND (@StartDate IS NULL OR CreatedOn >= @StartDate)
      AND (@EndDate IS NULL OR CreatedOn <= @EndDate)
    ORDER BY Name
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;

ALTER PROCEDURE GetDetailsByStates
    @StateNames NVARCHAR(MAX),
    @CityNames NVARCHAR(MAX) = NULL
AS
BEGIN
    SELECT * 
    FROM tb_task5
    WHERE StateName IN (SELECT value FROM STRING_SPLIT(@StateNames, ','))
    AND (@CityNames IS NULL OR CityName IN (SELECT value FROM STRING_SPLIT(@CityNames, ',')))
END
EXEC GetDetailsByStates @StateNames = 'Telangana,AP'
DECLARE @TotalCount INT;

EXEC PageTask
    @PageSize = 10,
    @PageNumber = 2,
    @TotalCount = @TotalCount OUTPUT,
    @CityNames = 'Guntur,Amalapuram,Madurai,Visakhapatnam,Kochi,Kollam,Kozhikode,Thiruvananthapuram,Warangal,Hyderabad,Rajahmundry,Guntur,Thiruvananthapuram,Coimbatore,Chennai,Khammam',
	@SearchTerm='acer'


  
	SELECT @totalcount AS totalcount;
	use db1

	-- Step 1: Drop existing default constraint (if any)
IF EXISTS (
    SELECT * FROM sys.default_constraints
    WHERE parent_object_id = OBJECT_ID('tb_task5')
    AND parent_column_id = (
        SELECT column_id FROM sys.columns
        WHERE object_id = OBJECT_ID('tb_task5')
        AND name = 'CreatedOn'
    )
)
BEGIN
    -- Get the name of the default constraint
    DECLARE @constraint_name NVARCHAR(128);
    SELECT @constraint_name = name
    FROM sys.default_constraints
    WHERE parent_object_id = OBJECT_ID('tb_task5')
    AND parent_column_id = (
        SELECT column_id FROM sys.columns
        WHERE object_id = OBJECT_ID('tb_task5')
        AND name = 'CreatedOn'
    );
    
    -- Drop the existing default constraint
    EXEC('ALTER TABLE tb_task5 DROP CONSTRAINT ' + @constraint_name);
END

-- Step 2: Alter the column data type to DATE
ALTER TABLE tb_task5
ALTER COLUMN CreatedOn DATE;

-- Step 3: Add a new default constraint for the DATE type
ALTER TABLE tb_task5
ADD CONSTRAINT DF_tb_task5_CreatedOn DEFAULT CONVERT(DATE, GETDATE()) FOR CreatedOn;
select * from tb_task5
insert into tb_task5 values



	


