ALTER PROCEDURE [dbo].[spRefund]
	@RequestID		INT,
	@Percentage		INT,
	@ErrorCode		INT	OUTPUT
AS
BEGIN
		
		IF EXISTS ( SELECT 1 FROM REFUNDREQUESTS WHERE REQUESTID = @RequestID AND [STATUS] = 'ACCEPTED' )
		BEGIN
			SET @ErrorCode = 1 --ALREADY REFUNDED
			RETURN ;
		END

		IF @Percentage >= 100 OR @Percentage <= 10
		BEGIN
			SET @ErrorCode = 2 -- PERCENTAGE RESTRICTION
			RETURN ;
		END

		DECLARE @RentID INT
		SET @RentID = (SELECT RENTALID FROM REFUNDREQUESTS WHERE REQUESTID = @RequestID)
		print 'rent id ' + cast(@rentID as varchar(5))

		DECLARE @TOTAL DECIMAL(18,2)
		SET @Total = (SELECT AMOUNT FROM CARRENTAL WHERE RENTALID = @RentID)
		print 'total ' + cast(@total as varchar(40))

		DECLARE @CardID INT
		SET @CardID= (SELECT CARDID FROM CARRENTAL WHERE RENTALID = @RentID)
		print 'card id  ' + cast(@cardid as varchar(5))

		DECLARE @CardNumber VARCHAR(16)
		SET @CardNumber = (SELECT CARDNUMBER FROM VISACARD WHERE CARDID = @CardID)
		print 'card ' + cast(@cardnumber as varchar(5))

		UPDATE REFUNDREQUESTS
		SET [STATUS]     = 'ACCEPTED',
			RESOLUTION   = 'REFUNDED',
			ACCEPTEDDATE = GETDATE()
		WHERE REQUESTID  = @RequestID and RENTALID = @RentID


		-- ADD AMOUNT REFUNDED COLUMN IN TABLE REFUND REQUESTS OR PERCENTAGE

		DECLARE @RefundedAmount DECIMAL(18,2)
		SET @RefundedAmount = @TOTAL * (CAST(@Percentage AS DECIMAL(18,2))/100)
		print 'refunded : ' + cast(@refundedamount as varchar(40))


		UPDATE VISACARD
		SET BALANCE = BALANCE + @RefundedAmount
		WHERE CARDNUMBER = @CardNumber

		SET @ErrorCode = 0 --SUCCESS
		print 'error code : ' + cast(@errorcode as varchar(5))

END
go

