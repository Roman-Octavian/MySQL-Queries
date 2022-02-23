# 1. Show the members under the name "Jens S." who were born before 1970 that became members of the library in 2013.
SELECT * FROM tmember
WHERE cName = 'Jens S.' AND dBirth < '1970-01-01' AND dNewMember < '2014-01-01' AND dNewMember >= '2013-01-01';

# 2. Show those books that have not been published by the publishing companies with ID 15 and 32, except if they were published before 2000.
SELECT * FROM tbook WHERE
(nPublishingCompanyID > 0 AND nPublishingCompanyID < 14) OR
(nPublishingCompanyID = 15 AND nPublishingYear < 2000) OR
(nPublishingCompanyID > 16 AND tbook.nPublishingCompanyID < 32) OR
(nPublishingCompanyID = 32 AND nPublishingYear < 2000) OR
(nPublishingCompanyID > 32);

# 3. Show the name and surname of the members who have a phone number, but no address.
SELECT cName, cSurname FROM tmember WHERE cPhoneNo IS NOT NULL AND cAddress IS NULL;

# 4. Show the authors with surname "Byatt" whose name starts by an "A" (uppercase) and contains an "S" (uppercase).
SELECT * FROM tauthor WHERE cSurname = 'Byatt' AND LEFT(cName, 1) = 'A' AND cName LIKE '%S%';

# 5. Show the number of books published in 2007 by the publishing company with ID 32.
SELECT COUNT(*) FROM tbook WHERE nPublishingCompanyID = 32;

# 6. For each day of the year 2014, show the number of books loaned by the member with CPR "0305393207".
SELECT dLoan, COUNT(*) AS "# of Books Loaned"
FROM tloan
WHERE cCPR = 0305393207 AND dLoan < '2015-01-01' AND dLoan >= '2014-01-01'
GROUP BY dLoan;

# 7. Modify the previous clause so that only those days where the member was loaned more than one book appear.
SELECT dLoan, COUNT(*) AS "# of Books Loaned"
FROM tloan
WHERE cCPR = 0305393207 AND dLoan < '2015-01-01' AND dLoan >= '2014-01-01'
GROUP BY dLoan
HAVING COUNT(*) > 1;

# 8. Show all library members from the newest to the oldest. Those who became members on the same day will be sorted alphabetically (by surname and name) within that day.
SELECT * FROM tmember ORDER BY dNewMember DESC, cName, cSurname;

# 9. Show the title of all books published by the publishing company with ID 32 along with their theme or themes.
SELECT tbook.cTitle, tbooktheme.nThemeID
FROM tbook
INNER JOIN tbooktheme ON tbooktheme.nBookID = tbook.nBookID
WHERE nPublishingCompanyID = 32;

# 10. Show the name and surname of every author along with the number of books authored by them, but only for authors who have registered books on the database.
SELECT cName, cSurname, COUNT(*) AS "# of Books Authored"
FROM tauthorship
INNER JOIN tbook USING (nBookID)
INNER JOIN tauthor USING (nAuthorID) GROUP BY tauthor.nAuthorID;

# 11. Show the name and surname of all the authors with published books along with the lowest publishing year for their books.
SELECT tauthor.cName, tauthor.cSurname, MIN(tbook.nPublishingYear) AS LPY
FROM tauthor
INNER JOIN tauthorship ON tauthor.nAuthorID = tauthorship.nAuthorID
INNER JOIN tbook ON tauthorship.nBookID = tbook.nBookID
GROUP BY tauthor.cName;

# 12. For each signature and loan date, show the title of the corresponding books and the name and surname of the member who had them loaned.
SELECT cSignature, dLoan, cTitle, cName, cSurname
FROM tloan
INNER JOIN tbookcopy USING (cSignature)
INNER JOIN tbook USING (nBookID)
INNER JOIN tmember USING (cCPR)
ORDER BY dLoan DESC;

# 13. Repeat exercises 9 to 12 using the modern JOIN notation.
# As no notation had been specified previously, to my limited understanding, I already did.

# 14. Show all theme names along with the titles of their associated books. All themes must appear (even if there are no books for some particular themes). Sort by theme name.
SELECT ttheme.cName, tbook.cTitle
FROM ttheme
LEFT OUTER JOIN tbooktheme ON ttheme.nThemeID = tbooktheme.nThemeID
LEFT OUTER JOIN tbook ON tbooktheme.nBookID = tbook.nBookID
ORDER BY ttheme.cName;

# 15. Show the name and surname of all members who joined the library in 2013 along with the title of the books they took on loan during that same year. All members must be shown, even if they did not take any book on loan during 2013. Sort by member surname and name.
SELECT tmember.cName, tmember.cSurname, tbook.cTitle
FROM tmember
LEFT OUTER JOIN tloan ON tmember.cCPR = tloan.cCPR
LEFT OUTER JOIN tbookcopy ON tloan.cSignature = tbookcopy.cSignature
LEFT OUTER JOIN tbook ON tbookcopy.nBookID = tbook.nBookID
WHERE tmember.dNewMember < '2014-01-01' AND tmember.dNewMember >= '2013-01-01'
ORDER BY tmember.cSurname, tmember.cName;

# 16. Show the name and surname of all authors along with their nationality or nationalities and the titles of their books. Every author must be shown, even though s/he has no registered books. Sort by author name and surname.
SELECT tauthor.cName, tauthor.cSurname, tcountry.cName, tbook.cTitle
FROM tauthor
LEFT OUTER JOIN tnationality ON tauthor.nAuthorID = tnationality.nAuthorID
LEFT OUTER JOIN tcountry ON tnationality.nCountryID = tcountry.nCountryID
LEFT OUTER JOIN tauthorship ON tauthor.nAuthorID = tauthorship.nAuthorID
LEFT OUTER JOIN tbook on tauthorship.nBookID = tbook.nBookID
ORDER BY tauthor.cName, tauthor.cSurname;

# 17. Show the title of those books which have had different editions published in both 1970 and 1989.
SELECT tbook.cTitle
FROM tbook
WHERE nPublishingYear = 1970 OR nPublishingYear = 1989
GROUP BY cTitle
HAVING COUNT(tbook.nPublishingYear ) > 1;

# 18. Show the surname and name of all members who joined the library in December 2013 followed by the surname and name of those authors whose name is “William”.
SELECT tmember.cSurname, tmember.cName, tauthor.cName, tauthor.cSurname
FROM tmember
JOIN tauthor
WHERE tmember.dNewMember < '2014-01-01' AND tmember.dNewMember >= '2014-12-01' OR tauthor.cName = 'William';

# 19. Show the name and surname of the first chronological member of the library using subqueries.
SELECT tmember.cName, tmember.cSurname
FROM tmember
WHERE dNewMember = (SELECT MIN(dNewMember) FROM tmember);

-- Without subqueries would be:
SELECT tmember.cName, tmember.cSurname
FROM tmember
ORDER BY dNewMember LIMIT 1;

# 20. For each publishing year, show the number of book titles published by publishing companies from countries that constitute the nationality for at least three authors. Use subqueries
SELECT nPublishingYear, COUNT(*)
FROM tbook
LEFT JOIN tpublishingcompany USING (nPublishingCompanyID)
LEFT JOIN (SELECT nCountryID, COUNT(*)
            FROM tauthor
            LEFT JOIN tnationality USING (nAuthorID)
            GROUP BY nCountryID
            HAVING COUNT(*) >= 3) c
ON c.nCountryID=tpublishingcompany.nCountryID
GROUP BY nPublishingYear
ORDER BY nPublishingYear;


# 21. Show the name and country of all publishing companies with the headings "Name" and "Country".
SELECT tpublishingcompany.cName AS Name, tcountry.cName AS Country
FROM tpublishingcompany
INNER JOIN tcountry ON tpublishingcompany.nCountryID = tcountry.nCountryID;

# 22. Show the titles of the books published between 1926 and 1978 that were not published by the publishing company with ID 32.
SELECT tbook.cTitle
FROM tbook
WHERE nPublishingCompanyID != 32 AND nPublishingYear >= 1926 AND nPublishingYear <= 1978;

# 23. Show the name and surname of the members who joined the library after 2016 and have no address.
SELECT tmember.cName, tmember.cSurname
FROM tmember
WHERE dNewMember >= '2017-01-01' AND cAddress IS NULL;

# 24. Show the country codes for countries with publishing companies. Exclude repeated values.
SELECT DISTINCT tcountry.nCountryID
FROM tcountry, tpublishingcompany
WHERE tcountry.nCountryID = tpublishingcompany.nCountryID;

# 25. Show the titles of books whose title starts by "The Tale" and that are not published by "Lynch Inc".
SELECT tbook.cTitle
FROM tbook
JOIN tpublishingcompany USING (nPublishingCompanyID)
WHERE cTitle LIKE 'The Tale%'
AND tbook.nPublishingCompanyID !=
    (SELECT DISTINCT tpublishingcompany.nPublishingCompanyID
    FROM tpublishingcompany
    WHERE tpublishingcompany.cName= 'Lynch Inc');

# 26. Show the list of themes for which the publishing company "Lynch Inc" has published books, excluding repeated values.
SELECT DISTINCT ttheme.cName
FROM ttheme
INNER JOIN tbooktheme USING (nThemeID)
INNER JOIN tbook USING (nBookID)
INNER JOIN tpublishingcompany USING (nPublishingCompanyID)
WHERE tpublishingcompany.cName = 'Lynch Inc';

# 27. Show the titles of those books which have never been loaned.
SELECT DISTINCT tbook.cTitle
FROM tbook
LEFT OUTER JOIN tbookcopy USING (nBookID)
LEFT OUTER JOIN tloan ON tbookcopy.cSignature = tloan.cSignature
WHERE tloan.dLoan IS NULL;

# 28. For each publishing company, show its number of existing books under the heading "No. of Books".
SELECT tpublishingcompany.cName, COUNT(*) AS 'No. of Books'
FROM tbook
INNER JOIN tpublishingcompany USING (nPublishingCompanyID)
GROUP BY tpublishingcompany.cName;

# 29. Show the number of members who took some book on a loan during 2013.
SELECT COUNT(*) AS 'No. Members w/ loan'
FROM tmember
INNER JOIN tloan USING (cCPR)
WHERE dLoan < '2014-01-01' AND dLoan >= '2013-01-01';

# 30. For each book that has at least two authors, show its title and number of authors under the heading "No. of Authors".
SELECT tbook.cTitle, COUNT(tauthorship.nAuthorID) AS 'No. of Authors'
FROM tbook
INNER JOIN tauthorship USING (nBookID)
GROUP BY cTitle
HAVING COUNT(*) > 1;