USE [abcdRent]
GO
/****** Object:  View [dbo].[vwAllCars]    Script Date: 12/31/2023 12:15:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[vwAllCars]
AS
  SELECT carid        AS [Car ID],
         licenseplate AS [License Plate],
         color        AS [Color],
         model        AS [Model],
         [type]       AS [Type],
		 MANUFACTURER as [Make],
         mileage      AS [Mileage],
         CASE
            WHEN isrented = 1 THEN 'Rented'
            WHEN isrented = 0 THEN 'Available'
            ELSE 'Unknown'
         END AS [Rented/Availability]
  FROM   car;

GO

/****** Object:  View [dbo].[vwRented]    Script Date: 12/31/2023 12:15:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

alter view [dbo].[vwRented]
as
	select * 
	from   vwAllCars
	where  [Rented/Availability] = 'Available'
GO
/****** Object:  View [dbo].[vwAllInsurance]    Script Date: 12/31/2023 12:15:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  View [dbo].[vwExpiredInsurance]    Script Date: 12/31/2023 12:15:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vwExpiredInsurance]
as
	select *
	from vwAllInsurance
	where (datediff(day,getdate(),[Expired In])) < 0
GO
/****** Object:  View [dbo].[vwRefundRequests]    Script Date: 12/31/2023 12:15:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwRefundRequests]
AS
    SELECT
        REQUESTID	AS [Request ID],
        RR.RENTALID AS [Rent ID],
        [STATUS]	AS [Request Status],
        RESOLUTION	AS [Resolution],
        COALESCE(CONVERT(VARCHAR(10), ACCEPTEDDATE, 101), 'N/A') AS [Accepted Date]
    FROM
        REFUNDREQUESTS RR;
GO
/****** Object:  View [dbo].[vwPendingRequests]    Script Date: 12/31/2023 12:15:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwPendingRequests]
as
	SELECT *
	FROM  vwRefundRequests
	WHERE [Request Status] = 'PENDING' and RESOLUTION = 'NOT REFUNDED'
GO
/****** Object:  View [dbo].[vwCarsOverdue]    Script Date: 12/31/2023 12:15:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwCarsOverdue]
AS
  SELECT vc.*,
         rentstartdate AS [Start Date],
         rentenddate   AS [End Date]
  
  FROM   vwallcars vc
         INNER JOIN carrental cr
		 ON vc.[car id] = cr.carid
		 AND DATEDIFF(DAY,GETDATE(),CR.RENTENDDATE) < 0
GO
/****** Object:  View [dbo].[vwCarInfoWithPrice]    Script Date: 12/31/2023 12:15:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER view [dbo].[vwCarInfoWithPrice]
as
	select c.*,cp.PRICEPERDAY
	from vwAllCars as c
	INNER JOIN 
	CARPRICING as cp On c.[Car ID] = cp.CARID
GO
/****** Object:  View [dbo].[vwCarsHistory]    Script Date: 12/31/2023 12:15:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vwCarsHistory]
AS
	SELECT  INOUTID   AS [ID],
			CARID	  AS [Car ID],
			ENTRYTIME AS [Entry Time],
			EXITTIME  AS [Exit Time]
	FROM CARINOUT
GO
/****** Object:  View [dbo].[vwRentsInfo]    Script Date: 12/31/2023 12:15:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
        CUSTOMER    c
        INNER JOIN
            CARRENTAL cr
                ON c.CUSTOMERID = cr.CUSTOMERID;
GO
