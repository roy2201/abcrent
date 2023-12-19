USE [abcrent]
GO
/****** Object:  StoredProcedure [dbo].[spSignUp]    Script Date: 12/18/2023 7:58:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
sp in : user details
sp out: @errorcode : => 0 success
					 => 1 email already taken
*/
alter procedure [dbo].[spSignUp]
    @firstname varchar(256),
    @lastname varchar(256),
    @age int,
    @address varchar(256),
    @email varchar(256),
    @password varchar(256),
    @errorcode int output
as
begin
    set nocount on;

    -- Check if the email already exists
    if not exists (select 1 from CUSTOMER where EMAIL = @email)
    begin

        declare @hashedPassword varchar(256);
        set @hashedPassword = convert(varchar(256), hashbytes('SHA2_256', @password), 2);
        print 'Hashed password is: ' + @hashedPassword;

        -- Insert new customer
        insert into Customer(FIRSTNAME, LASTNAME, AGE, [ADDRESS], EMAIL, [PASSWORDHASH], ISLOGGED)
        values (@firstname, @lastname, @age, @address, @email, @hashedPassword, 0);

        set @errorcode = 0;
		print 'errorcode : ' + cast(@errorcode as varchar(1))
        print 'Sign up successful for ' + @firstname + ' ' + @lastname;

    end
    else
    begin
        -- Email already exists, handle accordingly (e.g., raise an error or set an output parameter)
        set @errorcode = 1;
		print 'errorcode : ' + cast(@errorcode as varchar(1))
        print 'Email already exists. Sign up failed.';
    end
end;
