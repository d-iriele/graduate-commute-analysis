-- ============================================================
-- Schema — Milestone 3
-- Three raw tables mirroring the three source files from
-- Milestone 2: salary (LEO, by region), rent (ONS, by local
-- authority), commute (manually curated, by city).
-- ============================================================

CREATE TABLE salary_raw (
    time_period TEXT,
    time_identifier TEXT,
    geographic_level TEXT,
    country_code TEXT,
    country_name TEXT,
    current_region TEXT,
    providers_earnings NUMERIC,
    earnings_min NUMERIC,
    earnings_LQ NUMERIC,
    earnings_median NUMERIC,
    earnings_UQ NUMERIC,
    earnings_max NUMERIC,
    earnings_diff NUMERIC
);

CREATE TABLE rent_raw (
    city TEXT,
    local_authority TEXT,
    monthly_rent_1bed_gbp NUMERIC,
    annual_rent_gbp NUMERIC,
    source TEXT,
    date_collected DATE
);

CREATE TABLE commute_raw (
    city TEXT,
    origin_station TEXT,
    destination_station TEXT,
    annual_season_ticket_gbp NUMERIC,
    journey_time_minutes NUMERIC,
    route_type TEXT,
    source TEXT,
    date_collected DATE
);

SELECT COUNT(*) 
FROM salary_raw;   -- expect 12

SELECT COUNT(*) 
FROM rent_raw;     -- expect 6

SELECT COUNT(*) 
FROM commute_raw;  -- expect 6