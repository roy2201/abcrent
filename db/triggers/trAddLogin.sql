create trigger [dbo].[trAddLogin]
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
		values (@cid, getdate(), NULL, NULL, 0)
	end
end