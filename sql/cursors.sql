/**Cursors**/

DECLARE @CarID INT
DECLARE @Revenue FLOAT

DECLARE CarCursor CURSOR FOR
    SELECT CARID FROM dbo.CAR

OPEN CarCursor

FETCH NEXT FROM CarCursor INTO @CarID

-- Loop through each car
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Calculate revenue for the current car
    SET @Revenue = (
        SELECT ISNULL(SUM(AMOUNT), 0)
        FROM dbo.CARRENTAL
        WHERE CARID = @CarID AND ISRETURNED = 1
    )

    -- Print the result
    PRINT 'CarID: ' + CAST(@CarID AS VARCHAR) + ', Revenue: ' + CAST(@Revenue AS VARCHAR)

    -- Fetch the next car ID
    FETCH NEXT FROM CarCursor INTO @CarID
END

-- Close and deallocate the cursor
CLOSE CarCursor
DEALLOCATE CarCursor


/*Cursor2*/

DECLARE @CustomerID INT
DECLARE @RentalID INT
DECLARE @TotalAmount FLOAT

-- Declare the outer cursor for the Customer table
DECLARE CustomerCursor CURSOR FOR
    SELECT CUSTOMERID FROM dbo.CUSTOMER

-- Open the outer cursor
OPEN CustomerCursor

-- Fetch the first customer ID into the variable
FETCH NEXT FROM CustomerCursor INTO @CustomerID

-- Loop through each customer
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Initialize the total amount for the current customer
    SET @TotalAmount = 0

    -- Declare the inner cursor for the rentals of the current customer
    DECLARE RentalCursor CURSOR FOR
        SELECT RENTALID
        FROM dbo.CARRENTAL
        WHERE CUSTOMERID = @CustomerID

    -- Open the inner cursor
    OPEN RentalCursor

    -- Fetch the first rental ID into the variable
    FETCH NEXT FROM RentalCursor INTO @RentalID

    -- Loop through each rental for the current customer
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Add the amount of the current rental to the total amount
        SET @TotalAmount = @TotalAmount + (
            SELECT ISNULL(AMOUNT, 0)
            FROM dbo.CARRENTAL
            WHERE RENTALID = @RentalID
        )

        -- Fetch the next rental ID
        FETCH NEXT FROM RentalCursor INTO @RentalID
    END

    -- Close and deallocate the inner cursor
    CLOSE RentalCursor
    DEALLOCATE RentalCursor

    -- Print the result for the current customer
    PRINT 'CustomerID: ' + CAST(@CustomerID AS VARCHAR) + ', Total Rental Amount: ' + CAST(@TotalAmount AS VARCHAR)

    -- Fetch the next customer ID
    FETCH NEXT FROM CustomerCursor INTO @CustomerID
END

-- Close and deallocate the outer cursor
CLOSE CustomerCursor
DEALLOCATE CustomerCursor
