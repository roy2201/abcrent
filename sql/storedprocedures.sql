/*Stored Procedures*/

CREATE PROCEDURE [dbo].[spAddCar]
    @licensePlate varchar(20),
    @color        varchar(256),
    @make         varchar(256),
    @model        varchar(256),
    @type         varchar(256),
    @mileage      int
AS
    BEGIN

        INSERT INTO CAR
        VALUES
            (
                @licensePlate, @color, @make, @model, @type, @mileage, 0
            )

    END
GO

CREATE PROCEDURE [dbo].[spAddInsurance]
    @CARID                 INT,
    @INSURANCEPROVIDER     VARCHAR(256),
    @INSURANCEPOLICYNUMBER VARCHAR(20),
    @STARTINGDATE          DATE,
    @EXPIRYDATE            DATE
AS
    BEGIN
        INSERT INTO [dbo].[insurance]
            (
                [carid],
                [insuranceprovider],
                [insurancepolicynumber],
                [startingdate],
                [expirydate],
                [cost]
            )
        VALUES
            (
                @CARID, @INSURANCEPROVIDER, @INSURANCEPOLICYNUMBER, @STARTINGDATE, @EXPIRYDATE, 1000
            );
    END;
GO

CREATE PROCEDURE [dbo].[spAddRole]
    @rolename  VARCHAR(30),
    @ownername VARCHAR(30) = NULL
AS
    BEGIN
        DECLARE @exec_stmt VARCHAR(1000)

        IF @ownername IS NULL
            SELECT
                @ownername = USER_NAME()

        SET @exec_stmt = 'CREATE ROLE '
        SET @exec_stmt += QUOTENAME(@rolename, ']')
        SET @exec_stmt += ' AUTHORIZATION '
        SET @exec_stmt += QUOTENAME(@ownername, ']')

        PRINT @exec_stmt
        EXEC (@exec_stmt)
    END
GO

CREATE PROCEDURE [dbo].[spAddVisa]
    @cid            INT,
    @cardHoldreName VARCHAR(256),
    @expDate        DATE,
    @CVV            VARCHAR(3),
    @cardNumber     VARCHAR(5),
    @ErrorCode      INT OUTPUT
AS
    BEGIN
        IF NOT EXISTS
            (
                SELECT
                    1
                FROM
                    customer
                WHERE
                    customerid = @cid
            )
            --should add card to existing customer
            BEGIN
                PRINT 'CUSTOMER DOES NOT EXIST'

                SET @ErrorCode = 1

                RETURN;
            END

        IF Datediff(day, Getdate(), @EXPDATE) < 0 --exp date validation
            BEGIN
                SET @ErrorCode = 2

                PRINT 'INVALID EXPIRY DATE'

                RETURN;
            END

        INSERT INTO visacard
            (
                customerid,
                cardholdername,
                cvv,
                expirationdate,
                balance,
                cardnumber
            )
        VALUES
            (
                @cid, @cardHoldreName, @CVV, @expDate, 1000, @cardNumber
            );

        SET @ErrorCode = 0

        PRINT 'CARD ADDED'
    END;
GO

CREATE PROCEDURE [dbo].[spArrivedBetween]
    @date1 DATE,
    @date2 DATE
AS
    BEGIN
        -- Check if @date1 is greater than @date2, swap them if necessary
        IF @date1 > @date2
            BEGIN
                DECLARE @tempDate DATE;

                -- Swap @date1 and @date2
                SET @tempDate = @date1;
                SET @date1 = @date2;
                SET @date2 = @tempDate;
            END

        -- Select data based on the corrected date range
        SELECT
                *
        FROM
                vwRentsInfo as ri
        WHERE
                ri.[Returned Date]
        BETWEEN @date1 AND @date2;
    END;
GO


CREATE procedure [dbo].[spCarRevenue]
    @greaterthan float,
    @lessthan    float
as
    begin

        if @lessthan is null
            begin
                select
                    RI.*
                from
                    vwRentsInfo RI
                where
                    ri.[Car ID] in (
                                       select
                                           [Car ID]
                                       from
                                           vwRentsInfo as ri
                                       group by
                                           [Car ID]
                                       Having
                                           Sum(Amount) > @greaterthan
                                   )
            end
        else if @greaterthan is null
                 begin
                     select
                         RI.*
                     from
                         vwRentsInfo RI
                     where
                         [Car ID] in (
                                         select
                                             [Car ID]
                                         from
                                             vwRentsInfo
                                         group by
                                             [Car ID]
                                         Having
                                             Sum(Amount) < @lessthan
                                     )
                 end
        else
                 begin
                     select
                         RI.*
                     from
                         vwRentsInfo RI
                     where
                         [Car ID] in (
                                         select
                                             [Car ID]
                                         from
                                             vwRentsInfo
                                         group by
                                             [Car ID]
                                         Having
                                             Sum(Amount) > @greaterthan
                                             and Sum(Amount) < @lessthan
                                     )
                 end

    end
GO

CREATE PROCEDURE [dbo].[spChangePassword]
    @NewPassword VARCHAR(256),
    @CID         INT,
    @ErrorCode   INT OUTPUT
AS
    BEGIN

        SET NOCOUNT ON

        BEGIN TRY

            --CHECK IF THE USER EXISTS
            IF EXISTS
                (
                    SELECT
                        1
                    FROM
                        CUSTOMER
                    WHERE
                        CUSTOMERID = @CID
                )
                BEGIN

                    DECLARE @HashedPassword VARCHAR(256);
                    SET @HashedPassword = CONVERT(VARCHAR(256), HASHBYTES('SHA2_256', @NewPassword), 2);

                    UPDATE
                        CUSTOMER
                    SET
                        PASSWORDHASH = @HashedPassword
                    WHERE
                        CUSTOMERID = @CID

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

CREATE PROCEDURE [dbo].[spCheckMyRent]
    @UserID    INT,
    @RentID    INT,
    @DaysLeft  INT   OUTPUT,
    @Penalty   FLOAT OUTPUT,
    @ErrorCode INT   OUTPUT
AS
    BEGIN

        SET NOCOUNT ON

        --CHECK IF RENT ID IF FOR USER ID
        IF NOT EXISTS
            (
                SELECT
                    1
                FROM
                    CARRENTAL
                WHERE
                    CUSTOMERID = @UserID
                    AND RENTALID = @RentID
            )
            BEGIN
                SET @ErrorCode = 1
                RETURN;
            END

        IF dbo.fnReturnedBeforeExp(@RentID) = 1
            begin
                SET @ErrorCode = 4
                SET @DaysLeft = datediff(   day,
                                    (
                                        SELECT
                                            RETURNEDDATE
                                        FROM
                                            CARRENTAL
                                        WHERE
                                            RENTALID = @RENTID
                                    ),
                                    (
                                        SELECT
                                            RENTENDDATE
                                        FROM
                                            CARRENTAL
                                        WHERE
                                            RENTALID = @RENTID
                                    )
                                        )
                return;
            end

        --GET RENTAL INFORMATION
        DECLARE
            @StartDate DATE,
            @EndDate   DATE
        DECLARE @PricePerDay FLOAT

        --GET CAR PRICE
        SELECT
            @PricePerDay = vw.PricePerDay
        FROM
            CARRENTAL              cr
            INNER JOIN
                vwCarInfoWithPrice vw
                    ON cr.CARID = vw.[Car ID]
        WHERE
            cr.RENTALID = @RentID;

        --GET START DATE AND END DATE
        SELECT
            @StartDate = RENTSTARTDATE,
            @EndDate   = RENTENDDATE
        FROM
            CARRENTAL    cr
            Inner Join
                CUSTOMER c
                    ON cr.CUSTOMERID = c.CUSTOMERID
            Inner Join
                CAR      ca
                    ON ca.CARID = cr.CARID
        WHERE
            cr.RENTALID = @RentID;

        DECLARE @Today DATE = GETDATE();
        DECLARE @DaysRented INT = DATEDIFF(DAY, @StartDate, @Today);
        DECLARE @TotalDays INT = DATEDIFF(DAY, @StartDate, @EndDate);

        IF @Today < @EndDate
            BEGIN

                SET @DaysLeft = @TotalDays - @DaysRented
                SET @Penalty = 0.0
                PRINT 'DAYS LEFT : ' + CAST(@DaysLeft AS VARCHAR(5))
                SET @ErrorCode = 2
            END
        ELSE --RENTAL IS OVERDUE
            BEGIN
                SET @DaysLeft = @DaysRented - @TotalDays
                SET @Penalty = 0.25 * @PricePerDay * (@DaysRented - @TotalDays)
                PRINT 'OVERDUE BY : ' + CAST(@DaysLeft AS VARCHAR(5)) + 'DAYS'
                PRINT 'PENALTY : ' + CAST(@Penalty AS VARCHAR(5)) + ' USD'
                SET @ErrorCode = 3
            END

    END
GO

CREATE PROCEDURE [dbo].[spConfirmArrival]
    @carid      INT,
    @newMileage INT,
    @ErrorCode  INT OUTPUT
AS
    BEGIN

        IF EXISTS
            (
                SELECT
                    1
                FROM
                    CAR
                WHERE
                    CARID = @carid
                    AND ISRENTED = 1
            )
            BEGIN

                UPDATE
                    CAR
                SET
                    MILEAGE = MILEAGE + @newMileage
                WHERE
                    CARID = @carid

                UPDATE
                    CARRENTAL
                SET
                    RETURNEDDATE = GETDATE(),
                    ISRETURNED = 1
                WHERE
                    CARID = @carid

                UPDATE
                    CAR
                SET
                    ISRENTED = 0
                WHERE
                    CARID = @carid

                SET @ErrorCode = 0 --succes

            END
        ELSE
            BEGIN
                SET @ErrorCode = 1 --car not rented
            END
    END;
GO


CREATE proc [dbo].[spCreateLogin]
    @logname varchar(30),
    @logpass varchar(20) = NULL,    -- default is no password
    @defdb   varchar(30) = 'master' -- default db is master if not provided
as
    declare @exec_stmt varchar(1000)

    set @exec_stmt = '' --good practice
    set @exec_stmt += 'create login ' + quotename(@logname)

    if @logpass is null
        select
            @logpass = ''

    set @exec_stmt = @exec_stmt + ' with password = ' + quotename(@logpass, '''')
    set @exec_stmt = @exec_stmt + ' must_change '

    if @defdb is null
        set @defdb = 'master'
    else
        set @exec_stmt = @exec_stmt + ', default_database = ' + quotename(@defdb)

    set @exec_stmt = @exec_stmt + ' , check_expiration=on, check_policy=on'
    --for debugging
    print @exec_stmt
    exec (@exec_stmt)

    if @@error <> 0
        begin
            print 'some error occured'
            return (1)
        end
GO

CREATE proc [dbo].[spCreateUser]
    @logname sysname, --login name
    @uname   sysname  --user to add for login
as
    Declare @exec_stmt varchar(1000)

    set @exec_stmt = 'create user ' + quotename(@uname)
    set @exec_stmt += ' for login ' + quotename(@logname)

    print @exec_stmt
    exec (@exec_stmt) --execute before testing @@error macro
    if @@error <> 0
        begin
            print 'Some error occur'
            return (-1)
        end
    else
        print 'user ' + @uname + ' added to login ' + @logname
GO
/****** Object:  StoredProcedure [dbo].[spDeleteCar]    Script Date: 1/17/2024 11:00:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDeleteCar] @carid INT
AS
    BEGIN
        -- remove car in out
        DELETE FROM carinout
        WHERE
            carid = @carid

        -- remove car insurance
        DELETE FROM insurance
        WHERE
            carid = @carid

        -- remove car pricing
        DELETE FROM carpricing
        WHERE
            carid = @carid

        -- remove from rentals
        DELETE FROM carrental
        WHERE
            carid = @carid

        -- remove car from table car
        DELETE FROM car
        WHERE
            carid = @carid
    END

GO

CREATE proc [dbo].[spDeleteLogin] @logname varchar(30)
as
    declare @exec_stmt varchar(100)

    set @exec_stmt = ''
    set @exec_stmt = 'drop login '

    if @logname is not null
        set @exec_stmt = @exec_stmt + quotename(@logname)

    print (@exec_stmt)
    exec (@exec_stmt)
    if @@error <> 0
        begin
            print 'Failed Deleting Login'
            return (-1)
        end
    else
        begin
            print 'Login deleted'
        end
GO

CREATE proc [dbo].[spDeleteUser] @uname sysname
as
    Declare @exec_stmt varchar(1000)

    set @exec_stmt = 'Drop User if exists ' + @uname
    print @exec_stmt
    exec (@exec_stmt)

    if @@error <> 0
        begin
            print 'Some error occur'
            return (-2)
        end
    else
        print 'user ' + @uname + ' dropped'
GO

CREATE proc [dbo].[spGetTableNames] @dbname varchar(30)
as
    declare @exec_stmt varchar(1000)

    set @exec_stmt = ''
    set @exec_stmt
        = @exec_stmt + 'select name from ' + quotename(@dbname) + '.sys.objects where type = ' + quotename('U', '''')
    print @exec_stmt
    exec (@exec_stmt)
    if @@error <> 0
        print 'some error occur'
GO

CREATE proc [dbo].[spGiveRole]
    @logname sysname,
    @role    varchar(30),
    @type    char         = 'U',
    @out     varchar(100) output --for debugging
as
    declare @exec_stmt varchar(1000)
    set @exec_stmt = 'alter '

    if (@type = 'S')
        set @exec_stmt += 'server '
    set @exec_stmt += 'role ' + quotename(@role) + ' add member ' + quotename(@logname)

    print @exec_stmt --for debugging
    exec (@exec_stmt)
    if @@error <> 0
        begin
            print 'Failed---'
            return (-1)
        end
    else
        begin
            print 'Success+++'
            set @out = @exec_stmt
        end
GO


/*
sp in:  logname (could be user or role name)
		tablename
		insert bit, update bit, delete bit, {grand | revoke} bit
sp do: control role / user permission on tablename
*/
CREATE proc [dbo].[spGrantTables]
    @logname   varchar(30),
    @tablename varchar(30),
    @i         bit,
    @u         bit,
    @d         bit,
    @q         varchar(100) output,
    @g         bit          = 1
as
    Declare
        @exec_stmt varchar(1000),
        @prev      bit

    if @g = 1
        set @exec_stmt = 'grant '
    else
        set @exec_stmt = 'revoke '

    if @i = 1
        begin
            set @exec_stmt += 'insert '
            set @prev = 1
        end
    if @u = 1
        begin
            if @prev = 1
                set @exec_stmt += ', '
            set @exec_stmt += 'update '
            set @prev = 1
        end
    if @d = 1
        begin
            if @prev = 1
                set @exec_stmt += ', '
            set @exec_stmt += 'delete '
        end
    set @exec_stmt += 'on ' + quotename(@tablename)
    set @exec_stmt += ' to ' + quotename(@logname)
    print @exec_stmt
    if @@error <> 0
        begin
            print 'some error occur'
            return (-1)
        end
    else
        print 'Success+++'
    set @q = @exec_stmt
GO


CREATE PROCEDURE [dbo].[spInitRefundRequest]
    @RentID     INT,
    @UserID     INT,
    @Reason     VARCHAR(512),
    @Email      VARCHAR(256),
    @CardNumber VARCHAR(16),
    @ErrorCode  INT OUTPUT
AS
    BEGIN

        SET NOCOUNT ON

        --CHECK IF RENT ID IS VALID
        IF NOT EXISTS
            (
                SELECT
                    1
                FROM
                    CARRENTAL
                WHERE
                    RENTALID = @RentID
            )
            BEGIN
                SET @ErrorCode = 1
                RETURN;
            END

        --CHECK IF REFUND ALREADY INITAITED FOR GIVEN RENT ID
        IF EXISTS
            (
                SELECT
                    1
                FROM
                    REFUNDREQUESTS
                WHERE
                    RENTALID = @RentID
            )
            BEGIN
                SET @ErrorCode = 2
                RETURN;
            END

        --CHECK IF CARD NUMBER IS VALID FOR THE GIVEN USER
        IF (
               (
                   SELECT
                       DBO.fnCardExistForUserId(@UserID, @CardNumber)
               ) = 0
           )
            BEGIN
                SET @ErrorCode = 3
                RETURN;
            END

        INSERT INTO REFUNDREQUESTS
        VALUES
            (
                @RentID, GETDATE(), NULL, @Reason, 'PENDING', 'NOT REFUNDED'
            )

        SET @ErrorCode = 0 --SUCCESS

    END
GO

create proc [dbo].[spLoadDBNames]
as
    select
        [name]
    from
        sys.databases
GO

CREATE PROCEDURE [dbo].[spLoadManufacturer]
AS
    BEGIN
        SELECT DISTINCT
            MANUFACTURER
        FROM
            CAR;
    END
GO

CREATE proc [dbo].[spLoadRoles]
as
    select
        name
    from
        sys.database_principals
    where
        type = 'R'
        and is_fixed_role = 0
        and principal_id != 0
GO

CREATE PROCEDURE [dbo].[spLoadTypes]
AS
    BEGIN
        SELECT DISTINCT
            [TYPE]
        FROM
            CAR
    END
GO

CREATE PROCEDURE [dbo].[spRefund]
    @RequestID      INT,
    @Percentage     INT,
    @RefundedAmount DECIMAL(18, 2) OUTPUT,
    @ErrorCode      INT            OUTPUT
AS
    BEGIN
        -- TAKE CARDNUMBER INPUT FROM JAVA

        IF EXISTS
            (
                SELECT
                    1
                FROM
                    REFUNDREQUESTS
                WHERE
                    REQUESTID = @RequestID
                    AND [STATUS] = 'ACCEPTED'
            )
            BEGIN
                SET @ErrorCode = 1 --ALREADY REFUNDED
                RETURN;
            END

        IF @Percentage >= 100
           OR @Percentage <= 10
            BEGIN
                SET @ErrorCode = 2 -- PERCENTAGE RESTRICTION
                RETURN;
            END

        DECLARE @RentID INT
        SET @RentID =
            (
                SELECT
                    RENTALID
                FROM
                    REFUNDREQUESTS
                WHERE
                    REQUESTID = @RequestID
            )
        print 'rent id ' + cast(@rentID as varchar(5))

        DECLARE @TOTAL DECIMAL(18, 2)
        SET @Total =
            (
                SELECT
                    AMOUNT
                FROM
                    CARRENTAL
                WHERE
                    RENTALID = @RentID
            )
        print 'total ' + cast(@total as varchar(40))

        DECLARE @CardID INT
        SET @CardID =
            (
                SELECT
                    CARDID
                FROM
                    CARRENTAL
                WHERE
                    RENTALID = @RentID
            )
        print 'card id  ' + cast(@cardid as varchar(5))

        DECLARE @CardNumber VARCHAR(16)
        SET @CardNumber =
            (
                SELECT
                    CARDNUMBER
                FROM
                    VISACARD
                WHERE
                    CARDID = @CardID
            )
        print 'card ' + cast(@cardnumber as varchar(5))

        UPDATE
            REFUNDREQUESTS
        SET
            [STATUS] = 'ACCEPTED',
            RESOLUTION = 'REFUNDED',
            ACCEPTEDDATE = GETDATE()
        WHERE
            REQUESTID = @RequestID
            and RENTALID = @RentID


        -- ADD AMOUNT REFUNDED COLUMN IN TABLE REFUND REQUESTS OR PERCENTAGE

        SET @RefundedAmount = @TOTAL * (CAST(@Percentage AS DECIMAL(18, 2)) / 100)
        print 'refunded : ' + cast(@refundedamount as varchar(40))


        UPDATE
            VISACARD
        SET
            BALANCE = BALANCE + @RefundedAmount
        WHERE
            CARDNUMBER = @CardNumber

        SET @ErrorCode = 0 --SUCCESS
        print 'error code : ' + cast(@errorcode as varchar(5))

    END
GO


CREATE PROCEDURE [dbo].[spRenewInsurance]
    @CarID     INT,
    @ErrorCode INT OUTPUT
AS
    BEGIN
        DECLARE @CurrentExpiryDate DATE
        DECLARE @CurrentDate DATE = GETDATE()
        DECLARE @NewStartingDate DATE
        DECLARE @NewExpiryDate DATE

        -- Initialize error code to 0 (no error)
        SET @ErrorCode = 0

        -- Get the current expiry date
        SELECT
            @CurrentExpiryDate = MAX(EXPIRYDATE)
        FROM
            INSURANCE
        WHERE
            CARID = @CarID

        -- Check if the current expiry date is not null and is in the past
        IF @CurrentExpiryDate IS NOT NULL
           AND @CurrentExpiryDate <= @CurrentDate
            BEGIN
                -- Calculate new starting date and expiry date for renewal (assuming 3 days duration)
                SET @NewStartingDate = DATEADD(DAY, 1, GETDATE())
                SET @NewExpiryDate = DATEADD(DAY, 3, @NewStartingDate)

                -- Insert a new insurance row for the car with the same values
                INSERT INTO INSURANCE
                    (
                        CARID,
                        INSURANCEPROVIDER,
                        INSURANCEPOLICYNUMBER,
                        STARTINGDATE,
                        EXPIRYDATE,
                        COST
                    )
                            SELECT
                                CARID,
                                INSURANCEPROVIDER,
                                INSURANCEPOLICYNUMBER,
                                @NewStartingDate,
                                @NewExpiryDate,
                                COST
                            FROM
                                INSURANCE
                            WHERE
                                CARID = @CarID
                                AND EXPIRYDATE = @CurrentExpiryDate

                PRINT 'New insurance inserted successfully.'
            END
        ELSE
            BEGIN
                -- Set error code to 2 (insurance not expired)
                SET @ErrorCode = 1
                PRINT 'Error: Unable to insert new insurance. The insurance is not expired.'
            END
    END
GO

CREATE PROCEDURE [dbo].[spRentCar]
    @CustID     INT,
    @CarID      INT,
    @NbDays     INT,
    @CardNumber VARCHAR(16),
    @ErrorCode  INT OUTPUT
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE
            @Total      FLOAT,
            @HaveCard   BIT,
            @HaveEnough BIT,
            @Rented     BIT,
            @CardID     INT;

        BEGIN TRY
            BEGIN TRANSACTION;

            -- Check if the customer card exists
            set @HaveCard =
                (
                    select
                        DBO.fnCardExistForUserId(@CustID, @CardNumber)
                );
            set @Rented =
                (
                    select
                        isRented
                    from
                        CAR
                    where
                        CARID = @CarID
                )
            set @HaveEnough =
                (
                    select
                        DBO.fnCheckBalance(@CardNumber)
                );

            if @Rented = 1
                begin
                    set @ErrorCode = 3
                    print 'sorry , car is already rented'
                    rollback
                end

            if @HaveCard = 0
                begin
                    set @ErrorCode = 1
                    print 'invalid card for this customer'
                    rollback
                end

            if @HaveEnough = 0
                begin
                    set @ErrorCode = 2
                    print 'customer does not have enough balance to complete transaction'
                    rollback
                end

            --calculate total
            set @Total =
                (
                    select
                        DBO.fnTotalWithPrem(@CarID, @NbDays, @CustID)
                );

            UPDATE
                CAR
            SET
                ISRENTED = 1
            WHERE
                CARID = @CarID

            UPDATE
                VISACARD
            set
                BALANCE = BALANCE - @Total
            where
                CardNumber = @CardNumber;

            set @CardID =
                (
                    select
                        CARDID
                    from
                        VISACARD
                    where
                        CARDNUMBER = @CardNumber
                )

            insert into CARRENTAL
            values
                (
                    @CustID, @CarID, @CardID, GETDATE(), DATEADD(DAY, @NbDays, GETDATE()), 0, NULL, @Total
                )

            COMMIT;
        END TRY
        BEGIN CATCH
            --error occured
            if @@TRANCOUNT > 0
                rollback;

            -- Handle the error 
            print 'Error Occurred: ' + ERROR_MESSAGE();
            set @ErrorCode = 99;
            return;

        END CATCH;
    END;
GO

CREATE procedure [dbo].[spRentedBetween]
    @date1 date,
    @date2 date
as
    begin

        IF @date1 > @date2
            BEGIN
                DECLARE @tempDate DATE;

                -- Swap @date1 and @date2
                SET @tempDate = @date1;
                SET @date1 = @date2;
                SET @date2 = @tempDate;
            END


        select
                *
        from
                vwRentsInfo
        where
                RENTSTARTDATE
        between @date1 and @date2

    end
GO

CREATE PROCEDURE [dbo].[spSignIn]
    @Email     VARCHAR(256),
    @Password  VARCHAR(256),
    @ErrorCode INT OUTPUT,
    @UserId    INT OUTPUT
AS
    BEGIN
        SET NOCOUNT ON;

        -- Check if the email exists
        IF EXISTS
            (
                SELECT
                    1
                FROM
                    CUSTOMER
                WHERE
                    EMAIL = @Email
            )
            BEGIN

                DECLARE @HashedPassword VARCHAR(256);
                SELECT
                    @HashedPassword = [PASSWORDHASH]
                FROM
                    CUSTOMER
                WHERE
                    EMAIL = @Email;

                -- Check if the hashed password matches
                IF @HashedPassword = CONVERT(VARCHAR(256), HASHBYTES('SHA2_256', @Password), 2)
                    BEGIN
                        -- Password is correct, sign in successful
                        SET @ErrorCode = 0;
                        PRINT 'ErrorCode : ' + CAST(@ErrorCode AS VARCHAR(1));
                        PRINT 'Sign in successful for ' + @Email;

                        -- Return userId, for Java metadata
                        SET @UserId =
                            (
                                SELECT DISTINCT
                                    CUSTOMERID
                                FROM
                                    CUSTOMER
                                WHERE
                                    EMAIL = @Email
                            );

                        -- Set ISLOGGED = 1 in the CUSTOMER table
                        UPDATE
                            CUSTOMER
                        SET
                            ISLOGGED = 1
                        WHERE
                            EMAIL = @Email;
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

CREATE PROCEDURE [dbo].[spSignOut] @CustomerId INT
AS
    BEGIN
        UPDATE
            CUSTOMER
        SET
            ISLOGGED = 0
        WHERE
            CUSTOMERID = @CustomerId;
    END;
GO
/****** Object:  StoredProcedure [dbo].[spSignUp]    Script Date: 1/17/2024 11:00:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSignUp]
    @FirstName VARCHAR(256),
    @LastName  VARCHAR(256),
    @Age       INT,
    @Address   VARCHAR(256),
    @Email     VARCHAR(256),
    @Password  VARCHAR(256),
    @ErrorCode INT OUTPUT
AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRY
            -- Check if the email already exists
            IF NOT EXISTS
                (
                    SELECT
                        1
                    FROM
                        CUSTOMER
                    WHERE
                        EMAIL = @Email
                )
                BEGIN
                    DECLARE @HashedPassword VARCHAR(256);
                    SET @HashedPassword = CONVERT(VARCHAR(256), HASHBYTES('SHA2_256', @Password), 2);
                    -- PRINT 'Hashed password is: ' + @HashedPassword;

                    -- Insert new customer
                    INSERT INTO CUSTOMER
                        (
                            FIRSTNAME,
                            LASTNAME,
                            AGE,
                            [ADDRESS],
                            EMAIL,
                            [PASSWORDHASH],
                            ISLOGGED
                        )
                    VALUES
                        (
                            @FirstName, @LastName, @Age, @Address, @Email, @HashedPassword, 0
                        );

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

CREATE PROCEDURE [dbo].[spSubscribe] @CID INT
AS
    BEGIN

        DECLARE
            @Today   DATE,
            @EndDate DATE

        SET @Today = GETDATE()
        SET @EndDate = DATEADD(DAY, 3, @Today)

        INSERT INTO SUBSCRIPTION
        VALUES
            (
                @CID, @Today, @EndDate, 0
            )

    END

GO

CREATE PROCEDURE [dbo].[spUpdateExpiredSubscriptions]
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            SUBSCRIPTION
        SET
            EXPIRED = 1
        WHERE
            DATEDIFF(DAY, STATDATE, ENDDATE) = 3
            AND ENDDATE >= GETDATE();
    END;

GO

CREATE PROCEDURE [dbo].[spValidateCard]
    @CID        INT,
    @HolderName VARCHAR(256),
    @CardNumber VARCHAR(16),
    @CVV        VARCHAR(3),
    @ExpDate    DATE,
    @IsValid    BIT OUTPUT
AS
    BEGIN

        SELECT
            @IsValid = CASE
                           WHEN EXISTS
            (
                SELECT
                    1
                FROM
                    VISACARD
                WHERE
                    CARDHOLDERNAME = @HolderName
                    AND CARDNUMBER = @CardNumber
                    AND CVV = @CVV
                    AND EXPIRATIONDATE = @ExpDate
                    AND CUSTOMERID = @CID
            )
                               THEN 1
                           ELSE
                               0
                       END

    END
GO

CREATE PROCEDURE [dbo].[spViewMatches]
    @type VARCHAR(256),
    @make VARCHAR(256)
AS
    BEGIN
        IF @type = 'any'
           AND @make = 'any'
            BEGIN
                SELECT
                    *
                FROM
                    vwCarInfoWithPrice
            END
        ELSE IF @type = 'any'
                 BEGIN
                     SELECT
                         *
                     FROM
                         vwCarInfoWithPrice as v
                     WHERE
                         v.Make = @make
                 END
        ELSE IF @make = 'any'
                 BEGIN
                     SELECT
                         *
                     FROM
                         vwCarInfoWithPrice
                     WHERE
                         [TYPE] = @type
                 END
        ELSE
                 BEGIN
                     SELECT
                         *
                     FROM
                         vwCarInfoWithPrice
                     WHERE
                         [TYPE] = @type
                         AND Make = @make
                 END
    END
GO

CREATE PROCEDURE [dbo].[spViewMyCards] @CID INT
AS
    BEGIN
        SELECT
            CARDHOLDERNAME AS [Holder Name],
            CARDNUMBER     AS [Card Number],
            CVV            AS [CVV],
            EXPIRATIONDATE AS [Expiration Date],
            BALANCE        AS [Balance]
        FROM
            VISACARD
        WHERE
            CUSTOMERID = @CID
    END
GO

CREATE PROCEDURE [dbo].[spViewMyRents] @CID INT
AS
    BEGIN
        SELECT
            RENTALID      AS [My Rent ID],
            RENTSTARTDATE AS [Start Date],
            RENTENDDATE   AS [End Date],
            AMOUNT        AS [Payed Amount]
        FROM
            CARRENTAL    CR
            INNER JOIN
                CUSTOMER C
                    ON CR.CUSTOMERID = C.CUSTOMERID
        WHERE
            CR.CUSTOMERID = @CID
    END
GO

CREATE PROCEDURE [dbo].[spViewMyRequests] @CID INT
AS
    BEGIN

        SELECT
            REQUESTID   AS [My Request ID],
            RR.RENTALID AS [My Rent ID],
            CR.CARID    AS [Car ID],
            [STATUS]    AS [Request Status],
            RESOLUTION  AS [Resolution]
        FROM
            REFUNDREQUESTS RR
            INNER JOIN
                CARRENTAL  CR
                    ON RR.RENTALID = CR.RENTALID
        WHERE
            CR.CUSTOMERID = @CID

    END
GO
