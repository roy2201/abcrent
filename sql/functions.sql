/*Views*/

CREATE FUNCTION [dbo].[fnCalculateTotalPayment] (
    @CarId INT,
    @NumDays INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @DailyRate FLOAT;
    DECLARE @TotalAmount FLOAT;
    
	SELECT @DailyRate = PRICEPERDAY
    FROM vwCarInfoWithPrice
    WHERE [Car ID] = @CarId;
    
	SET @TotalAmount = @DailyRate * @NumDays;
    RETURN @TotalAmount;
END
GO

CREATE function [dbo].[fnCardExistForUserId] (
    @cid int,
    @cardNumber varchar(16))
returns bit
as
begin
    declare @haveCard bit
    select @haveCard = Case
                            when exists (   select 1
                                              from VISACARD
                                             where CUSTOMERID = @cid
                                               and CardNumber = @cardNumber) then 1
                            else 0 end
    return @haveCard
end
GO

CREATE FUNCTION [dbo].[fnCheckBalance] (@CardNumber VARCHAR(16))
RETURNS BIT
AS
BEGIN
    DECLARE @IsEnoughBalance BIT;

    SELECT @IsEnoughBalance = CASE
                                   WHEN Balance >= 0 THEN 1
                                   ELSE 0 END
      FROM VISACARD
     WHERE CardNumber = @CardNumber;

    RETURN @IsEnoughBalance;
END;
GO

CREATE FUNCTION [dbo].[fnCheckPrem] (@CustomerID INT)
RETURNS BIT
AS
BEGIN
    DECLARE @isPremium BIT

    SELECT @isPremium = CASE
                             WHEN EXISTS (SELECT 1 FROM SUBSCRIPTION WHERE CUSTOMERID = @CustomerID) THEN 1
                             ELSE 0 END

    RETURN @isPremium
END
GO

CREATE FUNCTION [dbo].[fnIsCarAvailable] (@CarID INT)
RETURNS BIT
AS
BEGIN
    DECLARE @available BIT;

    SELECT TOP 1 @available = isRented
      FROM CAR
     WHERE CARID = @CarID;

    RETURN COALESCE(@available, 0);
END;
GO


CREATE function [dbo].[fnReturnedBeforeExp] (
	@RentID		int
	)
RETURNS BIT
As
Begin

	if exists (select 1
			   from CARRENTAL
			   where RENTENDDATE > RETURNEDDATE
			   and ISRETURNED = 1
			   and RENTALID = @RentID )
			   begin
					RETURN 0
			   end
	RETURN 1
End
GO

CREATE FUNCTION [dbo].[fnTotalWithPrem] (
    @CarId INT,
    @NumDays INT,
    @UserID INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @DailyRate FLOAT;
    DECLARE @TotalAmount FLOAT;
    DECLARE @IsPremium BIT;

    SET @IsPremium = dbo.fnCheckPrem(@UserID);

    SELECT @DailyRate = PRICEPERDAY
      FROM vwCarInfoWithPrice
     WHERE [Car ID] = @CarId;

    IF @IsPremium = 1
    BEGIN
        SET @DailyRate = @DailyRate * 0.85; -- Apply a 15% discount
    END

    SET @TotalAmount = @DailyRate * @NumDays;

    RETURN @TotalAmount;
END
GO

CREATE FUNCTION [dbo].[IsValidViscardDate] (@inputDate DATE)
RETURNS BIT
AS
BEGIN
    DECLARE @isValid BIT;

    SET @isValid = CASE
                        WHEN @inputDate IS NULL THEN 0 -- Invalid: Date is NULL
                        WHEN TRY_CAST(@inputDate AS DATE) IS NULL THEN 0 -- Invalid: Not a valid date
                        ELSE 1 -- Valid
                   END;

    RETURN @isValid;
END;
GO


CREATE function [dbo].[fnLoadTables] ( @dbname varchar(30) )
returns table
return
	select [name]
	from sysobjects 
	where type = 'U'
GO
