ALTER trigger [dbo].[trUpdateUserInfo]
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
