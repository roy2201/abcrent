Alter Procedure [dbo].[spRefund] @RequestID  int,
                                  @Percentage int,
                                  @ErrorCode  int output
As
  Begin
      If Exists (Select 1
                 From   REFUNDREQUESTS
                 Where  requestid = @RequestID
                        And [status] = 'ACCEPTED')
        Begin
            Set @ErrorCode = 1 --ALREADY REFUNDED

            Return;
        End

      If @Percentage >= 100
          Or @Percentage <= 10
        Begin
            Set @ErrorCode = 2 -- PERCENTAGE RESTRICTION

            Return;
        End

      Declare @RentID int

      Set @RentID = (Select rentalid
                     From   REFUNDREQUESTS
                     Where  requestid = @RequestID)

      Print 'rent id ' + Cast(@rentID As varchar(5))

      Declare @TOTAL decimal(18, 2)

      Set @Total = (Select amount
                    From   CARRENTAL
                    Where  rentalid = @RentID)

      Print 'total ' + Cast(@total As varchar(40))

      Declare @CardID int

      Set @CardID= (Select cardid
                    From   CARRENTAL
                    Where  rentalid = @RentID)

      Print 'card id  ' + Cast(@cardid As varchar(5))

      Declare @CardNumber varchar(16)

      Set @CardNumber = (Select cardnumber
                         From   VISACARD
                         Where  cardid = @CardID)

      Print 'card ' + Cast(@cardnumber As varchar(5))

      Update REFUNDREQUESTS
      Set    [status] = 'ACCEPTED',
             resolution = 'REFUNDED',
             accepteddate = Getdate()
      Where  requestid = @RequestID
             And rentalid = @RentID

      -- ADD AMOUNT REFUNDED COLUMN IN TABLE REFUND REQUESTS OR PERCENTAGE
      Declare @RefundedAmount decimal(18, 2)

      Set @RefundedAmount = @TOTAL * ( Cast(@Percentage As decimal(18, 2)) / 100
                                     )

      Print 'refunded : '
            + Cast(@refundedamount As varchar(40))

      Update VISACARD
      Set    balance = balance + @RefundedAmount
      Where  cardnumber = @CardNumber

      Set @ErrorCode = 0 --SUCCESS

      Print 'error code : '
            + Cast(@errorcode As varchar(5))
  End

go