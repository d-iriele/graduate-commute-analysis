-- ============================================================
-- BI Data Model — Milestone 5
--
-- At six rows, this project does not benefit from a star schema
-- (fact + dimension tables) — that pattern earns its complexity
-- at much larger scale, as in the loan portfolio project. Instead,
-- city_dashboard is a single, flat, dashboard-ready table
-- containing every KPI and ranking a visual will need, built
-- directly from city_kpis.
-- ============================================================

CREATE TABLE city_dashboard AS
SELECT
    city,
    mapped_region,
    local_authority,
    route_type,
    graduate_salary,
    RANK() OVER (ORDER BY graduate_salary DESC) AS salary_rank,
    annual_rent_gbp,
    annual_season_ticket_gbp,
    commute_cost_pct_salary,
    journey_time_minutes,
    annual_commute_hours,
    time_cost_gbp,
    disposable_income_gbp,
    RANK() OVER (ORDER BY disposable_income_gbp DESC) AS disposable_income_rank,
    total_cost_of_work_gbp,
    RANK() OVER (ORDER BY total_cost_of_work_gbp ASC) AS total_cost_rank,
    RANK() OVER (ORDER BY graduate_salary DESC) -
        RANK() OVER (ORDER BY total_cost_of_work_gbp ASC) AS rank_shift
FROM city_kpis;

SELECT * 
FROM city_dashboard;