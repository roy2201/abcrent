/*
sp in : user id
sp out: /
sp do : change isLogged from 1 to 0 for user
*/
alter procedure spSignOut
	@cid	int
as
begin
	update Customer
	set isLogged = 0
	where CustomerId = @cid
end