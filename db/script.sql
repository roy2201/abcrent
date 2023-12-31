USE [master]
GO
/****** Object:  Database [abcdRent]    Script Date: 12/26/2023 5:04:21 PM ******/
CREATE DATABASE [abcdRent]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'abcdRent', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\abcdRent.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'abcdRent_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\abcdRent_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [abcdRent] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [abcdRent].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [abcdRent] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [abcdRent] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [abcdRent] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [abcdRent] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [abcdRent] SET ARITHABORT OFF 
GO
ALTER DATABASE [abcdRent] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [abcdRent] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [abcdRent] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [abcdRent] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [abcdRent] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [abcdRent] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [abcdRent] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [abcdRent] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [abcdRent] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [abcdRent] SET  DISABLE_BROKER 
GO
ALTER DATABASE [abcdRent] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [abcdRent] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [abcdRent] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [abcdRent] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [abcdRent] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [abcdRent] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [abcdRent] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [abcdRent] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [abcdRent] SET  MULTI_USER 
GO
ALTER DATABASE [abcdRent] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [abcdRent] SET DB_CHAINING OFF 
GO
ALTER DATABASE [abcdRent] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [abcdRent] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [abcdRent] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [abcdRent] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [abcdRent] SET QUERY_STORE = ON
GO
ALTER DATABASE [abcdRent] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [abcdRent]
GO
/****** Object:  UserDefinedFunction [dbo].[fnCalculateTotalPayment]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnCalculateTotalPayment]
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
    FROM vwCarInfoWithPrice
    WHERE CARID = @CarId;

    SET @TotalAmount = @DailyRate * @NumDays;

    RETURN @TotalAmount;
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnCardExistForUserId]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fnCardExistForUserId]
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
/****** Object:  UserDefinedFunction [dbo].[fnCheckBalance]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnCheckBalance] 
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
/****** Object:  UserDefinedFunction [dbo].[fnCheckPrem]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnCheckPrem]
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
/****** Object:  UserDefinedFunction [dbo].[fnIsCarAvailable]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnIsCarAvailable]
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
/****** Object:  UserDefinedFunction [dbo].[fnTotalWithPrem]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnTotalWithPrem]
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
/****** Object:  Table [dbo].[CAR]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CAR](
	[CARID] [int] IDENTITY(1,1) NOT NULL,
	[LICENSEPLATE] [varchar](20) NULL,
	[COLOR] [varchar](256) NULL,
	[MANUFACTURER] [varchar](256) NULL,
	[MODEL] [varchar](256) NULL,
	[TYPE] [varchar](256) NULL,
	[MILEAGE] [int] NULL,
	[ISRENTED] [bit] NULL,
 CONSTRAINT [PK_CAR] PRIMARY KEY CLUSTERED 
(
	[CARID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CARPRICING]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CARPRICING](
	[CARPRICINGID] [int] IDENTITY(1,1) NOT NULL,
	[CARID] [int] NOT NULL,
	[EFFECTIVEDATE] [date] NULL,
	[PRICEPERDAY] [float] NULL,
 CONSTRAINT [PK_CARPRICING] PRIMARY KEY CLUSTERED 
(
	[CARPRICINGID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwCarInfoWithPrice]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vwCarInfoWithPrice]
as
	select c.CARID, COLOR, MANUFACTURER, MODEL, [TYPE], PRICEPERDAY
	from CAR as c
	INNER JOIN 
	CARPRICING as cp On c.CARID = cp.CARID
GO
/****** Object:  Table [dbo].[CARINOUT]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CARINOUT](
	[INOUTID] [int] IDENTITY(1,1) NOT NULL,
	[CARID] [int] NOT NULL,
	[ENTRYTIME] [date] NULL,
	[EXITTIME] [date] NULL,
	[RENTEDDURATION] [int] NULL,
 CONSTRAINT [PK_CARINOUT] PRIMARY KEY CLUSTERED 
(
	[INOUTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CARRENTAL]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CARRENTAL](
	[CUSTOMERID] [int] NOT NULL,
	[CARID] [int] NOT NULL,
	[RENTALID] [int] IDENTITY(1,1) NOT NULL,
	[RENTSTARTDATE] [date] NULL,
	[RENTENDDATE] [date] NULL,
	[ISRETURNED] [bit] NULL,
	[RETURNEDDATE] [date] NULL,
	[AMOUNT] [float] NULL,
 CONSTRAINT [PK_CARRENTAL] PRIMARY KEY CLUSTERED 
(
	[RENTALID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CUSTOMER]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUSTOMER](
	[CUSTOMERID] [int] IDENTITY(1,1) NOT NULL,
	[FIRSTNAME] [varchar](256) NULL,
	[LASTNAME] [varchar](256) NULL,
	[ADDRESS] [varchar](256) NULL,
	[EMAIL] [varchar](256) NULL,
	[PASSWORDHASH] [varchar](256) NULL,
	[AGE] [int] NULL,
	[ISLOGGED] [bit] NULL,
 CONSTRAINT [PK_CUSTOMER] PRIMARY KEY CLUSTERED 
(
	[CUSTOMERID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[INSURANCE]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[INSURANCE](
	[INSURANCEID] [int] IDENTITY(1,1) NOT NULL,
	[CARID] [int] NOT NULL,
	[INSURANCEPROVIDER] [varchar](256) NULL,
	[INSURANCEPOLICYNUMBER] [varchar](20) NULL,
	[STARTINGDATE] [date] NULL,
	[EXPIRYDATE] [date] NULL,
	[COST] [decimal](18, 2) NULL,
 CONSTRAINT [PK_INSURANCE] PRIMARY KEY CLUSTERED 
(
	[INSURANCEID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOGINHISTORY]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOGINHISTORY](
	[LOGINID] [int] IDENTITY(1,1) NOT NULL,
	[CUSTOMERID] [int] NOT NULL,
	[LOGINTIME] [datetime] NULL,
	[LOGOUTTIME] [datetime] NULL,
	[SESSIONDURATION] [int] NULL,
 CONSTRAINT [PK_LOGINHISTORY] PRIMARY KEY CLUSTERED 
(
	[LOGINID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[REFUNDREQUESTS]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REFUNDREQUESTS](
	[REQUESTID] [int] IDENTITY(1,1) NOT NULL,
	[RENTALID] [int] NULL,
	[REQUESTDATE] [datetime] NULL,
	[ACCEPTEDDATE] [datetime] NULL,
	[REASON] [varchar](512) NULL,
	[STATUS] [varchar](50) NULL,
	[RESOLUTION] [varchar](50) NULL,
 CONSTRAINT [PK_REFUNDREQUESTS] PRIMARY KEY CLUSTERED 
(
	[REQUESTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SUBSCRIPTION]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SUBSCRIPTION](
	[SUBSCRIPTIONID] [int] IDENTITY(1,1) NOT NULL,
	[CUSTOMERID] [int] NOT NULL,
	[STATDATE] [date] NULL,
	[ENDDATE] [date] NULL,
	[EXPIRED] [bit] NULL,
 CONSTRAINT [PK_SUBSCRIPTION] PRIMARY KEY CLUSTERED 
(
	[SUBSCRIPTIONID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VISACARD]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VISACARD](
	[CARDID] [int] IDENTITY(1,1) NOT NULL,
	[CUSTOMERID] [int] NOT NULL,
	[CARDHOLDERNAME] [varchar](256) NULL,
	[CARDNUMBER] [varchar](16) NULL,
	[CVV] [varchar](3) NULL,
	[EXPIRATIONDATE] [date] NULL,
	[BALANCE] [decimal](18, 2) NULL,
 CONSTRAINT [PK_VISACARD] PRIMARY KEY CLUSTERED 
(
	[CARDID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [INOUTINFO_FK]    Script Date: 12/26/2023 5:04:21 PM ******/
CREATE NONCLUSTERED INDEX [INOUTINFO_FK] ON [dbo].[CARINOUT]
(
	[CARID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [PRICEINFO_FK]    Script Date: 12/26/2023 5:04:21 PM ******/
CREATE NONCLUSTERED INDEX [PRICEINFO_FK] ON [dbo].[CARPRICING]
(
	[CARID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [CARRENTAL_FK]    Script Date: 12/26/2023 5:04:21 PM ******/
CREATE NONCLUSTERED INDEX [CARRENTAL_FK] ON [dbo].[CARRENTAL]
(
	[CUSTOMERID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [CARRENTAL2_FK]    Script Date: 12/26/2023 5:04:21 PM ******/
CREATE NONCLUSTERED INDEX [CARRENTAL2_FK] ON [dbo].[CARRENTAL]
(
	[CARID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [INSURANCEINFO_FK]    Script Date: 12/26/2023 5:04:21 PM ******/
CREATE NONCLUSTERED INDEX [INSURANCEINFO_FK] ON [dbo].[INSURANCE]
(
	[CARID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [LOGININFO_FK]    Script Date: 12/26/2023 5:04:21 PM ******/
CREATE NONCLUSTERED INDEX [LOGININFO_FK] ON [dbo].[LOGINHISTORY]
(
	[CUSTOMERID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [SUBSCRIBE_FK]    Script Date: 12/26/2023 5:04:21 PM ******/
CREATE NONCLUSTERED INDEX [SUBSCRIBE_FK] ON [dbo].[SUBSCRIPTION]
(
	[CUSTOMERID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [HAVEVISA_FK]    Script Date: 12/26/2023 5:04:21 PM ******/
CREATE NONCLUSTERED INDEX [HAVEVISA_FK] ON [dbo].[VISACARD]
(
	[CUSTOMERID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CARINOUT]  WITH CHECK ADD  CONSTRAINT [FK_CARINOUT_INOUTINFO_CAR] FOREIGN KEY([CARID])
REFERENCES [dbo].[CAR] ([CARID])
GO
ALTER TABLE [dbo].[CARINOUT] CHECK CONSTRAINT [FK_CARINOUT_INOUTINFO_CAR]
GO
ALTER TABLE [dbo].[CARPRICING]  WITH CHECK ADD  CONSTRAINT [FK_CARPRICI_PRICEINFO_CAR] FOREIGN KEY([CARID])
REFERENCES [dbo].[CAR] ([CARID])
GO
ALTER TABLE [dbo].[CARPRICING] CHECK CONSTRAINT [FK_CARPRICI_PRICEINFO_CAR]
GO
ALTER TABLE [dbo].[CARRENTAL]  WITH CHECK ADD  CONSTRAINT [FK_CARRENTA_CARRENTAL_CAR] FOREIGN KEY([CARID])
REFERENCES [dbo].[CAR] ([CARID])
GO
ALTER TABLE [dbo].[CARRENTAL] CHECK CONSTRAINT [FK_CARRENTA_CARRENTAL_CAR]
GO
ALTER TABLE [dbo].[CARRENTAL]  WITH CHECK ADD  CONSTRAINT [FK_CARRENTA_CARRENTAL_CUSTOMER] FOREIGN KEY([CUSTOMERID])
REFERENCES [dbo].[CUSTOMER] ([CUSTOMERID])
GO
ALTER TABLE [dbo].[CARRENTAL] CHECK CONSTRAINT [FK_CARRENTA_CARRENTAL_CUSTOMER]
GO
ALTER TABLE [dbo].[INSURANCE]  WITH CHECK ADD  CONSTRAINT [FK_INSURANC_INSURANCE_CAR] FOREIGN KEY([CARID])
REFERENCES [dbo].[CAR] ([CARID])
GO
ALTER TABLE [dbo].[INSURANCE] CHECK CONSTRAINT [FK_INSURANC_INSURANCE_CAR]
GO
ALTER TABLE [dbo].[LOGINHISTORY]  WITH CHECK ADD  CONSTRAINT [FK_LOGINHIS_LOGININFO_CUSTOMER] FOREIGN KEY([CUSTOMERID])
REFERENCES [dbo].[CUSTOMER] ([CUSTOMERID])
GO
ALTER TABLE [dbo].[LOGINHISTORY] CHECK CONSTRAINT [FK_LOGINHIS_LOGININFO_CUSTOMER]
GO
ALTER TABLE [dbo].[REFUNDREQUESTS]  WITH CHECK ADD  CONSTRAINT [FK_REFUNDRE_REFERENCE_CARRENTA] FOREIGN KEY([RENTALID])
REFERENCES [dbo].[CARRENTAL] ([RENTALID])
GO
ALTER TABLE [dbo].[REFUNDREQUESTS] CHECK CONSTRAINT [FK_REFUNDRE_REFERENCE_CARRENTA]
GO
ALTER TABLE [dbo].[SUBSCRIPTION]  WITH CHECK ADD  CONSTRAINT [FK_SUBSCRIP_SUBSCRIBE_CUSTOMER] FOREIGN KEY([CUSTOMERID])
REFERENCES [dbo].[CUSTOMER] ([CUSTOMERID])
GO
ALTER TABLE [dbo].[SUBSCRIPTION] CHECK CONSTRAINT [FK_SUBSCRIP_SUBSCRIBE_CUSTOMER]
GO
ALTER TABLE [dbo].[VISACARD]  WITH CHECK ADD  CONSTRAINT [FK_VISACARD_HAVEVISA_CUSTOMER] FOREIGN KEY([CUSTOMERID])
REFERENCES [dbo].[CUSTOMER] ([CUSTOMERID])
GO
ALTER TABLE [dbo].[VISACARD] CHECK CONSTRAINT [FK_VISACARD_HAVEVISA_CUSTOMER]
GO
/****** Object:  StoredProcedure [dbo].[spAddVisa]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAddVisa]
    @cid			INT,
    @cardHoldreName VARCHAR(256),
    @expDate		DATE,
    @CVV			VARCHAR(3),
    @cardNumber		VARCHAR(5),
	@ErrorCode		INT		OUTPUT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM CUSTOMER WHERE CUSTOMERID = @cid)
    BEGIN
        PRINT 'CUSTOMER DOES NOT EXIST'
		SET @ErrorCode = 1
        RETURN;
    END

    INSERT INTO VISACARD (CUSTOMERID, CardHolderName, CVV, EXPIRATIONDATE, BALANCE, CARDNUMBER)
    VALUES (@cid, @cardHoldreName, @CVV, @expDate, 1000, @cardNumber);

	SET @ErrorCode = 0
	PRINT 'CARD ADDED'
END;
GO
/****** Object:  StoredProcedure [dbo].[spChangePassword]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spChangePassword]
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
/****** Object:  StoredProcedure [dbo].[spCheckMyRent]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCheckMyRent]
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
		SET @ErrorCode = 2
	END
	ELSE --RENTAL IS OVERDUE
	BEGIN
		SET @DaysLeft = @DaysRented - @TotalDays
		SET @Penalty  = 0.25 * @PricePerDay * (@DaysRented - @TotalDays)
		PRINT 'OVERDUE BY : ' + CAST(@DaysLeft AS VARCHAR(5)) + 'DAYS'
		PRINT 'PENALTY : ' + CAST(@Penalty AS VARCHAR(5)) + ' USD'
		SET @ErrorCode = 3
	END

END
GO
/****** Object:  StoredProcedure [dbo].[spInitRefundRequest]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spInitRefundRequest]
	@RentID			INT,
	@UserID			INT,
	@Reason			VARCHAR(512),
	@Email			VARCHAR(256),
	@CardNumber		VARCHAR(16),
	@ErrorCode		INT		OUTPUT
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
GO
/****** Object:  StoredProcedure [dbo].[spLoadManufacturer]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLoadManufacturer]
AS
BEGIN
    SELECT DISTINCT MANUFACTURER
    FROM CAR;
END
GO
/****** Object:  StoredProcedure [dbo].[spLoadTypes]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLoadTypes]
AS
BEGIN
    SELECT DISTINCT [TYPE]
    FROM CAR
END
GO
/****** Object:  StoredProcedure [dbo].[spRentCar]    Script Date: 12/26/2023 5:04:21 PM ******/
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
        SET @HaveCard = (SELECT DBO.fnCardExistForUserId(@CustID, @CardNumber));

		IF (@HaveCard = 1)
		BEGIN
			PRINT 'CUSTOMER CARD IS VALID';

            -- Calculate the total with premium
            SET @Total = (SELECT DBO.fnTotalWithPrem(@CarID, @NbDays, @CustID));

            -- Check if the customer has enough balance
            SET @HaveEnough = (SELECT DBO.fnCheckBalance(@CardNumber));

            IF (@HaveEnough = 1)
            BEGIN
                PRINT 'CUSTOMER HAS ENOUGH BALANCE TO COMPLETE TRANSACTION';

                -- Update the balance in the VISACARD table
                UPDATE VISACARD
                SET BALANCE = BALANCE - @Total
                WHERE CardNumber = @CardNumber;
				INSERT INTO CARRENTAL
				VALUES (@CustID,@CarID, GETDATE(), DATEADD(DAY, @NbDays, GETDATE()), 0, NULL, @Total)
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
/****** Object:  StoredProcedure [dbo].[spSignIn]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSignIn]
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
/****** Object:  StoredProcedure [dbo].[spSignOut]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSignOut]
    @CustomerId INT
AS
BEGIN
    UPDATE CUSTOMER
    SET ISLOGGED = 0
    WHERE CUSTOMERID = @CustomerId;
END;
GO
/****** Object:  StoredProcedure [dbo].[spSignUp]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSignUp]
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
/****** Object:  StoredProcedure [dbo].[spSubscribe]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSubscribe]
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
/****** Object:  StoredProcedure [dbo].[spUpdateExpiredSubscriptions]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spUpdateExpiredSubscriptions]
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE SUBSCRIPTION
    SET EXPIRED = 1
    WHERE DATEDIFF(DAY, STATDATE, ENDDATE) = 3
    AND ENDDATE >= GETDATE();
END;

GO
/****** Object:  StoredProcedure [dbo].[spValidateCard]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spValidateCard]
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
GO
/****** Object:  StoredProcedure [dbo].[spViewMatches]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spViewMatches]
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
/****** Object:  StoredProcedure [dbo].[spViewMyCards]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spViewMyCards]
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
/****** Object:  StoredProcedure [dbo].[spViewMyRents]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spViewMyRents]
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
/****** Object:  StoredProcedure [dbo].[spViewMyRequests]    Script Date: 12/26/2023 5:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spViewMyRequests]
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
USE [master]
GO
ALTER DATABASE [abcdRent] SET  READ_WRITE 
GO
