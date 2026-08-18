-- ============================================================
-- Cleaning & Combination — Milestone 3
--
-- Builds city_analysis: joins salary (by region), rent, and
-- commute (both by city) into one row per city. Salary is
-- mapped from region to city per the methodology documented in
-- docs/01_data_dictionary.md — each city is treated as the
-- economic focal point of its region.
-- ============================================================

CREATE TABLE city_analysis AS
SELECT
    r.city,
    r.local_authority,
    r.monthly_rent_1bed_gbp,
    r.annual_rent_gbp,
    c.origin_station,
    c.destination_station,
    c.annual_season_ticket_gbp,
    c.journey_time_minutes,
    c.route_type,
    s.current_region AS mapped_region,
    s.earnings_median AS graduate_salary
FROM rent_raw r
JOIN commute_raw c ON r.city = c.city
JOIN salary_raw s ON s.current_region = CASE r.city
    WHEN 'London' THEN 'London'
    WHEN 'Manchester' THEN 'North West'
    WHEN 'Birmingham' THEN 'West Midlands'
    WHEN 'Bristol' THEN 'South West'
    WHEN 'Leeds' THEN 'Yorkshire and the Humber'
    WHEN 'Edinburgh' THEN 'Scotland'
END;

SELECT * FROM city_analysis;


-- ============================================================
-- KPI Calculations
--
-- Builds city_kpis from city_analysis: calculates disposable
-- income, commute cost as % of salary, the monetary value of
-- commuting time, total cost of work, and rankings by both raw
-- salary and disposable income (the project's central comparison).
--
-- Constants: 253 standard UK working days/year; 7.5hr working
-- day (1,897.5 standard annual hours), used to convert salary
-- into an hourly-equivalent wage for the time-cost calculation.
-- ============================================================

CREATE TABLE city_kpis AS
SELECT
    city,
    graduate_salary,
    annual_rent_gbp,
    annual_season_ticket_gbp,
    journey_time_minutes,
    route_type,

    -- Disposable income: what's left after rent and commute cost
    graduate_salary - annual_rent_gbp - annual_season_ticket_gbp AS disposable_income_gbp,

    -- Commute cost as a % of gross salary
    ROUND(
        100.0 * annual_season_ticket_gbp / graduate_salary,
        2
    ) AS commute_cost_pct_salary,

    -- Annual commute hours: one-way minutes × 2 (round trip) × 253 days, converted to hours
    ROUND(
        (journey_time_minutes * 2 * 253) / 60.0,
        1
    ) AS annual_commute_hours,

    -- Time cost: annual commute hours priced at the graduate's own hourly-equivalent wage
    ROUND(
        (journey_time_minutes * 2 * 253) / 60.0 * (graduate_salary / 1897.5),
        2
    ) AS time_cost_gbp,

    -- Total cost of work: rent + commute cost + time cost combined
    ROUND(
        annual_rent_gbp + annual_season_ticket_gbp +
        ((journey_time_minutes * 2 * 253) / 60.0 * (graduate_salary / 1897.5)),
        2
    ) AS total_cost_of_work_gbp

FROM city_analysis;