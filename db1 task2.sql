
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
      and (@CityNames IS NULL OR CityName IN (SELECT value FROM STRING_SPLIT(@CityNames, ',')))
      and (@StartDate IS NULL OR CreatedOn >= @StartDate)
      and (@EndDate IS NULL OR CreatedOn <= @EndDate);

   
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
      and (@CityNames IS NULL OR CityName IN (SELECT value FROM STRING_SPLIT(@CityNames, ',')))
      and (@StartDate IS NULL OR CreatedOn >= @StartDate)
      AND (@EndDate IS NULL OR CreatedOn <= @EndDate)
    ORDER BY Name
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END; 
EXEC GetDetailsByStates @StateNames = 'Telangana,AP'
DECLARE @TotalCount INT;

EXEC PageTask
    @PageSize = 10,
    @PageNumber = 2,
    @TotalCount = @TotalCount OUTPUT,
    @CityNames = 'Guntur,Amalapuram,Madurai,Visakhapatnam,Kochi,Kollam,Kozhikode,Thiruvananthapuram,Warangal,Hyderabad,Rajahmundry,Guntur,Thiruvananthapuram,Coimbatore,Chennai,Khammam',
	@SearchTerm='acer'




	SELECT @Totalcount AS totalcount;
	  SELECT * FROM TB_TASK5

	insert into tb_task5 values
	('yash','9915505079','yash@gmail.com',4,16,'TN','Coimbatore','2023-05-04')
	DECLARE @TotalCount INT;

EXEC PageTask
    @PageSize = 10,
    @PageNumber = 2,
    @TotalCount = @TotalCount OUTPUT,
    @CityNames = 'Coimbatore', 
    @SearchTerm = 'yash',
    @StartDate = '2023-05-04', 
    @EndDate = '2024-08-29'; 


SELECT @TotalCount AS TotalCount;
--'kollam,kozhikode,Coimbatore,Vijayawada',
DECLARE @TotalCount INT;

EXEC PageTask
    @PageSize = 10,
    @PageNumber = 2,
    @TotalCount = @TotalCount OUTPUT,
	@CityNames = 'Khammam', 
    @SearchTerm = 'Alekhyav',
    @StartDate = '2024-08-30', 
    @EndDate = '2024-08-30'; 

SELECT @TotalCount AS TotalCount;
select * from tb_task5
