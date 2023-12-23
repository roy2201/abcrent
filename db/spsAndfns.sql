USE [abcdRent]
GO
/****** Object:  UserDefinedFunction [dbo].[fnCalculateTotalPayment]    Script Date: 12/23/2023 11:23:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fnCalculateTotalPayment]
(
    @CarId		INT,
    @NumDays	INT
)
RETURNS FLOAT
AS
BEGIN
    DECLARE @DailyRate   FLOAT;
    DECLARE @TotalAmount FLOAT;

    SELECT @DailyRate = PRICEPERDAY
    FROM   vwCarInfoWithPrice
    WHERE  CARID = @CarId;

    SET @TotalAmount = @DailyRate * @NumDays;

    RETURN @TotalAmount;
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnCardExistForUserId]    Script Date: 12/23/2023 11:23:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[fnCardExistForUserId]
(
	@cid		int,
	@cardNumber	varchar(16)
)
returns bit
as
begin
	declare @haveCard bit

	select @haveCard = Case when exists (
			select 1
			from VISACARD
			where CUSTOMERID = @cid and CardNumber = @cardNumber
			) then 1 else 0 end

	return @haveCard
end
GO
/****** Object:  UserDefinedFunction [dbo].[fnCheckBalance]    Script Date: 12/23/2023 11:23:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fnCheckBalance] 
(
@CardNumber VARCHAR(16)
)
RETURNS BIT
AS
BEGIN
    DECLARE @IsEnoughBalance BIT;

    SELECT @IsEnoughBalance = 
        CASE 
            WHEN Balance >= 0 THEN 1
            ELSE 0
        END
    FROM VISACARD
    WHERE CardNumber = @CardNumber;

    RETURN @IsEnoughBalance;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[fnCheckPrem]    Script Date: 12/23/2023 11:23:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fnCheckPrem]
(
    @CustomerID INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @isPremium BIT

    SELECT @isPremium = CASE WHEN EXISTS (
            SELECT 1
            FROM SUBSCRIPTION
            WHERE CUSTOMERID = @CustomerID
        ) THEN 1 ELSE 0 END

    RETURN @isPremium
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnIsCarAvailable]    Script Date: 12/23/2023 11:23:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fnIsCarAvailable]
(
    @CarID INT
)
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
/****** Object:  UserDefinedFunction [dbo].[fnTotalWithPrem]    Script Date: 12/23/2023 11:23:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fnTotalWithPrem]
(
    @CarId		INT,
    @NumDays	INT,
    @UserID		INT
)
RETURNS FLOAT
AS
BEGIN
    DECLARE @DailyRate	 FLOAT;
    DECLARE @TotalAmount FLOAT;
    DECLARE @IsPremium   BIT;

    SET @IsPremium = dbo.fnCheckPrem(@UserID);

    SELECT @DailyRate = PRICEPERDAY
    FROM   vwCarInfoWithPrice
    WHERE  CARID = @CarId;

    IF @IsPremium = 1
    BEGIN
        SET @DailyRate = @DailyRate * 0.85; -- Apply a 15% discount
    END

    SET @TotalAmount = @DailyRate * @NumDays;

    RETURN @TotalAmount;
END
GO
/****** Object:  View [dbo].[vwCarInfoWithPrice]    Script Date: 12/23/2023 11:23:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER view [dbo].[vwCarInfoWithPrice]
as
	select c.CARID, COLOR, MANUFACTURER, MODEL, [TYPE], PRICEPERDAY
	from CAR as c
	INNER JOIN 
	CARPRICING as cp On c.CARID = cp.CARID
GO
/****** Object:  StoredProcedure [dbo].[spAddVisa]    Script Date: 12/23/2023 11:23:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP PROC DBO.SPADDVISA
GO
CREATE PROCEDURE [dbo].[spAddVisa]
    @cid			INT,
    @cardHoldreName VARCHAR(256),
    @expDate		DATE,
    @CVV			VARCHAR(3),
    @cardNumber		VARCHAR(5)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM CUSTOMER WHERE CUSTOMERID = @cid)
    BEGIN
        PRINT 'CUSTOMER DOES NOT EXIST'
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO VISACARD (CUSTOMERID, CardHolderName, CVV, EXPIRATIONDATE, BALANCE, CARDNUMBER)
        VALUES (@cid, @cardHoldreName, @CVV, @expDate, 1000, @cardNumber);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
		PRINT 'ERROR DURING INSERT'
    END CATCH;
END;
GO
/****** Object:  StoredProcedure [dbo].[spLoadManufacturer]    Script Date: 12/23/2023 11:23:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spLoadManufacturer]
AS
BEGIN
    SELECT DISTINCT MANUFACTURER
    FROM CAR;
END
GO
/****** Object:  StoredProcedure [dbo].[spLoadTypes]    Script Date: 12/23/2023 11:23:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spLoadTypes]
AS
BEGIN
    SELECT DISTINCT [TYPE]
    FROM CAR
END
GO
/****** Object:  StoredProcedure [dbo].[spRentCar]    Script Date: 12/23/2023 11:23:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRentCar]
    @CustID         INT,
    @CarID          INT,
    @NbDays         INT,
    @CardNumber     VARCHAR(16),
    @ErrorCode      INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Total       FLOAT,
            @HaveCard    BIT,
            @HaveEnough  BIT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Check if the customer card exists
        --SET @HaveCard = (SELECT DBO.fnCardExistForUserId(@CustID, @CardNumber));

        IF (@HaveCard = 1)
        BEGIN
            PRINT 'CUSTOMER CARD IS VALID';

            -- Calculate the total with premium
            --SET @Total = (SELECT DBO.fnTotalWithPrem(@CarID, @NbDays, @CustID));

            -- Check if the customer has enough balance
            --SET @HaveEnough = (SELECT DBO.fnCheckBalance(@CardNumber));

            IF (@HaveEnough = 1)
            BEGIN
                PRINT 'CUSTOMER HAS ENOUGH BALANCE TO COMPLETE TRANSACTION';

                -- Update the balance in the VISACARD table
                UPDATE VISACARD
                SET BALANCE = BALANCE - @Total
                WHERE CardNumber = @CardNumber;
				INSERT INTO CARRENTAL
				VALUES (@CustID, @CarID, 0, GETDATE(), DATEADD(DAY, 7, GETDATE()), 0, @Total)
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
GO
/****** Object:  StoredProcedure [dbo].[spSignIn]    Script Date: 12/23/2023 11:23:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spSignIn]
    @Email      VARCHAR(256),
    @Password   VARCHAR(256),
    @ErrorCode  INT OUTPUT,
    @UserId     INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the email exists
    IF EXISTS (SELECT 1 FROM CUSTOMER WHERE EMAIL = @Email)
    BEGIN

        DECLARE @HashedPassword VARCHAR(256);
        SELECT @HashedPassword = [PASSWORDHASH] FROM CUSTOMER WHERE EMAIL = @Email;

        -- Check if the hashed password matches
        IF @HashedPassword = CONVERT(VARCHAR(256), HASHBYTES('SHA2_256', @Password), 2)
        BEGIN
            -- Password is correct, sign in successful
            SET @ErrorCode = 0;
            PRINT 'ErrorCode : ' + CAST(@ErrorCode AS VARCHAR(1));
            PRINT 'Sign in successful for ' + @Email;

            -- Return userId, for Java metadata
            SET @UserId = (SELECT DISTINCT CUSTOMERID FROM CUSTOMER WHERE EMAIL = @Email);

            -- Set ISLOGGED = 1 in the CUSTOMER table
            UPDATE CUSTOMER
            SET ISLOGGED = 1
            WHERE EMAIL = @Email;
        END
        ELSE
        BEGIN
            -- Password does not match
            SET @ErrorCode = 2;
            PRINT 'ErrorCode : ' + CAST(@ErrorCode AS VARCHAR(1));
            PRINT 'Incorrect password. Sign in failed.';
        END
    END
    ELSE
    BEGIN
        -- Email does not exist
        SET @ErrorCode = 1;
        PRINT 'ErrorCode : ' + CAST(@ErrorCode AS VARCHAR(1));
        PRINT 'Email not found. Sign in failed.';
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[spSignOut]    Script Date: 12/23/2023 11:23:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spSignOut]
    @CustomerId INT
AS
BEGIN
    UPDATE CUSTOMER
    SET ISLOGGED = 0
    WHERE CUSTOMERID = @CustomerId;
END;
GO
/****** Object:  StoredProcedure [dbo].[spSignUp]    Script Date: 12/23/2023 11:23:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spSignUp]
    @FirstName	VARCHAR(256),
    @LastName	VARCHAR(256),
    @Age		INT,
    @Address	VARCHAR(256),
    @Email		VARCHAR(256),
    @Password	VARCHAR(256),
    @ErrorCode	INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Check if the email already exists
        IF NOT EXISTS (SELECT 1 FROM CUSTOMER WHERE EMAIL = @Email)
        BEGIN
            DECLARE @HashedPassword VARCHAR(256);
            SET @HashedPassword = CONVERT(VARCHAR(256), HASHBYTES('SHA2_256', @Password), 2);
            -- PRINT 'Hashed password is: ' + @HashedPassword;

            -- Insert new customer
            INSERT INTO CUSTOMER (FIRSTNAME, LASTNAME, AGE, [ADDRESS], EMAIL, [PASSWORDHASH], ISLOGGED)
            VALUES (@FirstName, @LastName, @Age, @Address, @Email, @HashedPassword, 0);

            SET @ErrorCode = 0;
            -- PRINT 'ErrorCode : ' + CAST(@ErrorCode AS VARCHAR(1));
            PRINT 'Sign up successful for ' + @FirstName + ' ' + @LastName;
        END
        ELSE
        BEGIN
            -- Email already exists, handle accordingly (e.g., raise an error or set an output parameter)
            SET @ErrorCode = 1;
            -- PRINT 'ErrorCode : ' + CAST(@ErrorCode AS VARCHAR(1));
            PRINT 'Email already exists. Sign up failed.';
        END
    END TRY
    BEGIN CATCH
        -- Handle the error (you can log or raise an error as needed)
        SET @ErrorCode = 2;
        -- PRINT 'ErrorCode : ' + CAST(@ErrorCode AS VARCHAR(1));
        PRINT 'Error during sign up: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[spViewMatches]    Script Date: 12/23/2023 11:23:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spViewMatches]
	@type VARCHAR(256),
	@make VARCHAR(256)
AS
BEGIN
    IF @type = 'any' AND @make = 'any'
    BEGIN
        SELECT *
        FROM vwCarInfoWithPrice
    END
    ELSE IF @type = 'any'
    BEGIN
        SELECT *
        FROM vwCarInfoWithPrice
        WHERE MANUFACTURER = @make
    END
    ELSE IF @make = 'any'
    BEGIN
        SELECT *
        FROM vwCarInfoWithPrice
        WHERE [TYPE] = @type
    END
    ELSE
    BEGIN
        SELECT *
        FROM vwCarInfoWithPrice
        WHERE [TYPE] = @type AND MANUFACTURER = @make
    END
END
GO
