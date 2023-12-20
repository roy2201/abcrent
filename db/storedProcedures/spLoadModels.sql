create procedure spLoadModels
as
begin
	select distinct MODEL
	from CAR
end
go