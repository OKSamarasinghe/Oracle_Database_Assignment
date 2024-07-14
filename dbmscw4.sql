
SET SERVEROUTPUT ON;

--1.	Create tables with primary key and foreign key constraints having auto-increment sequences for one of the tables.
-- Creating Publishers table

CREATE SEQUENCE pub_seq
START WITH 1
INCREMENT BY 1;

CREATE TABLE Publishers (
    PublisherID NUMBER PRIMARY KEY,
    PublisherName VARCHAR2(255) NOT NULL,
    Address VARCHAR2(255),
    Mobile VARCHAR2(20)
);

-- Creating Books table
CREATE TABLE Books (
    BookID NUMBER PRIMARY KEY,
    Title VARCHAR2(255) NOT NULL,
    Author VARCHAR2(255) NOT NULL,
    Price NUMBER(5,2) NOT NULL,
    PublisherID NUMBER,
    CONSTRAINT fk_publisher
        FOREIGN KEY (PublisherID)
        REFERENCES Publishers (PublisherID)
);

-- Creating Customers table
CREATE TABLE Customers (
    CustomerID NUMBER PRIMARY KEY,
    CustomerName VARCHAR2(255) NOT NULL,
    Email VARCHAR2(255) UNIQUE NOT NULL
);

-- Creating Orders table
CREATE TABLE Orders (
    OrderID NUMBER PRIMARY KEY,
    BookID NUMBER NOT NULL,
    CustomerID NUMBER NOT NULL,
    Quantity NUMBER NOT NULL,
    OrderDate DATE DEFAULT SYSDATE,
    CONSTRAINT fk_book
        FOREIGN KEY (BookID)
        REFERENCES Books (BookID),
    CONSTRAINT fk_customer
        FOREIGN KEY (CustomerID)
        REFERENCES Customers (CustomerID)
);

--2.	Insert a set of matching records for the above tables.
-- Inserting records into Publishers table
INSERT INTO Publishers (PublisherID, PublisherName, Address, Mobile)
VALUES (pub_seq.NEXTVAL, 'Publisher A', '123 Main St', '123-456-7890');

INSERT INTO Publishers (PublisherID, PublisherName, Address, Mobile)
VALUES (pub_seq.NEXTVAL, 'Publisher B', '456 Elm St', '456-789-0123');

INSERT INTO Publishers (PublisherID, PublisherName, Address, Mobile)
VALUES (pub_seq.NEXTVAL, 'Publisher C', '789 Oak St', '789-012-3456');

INSERT INTO Publishers (PublisherID, PublisherName, Address, Mobile)
VALUES (pub_seq.NEXTVAL, 'Publisher D', '321 Pine St', '321-654-9870');

INSERT INTO Publishers (PublisherID, PublisherName, Address, Mobile)
VALUES (pub_seq.NEXTVAL, 'Publisher E', '654 Cedar St', '654-987-0123');

select * from Publishers;

-- Inserting records into Books table
INSERT INTO Books (BookID, Title, Author, Price, PublisherID)
VALUES (1, 'Book 1', 'Author 1', 800.00, 1);

INSERT INTO Books (BookID, Title, Author, Price, PublisherID)
VALUES (2, 'Book 2', 'Author 2', 900.00, 2);

INSERT INTO Books (BookID, Title, Author, Price, PublisherID)
VALUES (3, 'Book 3', 'Author 3', 200.00, 1);

INSERT INTO Books (BookID, Title, Author, Price, PublisherID)
VALUES (4, 'Book 4', 'Author 4', 550.00, 4);

INSERT INTO Books (BookID, Title, Author, Price, PublisherID)
VALUES (5, 'Book 5', 'Author 5', 300.00, 1);

INSERT INTO Books (BookID, Title, Author, Price, PublisherID)
VALUES (6, 'Book 6', 'Author 6', 400.00, 1);

INSERT INTO Books (BookID, Title, Author, Price, PublisherID)
VALUES (7, 'Book 7', 'Author 7', 800.00, 1);



select * from Books order by BookID;





-- Inserting records into Customers table
INSERT INTO Customers (CustomerID, CustomerName, Email)
VALUES (1, 'Customer A', 'customerA@example.com');

INSERT INTO Customers (CustomerID, CustomerName, Email)
VALUES (2, 'Customer B', 'customerB@example.com');

INSERT INTO Customers (CustomerID, CustomerName, Email)
VALUES (3, 'Customer C', 'customerC@example.com');

INSERT INTO Customers (CustomerID, CustomerName, Email)
VALUES (4, 'Customer D', 'customerD@example.com');

INSERT INTO Customers (CustomerID, CustomerName, Email)
VALUES (5, 'Customer E', 'customerE@example.com');

select * from Customers;


-- Inserting records into Orders table
INSERT INTO Orders (OrderID, BookID, CustomerID, Quantity, OrderDate)
VALUES (1, 1, 1, 2, SYSDATE);

INSERT INTO Orders (OrderID, BookID, CustomerID, Quantity, OrderDate)
VALUES (2, 2, 2, 3, SYSDATE);

INSERT INTO Orders (OrderID, BookID, CustomerID, Quantity, OrderDate)
VALUES (3, 3, 3, 1, SYSDATE);

INSERT INTO Orders (OrderID, BookID, CustomerID, Quantity, OrderDate)
VALUES (4, 4, 4, 4, SYSDATE);

INSERT INTO Orders (OrderID, BookID, CustomerID, Quantity, OrderDate)
VALUES (5, 5, 5, 2, SYSDATE);

INSERT INTO Orders (OrderID, BookID, CustomerID, Quantity, OrderDate)
VALUES (6, 1, 3, 2, SYSDATE);


select * from Publishers;
select * from Books;
select * from Customers;
select * from Orders order by OrderID;

--3.	Write any three select queries using where, group by, having, and order by.
-- Select query using WHERE clause
SELECT * FROM Books WHERE Price > 500.00;

-- Select query using GROUP BY and HAVING clause
SELECT PublisherID, COUNT(BookID) AS TotalBooks
FROM Books
GROUP BY PublisherID
HAVING COUNT(BookID) > 1;

-- Select query using ORDER BY clause
SELECT * FROM Books ORDER BY Title DESC ;

--4.	Write a single-row and multiple-row subquery using the above tables.
-- Single-Row Subquery
SELECT PublisherName
FROM Publishers
WHERE PublisherID = (SELECT PublisherID FROM Books WHERE BookID = 1);

-- Multiple-Row Subquery
SELECT CustomerName
FROM Customers
WHERE CustomerID IN (SELECT CustomerID FROM Orders WHERE BookID = 1);

--5.	Create a PL/SQL block that contains a Cursor. It must have a LOOP and a suitable cursor attribute. (Hint: Refer to the note)
DECLARE
    cursor book_cursor IS
        SELECT * FROM Books;
    book_row Books%ROWTYPE;
BEGIN
    OPEN book_cursor;
    LOOP
        FETCH book_cursor INTO book_row;
        EXIT WHEN book_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Book Title: ' || book_row.Title);
    END LOOP;
    CLOSE book_cursor;
END;

--6.	Create a view using one of the tables created.
CREATE VIEW BookDetails AS
SELECT b.Title, b.Author, p.PublisherName
FROM Books b
JOIN Publishers p ON b.PublisherID = p.PublisherID;


SELECT * FROM BookDetails;


--7.	Write a PL/ SQL block to retrieve a record for specific input.
DECLARE
    v_publisher_name Publishers.PublisherName%TYPE;
    v_publisher_id Publishers.PublisherID%TYPE := &PublisherID;
BEGIN
    SELECT PublisherName INTO v_publisher_name
    FROM Publishers
    WHERE PublisherID = v_publisher_id;
    DBMS_OUTPUT.PUT_LINE('Publisher Name: ' || v_publisher_name);
END;

--8.	Write a PL/ SQL block to update a record for specific input.
DECLARE
    v_new_price Books.Price%TYPE := 780.00;
    v_book_id Books.BookID%TYPE := &BookID;
BEGIN
    UPDATE Books
    SET Price = v_new_price
    WHERE BookID = v_book_id;
    DBMS_OUTPUT.PUT_LINE('Price updated successfully.');
END;

--9.	Write a PL/ SQL block to delete a record for specific input.
DECLARE
    v_book_id Books.BookID%TYPE :=  &BOOKid;
BEGIN
    DELETE FROM Books
    WHERE BookID = v_book_id;
    DBMS_OUTPUT.PUT_LINE('Record deleted successfully.');
END;



--10.	Modify the above query to display the number of rows deleted.
DECLARE
    v_book_id Books.BookID%TYPE := &BookId;
    v_rows_deleted NUMBER;
BEGIN
    DELETE FROM Books
    WHERE BookID = v_book_id;
    v_rows_deleted := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE(v_rows_deleted || ' row(s) deleted successfully.');
END;