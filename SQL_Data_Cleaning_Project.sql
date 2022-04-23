/*

Cleaning Data in SQL

*/

Select * 
From PortfolioProject.dbo.Nashville_Housing


----------------------------------------------------------------------------------------------------------

-- Standardize Date Format

/*
This query did not work for me

Select SaleDateConverted, CONVERT(Date, SaleDate) 
From PortfolioProject.dbo.Nashville_Housing

Update Nashville_Housing
SET SaleDate = CONVERT(Date, SaleDate)
*/

ALTER TABLE Nashville_Housing
Add SaleDateConverted Date;

Update Nashville_Housing
SET SaleDateConverted = CONVERT(Date, SaleDate)

----------------------------------------------------------------------------------------------------------

-- Populate Property Address Data

Select *
From PortfolioProject.dbo.Nashville_Housing
-- where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.Nashville_Housing a
JOIN PortfolioProject.dbo.Nashville_Housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.Nashville_Housing a
JOIN PortfolioProject.dbo.Nashville_Housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

----------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Coulumns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.Nashville_Housing

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.Nashville_Housing

ALTER TABLE Nashville_Housing
Add PropertySplitAddress Nvarchar(255);

Update Nashville_Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE Nashville_Housing
Add PropertySplitCity Nvarchar(255);

Update Nashville_Housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


Select * 
From PortfolioProject.dbo.Nashville_Housing


Select OwnerAddress
From PortfolioProject.dbo.Nashville_Housing


Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From PortfolioProject.dbo.Nashville_Housing


ALTER TABLE Nashville_Housing
Add OwnerSplitAddress Nvarchar(255);

Update Nashville_Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE Nashville_Housing
Add OwnerSplitCity Nvarchar(255);

Update Nashville_Housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE Nashville_Housing
Add OwnerSplitState Nvarchar(255);

Update Nashville_Housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

Select * 
From PortfolioProject.dbo.Nashville_Housing

----------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in " Sold as Vacant" field

Select Distinct(SoldasVacant), Count(SoldasVacant)
From PortfolioProject.dbo.Nashville_Housing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant,
CASE when SoldAsVacant = 'Y' THEN 'Yes'
	 when SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
From PortfolioProject.dbo.Nashville_Housing

Update Nashville_Housing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
						when SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
						END

----------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS (
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by UniqueID) row_num
From PortfolioProject.dbo.Nashville_Housing
-- order by ParcelID
)
DELETE
From RowNumCTE
where row_num > 1
-- Order by PropertyAddress

----------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *
From PortfolioProject.dbo.Nashville_Housing

ALTER TABLE PortfolioProject.dbo.Nashville_Housing
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict

ALTER TABLE PortfolioProject.dbo.Nashville_Housing
DROP COLUMN SaleDate
