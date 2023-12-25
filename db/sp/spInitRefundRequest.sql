
ALTER PROCEDURE spInitRefundRequest
	@RentID			INT,
	@UserID			INT,
	@Reason			VARCHAR(512),
	@Email			VARCHAR(256),
	@CardNumber		VARCHAR(16),
	@ErrorCode		INT
AS
BEGIN
	
	SET NOCOUNT ON
	
	--CHECK IF RENT ID IS VALID
	IF NOT EXISTS (SELECT 1 FROM CARRENTAL WHERE RENTALID = @RentID)
	BEGIN
		SET @ErrorCode = 1
		RETURN ;
	END

	--CHECK IF REFUND ALREADY INITAITED FOR GIVEN RENT ID
	IF EXISTS (SELECT 1 FROM REFUNDREQUESTS WHERE RENTALID = @RentID)
	BEGIN
		SET @ErrorCode = 2
		RETURN ;
	END

	--CHECK IF CARD NUMBER IS VALID FOR THE GIVEN USER
	IF ((SELECT DBO.fnCardExistForUserId(@UserID, @CardNumber)) = 0)
	BEGIN
		SET @ErrorCode = 3
		RETURN ;
	END

	INSERT INTO REFUNDREQUESTS
	VALUES (@RentID, GETDATE(), NULL, @Reason, 'PENDING', 'NOT REFUNDED')

	SET @ErrorCode = 0 --SUCCESS

END