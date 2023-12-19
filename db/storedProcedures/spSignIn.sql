USE [abcrent]
GO
/****** Object:  StoredProcedure [dbo].[spSignIn]    Script Date: 12/19/2023 2:53:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*===============================================================================
sp in : email, pass
sp out: errorcode : 0 => success
					1 => wrong pass =>increase number of failed attempts for email
					2 => wrong email
=================================================================================*/

ALTER procedure [dbo].[spSignIn]
    @email		varchar(256),
    @password	varchar(256),
    @errorcode	int output,
	@userId		int output
as
begin
    set nocount on;

    -- Check if the email exists
    if exists (select 1 from CUSTOMER where EMAIL = @email)
    begin

        declare @hashedPassword varchar(256);
        select @hashedPassword = [PASSWORDHASH] from CUSTOMER where EMAIL = @email;

        -- Check if the hashed password matches
        if @hashedPassword = convert(varchar(256), hashbytes('SHA2_256', @password), 2)
        begin
            -- Password is correct, sign in successful
            set @errorcode = 0;
			print 'errorcode : ' + cast(@errorcode as varchar(1))
            print 'Sign in successful for ' + @email;

			-- return userId, for java meta data
			set @userId = (select distinct CUSTOMERID from CUSTOMER where EMAIL=@email)

			-- set islogged = 1 in customer table
			update CUSTOMER
			set ISLOGGED = 1
			where EMAIL = @email


        end
        else
        begin
            -- Password does not match
            set @errorcode = 2;
			print 'errorcode : ' + cast(@errorcode as varchar(1))
            print 'Incorrect password. Sign in failed.';
        end
    end
    else
    begin
        -- Email does not exist
        set @errorcode = 1;
		print 'errorcode : ' + cast(@errorcode as varchar(1))
        print 'Email not found. Sign in failed.';
    end
end;