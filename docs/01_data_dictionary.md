**Note on Birmingham's commute cost figure:** Unlike the other five cities, Sutton Coldfield–Birmingham New Street is priced through the Network West Midlands zonal fare system, which did not return a standard point-to-point Annual Season price via the National Rail calculator. The figure used (£1,150) is estimated from the verified Anytime Day Return checkout price (£6.49) × 253 standard UK working days × a 30% season-ticket discount factor (typical for UK rail season tickets vs. daily fares), rather than a directly quoted annual price. This is flagged in `commute_data.csv` and should be treated as an estimate, not a scraped official figure.

## Salary data (LEO Graduate Outcomes — Earnings by Region)

Source: [DfE/HMRC Longitudinal Education Outcomes, "Earnings by Region"](https://explore-education-statistics.service.gov.uk/data-catalogue/graduate-outcomes-leo-provider-level-data/2020-21)
Tax year: 2020/21 (earnings measured five years post-graduation)

| Column | Type | Notes |
|---|---|---|
| current_region | text | Mapped to project cities: London→London, Manchester→North West, Birmingham→West Midlands, Bristol→South West, Leeds→Yorkshire and the Humber, Edinburgh→Scotland |
| earnings_median | numeric | Primary salary figure used in this project |
| earnings_LQ / earnings_UQ | numeric | Lower/upper quartile, available for range context if needed |
| providers_earnings | numeric | Number of contributing institutions — treat as a rough sample-size indicator |

**Note:** figures reflect earnings five years post-graduation, not entry-level graduate salary. This should be read as representative of established graduate earning power in each region, not a first-job salary comparison.

## Rent data (ONS Private Rent and House Prices, UK)

Source: [ONS "Housing prices in your area" interactive tool](https://www.ons.gov.uk/economy/inflationandpriceindices/bulletins/privaterentandhousepricesuk/july2026)
Data point: one-bedroom property average monthly rent, by local authority (or Broad Rental Market Area for Scotland)

| Column | Type | Notes |
|---|---|---|
| city | text | Project city label |
| local_authority | text | The actual local authority/BRMA the figure applies to — see methodology notes below |
| monthly_rent_1bed_gbp | numeric | ONS one-bedroom average monthly rent |
| annual_rent_gbp | numeric | monthly_rent_1bed_gbp × 12 — used directly in the Disposable Income KPI |

**Methodology note — rent is measured at the commute origin, not the destination city.** Consistent with the commute cost data, rent reflects the local authority a graduate would realistically live in (e.g., Stockport for Manchester, Reading for London), not the city centre where they work. This keeps rent and commute cost internally consistent so that both describe the same person's actual living location   rather than mixing a suburban commute cost with a city-centre rent figure, which would misrepresent a single graduate's real financial position.

**Methodology note — Scotland caution.** 
ONS explicitly advises caution when comparing Scotland's rent estimates (measured via Broad Rental Market Areas) against local-authority-level figures for England and Wales, due to differing data collection methods. This is the second dataset in this project (alongside the Edinburgh commute route) where Scotland required distinct methodological treatment — worth noting as a pattern in the findings write-up, not just a one-off caveat.

**Note on initial data collection error, corrected:** an earlier pull of this data was not filtered to one-bedroom properties and instead reflected all-property-size averages, which ran 27-29% higher across the sample checked. This was caught and corrected before use in any analysis — see commit history.

## city_dashboard (BI-ready table)

Built directly from city_kpis, adding permanent rank columns for salary, disposable income, and total cost of work. No star schema (fact/dimension split) was used — at six rows, this project does not benefit from that pattern, which is better suited to large-scale data like the loan portfolio project. A single flat table is the simpler, more appropriate choice here.