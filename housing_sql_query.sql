Select * From sample.dbo.Housing;


**********************************************************

-- Convert Datatype of SaleDate to Date Format

Select saleDate_, CONVERT(Date,SaleDate)
From sample.dbo.Housing;

ALTER TABLE Housing
Add SaleDate_ Date;

Update Housing
SET SaleDate_ = CONVERT(Date,SaleDate);

ALTER TABLE Housing
DROP COLUMN SaleDate;


***********************************************
-- Populate column Property Address data with help of column ParcelId

Select * From sample.dbo.Housing
Where PropertyAddress is null;



Update a SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From sample.dbo.Housing a
JOIN sample.dbo.Housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


****************************************************************
-- Property and owner address can be slipt in different columns (Address, city , state)

select PropertyAddress from sample.dbo.Housing;


ALTER TABLE Housing 
ADD P_Address VARCHAR(50),P_City VARCHAR(50);

Update Housing
SET P_Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 );

Update Housing
SET P_City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress));

************************************************************************

select OwnerAddress from sample.dbo.Housing;

ALTER TABLE Housing 
ADD O_Address VARCHAR(50),O_City VARCHAR(50), O_State VARCHAR(50);


Update Housing
SET O_Address = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3);

Update Housing
SET O_City = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2);

Update Housing
SET O_State = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1);

******************************************************************************************

-- In SoldasVacant column there are Y, N, Yes, No as distinct data change to only two value.

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) 
FROM sample.dbo.housing group by SoldAsVacant;

Update housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
END;
********************************************************************************************
--Delete the duplicate value in ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference

DELETE FROM sample.dbo.housing
WHERE UniqueID NOT IN (
    SELECT MIN(UniqueID)
    FROM sample.dbo.housing
    GROUP BY ParcelID, PropertyAddress, SalePrice, SaleDate_, LegalReference);


ALTER TABLE sample.dbo.housing
DROP COLUMN OwnerAddress, PropertyAddress;

*********************************************************************************************



Select * From sample.dbo.Housing;