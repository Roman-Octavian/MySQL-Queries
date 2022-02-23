# 1. How many songs are there in the playlist “Grunge”?
SELECT COUNT(*) AS 'Grunge Songs Amount'
FROM playlisttrack
WHERE TrackId = 16;

# 2. Show information about artists whose name includes the text “Jack” and about artists whose name includes the text “John”, but not the text “Martin”.
SELECT * FROM artist
WHERE (Name LIKE '%Jack%' AND Name NOT LIKE '%Martin%')
   OR (Name LIKE '%John%' AND Name NOT LIKE '%Martin%');

# 3. For each country where some invoice has been issued, show the total invoice monetary amount, but only for countries where at least $100 have been invoiced. Sort the information from higher to lower monetary amount.
SELECT invoice.BillingCountry, SUM(Total) AS Total FROM invoice
GROUP BY BillingCountry
HAVING SUM(TOTAL) >= 100;

# 4. Get the phone number of the boss of those employees who have given support to clients who have bought some song composed by “Miles Davis” in “MPEG Audio File” format.
SELECT DISTINCT employee.Phone FROM employee
JOIN customer ON employee.EmployeeId = customer.SupportRepId
JOIN invoice ON customer.CustomerId = invoice.CustomerId
JOIN invoiceline ON invoice.InvoiceId = invoiceline.InvoiceId
JOIN track ON invoiceline.TrackId = track.TrackId
JOIN mediatype ON track.MediaTypeId = mediatype.MediaTypeId
WHERE track.MediaTypeId = 1 AND track.Composer = 'Miles Davis'; -- 2

SELECT employee.Phone FROM employee WHERE EmployeeId = 2;

# 5.Show the information, without repeated records, of all albums that feature songs of the “Bossa Nova” genre whose title starts by the word “Samba”.
SELECT DISTINCT * FROM album
INNER JOIN track ON album.AlbumId = track.AlbumId
INNER JOIN genre ON track.GenreId = genre.GenreId
WHERE album.Title LIKE 'Samba%' AND genre.Name = 'Bossa Nova';

# 6. For each genre, show the average length of its songs in minutes (without indicating seconds). Use the headers “Genre” and “Minutes”, and include only genres that have any song longer than half an hour.
SELECT genre.Name AS Genre, FLOOR(AVG(track.Milliseconds / 60000)) AS Minutes
FROM genre
JOIN track ON genre.GenreId = track.GenreId
GROUP BY genre.Name
HAVING AVG((track.Milliseconds / 60000) > 30);

# 7. How many client companies have no state?
SELECT COUNT(customer.Company) AS count
FROM customer
WHERE customer.State IS NULL;

# 8. For each employee with clients in the “USA”, “Canada” and “Mexico” show the number of clients from these countries s/he has given support, only when this number is higher than 6. Sort the query by number of clients. Regarding the employee, show his/her first name and surname separated by a space. Use “Employee” and “Clients” as headers.
SELECT CONCAT(employee.FirstName, ' ', employee.LastName) AS Employee,
       COUNT(customer.Country) AS Clients
FROM employee
JOIN customer ON employee.EmployeeId = customer.SupportRepId
WHERE customer.Country = 'USA' OR customer.Country = 'Canada' OR customer.Country = 'Mexico'
GROUP BY employee
HAVING Clients > 6
ORDER BY Clients;

# 9. For each client from the “USA”, show his/her surname and name (concatenated and separated by a comma) and their fax number. If they do not have a fax number, show the text “S/he has no fax”. Sort by surname and first name.
SELECT CONCAT(customer.LastName, ',', customer.FirstName) AS FullName,
       IFNULL(Customer.Fax, 's/he has no fax') AS Fax
FROM Customer
WHERE Customer.Country = 'USA'
ORDER BY FullName;

# 10. For each employee, show his/her first name, last name, and their age at the time they were hired.
SELECT employee.FirstName, employee.LastName, TIMESTAMPDIFF(YEAR, employee.BirthDate, employee.HireDate) AS AgeWhenHired
FROM employee
ORDER BY FirstName;