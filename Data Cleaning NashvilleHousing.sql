--Cleaning Data in SQL Queries

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

--Standardize Data Format

UPDATE PortfolioProject..NashvilleHousing
SET SaleDate = Cast(SaleDate AS Date)

SELECT SaleDate 
FROM PortfolioProject..NashvilleHousing

----------------------------------------------------------------------

-- Populate Property Address Data
-- SINCE THE PARCEL ID IS SAME FOR SAME PROPERTY ADDRESS, WE USE THAT AS A JOIN COMDITION TO POPULATE OUR DATA. WE CAN ALSO JUST UPDATE WITH 'NO ADDRESS' IF WE WANT

SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing
WHERE PropertyAddress IS Null

SELECT a.uniqueid,a.parcelid,a.propertyaddress,b.uniqueid,b.parcelid,b.propertyaddress
FROM PortfolioProject..NashvilleHousing a JOIN PortfolioProject..NashvilleHousing b ON a.parcelid=b.parcelid AND a.uniqueid!=b.uniqueid
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.propertyaddress,b.propertyaddress)
FROM PortfolioProject..NashvilleHousing a JOIN PortfolioProject..NashvilleHousing b ON a.parcelid=b.parcelid AND a.uniqueid!=b.uniqueid
WHERE a.PropertyAddress IS NULL

----------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address,City,State)
-- FIRST WE ARE ALTERING PROPERTY ADDRESS INTO INDIVIDUAL COLUMNS

SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing

-- TO ADD INTO THE TABLE, WE NEED TO CREATE TWO DIFFERENT COLUMNS. WE CAN'T SEPERATE TWO VALUES FROM NE COLUMN WITHOUT CREATING TWO DIFFERENT TABLES

ALTER TABLE PortfolioProject..NashvilleHousing
ADD PropertySplitAddress Nvarchar(255)

UPDATE PortfolioProject..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1 , CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE PortfolioProject..NashvilleHousing
ADD PropertySplitCity Nvarchar(255)

UPDATE PortfolioProject..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

SELECT PropertySplitAddress,PropertySplitCity
FROM PortfolioProject..NashvilleHousing

--TO DO IT FOR THREE COLUMNS, WE USE PARSENAME FUNCTION
--WE ARE NOW ALTERING OWNER NAME INTO INDIVIDUAL COLUMNS

ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255)

UPDATE PortfolioProject..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerSplitCity Nvarchar(255)

UPDATE PortfolioProject..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerSplitState Nvarchar(255)

UPDATE PortfolioProject..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT OwnerSplitAddress,OwnerSplitCity, OwnerSplitState
FROM PortfolioProject..NashvilleHousing

------------------------------------------------------------------------
-- CHANGE Y AND N AS YES AND NO IN 'SOLD AS VACANT' FIELD

SELECT DISTINCT(SoldAsVacant),Count(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY SoldAsVacant

UPDATE PortfolioProject..NashvilleHousing
SET SoldAsVacant = (CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
					     WHEN SoldAsVacant = 'N' THEN 'No'
						 ELSE SoldAsVacant
						 END)

------------------------------------------------------------------------

--REMOVE DUPLICATES

WITH RowNumCTE 
AS
(
SELECT *,ROW_NUMBER() OVER (PARTITION BY ParcelID,
										 PropertyAddress,
										 SalePrice,
										 SaleDate,
										 LegalReference
							ORDER BY UniqueID) as row_num

FROM PortfolioProject..NashvilleHousing 

)

DELETE
FROM RowNumCTE
WHERE row_num>1

---------------------------------------------------------------------------------

--DELETE UNUSED COLUMNS

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress,PropertyAddress,SaleDate,TaxDistrict

SELECT *
FROM PortfolioProject..NashvilleHousing


--------------------------------------------------------------------------------