CREATE DATABASE IF NOT EXISTS MusicStore;
USE MusicStore;

CREATE TABLE IF NOT EXISTS Gener(
Genre_id INT NOT NULL,
Gname VARCHAR(30) NOT NULL,
PRIMARY KEY (Genre_id));

set session sql_mode = '';
LOAD DATA INFILE 
'D:/genre.csv' 
INTO TABLE Gener
FIELDS terminated by ',' 
ENCLOSED by '"' 
lines terminated by '\n'
ignore 1 rows;
SELECT * FROM Gener;

CREATE TABLE IF NOT EXISTS Employee(
Employee_id INT NOT NULL,
Last_name VARCHAR(30) NOT NULL,
First_name VARCHAR(30) NOT NULL,
Title VARCHAR(30) NOT NULL,
Reports_to VARCHAR(30) NOT NULL,
Levels VARCHAR(30) NOT NULL,
Birthdate VARCHAR(30) NOT NULL,
Hire_date VARCHAR(30) NOT NULL,
Address VARCHAR(30) NOT NULL,
City VARCHAR(30) NOT NULL,
State VARCHAR(30) NOT NULL,
Country VARCHAR(30) NOT NULL,
Postal_code VARCHAR(30) NOT NULL,
Phone VARCHAR(30) NOT NULL,
Fax	VARCHAR(30) NOT NULL,
Email VARCHAR(30) NOT NULL,
PRIMARY KEY (Employee_id));

set session sql_mode = '';
LOAD DATA INFILE 
'D:/employee.csv' 
INTO TABLE Employee
FIELDS terminated by ',' 
ENCLOSED by '"' 
lines terminated by '\n'
ignore 1 rows;
SELECT * FROM Employee;

CREATE TABLE IF NOT EXISTS Customer(
Customer_id INT NOT NULL,
First_name VARCHAR(30) NOT NULL,
Last_name VARCHAR(30) NOT NULL,
Company VARCHAR (30) NOT NULL,
Address VARCHAR(30) NOT NULL,
City VARCHAR(30) NOT NULL,
State VARCHAR(30) NOT NULL,
Country	VARCHAR(30) NOT NULL,
Postal_code	VARCHAR(30) NOT NULL,
Phone VARCHAR(30) NOT NULL,
Fax	VARCHAR(30) NOT NULL,
Email VARCHAR(30) NOT NULL,
Support_rep_id VARCHAR(30) NOT NULL,
PRIMARY KEY (Customer_id));

set session sql_mode = '';
LOAD DATA INFILE 
'D:/customer.csv' 
INTO TABLE Customer
FIELDS terminated by ',' 
ENCLOSED by '"' 
lines terminated by '\n'
ignore 1 rows;
SELECT * FROM Customer;

CREATE TABLE IF NOT EXISTS Artist(
Artist_id  INT NOT NULL,
Aname VARCHAR(30) NOT NULL,
PRIMARY KEY (Artist_id));

set session sql_mode = '';
LOAD DATA INFILE 
'D:/artist.csv' 
INTO TABLE Artist
FIELDS terminated by ',' 
ENCLOSED by '"' 
lines terminated by '\n'
ignore 1 rows;
SELECT * FROM Artist;

CREATE TABLE IF NOT EXISTS Album(
Album_id INT NOT NULL,
Title VARCHAR(30) NOT NULL,
Artist_id INT NOT NULL,
PRIMARY KEY (Album_id),
CONSTRAINT FK_Artist FOREIGN KEY (Artist_id)
REFERENCES Artist (Artist_id));

set session sql_mode = '';
LOAD DATA INFILE 
'D:/album.csv' 
INTO TABLE Album
FIELDS terminated by ',' 
ENCLOSED by '"' 
lines terminated by '\n'
ignore 1 rows;
SELECT * FROM Album;

CREATE TABLE IF NOT EXISTS Playlist(
Playlist_id	INT NOT NULL,
Pname VARCHAR(30) NOT NULL,
PRIMARY KEY (Playlist_id));

set session sql_mode = '';
LOAD DATA INFILE 
'D:/playlist.csv' 
INTO TABLE Playlist
FIELDS terminated by ',' 
ENCLOSED by '"' 
lines terminated by '\n'
ignore 1 rows;
SELECT * FROM Playlist;

CREATE TABLE IF NOT EXISTS MediaType(
Media_type_id INT NOT NULL,
Mname VARCHAR(30) NOT NULL,
PRIMARY KEY (Media_type_id));

set session sql_mode = '';
LOAD DATA INFILE 
'D:/media_type.csv' 
INTO TABLE MediaType
FIELDS terminated by ',' 
ENCLOSED by '"' 
lines terminated by '\n'
ignore 1 rows;
SELECT * FROM MediaType;

CREATE TABLE IF NOT EXISTS Invoice(
Invoice_id INT NOT NULL,
Customer_id INT NOT NULL,
Invoice_date VARCHAR(30) NOT NULL,
Billing_address VARCHAR(30) NOT NULL,
Billing_city VARCHAR(30) NOT NULL,
Billing_state VARCHAR(30) NOT NULL,
Billing_country VARCHAR(30) NOT NULL,
Billing_postal_code VARCHAR(30) NOT NULL,
Total VARCHAR(30) NOT NULL,
PRIMARY KEY (Invoice_id),
CONSTRAINT FK_CustomerInvoice FOREIGN KEY(Customer_id)
REFERENCES Customer (Customer_id) );

set session sql_mode = '';
LOAD DATA INFILE 
'D:/invoice.csv' 
INTO TABLE Invoice
FIELDS terminated by ',' 
ENCLOSED by '"' 
lines terminated by '\n'
ignore 1 rows;
SELECT * FROM Invoice;

CREATE TABLE IF NOT EXISTS InvoiceLine(
Invoice_line_id	INT NOT NULL,
Invoice_id INT NOT NULL,
Track_id INT NOT NULL,
Unit_price VARCHAR(30) NOT NULL,
Quantity VARCHAR(30) NOT NULL,
PRIMARY KEY (Invoice_line_id),
CONSTRAINT FK_InvoiceInvoiceLine FOREIGN KEY(Invoice_id)
REFERENCES Invoice (Invoice_id));

set session sql_mode = '';
LOAD DATA INFILE 
'D:/invoice_line.csv' 
INTO TABLE InvoiceLine
FIELDS terminated by ',' 
ENCLOSED by '"' 
lines terminated by '\n'
ignore 1 rows;
SELECT * FROM InvoiceLine;

CREATE TABLE IF NOT EXISTS PlaylistTrack(
Playlist_id INT NOT NULL,
Track_id INT NOT NULL,
CONSTRAINT FK_TrackPlaylist FOREIGN KEY (Track_id)
REFERENCES Track (Track_id));

set session sql_mode = '';
LOAD DATA INFILE 
'D:/playlist_track.csv' 
INTO TABLE PlaylistTrack
FIELDS terminated by ',' 
ENCLOSED by '"' 
lines terminated by '\n'
ignore 1 rows;
SELECT * FROM PlaylistTrack;

CREATE TABLE IF NOT EXISTS Track(
Track_id INT NOT NULL,
Tname VARCHAR(30) NOT NULL,
Album_id INT NOT NULL,
Media_type_id INT NOT NULL,
Genre_id INT NOT NULL,
Composer VARCHAR(30) NOT NULL,
Milliseconds VARCHAR(30) NOT NULL,
Bytes VARCHAR(30) NOT NULL,
Unit_price VARCHAR(30) NOT NULL,
PRIMARY KEY (Track_id),
CONSTRAINT FK_AlbumTrack FOREIGN KEY(Album_id) REFERENCES Album (Album_id),
CONSTRAINT FK_MediaTypeTrack FOREIGN KEY(Media_type_id) REFERENCES MediaType (Media_type_id),
CONSTRAINT FK_GenerTrack FOREIGN KEY(Genre_id) REFERENCES Gener (Genre_id));

set session sql_mode = '';
LOAD DATA INFILE 
'D:/track.csv' 
INTO TABLE Track
FIELDS terminated by ',' 
ENCLOSED by '"' 
lines terminated by '\n'
ignore 1 rows;
SELECT * FROM Track;

# 1. Who is the senior most employee based on job title?
SELECT Last_name, First_name, Title from Employee WHERE Title = 'Senior General Manager' LIMIT 1;
SELECT Last_name, First_name, Title from Employee ORDER BY LEVELS DESC LIMIT 1;

# 2. Which countries have the most Invoices?
SELECT COUNT(*) AS CountBill, Billing_country FROM Invoice GROUP BY Billing_country ORDER BY CountBill DESC;

# 3. What are top 3 values of total invoice?
SELECT Total FROM Invoice ORDER BY Total DESC LIMIT 3;

/* 4. Which city has the best customers? Write a query that returns one city that has the highest sum of
invoice totals. Return both the city name & sum of all invoice totals. */
SELECT Billing_city, SUM(Total) AS InvoiceTotal FROM Invoice 
GROUP BY Billing_city
ORDER BY InvoiceTotal DESC LIMIT 1;

/* 5. Who is the best customer? Write a query that returns the person who has spent the most money. */
SELECT Customer.Customer_id, Customer.First_name, Customer.Last_name,
SUM(Total) AS BestCustomer FROM Customer
JOIN Invoice ON Customer.Customer_id = Invoice.Customer_id
GROUP BY Customer.Customer_id, Customer.First_name, Customer.Last_name
ORDER BY BestCustomer DESC LIMIT 1;

/* 1. Write query to return the email, first name, last name, & Gener of all Rock Music listeners. Return
your list ordered alphabetically by email starting with A. */
SELECT DISTINCT Customer.First_name, Customer.Last_name, Customer.Email, Gener.Gname as Gener
FROM Customer 
JOIN Invoice ON Customer.Customer_id = Invoice.Customer_id
JOIN InvoiceLine ON Invoice.Invoice_id = InvoiceLine.Invoice_id
JOIN Track ON InvoiceLine.Track_id = Track.Track_id
JOIN Gener ON Gener.Genre_id = Track.Genre_id
WHERE UPPER(Gener.Gname) LIKE '%Rock%'
ORDER BY Customer.Email ASC;

/* 2. Write a query that returns the Artist name and total track count of the top 10 rock bands. */
SELECT Artist.Aname, COUNT(Track.Track_id) AS TotalTracks FROM Artist
JOIN Album ON Album.Artist_id = Artist.Artist_id
JOIN Track ON Track.Album_id = Album.Album_id
JOIN Gener ON Gener.Genre_id = Track.Genre_id
WHERE UPPER(Gener.Gname) LIKE '%Rock%'
GROUP BY Artist.Aname ORDER BY TotalTracks DESC LIMIT 10;

/* 3. Return all the track names that have a song length longer than the average song length. Return
the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */
SELECT Tname, Milliseconds FROM Track
WHERE Milliseconds > (SELECT AVG(Milliseconds) AS AvgTrackLength FROM Track)
ORDER BY Milliseconds DESC;

/* 1. Find how much amount spent by each customer on artists? Write a query to return customer name,
artist name and total spent. */
SELECT Customer.First_name, Customer.Last_name, Artist.Aname,
SUM(InvoiceLine.Unit_price) AS TotalSpent FROM Invoice
JOIN InvoiceLine ON Invoice.Invoice_id = InvoiceLine.Invoice_id
JOIN Track ON InvoiceLine.Track_id = Track.Track_id
JOIN Album ON Track.Album_id = Album.Album_id
JOIN Artist ON Album.Artist_id = Artist.Artist_id
JOIN Customer ON Invoice.Customer_id = Customer.Customer_id
GROUP BY Customer.First_name, Customer.Last_name, Artist.Aname
ORDER BY TotalSpent DESC;

/* 2. We want to find out the most popular music Genre for each country. We determine the most popular
genre as the genre with the highest amount of purchases. Write a query that returns each country along with
the top Genre. For countries where the maximum number of purchases is shared return all Genres */
SELECT Customer.Country, MAX(Gener.Gname) AS TopGener FROM Customer
JOIN Invoice ON Invoice.Customer_id = Customer.Customer_id
JOIN InvoiceLine ON Invoice.Invoice_id = InvoiceLine.Invoice_id
JOIN Track ON InvoiceLine.Track_id = Track.Track_id
JOIN Gener ON Track.Genre_id = Gener.Genre_id
GROUP BY Customer.Country
ORDER BY Customer.Country;

/* 3. Write a query that determines the customer that has spent the most on music for each country.
Write a query that returns the country along with the top customer and how much they spent. For countries
where the top amount spent is shared, provide all customers who spent this amount. */
WITH RECURSIVE
	TblCusWithCountry AS (
    SELECT Customer.Customer_id, Customer.First_name, Customer.Last_name, Invoice.Billing_country,
    SUM(Invoice.Total) AS TotalSpending FROM Invoice
    JOIN Customer ON Customer.Customer_id = Invoice.Customer_id
    GROUP BY 1, 2, 3, 4
    ORDER BY 2, 3 DESC),
    
    TblCountryMaxSpend AS  (
    SELECT Billing_country, MAX(TotalSpending) AS MaxSpending FROM TblCusWithCountry
    GROUP BY Billing_country)

SELECT TblCC.Billing_country, TblCC.TotalSpending, TblCC.Customer_id, TblCC.First_name, TblCC.Last_name
FROM TblCusWithCountry TblCC
JOIN TblCountryMaxSpend TblMS ON TblCC.Billing_country = TblMS.Billing_country
WHERE TblCC.TotalSpending = TblMS.MaxSpending
ORDER BY 1;