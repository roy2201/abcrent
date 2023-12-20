create procedure spLoadManufacturer
as
begin
	select distinct MANUFACTURER
	from CAR
end