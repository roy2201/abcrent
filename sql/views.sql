USE [abcdRent]
GO

CREATE VIEW [dbo].[vwAllCars]
AS
    SELECT
        carid        AS [Car ID],
        licenseplate AS [License Plate],
        color        AS [Color],
        model        AS [Model],
        [type]       AS [Type],
        MANUFACTURER as [Make],
        mileage      AS [Mileage],
        CASE
            WHEN isrented = 1
                THEN 'Rented'
            WHEN isrented = 0
                THEN 'Available'
            ELSE
                'Unknown'
        END          AS [Rented/Availability]
    FROM
        car;

GO

CREATE view [dbo].[vwRented]
as
    select
        *
    from
        vwAllCars
    where
        [Rented/Availability] = 'Rented'
GO

CREATE view [dbo].[vwAllInsurance]
as
    select
        INSURANCEID           as [ID],
        CARID                 as [Car ID],
        INSURANCEPROVIDER     as [Provider],
        INSURANCEPOLICYNUMBER as [Policy Number],
        EXPIRYDATE            as [Expired In],
        COST                  as [Ins Cost]
    from
        INSURANCE
GO


CREATE view [dbo].[vwExpiredInsurance]
as
    select
        *
    from
        vwAllInsurance
    where
        (datediff(day, getdate(), [Expired In])) < 0
GO

CREATE VIEW [dbo].[vwRefundRequests]
AS
    SELECT
        REQUESTID                                                AS [Request ID],
        RR.RENTALID                                              AS [Rent ID],
        [STATUS]                                                 AS [Request Status],
        RESOLUTION                                               AS [Resolution],
        COALESCE(CONVERT(VARCHAR(10), ACCEPTEDDATE, 101), 'N/A') AS [Accepted Date]
    FROM
        REFUNDREQUESTS RR;
GO

CREATE view [dbo].[vwPendingRequests]
as
    SELECT
        *
    FROM
        vwRefundRequests
    WHERE
        [Request Status] = 'PENDING'
        and RESOLUTION = 'NOT REFUNDED'
GO

CREATE view [dbo].[vwCarInfoWithPrice]
as
    select
        c.*,
        cp.PRICEPERDAY
    from
        vwAllCars      as c
        INNER JOIN
            CARPRICING as cp
                On c.[Car ID] = cp.CARID
GO

CREATE VIEW [dbo].[vwCarsOverdue]
AS
    SELECT
        vc.*,
        cr.rentstartdate AS [Start Date],
        cr.rentenddate   AS [End Date]
    FROM
        vwallcars     vc
        INNER JOIN
            carrental cr
                ON vc.[car id] = cr.carid
                   AND cr.rentenddate < GETDATE()
                   And [Rented/Availability] = 'Rented'
GO


CREATE VIEW [dbo].[vwCarsHistory]
AS
    SELECT
        INOUTID   AS [ID],
        CARID     AS [Car ID],
        ENTRYTIME AS [Entry Time],
        EXITTIME  AS [Exit Time]
    FROM
        CARINOUT
GO

create view [dbo].[vwDbNames]
as
    select
        [name]
    from
        sys.databases
GO

create view [dbo].[vwLoggedUsers]
as
    select
        EMAIL as [Email]
    from
        CUSTOMER
    where
        ISLOGGED = 1
GO

CREATE VIEW [dbo].[vwLoginHistory]
AS
    SELECT
        C.EMAIL                                AS [Email],
        SESSIONDURATION                        AS [Session Duration],
        FORMAT(LOGINTIME, 'yyyy-MM-dd HH:mm')  AS [Login Time],
        FORMAT(LOGOUTTIME, 'yyyy-MM-dd HH:mm') AS [Logout Time]
    FROM
        LOGINHISTORY LH
        INNER JOIN
            CUSTOMER C
                ON C.CUSTOMERID = LH.CUSTOMERID
GO

CREATE VIEW [dbo].[vwRentsInfo]
AS
    SELECT
        EMAIL                                                        AS [Email],
        CARID                                                        AS [Car ID],
        RENTSTARTDATE                                                AS [Start Date],
        RENTENDDATE                                                  AS [End Date],
        ISRETURNED                                                   AS [Returned ?],
        COALESCE(CONVERT(VARCHAR(10), RETURNEDDATE), 'not returned') AS [Returned Date],
        AMOUNT
    FROM
        CUSTOMER      c
        INNER JOIN
            CARRENTAL cr
                ON c.CUSTOMERID = cr.CUSTOMERID;
GO
