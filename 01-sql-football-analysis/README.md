
# Jordan on the World Stage — Football Data Analysis

![SQL](https://img.shields.io/badge/SQL-025E8C?style=for-the-badge)
![BigQuery](https://img.shields.io/badge/Google_BigQuery-4285F4?style=for-the-badge&logo=googlebigquery&logoColor=white)

## Project Overview

This project explores international football data using SQL and Google BigQuery, with a particular focus on Jordan's national football team.

The objective is to analyze historical performance, identify long-term trends, explore match and goal statistics, and evaluate the reliability of the available data.

This project was completed as part of the ASAC Data Science Bootcamp at LTUC.

## Dataset Overview

The supplied dataset consists of three relational tables covering international football matches from 1872 to 2026.

| Table | Description | Records |
|---|---|---:|
| `matches` | International football match results | 49,807 |
| `goals` | Recorded goal-scoring events | 47,914 |
| `shootouts` | Penalty shootout records | 694 |

A SQL view named `team_matches` was created to transform each match into two team-level records, producing 99,614 rows.

## Project Objectives

- Analyze Jordan's overall international football performance.
- Evaluate changes in win rates across decades.
- Identify Jordan's most frequent opponents and biggest victories.
- Analyze Jordan's performance in the 2023 AFC Asian Cup and 2026 FIFA World Cup using the supplied dataset.
- Investigate the completeness of historical goal-scoring records.
- Compare team scoring performance during the 2026 World Cup.

## Tools and Technologies

- Google BigQuery
- GoogleSQL
- Git and GitHub

## SQL Concepts Applied

| Concept | Application |
|---|---|
| Aggregation functions | Counting matches, goals, wins and losses |
| Common Table Expressions (CTEs) | Structuring multi-step queries |
| SQL views | Creating a reusable team-level dataset |
| CASE statements | Classifying match results |
| UNION ALL | Combining home and away team records |
| JOINs | Connecting match and goal-scoring data |
| Window functions | Calculating running goal totals |
| Subqueries | Comparing team performance against averages |
| GROUP BY and HAVING | Grouping and filtering aggregated results |
| Data validation | Checking dataset consistency and completeness |

## Methodology

1. Inspect and validate the source tables.
2. Transform match records into a team-level SQL view.
3. Calculate key performance indicators for Jordan.
4. Analyze historical trends and tournament performance.
5. Assess missing goal-scoring records and their analytical impact.
6. Compare team scoring averages.

## Key Findings

### Jordan's Overall Performance

| Metric | Result |
|---|---:|
| Matches played | 494 |
| Wins | 181 |
| Draws | 136 |
| Losses | 177 |
| Goals scored | 630 |
| Goals conceded | 559 |
| Win rate | 36.6% |

### Match Outcomes

| Result | Percentage |
|---|---:|
| Wins | 36.6% |
| Draws | 27.5% |
| Losses | 35.8% |

### Historical Performance

Jordan's reported win rate increased from 7.7% in the 1960s to 44.9% in the 2020s.

### Most Frequent Opponents

| Opponent | Matches |
|---|---:|
| Iraq | 48 |
| Syria | 30 |
| Bahrain | 26 |
| Kuwait | 26 |
| Lebanon | 26 |

### AFC Asian Cup Performance

During the 2023 AFC Asian Cup, played in 2024, Jordan reached the final and recorded:

- 7 matches
- 4 wins
- 1 draw
- 2 losses
- 13 goals scored

## Data Quality and Limitations

An important part of this project was evaluating the reliability of historical goal-scoring records.

Jordan scored at least one goal in 321 matches. However, 240 of those matches had no corresponding Jordan goal record in the goals table.

This represents approximately 74.8% of Jordan's scoring matches.

Consequently, the available goal records are insufficient for producing a reliable all-time top scorers ranking.

This highlights the importance of validating data completeness before drawing conclusions.

All numerical findings are based on the supplied bootcamp dataset.

