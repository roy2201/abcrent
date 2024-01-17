/**TRIGGERS**/


CREATE trigger [dbo].[trNoSameLicenseCar]
on [dbo].[CAR]
for insert
as
begin
    if (exists (
        select 1
        from car as c
        inner join inserted as i on c.licenseplate = i.licenseplate
    ))
    begin
        --raiseerror('Car already has this license plate number', 16, 1);
        rollback;
    end;
end
GO

ALTER TABLE [dbo].[CAR] ENABLE TRIGGER [trNoSameLicenseCar]
GO


CREATE trigger [dbo].[trAddLogin]
On [dbo].[CUSTOMER]
After update
as
begin
	if (select count(*) 
	from inserted as i, deleted as d
	where i.islogged=1 and d.islogged=0 )>0
	begin
		declare @cid int
		set @cid = (select customerid from inserted)
		insert into loginhistory
		values (@cid, getdate(), NULL, 0)
	end
end
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

-- trEnforceCarModel
create trigger trEnforceCarModel
on Car
for insert
as
begin
	if (exists (select 1 from inserted i where i.MODEL is null))
	begin
		--raiseerror('Model should not be null', 16, 1);
		rollback
	end
end

-- trPriceHaveCar
create trigger trPriceHaveCar
on CarPricing
for insert
as
begin
	if (not exists (select 1 from inserted i
				inner join car c
				on i.CARID = c.CARID ))
	begin
		print 'no car assicaited with this price'
		rollback
	end
end