-- ============================================================
-- Rankings: salary-only rank vs. disposable-income-adjusted rank.
-- This comparison is the project's headline finding where a
-- city's true financial ranking diverges from its salary ranking.
-- ============================================================

SELECT
    city,
    graduate_salary,
    RANK() OVER (ORDER BY graduate_salary DESC) AS salary_rank,
    disposable_income_gbp,
    RANK() OVER (ORDER BY disposable_income_gbp DESC) AS disposable_income_rank,
    commute_cost_pct_salary,
    time_cost_gbp,
    total_cost_of_work_gbp
FROM city_kpis
ORDER BY disposable_income_rank;

-- Finding: Viewed together, salary rank and disposable income rank diverge
-- meaningfully for several cities; most notably London (1st on salary,
-- 4th on disposable income) and Edinburgh (2nd on salary, 1st on disposable
-- income) - establishing early that headline salary alone is a poor proxy
-- for actual financial outcome. Commute cost burden (4.26%-21.86% of salary)
-- and time cost (£1,080-£8,294) vary dramatically across cities and are
-- clearly not correlated with each other: London has the highest commute
-- cost but only the 2nd-highest time cost, while Edinburgh has a mid-range
-- commute cost but by far the highest time cost. This initial comparison 
-- motivated the five business questions explored in detail below, each
-- isolating one dimension of the overall picture.


-- ============================================================
-- BUSINESS QUESTION 1: Where does a graduate's salary go
-- furthest once fixed costs are removed?
-- ============================================================

SELECT
    city,
    graduate_salary,
    annual_rent_gbp,
    annual_season_ticket_gbp,
    disposable_income_gbp,
    RANK() OVER (ORDER BY disposable_income_gbp DESC) AS disposable_income_rank
FROM city_kpis
ORDER BY disposable_income_rank;

-- Finding (Question 1): Edinburgh offers the highest disposable income
-- (£16,792) despite ranking only 2nd on raw salary, narrowly ahead of
-- Manchester (£16,208). London ranks 1st on salary (£31,800) but drops to
-- 4th on disposable income (£11,468) which is over £5,300 lower than Edinburgh
-- once rent and commute cost are removed. Bristol has the lowest disposable
-- income of the six (£9,996), driven primarily by Bath's high rent
-- (£14,460/year) rather than commute cost, which sits mid-range.


-- ============================================================
-- BUSINESS QUESTION 2: How much of a graduate's income is
-- absorbed by commuting specifically?
-- ============================================================

SELECT
    city,
    annual_season_ticket_gbp,
    commute_cost_pct_salary,
    RANK() OVER (ORDER BY commute_cost_pct_salary DESC) AS commute_burden_rank
FROM city_kpis
ORDER BY commute_burden_rank;

-- Finding (Question 2): London's commute cost consumes 21.86% of gross
-- salary, nearly double the next-highest city (Leeds, 11.83%) despite
-- London also having the highest headline salary. Manchester (4.33%) and
-- Birmingham (4.26%) sit at the opposite extreme, both under 5%, showing
-- commute burden is not simply a function of city size, salary level, or
-- distance travelled alone.


-- ============================================================
-- BUSINESS QUESTION 3: What is the true time cost of commuting,
-- priced at the graduate's own wage?
-- ============================================================

SELECT
    city,
    journey_time_minutes,
    annual_commute_hours,
    time_cost_gbp,
    RANK() OVER (ORDER BY time_cost_gbp DESC) AS time_cost_rank
FROM city_kpis
ORDER BY time_cost_rank;

-- Finding (Question 3): Edinburgh's time cost (£8,294) is 2.4x higher than
-- the next-highest city (London, £3,392) and over 7.5x higher than
-- Manchester's (£1,080) — a direct consequence of the intercity
-- Glasgow-Edinburgh commute (62 minutes each way) rather than the suburban
-- commute pattern used for the other five cities (see route_type flag and
-- Milestone 0 methodology note). This is the single largest driver of
-- Edinburgh's fall from 1st place on disposable income to 5th on total
-- cost of work.


-- ============================================================
-- BUSINESS QUESTION 4: Which cities reorder most dramatically
-- once rent, commute cost, and time are all included?
-- ============================================================

SELECT
    city,
    graduate_salary,
    RANK() OVER (ORDER BY graduate_salary DESC) AS salary_rank,
    total_cost_of_work_gbp,
    RANK() OVER (ORDER BY total_cost_of_work_gbp ASC) AS total_cost_rank,
    RANK() OVER (ORDER BY graduate_salary DESC) -
        RANK() OVER (ORDER BY total_cost_of_work_gbp ASC) AS rank_shift
FROM city_kpis
ORDER BY ABS(RANK() OVER (ORDER BY graduate_salary DESC) -
        RANK() OVER (ORDER BY total_cost_of_work_gbp ASC)) DESC;

-- Finding (Question 4): London shows the most dramatic downward reordering, falling
-- 5 full positions, from #1 on raw salary to last (6th) on total cost of
-- work. This confirms that headline salary comparisons mislead
-- graduates about true financial outcome. Leeds shows the largest upward
-- shift (+4), moving from lowest salary to 2nd-lowest total cost. Manchester
-- is the standout overall performer, ranking 1st on total cost of work
-- despite only 3rd-highest salary. Edinburgh's case is distinct from the
-- others: its fall from 1st (disposable income) to 5th (total cost) is
-- driven specifically by time cost, not rent or commute cost, a reminder
-- that which cost factors are included can change the answer as much as
-- the underlying data itself.


-- ============================================================
-- BUSINESS QUESTION 5: How sensitive is the ranking to the
-- choice of commute route? Sensitivity check using an alternate
-- route for one city.
-- ============================================================

SELECT
    27000 - 14808 - 1024 AS alt_disposable_income,   -- Wolverhampton route
    27000 - 14808 - 1150 AS original_disposable_income;  -- Sutton Coldfield estimate

-- Finding (Question 5): Substituting a genuine, sourced alternate commute
-- route (Wolverhampton–Birmingham New Street, £1,024/year) for the original
-- estimated figure (Sutton Coldfield, £1,150, derived from a day-return price
-- due to the Network West Midlands zonal fare system) changes Birmingham's
-- disposable income by only £126 and does not change its ranking position
-- (5th of 6, between London and Bristol). This confirms the overall ranking
-- is not sensitive to the specific commute route or estimation method used
-- for Birmingham, the one city where a directly-sourced annual season
-- ticket price was unavailable through the standard calculator.

