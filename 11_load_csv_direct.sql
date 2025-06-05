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

-- Insertar datos de muestra basados en el archivo CSV
-- (En un entorno real, usaría SQL*Loader o External Tables)

INSERT INTO TMP_CRAIGSLIST_VEHICLES VALUES (
7222695916,'https://prescott.craigslist.org/cto/d/prescott-2010-ford-ranger/7222695916.html','prescott','https://prescott.craigslist.org',6000,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'az',NULL,NULL,NULL
);

INSERT INTO TMP_CRAIGSLIST_VEHICLES VALUES (
7218891961,'https://fayar.craigslist.org/ctd/d/bentonville-2017-hyundai-elantra-se/7218891961.html','fayetteville','https://fayar.craigslist.org',11900,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'ar',NULL,NULL,NULL
);

INSERT INTO TMP_CRAIGSLIST_VEHICLES VALUES (
7221797935,'https://keys.craigslist.org/cto/d/summerland-key-2005-excursion/7221797935.html','florida keys','https://keys.craigslist.org',21000,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'fl',NULL,NULL,NULL
);

INSERT INTO TMP_CRAIGSLIST_VEHICLES VALUES (
7222270760,'https://worcester.craigslist.org/cto/d/west-brookfield-2002-honda-odyssey-ex/7222270760.html','worcester / central MA','https://worcester.craigslist.org',1500,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'ma',NULL,NULL,NULL
);

INSERT INTO TMP_CRAIGSLIST_VEHICLES VALUES (
7210384030,'https://greensboro.craigslist.org/cto/d/trinity-1965-chevrolet-truck/7210384030.html','greensboro','https://greensboro.craigslist.org',4900,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'nc',NULL,NULL,NULL
);

-- Agregar algunos datos más completos para probar mejor
INSERT INTO TMP_CRAIGSLIST_VEHICLES VALUES (
1001, 'https://example.com/vehicle1', 'sacramento', 'https://sacramento.craigslist.org', 15000, 2018, 'toyota', 'camry', 'excellent', '4 cylinders', 'gas', 45000, 'clean', 'automatic', 'ABC123456789', 'fwd', 'mid-size', 'sedan', 'white', 'https://example.com/image1.jpg', 'Excellent condition, well maintained', 'sacramento', 'ca', 38.5816, -121.4944, '2023-01-15'
);

INSERT INTO TMP_CRAIGSLIST_VEHICLES VALUES (
1002, 'https://example.com/vehicle2', 'denver', 'https://denver.craigslist.org', 22000, 2020, 'ford', 'f-150', 'good', '8 cylinders', 'gas', 25000, 'clean', 'automatic', 'DEF987654321', '4wd', 'full-size', 'pickup', 'blue', 'https://example.com/image2.jpg', 'Great truck for work and family', 'denver', 'co', 39.7392, -104.9903, '2023-02-20'
);

INSERT INTO TMP_CRAIGSLIST_VEHICLES VALUES (
1003, 'https://example.com/vehicle3', 'miami', 'https://miami.craigslist.org', 18500, 2019, 'honda', 'civic', 'like new', '4 cylinders', 'gas', 12000, 'clean', 'manual', 'GHI456789123', 'fwd', 'compact', 'sedan', 'red', 'https://example.com/image3.jpg', 'Low mileage, single owner', 'miami-dade', 'fl', 25.7617, -80.1918, '2023-03-10'
);

INSERT INTO TMP_CRAIGSLIST_VEHICLES VALUES (
1004, 'https://example.com/vehicle4', 'seattle', 'https://seattle.craigslist.org', 35000, 2021, 'tesla', 'model 3', 'excellent', NULL, 'electric', 8000, 'clean', 'automatic', 'JKL789123456', 'rwd', 'mid-size', 'sedan', 'black', 'https://example.com/image4.jpg', 'Electric vehicle, great for commuting', 'king', 'wa', 47.6062, -122.3321, '2023-04-05'
);

INSERT INTO TMP_CRAIGSLIST_VEHICLES VALUES (
1005, 'https://example.com/vehicle5', 'phoenix', 'https://phoenix.craigslist.org', 12000, 2017, 'nissan', 'altima', 'good', '4 cylinders', 'gas', 65000, 'clean', 'automatic', 'MNO123456789', 'fwd', 'mid-size', 'sedan', 'silver', 'https://example.com/image5.jpg', 'Reliable family car', 'maricopa', 'az', 33.4484, -112.0740, '2023-05-12'
);

-- Agregar más variedad de datos
INSERT INTO TMP_CRAIGSLIST_VEHICLES VALUES (
1006, 'https://example.com/vehicle6', 'chicago', 'https://chicago.craigslist.org', 8500, 2015, 'chevrolet', 'malibu', 'fair', '4 cylinders', 'gas', 85000, 'clean', 'automatic', 'PQR789456123', 'fwd', 'mid-size', 'sedan', 'gray', 'https://example.com/image6.jpg', 'Needs some work but runs well', 'cook', 'il', 41.8781, -87.6298, '2023-06-01'
);

INSERT INTO TMP_CRAIGSLIST_VEHICLES VALUES (
1007, 'https://example.com/vehicle7', 'los angeles', 'https://losangeles.craigslist.org', 28000, 2020, 'bmw', '3 series', 'excellent', '4 cylinders', 'gas', 15000, 'clean', 'automatic', 'STU456123789', 'rwd', 'compact', 'sedan', 'white', 'https://example.com/image7.jpg', 'Luxury vehicle, well maintained', 'los angeles', 'ca', 34.0522, -118.2437, '2023-07-15'
);

INSERT INTO TMP_CRAIGSLIST_VEHICLES VALUES (
1008, 'https://example.com/vehicle8', 'atlanta', 'https://atlanta.craigslist.org', 45000, 2022, 'mercedes-benz', 'c-class', 'like new', '4 cylinders', 'gas', 5000, 'clean', 'automatic', 'VWX123789456', 'rwd', 'compact', 'sedan', 'black', 'https://example.com/image8.jpg', 'Almost new luxury sedan', 'fulton', 'ga', 33.7490, -84.3880, '2023-08-20'
);

INSERT INTO TMP_CRAIGSLIST_VEHICLES VALUES (
1009, 'https://example.com/vehicle9', 'portland', 'https://portland.craigslist.org', 16500, 2018, 'subaru', 'outback', 'good', '4 cylinders', 'gas', 55000, 'clean', 'manual', 'YZA789123456', 'awd', 'mid-size', 'wagon', 'green', 'https://example.com/image9.jpg', 'Great for outdoor adventures', 'multnomah', 'or', 45.5152, -122.6784, '2023-09-10'
);

INSERT INTO TMP_CRAIGSLIST_VEHICLES VALUES (
1010, 'https://example.com/vehicle10', 'boston', 'https://boston.craigslist.org', 19500, 2019, 'audi', 'a4', 'excellent', '4 cylinders', 'gas', 32000, 'clean', 'automatic', 'BCD456789123', 'awd', 'compact', 'sedan', 'blue', 'https://example.com/image10.jpg', 'Premium vehicle with all options', 'suffolk', 'ma', 42.3601, -71.0589, '2023-10-05'
);

COMMIT;

PROMPT 
PROMPT === DATOS CARGADOS ===
SELECT COUNT(*) AS "Total registros" FROM TMP_CRAIGSLIST_VEHICLES;

PROMPT 
PROMPT === MUESTRA DE DATOS ===
SELECT ID, REGION, MANUFACTURER, MODEL, PRICE, YEAR_DATA 
FROM TMP_CRAIGSLIST_VEHICLES 
WHERE ROWNUM <= 5;

PROMPT 
PROMPT Datos listos para procesar con: @@07_data_load.sql
