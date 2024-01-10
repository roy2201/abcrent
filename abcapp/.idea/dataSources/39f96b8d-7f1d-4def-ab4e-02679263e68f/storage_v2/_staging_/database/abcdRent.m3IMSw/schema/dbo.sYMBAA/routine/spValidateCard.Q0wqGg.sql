ALTER PROCEDURE spValidateCard
	@CID		INT,
	@HolderName	VARCHAR(256),
	@CardNumber	VARCHAR(16),
	@CVV		VARCHAR(3),
	@ExpDate	DATE,
	@IsValid	BIT		OUTPUT

AS
BEGIN

	SELECT @IsValid = IIF(EXISTS(SELECT 1
                                 FROM VISACARD
                                 WHERE CARDHOLDERNAME = @HolderName
                                   AND CARDNUMBER = @CardNumber
                                   AND CVV = @CVV
                                   AND EXPIRATIONDATE = @ExpDate
                                   AND CUSTOMERID = @CID), 1, 0)

END
go

