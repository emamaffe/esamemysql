-- Creo la tabella Category
CREATE TABLE Category (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL
);

-- Creo la tabella Product
CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    CategoryID INT NOT NULL,
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);

-- Creo la tabella Region
CREATE TABLE Region (
    RegionID INT PRIMARY KEY,
    RegionName VARCHAR(100) NOT NULL
);

-- Creo la tabella Sales
CREATE TABLE Sales (
    SalesID INT PRIMARY KEY,
    ProductID INT NOT NULL,
    RegionID INT NOT NULL,
    SalesAmount DECIMAL(10, 2) NOT NULL,
    SalesDate DATE NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (RegionID) REFERENCES Region(RegionID)
);

-- Popolo la tabella Category
INSERT INTO Category (CategoryID, CategoryName)
VALUES 
(1, 'Giocattoli'),
(2, 'Elettronica'),
(3, 'Abbigliamento');

-- Popolo la tabella Product
INSERT INTO Product (ProductID, ProductName, CategoryID)
VALUES 
(1, 'Macchinina', 1),
(2, 'Tablet', 2),
(3, 'T-shirt', 3),
(4, 'Robot', 1),
(5, 'Laptop', 2);

-- Popolo della tabella Region
INSERT INTO Region (RegionID, RegionName)
VALUES 
(1, 'Europa'),
(2, 'America'),
(3, 'Asia');

-- Popolo la tabella Sales
INSERT INTO Sales (SalesID, ProductID, RegionID, SalesAmount, SalesDate)
VALUES 
(1, 1, 1, 100.50, '2023-01-10'),
(2, 1, 2, 200.00, '2023-02-15'),
(3, 2, 1, 300.00, '2023-01-20'),
(4, 2, 3, 150.00, '2023-03-12'),
(5, 3, 2, 50.00, '2023-02-20'),
(6, 4, 1, 400.00, '2023-04-01'),
(7, 5, 3, 250.00, '2023-05-15');


-- Verifichiamo le PK su ciascuna tabella(utilizzando un count, si capisce dunque che se non ci sono risultati, le pk sono univoche)
SELECT SalesID FROM Sales GROUP BY SalesID HAVING COUNT(*) > 1;
SELECT ProductID FROM Product GROUP BY ProductID HAVING COUNT(*) > 1;
SELECT RegionID FROM Region GROUP BY RegionID HAVING COUNT(*) > 1;
SELECT CategoryID FROM Category GROUP BY CategoryID HAVING COUNT(*) > 1;


-- qui, esponiamo l'elenco dei soli prodotti venduti e il fatturato totale per anno.
SELECT 
    P.ProductName,
    YEAR(S.SalesDate) AS Year,
    SUM(S.SalesAmount) AS TotalRevenue
FROM Sales S
JOIN Product P ON S.ProductID = P.ProductID
GROUP BY P.ProductName, YEAR(S.SalesDate)
ORDER BY Year, P.ProductName;

-- qui esponiamo il fatturato totale di ogni stato per anno.
SELECT 
    R.RegionName,
    YEAR(S.SalesDate) AS Year,
    SUM(S.SalesAmount) AS TotalRevenue
FROM Sales S
JOIN Region R ON S.RegionID = R.RegionID
GROUP BY R.RegionName, YEAR(S.SalesDate)
ORDER BY Year, TotalRevenue DESC;


-- qui abbiamo la categoria di articoli maggiormente richiesta sul mercato 
SELECT 
    C.CategoryName,
    COUNT(S.SalesID) AS TotalSales
FROM Sales S
JOIN Product P ON S.ProductID = P.ProductID
JOIN Category C ON P.CategoryID = C.CategoryID
GROUP BY C.CategoryID, C.CategoryName
ORDER BY TotalSales DESC
LIMIT 1;

-- adesso, volendo utilizzare un secondo approccio, identifichiamo i prodotti che non compaiono in alcuna transazione di vendita, utilizzando una subquery
SELECT 
    P.ProductName
FROM Product P
WHERE P.ProductID NOT IN (
    SELECT DISTINCT S.ProductID FROM Sales S
);
-- nessun prodotto è comparso nella query, significa che "questo prodotto", non è stato venduto.


-- adesso utilizziamo come approccio, una left join con una condizione where 
SELECT 
    P.ProductName
FROM Product P
LEFT JOIN Sales S ON P.ProductID = S.ProductID
WHERE S.ProductID IS NULL;
-- si può notare, che il risultato tra i due approcci, coincide.



-- qui poi, mostriamo l'ultima data di vendita di ciascun prodotto
SELECT 
    P.ProductName,
    MAX(S.SalesDate) AS LastSaleDate
FROM Sales S
JOIN Product P ON S.ProductID = P.ProductID
GROUP BY P.ProductID, P.ProductName
ORDER BY LastSaleDate DESC;

