CREATE TABLE [dbo].[Customer] (
    [CustomerID] INT IDENTITY(1,1) NOT NULL,
    [FirstName] VARCHAR(256) NULL,
    [LastName] VARCHAR(256) NULL,
    [Address] VARCHAR(256) NULL,
    [Age] INT NULL,
    [Email] VARCHAR(256) NULL,
    [PasswordHash] VARCHAR(256) NULL,
    CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED ([CustomerID] ASC)
);

CREATE TABLE [dbo].[Subscription] (
    [SubscriptionID] INT IDENTITY(1,1) NOT NULL,
    [CustomerID] INT NOT NULL,
    [StartDate] DATE NOT NULL,
    [EndDate] DATE NULL,
    [IsPremium] BIT NOT NULL,
    CONSTRAINT [PK_Subscription] PRIMARY KEY CLUSTERED ([SubscriptionID] ASC),
    CONSTRAINT [FK_Subscription_Customer] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customer]([CustomerID])
);

CREATE TABLE [dbo].[VisaCard](
    [CardID] [int] IDENTITY(1,1) NOT NULL,
    [CustomerID] [int] NOT NULL,
    [CardNumber] [varchar](16) NOT NULL,
    [ExpirationDate] [date] NOT NULL,
    [CVV] [varchar](3) NOT NULL,
    [Balance] [decimal](18, 2) NULL,
    CONSTRAINT [PK_VisaCard] PRIMARY KEY CLUSTERED ([CardID] ASC),
    CONSTRAINT [FK_VisaCard_Customer] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customer]([CustomerID]),
    INDEX [IX_Customer_VisaCard] NONCLUSTERED ([CustomerID] ASC)
);


CREATE TABLE [dbo].[Admin](
    [AdminID] [int] IDENTITY(1,1) NOT NULL,
    [Email] [varchar](256) NULL,
    [PasswordHash] [varchar](256) NULL,
    CONSTRAINT [PK_Admin] PRIMARY KEY CLUSTERED ([AdminID] ASC)
);

CREATE TABLE [dbo].[AdminCard](
    [AdminCardID] [int] IDENTITY(1,1) NOT NULL,
    [AdminID] [int] NOT NULL,
    [CardNumber] [int] NULL,
    CONSTRAINT [PK_AdminCard] PRIMARY KEY CLUSTERED ([AdminCardID] ASC),
    CONSTRAINT [FK_AdminCard_Admin] FOREIGN KEY ([AdminID]) REFERENCES [dbo].[Admin]([AdminID])
);

CREATE TABLE [dbo].[Branches](
    [BranchID] INT IDENTITY(200,1) NOT NULL,
    [BranchName] VARCHAR(128) NULL,
    [BranchEmail] VARCHAR(128) NULL,
    [StreetAddress] VARCHAR(128) NULL,
    [City] VARCHAR(50) NULL,
    [Region] VARCHAR(50) NULL,
    [PostalCode] VARCHAR(20) NULL,
    [PhoneNumber] VARCHAR(20) NULL,
    [ManagerName] VARCHAR(100) NULL,
    [Status] VARCHAR(20) NULL,
    [OpeningHours] VARCHAR(100) NULL,
    [CreationTimestamp] DATETIME NOT NULL,
    [LastUpdatedTimestamp] DATETIME NULL,
    CONSTRAINT [PK_Branches] PRIMARY KEY CLUSTERED ([BranchID] ASC)
);

CREATE TABLE [dbo].[Cars](
    [CarID] [int] IDENTITY(100,1) NOT NULL,
    [BranchID] [int] NOT NULL,
    [LicensePlate] [varchar](20) NULL,
    [Color] [varchar](256) NULL,
    [Manufacturer] [varchar](256) NULL,
    [Model] [varchar](256) NULL,
    [Type] [varchar](256) NULL,
    [RentedStatus] [bit] NULL,
    [PricePerDay] [float] NULL,
    [Mileage] [int] NULL,
    [FuelType] [varchar](50) NULL,
    [InsuranceProvider] [varchar](256) NULL,
    [InsurancePolicyNumber] [varchar](50) NULL,
    CONSTRAINT [PK_Cars] PRIMARY KEY CLUSTERED ([CarID] ASC)
);

CREATE TABLE [dbo].[CarRentals](
    [RentalID] [int] IDENTITY(1,1) NOT NULL,
    [CarID] [int] NOT NULL,
    [StartDate] [datetime] NOT NULL,
    [EndDate] [datetime] NULL,
    [Returned] [bit] NULL,
    CONSTRAINT [PK_CarRentals] PRIMARY KEY CLUSTERED ([RentalID] ASC),
    CONSTRAINT [FK_CarRentals_Cars] FOREIGN KEY ([CarID]) REFERENCES [dbo].[Cars]([CarID])
);

CREATE TABLE [dbo].[Insurances](
    [InsuranceID] [int] IDENTITY(200,1) NOT NULL,
    [CarID] [int] NOT NULL,
    [StartingDate] [datetime] NOT NULL,
    [ExpiryDate] [datetime] NOT NULL,
    [Cost] [float] NOT NULL,
    CONSTRAINT [PK_Insurances] PRIMARY KEY CLUSTERED ([InsuranceID] ASC),
    CONSTRAINT [FK_Insurances_Cars] FOREIGN KEY ([CarID]) REFERENCES [dbo].[Cars]([CarID])
);

CREATE TABLE [dbo].[LoginHistory](
    [LoginID] [int] IDENTITY(1,1) NOT NULL,
    [UserID] [int] NOT NULL,
    [UserType] [varchar](50) NOT NULL,
    [LoginTime] [datetime] NOT NULL,
    [LogoutTime] [datetime] NULL,
    [Status] [varchar](20) NOT NULL,
    [SessionDuration] AS (DATEDIFF(MINUTE, [LoginTime], [LogoutTime])),
    [FailedLoginAttempts] [int] NULL,
    CONSTRAINT [PK_LoginHistory] PRIMARY KEY CLUSTERED ([LoginID] ASC),
    CONSTRAINT [FK_LoginHistory_Users] FOREIGN KEY ([UserID]) REFERENCES Customer([CustomerID])
);

CREATE TABLE [dbo].[Rentals](
    [CustomerID] [int] NOT NULL,
    [CarID] [int] NOT NULL,
    [RentalStartDate] [datetime] NOT NULL,
    [RentalEndDate] [datetime] NULL,
    CONSTRAINT [PK_Rentals] PRIMARY KEY CLUSTERED ([CustomerID] ASC, [CarID] ASC),
    CONSTRAINT [FK_Rentals_Customers] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customer](CustomerID),
    CONSTRAINT [FK_Rentals_Cars] FOREIGN KEY ([CarID]) REFERENCES [dbo].[Cars]([CarID])
);

CREATE TABLE [dbo].[CarInOut](
    [InOutID] [int] IDENTITY(1,1) NOT NULL,
    [CarID] [int] NOT NULL,
    [BranchID] [int] NOT NULL,
    [EntryTime] [datetime] NOT NULL,
    [ExitTime] [datetime] NULL,
    CONSTRAINT [PK_CarInOut] PRIMARY KEY CLUSTERED ([InOutID] ASC),
    CONSTRAINT [FK_CarInOut_Cars] FOREIGN KEY ([CarID]) REFERENCES [dbo].[Cars]([CarID]),
    CONSTRAINT [FK_CarInOut_Branches] FOREIGN KEY ([BranchID]) REFERENCES [dbo].[Branches]([BranchID])
);


CREATE TABLE [dbo].[RefundRequests](
    [RequestID] [int] IDENTITY(1,1) NOT NULL,
    [CustomerID] [int] NOT NULL,
    [RentalID] [int] NOT NULL,
    [RequestDate] [datetime] NOT NULL,
    [Reason] [varchar](max) NOT NULL,
    [Status] [varchar](50) NOT NULL,
    [Resolution] [varchar](max) NULL,
    CONSTRAINT [PK_RefundRequests] PRIMARY KEY CLUSTERED ([RequestID] ASC),
    CONSTRAINT [FK_RefundRequests_Customers] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customer]([CustomerID]),
    CONSTRAINT [FK_RefundRequests_Rentals] FOREIGN KEY ([RentalID]) REFERENCES [dbo].[CarRentals]([RentalID])
);
