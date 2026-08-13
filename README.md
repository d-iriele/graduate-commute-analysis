# The Cost of a Commute — Graduate Purchasing Power Across UK Cities

**Status:** 🚧 In Progress — Milestone 1 of 9 (Environment & Repo Setup)

## Overview

Graduate job offers are typically compared on headline salary alone, but this ignores two costs that vary enormously by location: the cost of commuting into the role, and the cost of housing near it. A graduate choosing between offers in different UK cities is effectively choosing between different disposable-income outcomes, not different salaries. This project builds a rigorous, city-by-city comparison of graduate purchasing power across six UK cities, incorporating salary, rent, commuting cost, and commuting time, to determine where a graduate's money — and time — actually goes furthest.

Full problem statement and business objectives: [`docs/00_problem_statement.md`](docs/00_problem_statement.md)

## Table of Contents

- [Business Questions](#business-questions)
- [Tech Stack & Methodology](#tech-stack--methodology)
- [Project Structure](#project-structure)
- [Data](#data)
- [How to Run This Project](#how-to-run-this-project)
- [Findings](#findings)
- [Dashboard](#dashboard)
- [Key Recommendations](#key-recommendations)

## Business Questions

1. Where does a graduate's salary go furthest once fixed costs are removed?
2. How much of a graduate's income is absorbed by commuting specifically?
3. What is the true time cost of commuting, priced at the graduate's own wage?
4. Which cities reorder most dramatically once rent, commute cost, and time are all included?
5. How sensitive is the ranking to the choice of commute route?

## Tech Stack & Methodology

| Tool | Role in this project |
|---|---|
| SQL (PostgreSQL) | Structuring bulk salary/rent data, calculating derived metrics (disposable income, time cost), and producing the final ranked comparison |
| Python (pandas) | Validation of SQL calculations and any scraping/cleanup needed for manually sourced commute data |
| Dashboard tool (TBD) | Visual, ranked comparison across cities |

Data flows through this pipeline: **bulk downloads (ONS/HESA) + manually curated commute data → SQL → Python validation → dashboard**. Unlike a project built entirely on one clean source file, this project deliberately combines two very different kinds of input — official bulk statistics and hand-curated, individually sourced figures — and documents that distinction explicitly (see Data section below).

## Project Structure

```
graduate-commute-analysis/
├── data/
│   ├── raw/              # ONS/HESA bulk downloads (gitignored — see Data section)
│   ├── processed/        # cleaned output from SQL stage (gitignored)
│   ├── manual/           # commute cost/time table, sourced and documented per city (tracked)
│   └── sample/           # small tracked sample of raw data, if applicable
├── sql/                  # schema, cleaning, and analysis queries
├── notebooks/            # exploratory validation notebooks
├── dashboard/            # dashboard files
├── docs/                 # problem statement, data dictionary, findings write-up
└── images/               # dashboard screenshots for this README
```

## Data

**Bulk sources:**
- Graduate salary by region: [HESA Graduate Outcomes](#) / [ONS ASHE](#)
- Rent by city (one-bedroom average): [ONS Private rent and house prices, UK](#)

**Manually curated source:**
- Commute cost and time: one representative route per city, priced via the [National Rail Season Ticket Calculator](https://www.nationalrail.co.uk/tickets-railcards-and-offers/ticket-types/season-ticket-calculator/) on the date of collection. Full route list, prices, and collection dates documented in `data/manual/commute_data.csv` and `docs/01_data_dictionary.md`. Unlike the bulk sources above, this file is committed directly to the repo rather than gitignored, since it represents original curation rather than a large derived export.

The full raw bulk datasets are not committed to this repo (see `.gitignore`). To reproduce, download from the links above and place in `data/raw/`.

## How to Run This Project

```bash
git clone <this-repo-url>
cd graduate-commute-analysis
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Then follow the steps in the [Data](#data) section to populate `data/raw/`, and run the SQL scripts in order.

## Findings

_Coming soon._

## Dashboard

_Coming soon._

## Key Recommendations

_Coming soon._

---

*This project is being built and documented in stages as a portfolio piece; commit history reflects the analysis process from raw data to final recommendations.*