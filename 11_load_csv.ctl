-- =====================================================
-- ARCHIVO: 11_load_csv.ctl
-- PROPOSITO: Archivo de control para SQL*Loader
-- AUTOR: Daniel Arevalo - Alex Hernandez
-- FECHA: Junio 2025
-- =====================================================

LOAD DATA
INFILE 'nuevo_vehiculos.csv'
INTO TABLE TMP_CRAIGSLIST_VEHICLES
REPLACE
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
   ID,
   URL,
   REGION,
   REGION_URL,
   PRICE,
   YEAR_DATA "DECODE(:YEAR_DATA, '', NULL, :YEAR_DATA)",
   MANUFACTURER,
   MODEL,
   CONDITION,
   CYLINDERS,
   FUEL,
   ODOMETER "DECODE(:ODOMETER, '', NULL, :ODOMETER)",
   TITLE_STATUS,
   TRANSMISSION,
   VIN,
   DRIVE,
   SIZE_DATA,
   TYPE_DATA,
   PAINT_COLOR,
   IMAGE_URL,
   DESCRIPTION_DATA,
   COUNTRY,
   STATE_DATA,
   LAT "DECODE(:LAT, '', NULL, :LAT)",
   LONGITUDE "DECODE(:LONGITUDE, '', NULL, :LONGITUDE)",
   POSTING_DATE
)
