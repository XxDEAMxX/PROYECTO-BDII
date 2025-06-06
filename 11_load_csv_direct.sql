-- =====================================================
-- SCRIPT: 11_load_csv_direct.sql
-- PROPOSITO: Cargar datos CSV directamente con SQL (alternativa a SQL*Loader)
-- AUTOR: Daniel Arevalo - Alex Hernandez
-- FECHA: Junio 2025
-- =====================================================

PROMPT ===============================================
PROMPT CARGA DIRECTA DE DATOS CSV
PROMPT ===============================================

-- Limpiar tabla temporal
TRUNCATE TABLE TMP_CRAIGSLIST_VEHICLES;

PROMPT 
PROMPT Cargando datos de muestra desde CSV...

-- Datos originales del CSV (incompletos)
INSERT INTO TMP_CRAIGSLIST_VEHICLES VALUES (
7222695916,'https://prescott.craigslist.org/cto/d/prescott-2010-ford-ranger/7222695916.html','prescott','https://prescott.craigslist.org',6000,2010,'ford','ranger','good','6 cylinders','gas',85000,'clean','manual',NULL,'4wd','mid-size','pickup','blue',NULL,'2010 Ford Ranger in good condition','maricopa','az',34.1682,-112.0962,'2023-01-15'
);

INSERT INTO TMP_CRAIGSLIST_VEHICLES VALUES (
7218891961,'https://fayar.craigslist.org/ctd/d/bentonville-2017-hyundai-elantra-se/7218891961.html','fayetteville','https://fayar.craigslist.org',11900,2017,'hyundai','elantra se','excellent','4 cylinders','gas',45000,'clean','automatic',NULL,'fwd','compact','sedan','silver',NULL,'2017 Hyundai Elantra SE in excellent condition','benton','ar',36.3729,-94.2088,'2023-02-20'
);

INSERT INTO TMP_CRAIGSLIST_VEHICLES VALUES (
7221797935,'https://keys.craigslist.org/cto/d/summerland-key-2005-excursion/7221797935.html','florida keys','https://keys.craigslist.org',21000,2015,'ford','excursion','good','8 cylinders','gas',120000,'clean','automatic',NULL,'4wd','full-size','suv','white',NULL,'2015 Ford Excursion SUV','monroe','fl',24.8341,-81.7815,'2023-03-10'
);

INSERT INTO TMP_CRAIGSLIST_VEHICLES VALUES (
7222270760,'https://worcester.craigslist.org/cto/d/west-brookfield-2002-honda-odyssey-ex/7222270760.html','worcester','https://worcester.craigslist.org',1500,2016,'honda','odyssey ex','fair','6 cylinders','gas',95000,'clean','automatic',NULL,'fwd','full-size','van','blue',NULL,'2016 Honda Odyssey EX van','worcester','ma',42.2626,-71.8023,'2023-04-05'
);

INSERT INTO TMP_CRAIGSLIST_VEHICLES VALUES (
7210384030,'https://greensboro.craigslist.org/cto/d/trinity-1965-chevrolet-truck/7210384030.html','greensboro','https://greensboro.craigslist.org',4900,2018,'chevrolet','silverado','good','8 cylinders','gas',75000,'clean','automatic',NULL,'4wd','full-size','pickup','red',NULL,'2018 Chevrolet Silverado truck','guilford','nc',36.0726,-79.7920,'2023-05-12'
);

-- DATOS MEJORADOS PARA PRUEBAS (años 2015-2024, campos completos)
INSERT ALL
  INTO TMP_CRAIGSLIST_VEHICLES VALUES (2001, 'https://example.com/2001', 'sacramento', 'https://sacramento.craigslist.org', 15000, 2018, 'toyota', 'camry', 'excellent', '4 cylinders', 'gas', 45000, 'clean', 'automatic', 'ABC123456789', 'fwd', 'mid-size', 'sedan', 'white', 'https://example.com/image1.jpg', 'Excellent 2018 Toyota Camry', 'sacramento', 'ca', 38.5816, -121.4944, '2023-01-15')
  INTO TMP_CRAIGSLIST_VEHICLES VALUES (2002, 'https://example.com/2002', 'denver', 'https://denver.craigslist.org', 22000, 2020, 'ford', 'f-150', 'good', '8 cylinders', 'gas', 25000, 'clean', 'automatic', 'DEF987654321', '4wd', 'full-size', 'pickup', 'blue', 'https://example.com/image2.jpg', 'Great 2020 Ford F-150', 'denver', 'co', 39.7392, -104.9903, '2023-02-20')
  INTO TMP_CRAIGSLIST_VEHICLES VALUES (2003, 'https://example.com/2003', 'miami', 'https://miami.craigslist.org', 18500, 2019, 'honda', 'civic', 'like new', '4 cylinders', 'gas', 12000, 'clean', 'manual', 'GHI456789123', 'fwd', 'compact', 'sedan', 'red', 'https://example.com/image3.jpg', 'Low mileage 2019 Honda Civic', 'miami-dade', 'fl', 25.7617, -80.1918, '2023-03-10')
  INTO TMP_CRAIGSLIST_VEHICLES VALUES (2004, 'https://example.com/2004', 'seattle', 'https://seattle.craigslist.org', 35000, 2021, 'tesla', 'model 3', 'excellent', NULL, 'electric', 8000, 'clean', 'automatic', 'JKL789123456', 'rwd', 'mid-size', 'sedan', 'black', 'https://example.com/image4.jpg', 'Electric 2021 Tesla Model 3', 'king', 'wa', 47.6062, -122.3321, '2023-04-05')
  INTO TMP_CRAIGSLIST_VEHICLES VALUES (2005, 'https://example.com/2005', 'phoenix', 'https://phoenix.craigslist.org', 12000, 2017, 'nissan', 'altima', 'good', '4 cylinders', 'gas', 65000, 'clean', 'automatic', 'MNO123456789', 'fwd', 'mid-size', 'sedan', 'silver', 'https://example.com/image5.jpg', 'Reliable 2017 Nissan Altima', 'maricopa', 'az', 33.4484, -112.0740, '2023-05-12')
  INTO TMP_CRAIGSLIST_VEHICLES VALUES (2006, 'https://example.com/2006', 'chicago', 'https://chicago.craigslist.org', 8500, 2015, 'chevrolet', 'malibu', 'fair', '4 cylinders', 'gas', 85000, 'clean', 'automatic', 'PQR789456123', 'fwd', 'mid-size', 'sedan', 'gray', 'https://example.com/image6.jpg', '2015 Chevrolet Malibu', 'cook', 'il', 41.8781, -87.6298, '2023-06-01')
  INTO TMP_CRAIGSLIST_VEHICLES VALUES (2007, 'https://example.com/2007', 'los angeles', 'https://losangeles.craigslist.org', 28000, 2020, 'bmw', '3 series', 'excellent', '4 cylinders', 'gas', 15000, 'clean', 'automatic', 'STU456123789', 'rwd', 'compact', 'sedan', 'white', 'https://example.com/image7.jpg', 'Luxury 2020 BMW 3 Series', 'los angeles', 'ca', 34.0522, -118.2437, '2023-07-15')
  INTO TMP_CRAIGSLIST_VEHICLES VALUES (2008, 'https://example.com/2008', 'atlanta', 'https://atlanta.craigslist.org', 45000, 2022, 'mercedes-benz', 'c-class', 'like new', '4 cylinders', 'gas', 5000, 'clean', 'automatic', 'VWX123789456', 'rwd', 'compact', 'sedan', 'black', 'https://example.com/image8.jpg', 'Almost new 2022 Mercedes C-Class', 'fulton', 'ga', 33.7490, -84.3880, '2023-08-20')
  INTO TMP_CRAIGSLIST_VEHICLES VALUES (2009, 'https://example.com/2009', 'portland', 'https://portland.craigslist.org', 16500, 2018, 'subaru', 'outback', 'good', '4 cylinders', 'gas', 55000, 'clean', 'manual', 'YZA789123456', 'awd', 'mid-size', 'wagon', 'green', 'https://example.com/image9.jpg', '2018 Subaru Outback AWD', 'multnomah', 'or', 45.5152, -122.6784, '2023-09-10')
  INTO TMP_CRAIGSLIST_VEHICLES VALUES (2010, 'https://example.com/2010', 'boston', 'https://boston.craigslist.org', 19500, 2019, 'audi', 'a4', 'excellent', '4 cylinders', 'gas', 32000, 'clean', 'automatic', 'BCD456789123', 'awd', 'compact', 'sedan', 'blue', 'https://example.com/image10.jpg', 'Premium 2019 Audi A4', 'suffolk', 'ma', 42.3601, -71.0589, '2023-10-05')
SELECT * FROM DUAL;

-- MÁS VEHÍCULOS PARA DIVERSIDAD DE DATOS (2015-2024)
INSERT ALL
  INTO TMP_CRAIGSLIST_VEHICLES VALUES (2011, 'https://example.com/2011', 'dallas', 'https://dallas.craigslist.org', 13500, 2016, 'toyota', 'prius', 'good', '4 cylinders', 'hybrid', 78000, 'clean', 'automatic', 'HYB111222333', 'fwd', 'compact', 'hatchback', 'white', NULL, '2016 Toyota Prius Hybrid', 'dallas', 'tx', 32.7767, -96.7970, '2023-11-01')
  INTO TMP_CRAIGSLIST_VEHICLES VALUES (2012, 'https://example.com/2012', 'san francisco', 'https://sfbay.craigslist.org', 42000, 2023, 'tesla', 'model y', 'like new', NULL, 'electric', 3000, 'clean', 'automatic', 'TESLA2023001', 'awd', 'mid-size', 'suv', 'red', NULL, '2023 Tesla Model Y AWD', 'san francisco', 'ca', 37.7749, -122.4194, '2023-11-15')
  INTO TMP_CRAIGSLIST_VEHICLES VALUES (2013, 'https://example.com/2013', 'houston', 'https://houston.craigslist.org', 18900, 2021, 'honda', 'accord', 'excellent', '4 cylinders', 'gas', 22000, 'clean', 'automatic', 'HND2021ACC01', 'fwd', 'mid-size', 'sedan', 'black', NULL, '2021 Honda Accord Sedan', 'harris', 'tx', 29.7604, -95.3698, '2023-12-01')
  INTO TMP_CRAIGSLIST_VEHICLES VALUES (2014, 'https://example.com/2014', 'detroit', 'https://detroit.craigslist.org', 31000, 2024, 'ford', 'mustang', 'excellent', '8 cylinders', 'gas', 1500, 'clean', 'manual', 'MUSTANG24001', 'rwd', 'compact', 'coupe', 'yellow', NULL, '2024 Ford Mustang GT', 'wayne', 'mi', 42.3314, -83.0458, '2024-01-10')
  INTO TMP_CRAIGSLIST_VEHICLES VALUES (2015, 'https://example.com/2015', 'las vegas', 'https://lasvegas.craigslist.org', 25000, 2022, 'nissan', 'frontier', 'good', '6 cylinders', 'gas', 18000, 'clean', 'automatic', 'FRONTIER2022', '4wd', 'mid-size', 'pickup', 'gray', NULL, '2022 Nissan Frontier 4WD', 'clark', 'nv', 36.1699, -115.1398, '2024-01-20')
SELECT * FROM DUAL;

-- VEHÍCULOS ADICIONALES PARA COMPLETAR MUESTRA
INSERT ALL
  INTO TMP_CRAIGSLIST_VEHICLES VALUES (2016, 'https://example.com/2016', 'philadelphia', 'https://philadelphia.craigslist.org', 9500, 2015, 'volkswagen', 'jetta', 'fair', '4 cylinders', 'gas', 92000, 'clean', 'manual', 'VW2015JETTA', 'fwd', 'compact', 'sedan', 'white', NULL, '2015 Volkswagen Jetta', 'philadelphia', 'pa', 39.9526, -75.1652, '2024-02-01')
  INTO TMP_CRAIGSLIST_VEHICLES VALUES (2017, 'https://example.com/2017', 'minneapolis', 'https://minneapolis.craigslist.org', 27500, 2021, 'jeep', 'wrangler', 'excellent', '6 cylinders', 'gas', 35000, 'clean', 'manual', 'JEEP2021WR', '4wd', 'compact', 'suv', 'orange', NULL, '2021 Jeep Wrangler 4WD', 'hennepin', 'mn', 44.9778, -93.2650, '2024-02-15')
  INTO TMP_CRAIGSLIST_VEHICLES VALUES (2018, 'https://example.com/2018', 'san diego', 'https://sandiego.craigslist.org', 21500, 2020, 'mazda', 'cx-5', 'good', '4 cylinders', 'gas', 41000, 'clean', 'automatic', 'MAZDA20CX5', 'awd', 'compact', 'suv', 'blue', NULL, '2020 Mazda CX-5 AWD', 'san diego', 'ca', 32.7157, -117.1611, '2024-03-01')
  INTO TMP_CRAIGSLIST_VEHICLES VALUES (2019, 'https://example.com/2019', 'tampa', 'https://tampa.craigslist.org', 14500, 2017, 'hyundai', 'sonata', 'good', '4 cylinders', 'gas', 58000, 'clean', 'automatic', 'HYU2017SON', 'fwd', 'mid-size', 'sedan', 'silver', NULL, '2017 Hyundai Sonata', 'hillsborough', 'fl', 27.9506, -82.4572, '2024-03-15')
  INTO TMP_CRAIGSLIST_VEHICLES VALUES (2020, 'https://example.com/2020', 'st louis', 'https://stlouis.craigslist.org', 23500, 2023, 'kia', 'sorento', 'like new', '4 cylinders', 'gas', 12000, 'clean', 'automatic', 'KIA2023SOR', 'awd', 'mid-size', 'suv', 'black', NULL, '2023 Kia Sorento AWD', 'st louis', 'mo', 38.6270, -90.1994, '2024-04-01')
SELECT * FROM DUAL;

COMMIT;

PROMPT 
PROMPT === DATOS CARGADOS ===
SELECT COUNT(*) AS "Total registros" FROM TMP_CRAIGSLIST_VEHICLES;

PROMPT 
PROMPT === MUESTRA DE DATOS COMPLETOS ===
SELECT ID, REGION, MANUFACTURER, MODEL, PRICE, YEAR_DATA, FUEL, CONDITION 
FROM TMP_CRAIGSLIST_VEHICLES 
WHERE MANUFACTURER IS NOT NULL 
  AND YEAR_DATA IS NOT NULL
  AND ROWNUM <= 10
ORDER BY ID;

PROMPT 
PROMPT === ESTADÍSTICAS POR AÑO ===
SELECT YEAR_DATA, COUNT(*) AS TOTAL
FROM TMP_CRAIGSLIST_VEHICLES 
WHERE YEAR_DATA IS NOT NULL
GROUP BY YEAR_DATA
ORDER BY YEAR_DATA;

PROMPT 
PROMPT === ESTADÍSTICAS POR COMBUSTIBLE ===
SELECT FUEL, COUNT(*) AS TOTAL
FROM TMP_CRAIGSLIST_VEHICLES 
WHERE FUEL IS NOT NULL
GROUP BY FUEL
ORDER BY FUEL;

PROMPT 
PROMPT Datos listos para procesar con: @@07_data_load.sql
