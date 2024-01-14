CREATE PROCEDURE [dbo].[spRentCar]
    @CustID		INT,
    @CarID		INT,
    @NbDays		INT,
    @CardNumber VARCHAR(16),
    @ErrorCode	INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Total      FLOAT,
            @HaveCard   BIT,
            @HaveEnough BIT,
            @CardID     INT,
            @IsRented   BIT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Check if the customer card exists
        set @HaveCard = (select DBO.fnCardExistForUserId(@CustID, @CardNumber));

        set @IsRented = (SELECT ISRENTED FROM CAR WHERE CARID = @CarID)

        if @IsRented = 1
            begin
                set @ErrorCode = 3
                rollback
            end

        IF (@HaveCard = 1)
        BEGIN
            PRINT 'CUSTOMER CARD IS VALID';

            -- Calculate the total with premium
            SET @Total = (SELECT DBO.fnTotalWithPrem(@CarID, @NbDays, @CustID));

            -- Check if the customer has enough balance
            SET @HaveEnough = (SELECT DBO.fnCheckBalance(@CardNumber));

            IF @HaveEnough = 1
            BEGIN
                PRINT 'CUSTOMER HAS ENOUGH BALANCE TO COMPLETE TRANSACTION';

				-- car is now rented
				UPDATE CAR
				SET ISRENTED = 1
				WHERE CARID = @CarID

                -- Update the balance in the VISACARD table
                UPDATE VISACARD
                   SET BALANCE = BALANCE - @Total
                 WHERE CardNumber = @CardNumber;

                SET @CardID = (SELECT CARDID FROM VISACARD WHERE CARDNUMBER = @CardNumber)

                INSERT INTO CARRENTAL
                VALUES (@CustID, @CarID, @CardID, GETDATE(), DATEADD(DAY, @NbDays, GETDATE()), 0, NULL, @Total)
            END
            ELSE
            BEGIN
                PRINT 'CUSTOMER DOES NOT HAVE ENOUGH BALANCE';
                SET @ErrorCode = 2;
                RETURN;
            END
        END
        ELSE
        BEGIN
            PRINT 'INVALID CARD FOR CUSTOMER';
            SET @ErrorCode = 1;
            RETURN;
        END

        COMMIT;
    END TRY
    BEGIN CATCH
        -- An error occurred, rollback the transaction
        IF @@TRANCOUNT > 0
            ROLLBACK;

        -- Handle the error 
        PRINT 'Error Occurred: ' + ERROR_MESSAGE();
        SET @ErrorCode = 99;
        RETURN;
    END CATCH;
END;
go

