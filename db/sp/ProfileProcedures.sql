ALTER PROCEDURE spViewMyRents
	@CID		INT
AS
BEGIN
	SELECT  RENTALID	  AS [My Rent ID],
			RENTSTARTDATE AS [Start Date],
			RENTENDDATE   AS [End Date],
			AMOUNT        AS [Payed Amount]
	FROM CARRENTAL CR
	INNER JOIN CUSTOMER C
	ON CR.CUSTOMERID = C.CUSTOMERID
	WHERE CR.CUSTOMERID = @CID
END

GO
/*==================================================*/

ALTER PROCEDURE spViewMyRequests
	@CID		INT
AS
BEGIN
	
	SELECT  REQUESTDATE	AS	[My Request ID],
			RR.RENTALID AS  [My Rent ID],
			CR.CARID    AS  [Car ID],
			[STATUS]	AS  [Request Status],
			RESOLUTION  AS  [Resolution]
	FROM REFUNDREQUESTS RR
	INNER JOIN CARRENTAL CR
	ON RR.RENTALID = CR.RENTALID
	WHERE CR.CUSTOMERID = @CID

END

GO

/*==================================================*/

ALTER PROCEDURE spViewMyCards
	@CID		INT
AS
BEGIN
	SELECT  CARDHOLDERNAME AS [Holder Name],
			CARDNUMBER     AS [Card Number],
			CVV			   AS [CVV],
			EXPIRATIONDATE AS [Expiration Date],
			BALANCE		   AS [Balance]
	FROM VISACARD
	WHERE CUSTOMERID = @CID
END

GO
/*==================================================*/

ALTER PROCEDURE spChangePassword
	@NewPassword		VARCHAR(256),
	@CID				INT,
	@ErrorCode			INT		OUTPUT
AS
BEGIN
	
	SET NOCOUNT ON

	BEGIN TRY

		--CHECK IF THE USER EXISTS
		IF EXISTS (SELECT 1 FROM CUSTOMER WHERE CUSTOMERID = @CID)
		BEGIN

			DECLARE @HashedPassword	VARCHAR(256);
			SET @HashedPassword = CONVERT(VARCHAR(256), HASHBYTES('SHA2_256', @NewPassword), 2);

			UPDATE CUSTOMER
			SET PASSWORDHASH = @HashedPassword
			WHERE CUSTOMERID = @CID

			SET @ErrorCode = 0 --SUCCESS
		END
		ELSE
		BEGIN

			SET @ErrorCode = 1 --FAIL
			PRINT 'User with UserID ' + CAST(@CID AS VARCHAR(10)) + ' does not exist. Password change failed.';
		END
	END TRY
	BEGIN CATCH

		SET @ErrorCode = 2
		PRINT 'Error during password change: ' + ERROR_MESSAGE();
    END CATCH
END

GO
/*====================================================*/

CREATE PROCEDURE spSubscribe
	@CID			INT
AS
BEGIN

	DECLARE @Today		DATE,
			@EndDate	DATE

	SET @Today   = GETDATE()
	SET @EndDate = DATEADD(DAY, 3, @Today)

	INSERT INTO SUBSCRIPTION
	VALUES
	(@CID, @Today, @EndDate, 0)

END
 
GO
/*======================================================*/

ALTER PROCEDURE spUpdateExpiredSubscriptions
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE SUBSCRIPTION
    SET EXPIRED = 1
    WHERE DATEDIFF(DAY, STATDATE, ENDDATE) = 3
    AND ENDDATE >= GETDATE();
END;

GO
/*======================================================*/

CREATE PROCEDURE spValidateCard
	@CID		INT,
	@HolderName	VARCHAR(256),
	@CardNumber	VARCHAR(16),
	@CVV		VARCHAR(3),
	@ExpDate	DATE,
	@IsValid	BIT		OUTPUT

AS
BEGIN

	SELECT @IsValid = CASE WHEN EXISTS(
	SELECT 1 
	FROM VISACARD
	WHERE CARDHOLDERNAME = @HolderName
	AND CARDNUMBER = @CardNumber
	AND CVV = @CVV
	AND EXPIRATIONDATE = @ExpDate
	AND CUSTOMERID = @CID) THEN 1 ELSE 0 END

END
/*======================================================*/