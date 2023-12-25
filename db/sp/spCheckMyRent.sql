USE [abcdRent]
GO
/****** Object:  StoredProcedure [dbo].[spCheckMyRent]    Script Date: 12/24/2023 11:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spCheckMyRent]
	@UserID			INT,
	@RentID			INT,
	@DaysLeft		INT		OUTPUT,
	@Penalty		FLOAT	OUTPUT,
	@ErrorCode		INT		OUTPUT
AS
BEGIN

	SET NOCOUNT ON

	--CHECK IF RENT ID IF FOR USER ID
	IF NOT EXISTS (SELECT 1 FROM CARRENTAL WHERE CUSTOMERID = @UserID AND RENTALID = @RentID)
	BEGIN
		SET @ErrorCode = 1
		RETURN ;
	END

	--GET RENTAL INFORMATION
	DECLARE @StartDate		DATE,
			@EndDate		DATE
	DECLARE @PricePerDay	FLOAT

	--GET CAR PRICE
	SELECT @PricePerDay = vw.PricePerDay
	FROM CARRENTAL cr
	INNER JOIN vwCarInfoWithPrice vw ON cr.CARID = vw.CARID
	WHERE cr.RENTALID = @RentID;
	 
	--GET START DATE AND END DATE
	SELECT @StartDate = RENTSTARTDATE, @EndDate = RENTENDDATE
    FROM CARRENTAL cr
	Inner Join CUSTOMER c ON cr.CUSTOMERID = c.CUSTOMERID
	Inner Join CAR ca ON ca.CARID = cr.CARID
    WHERE cr.RENTALID = @RentID;

	DECLARE @Today		DATE = GETDATE();
    DECLARE @DaysRented INT  = DATEDIFF(DAY, @StartDate, @Today);
    DECLARE @TotalDays  INT  = DATEDIFF(DAY, @StartDate, @EndDate);

	IF @Today < @EndDate
	BEGIN
		SET @DaysLeft = @TotalDays - @DaysRented
		SET @Penalty = 0.0
		PRINT 'DAYS LEFT : ' + CAST(@DaysLeft AS VARCHAR(5))
	END
	ELSE --RENTAL IS OVERDUE
	BEGIN
		SET @DaysLeft = @DaysRented - @TotalDays
		SET @Penalty  = 0.25 * @PricePerDay * (@DaysRented - @TotalDays)
		PRINT 'OVERDUE BY : ' + CAST(@DaysLeft AS VARCHAR(5)) + 'DAYS'
		PRINT 'PENALTY : ' + CAST(@Penalty AS VARCHAR(5)) + ' USD'
	END

	SET @ErrorCode = 0 --SUCCESS

END