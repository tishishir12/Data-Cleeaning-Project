Select *
FROM PortfolioProject..NashvilleHousing

--Standerizing the date format
Select SaleDateConverted, CONVERT(Date,SaleDate)
FROM PortfolioProject..NashvilleHousing

Update NashvilleHousing
set SaleDate = CONVERT(Date, SaleDate)

Alter Table NashvilleHousing
Add saleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)  

--Populate property address data

SELECT PropertyAddress
From PortfolioProject..NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

Select x.PropertyAddress, x.ParcelID, y.PropertyAddress, y.ParcelID,
ISNULL(x.PropertyAddress,y.PropertyAddress)
From PortfolioProject..NashvilleHousing x
Join PortfolioProject..NashvilleHousing y
on x.ParcelID = y.ParcelID
AND x.[UniqueID ] <> y.[UniqueID ]
Where y.PropertyAddress is null

UPDATE x
SET PropertyAddress = ISNULL(x.PropertyAddress,y.PropertyAddress)
FROM PortfolioProject..NashvilleHousing x
Join PortfolioProject..NashvilleHousing y
on x.ParcelID = y.ParcelID
AND x.[UniqueID ] <> y.[UniqueID ]
Where x.PropertyAddress is null

--Breaking out address INTO Individual Columns (Address, City, State)

SELECT PropertyAddress
From PortfolioProject..NashvilleHousing

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))as Address
From PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter Table NashvilleHousing
Add PropertySpiltCity Nvarchar(255);

Update NashvilleHousing
SET PropertySpiltCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

Select *
From PortfolioProject.. NashvilleHousing
  
  Select OwnerAddress
  From PortfolioProject..NashvilleHousing

  Select 
  PARSENAME(Replace (OwnerAddress, ',','.') ,3),
    PARSENAME(Replace (OwnerAddress, ',','.') ,2),
	  PARSENAME(Replace (OwnerAddress, ',','.') ,1)
  From PortfolioProject..NashvilleHousing

  
Alter Table NashvilleHousing
Add PropertySpiltCity Nvarchar(255);

Update NashvilleHousing
SET PropertySpiltCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

Select *
From PortfolioProject.. NashvilleHousing
  
  Select OwnerAddress
  From PortfolioProject..NashvilleHousing


  ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(Replace (OwnerAddress, ',','.') ,3)

Alter Table NashvilleHousing
Add OwnerSpiltCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSpiltCity =PARSENAME(Replace (OwnerAddress, ',','.') ,2)

Alter Table NashvilleHousing
Add OwnerSpiltState Nvarchar(255);

Update NashvilleHousing
SET OwnerSpiltState =PARSENAME(Replace (OwnerAddress, ',','.') ,1)

Select *
From PortfolioProject.. NashvilleHousing
  

  --Changing y and n to yes and no in vegant field.
  Select Distinct(SoldAsVacant), Count(SoldAsVacant)
  From PortfolioProject..NashvilleHousing
  Group by SoldAsVacant
  Order by 2

  Select SoldAsVacant
  CASE When SoldAsVacant = 'y' THEN 'YES'
       When SoldAsVacant = 'N' THEN 'NO'
	   Else SoldAsVacant
	   END
  FROM PortfolioProject..NashvilleHousing 
 

 Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

	   --Removing the duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice, 
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject..NashvilleHousing
)
Select * 
From RowNumCTE
Where row_num > 1
Order By PropertyAddress

--Delete Unsed Column

Select *
from PortfolioProject..NashvilleHousing

Alter TABLE PortfolioProject..NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress


Alter TABLE PortfolioProject..NashvilleHousing
Drop Column SaleDate
