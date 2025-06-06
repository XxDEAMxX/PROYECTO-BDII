

CREATE OR REPLACE PROCEDURE SP_CONDITION_PIVOT_BY_YEAR (
    P_START_YEAR IN NUMBER,
    P_END_YEAR   IN NUMBER,
    OUT_CURSOR   OUT SYS_REFCURSOR
)
AS
    v_sql CLOB;
    v_cols VARCHAR2(4000);
BEGIN
    v_cols := '';
    FOR yr IN P_START_YEAR .. P_END_YEAR LOOP
        v_cols := v_cols || yr || ',';
    END LOOP;
    v_cols := RTRIM(v_cols, ',');

    v_sql := '
        SELECT 
            CONDITION_TYPE, ';

    FOR yr IN P_START_YEAR .. P_END_YEAR LOOP
        v_sql := v_sql || 'NVL("' || yr || '", 0) AS "COND_' || yr || '", ';
    END LOOP;

    v_sql := RTRIM(v_sql, ', ') || '
        FROM (
            SELECT 
                c.NAME AS CONDITION_TYPE,
                v.YEAR,
                COUNT(*) AS CONDITION_COUNT
            FROM VEHICLES v
            INNER JOIN CONDITIONS c ON v.CONDITION_ID = c.ID
            WHERE v.YEAR BETWEEN ' || P_START_YEAR || ' AND ' || P_END_YEAR || '
            GROUP BY c.NAME, v.YEAR
        ) SOURCE
        PIVOT (
            SUM(CONDITION_COUNT)
            FOR YEAR IN (' || v_cols || ')
        )
        ORDER BY CONDITION_TYPE';

    OPEN OUT_CURSOR FOR v_sql;
END;
/

CREATE OR REPLACE PROCEDURE SP_VEHICLES_PIVOT_BY_YEAR (
    P_START_YEAR IN NUMBER,
    P_END_YEAR   IN NUMBER,
    OUT_CURSOR   OUT SYS_REFCURSOR
)
AS
    v_sql   CLOB;
    v_cols  VARCHAR2(4000);
    v_total VARCHAR2(4000);
BEGIN
    v_cols := '';
    v_total := '';
    FOR yr IN P_START_YEAR .. P_END_YEAR LOOP
        v_cols := v_cols || yr || ',';
        v_total := v_total || '"' || yr || '" + ';
    END LOOP;
    
    v_cols := RTRIM(v_cols, ',');
    v_total := RTRIM(v_total, '+ ');

    v_sql := '
        SELECT 
            MANUFACTURER, ';

    FOR yr IN P_START_YEAR .. P_END_YEAR LOOP
        v_sql := v_sql || 'NVL("' || yr || '", 0) AS "AÑO_' || yr || '", ';
    END LOOP;

    v_sql := v_sql || '(' || v_total || ') AS TOTAL_VEHICULOS
        FROM (
            SELECT 
                m.NAME AS MANUFACTURER,
                v.YEAR,
                COUNT(*) AS VEHICLE_COUNT
            FROM VEHICLES v
            INNER JOIN MANUFACTURERS m ON v.MANUFACTURER_ID = m.ID
            WHERE v.YEAR BETWEEN ' || P_START_YEAR || ' AND ' || P_END_YEAR || '
            GROUP BY m.NAME, v.YEAR
        ) SOURCE
        PIVOT (
            SUM(VEHICLE_COUNT)
            FOR YEAR IN (' || v_cols || ')
        )
        ORDER BY TOTAL_VEHICULOS DESC';

    OPEN OUT_CURSOR FOR v_sql;
END;
/

VAR rc REFCURSOR;
EXEC SP_CONDITION_PIVOT_BY_YEAR(2015, 2018, :rc);
PRINT rc;

VAR rc REFCURSOR;
EXEC SP_VEHICLES_PIVOT_BY_YEAR(2015, 2016, :rc);
PRINT rc;


--Todo: pivot de vehículos por año
CREATE OR REPLACE PROCEDURE SP_VEHICLES_PIVOT_BY_YEAR (
    p_start_year IN NUMBER,
    p_end_year   IN NUMBER
) AS
    v_sql CLOB;
    v_cols CLOB := '';
    v_pivot_cols CLOB := '';
    v_total_expr CLOB := '';
BEGIN
    IF p_end_year < p_start_year THEN
        RAISE_APPLICATION_ERROR(-20001, 'El año final no puede ser menor que el año de inicio.');
    END IF;
    FOR y IN p_start_year .. p_end_year LOOP
        v_cols := v_cols || 'NVL("' || y || '", 0) AS "AÑO_' || y || '", ';
        v_pivot_cols := v_pivot_cols || y || ', ';
        v_total_expr := v_total_expr || 'NVL("' || y || '", 0) + ';
    END LOOP;

    v_cols := RTRIM(v_cols, ', ');
    v_pivot_cols := RTRIM(v_pivot_cols, ', ');
    v_total_expr := RTRIM(v_total_expr, ' +');

    v_sql := '
        CREATE OR REPLACE VIEW VW_VEHICLES_PIVOT_BY_YEAR AS
        SELECT 
            MANUFACTURER,
            ' || v_cols || ',
            (' || v_total_expr || ') AS TOTAL_VEHICULOS
        FROM (
            SELECT 
                m.NAME AS MANUFACTURER,
                v.YEAR,
                COUNT(*) AS VEHICLE_COUNT
            FROM VEHICLES v
            INNER JOIN MANUFACTURERS m ON v.MANUFACTURER_ID = m.ID
            WHERE v.YEAR BETWEEN ' || p_start_year || ' AND ' || p_end_year || '
            GROUP BY m.NAME, v.YEAR
        ) SOURCE
        PIVOT (
            SUM(VEHICLE_COUNT)
            FOR YEAR IN (' || v_pivot_cols || ')
        )
        ORDER BY TOTAL_VEHICULOS DESC
    ';
    EXECUTE IMMEDIATE v_sql;
END;
/

BEGIN
    SP_VEHICLES_PIVOT_BY_YEAR(2018, 2019);
END;
/

select * from VW_VEHICLES_PIVOT_BY_YEAR;