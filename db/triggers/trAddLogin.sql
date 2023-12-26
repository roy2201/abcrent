USE [abcdRent]
GO

/****** Object:  Trigger [dbo].[trAddLogin]    Script Date: 12/26/2023 5:11:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE trigger [dbo].[trAddLogin]
On [dbo].[CUSTOMER]
After update
as
begin
	if (select count(*) 
	from inserted as i, deleted as d
	where i.ISLOGGED=1 and d.ISLOGGED=0 )>0
	begin
		declare @cid int
		set @cid = (select CUSTOMERID from inserted)
		insert into LOGINHISTORY
		values (@cid, getdate(), NULL, 0)
	end
end
GO

ALTER TABLE [dbo].[CUSTOMER] ENABLE TRIGGER [trAddLogin]
GO

