USE [abcdRent]
GO

/****** Object:  Trigger [dbo].[trUpdateUserInfo]    Script Date: 12/26/2023 5:11:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE trigger [dbo].[trUpdateUserInfo]
on [dbo].[CUSTOMER]
after update
as
begin
    update lh
    set lh.sessionduration = datediff(minute, lh.logintime, getdate()),
        lh.logouttime = getdate()
    from loginhistory lh
    inner join inserted i on lh.customerid = i.customerid
    inner join deleted d on i.customerid = d.customerid
    where lh.logouttime is null
        and i.islogged = 0
        and d.islogged = 1;
end;
GO

ALTER TABLE [dbo].[CUSTOMER] ENABLE TRIGGER [trUpdateUserInfo]
GO

