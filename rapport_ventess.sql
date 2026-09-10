-- Vues SQL pour le rapport de ventes (base Chinook)
-- Projet 5 - reporting automatisé

-- Ventes par agent commercial
CREATE VIEW VueVentesParAgent AS
SELECT Employee.FirstName || ' ' || Employee.LastName AS Agent,
       SUM(Invoice.Total) AS VentesTotales
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
JOIN Employee ON Customer.SupportRepId = Employee.EmployeeId
GROUP BY EmployeeId;

-- SELECT * FROM VueVentesParAgent ORDER BY VentesTotales DESC;


-- Ventes par pays
CREATE VIEW VueVentesParPays AS
SELECT BillingCountry AS Pays,
       SUM(Invoice.Total) AS VentesTotales
FROM Invoice
GROUP BY BillingCountry;

-- top 10 : SELECT * FROM VueVentesParPays ORDER BY VentesTotales DESC LIMIT 10;


-- Morceaux les plus vendus
CREATE VIEW VueTopMorceaux AS
SELECT Track.Name AS Morceau,
       COUNT(Quantity) AS QuantiteVendue
FROM InvoiceLine
JOIN Track ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Track.Name;

-- j'ai groupé par Track.Name et pas TrackId, sinon deux morceaux
-- avec le même nom (mais des ID différents) ressortaient en double
-- SELECT * FROM VueTopMorceaux ORDER BY QuantiteVendue DESC LIMIT 10;


-- Artistes les plus vendus
CREATE VIEW VueTopArtistes AS
SELECT Artist.Name AS Artiste,
       COUNT(Quantity) AS QuantiteVendue
FROM InvoiceLine
JOIN Track ON InvoiceLine.TrackId = Track.TrackId
JOIN Album ON Track.AlbumId = Album.AlbumId
JOIN Artist ON Album.ArtistId = Artist.ArtistId
GROUP BY Artist.Name;

-- SELECT * FROM VueTopArtistes ORDER BY QuantiteVendue DESC LIMIT 5;


-- Ventes par produit sur le dernier trimestre
-- (les données Chinook s'arrêtent en 2013, donc j'ai pris
-- Q4 2013 comme "dernier trimestre" plutôt qu'une date glissante)
CREATE VIEW VueVentesParProduitDernierTrimestre AS
SELECT Track.Name AS Produit,
       SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) AS Recettes,
       COUNT(*) AS NombreVentes
FROM InvoiceLine
JOIN Invoice ON InvoiceLine.InvoiceId = Invoice.InvoiceId
JOIN Track ON InvoiceLine.TrackId = Track.TrackId
WHERE Invoice.InvoiceDate BETWEEN '2013-10-01' AND '2013-12-31'
GROUP BY Track.Name;

-- SELECT * FROM VueVentesParProduitDernierTrimestre ORDER BY Recettes DESC LIMIT 10;
