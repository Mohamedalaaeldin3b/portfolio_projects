use nashville_housing 
go

select top 100* 
from nashville_housing

------------------------------------------------------------------

-- SaleDate -- 

alter table nashville_housing
add SaleYear int

update nashville_housing
set SaleYear = year(SaleDate)

alter table nashville_housing
add SaleMonth smallint

update nashville_housing
set SaleMonth = month(SaleDate)

------------------------------------------------------------------

                                 -- Handling Null Values --

-- Checking ParcelID Column

select ParcelID
from nashville_housing
where ParcelID is null

							     -- LandUse Column -- 

select LandUse
from nashville_housing
where ParcelID is null

                                 -- PropertyAddress Column --

select PropertyAddress
from nashville_housing
where PropertyAddress is null

select ParcelID, PropertyAddress
from nashville_housing
where ParcelID is null or PropertyAddress is null

select * 
from nashville_housing
where ParcelID = '052 01 0 296.00' or 
      ParcelID = '093 08 0 054.00'

select a.ParcelID, a.PropertyAddress, b.PropertyAddress, b.ParcelID, isnull(a.PropertyAddress, b.PropertyAddress)
from nashville_housing a
join nashville_housing b on
	a.ParcelID = b.ParcelID and 
	a.UniqueID <> b.UniqueID 
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from nashville_housing a
join nashville_housing b on
	a.ParcelID = b.ParcelID and 
	a.UniqueID <> b.UniqueID 

select 
substring(PropertyAddress, 1, charindex(',', PropertyAddress)-1) as Address,
substring(PropertyAddress, charindex(',', PropertyAddress)+1, len(PropertyAddress)) as City
from nashville_housing
order by City 

-- Owner Address Column

-- splitting it into 3 parts 

select parsename(replace(OwnerAddress, ',', '.'), 3),
       parsename(replace(OwnerAddress, ',', '.'), 2),
	   parsename(replace(OwnerAddress, ',', '.'), 1)
from nashville_housing



alter table nashville_housing
add Owner_Address varchar(100), 
    Owner_City varchar(50),
	Owner_State varchar(50)

update nashville_housing
set Owner_Address = parsename(replace(OwnerAddress, ',', '.'), 3),
    Owner_City = parsename(replace(OwnerAddress, ',', '.'), 2),
	Owner_State = parsename(replace(OwnerAddress, ',', '.'), 1)
     
Alter Table nashville_housing 
Drop Column OwnerAddress


-- SoldAsVacant Column
-- Checking for unexpected values  

select distinct(SoldAsVacant)
from nashville_housing




-- Dropping Duplicates 

with cte as ( 
	select UniqueID,
	       ParcelID,
		   LandUse,
           PropertyAddress,
		   SalePrice, 
		   SaleDate,
		   LegalReference,
		   SoldAsVacant,
		   OwnerName,
		   Acreage,
		   TaxDistrict, 
		   LandValue, 
		   BuildingValue,
		   ROW_NUMBER() over (
				partition by ParcelID,
					         PropertyAddress,
							 SalePrice, 
							 SaleDate,
							 LegalReference 

				order by ParcelID,
					         PropertyAddress,
							 SalePrice, 
							 SaleDate,
							 LegalReference
					 ) row_num
	from nashville_housing.dbo.nashville_housing
)

select * 
from cte 
where row_num > 1 
order by PropertyAddress




