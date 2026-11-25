-- Assignment 1: Jordan on the world stage, in SQL
-- Name:Moslem Riyad Salim Al-Issa
-- TA group:
--
-- Save this file as A01_<FirstName>_<LastName>.sql.
-- Under every query: the number of rows it returned, and one sentence that answers the question.
-- The file must run from top to bottom without errors: the view in Q2 has to exist before Q3 reads it.


-- =====================================================================
-- Part 1. Load and check the data
-- =====================================================================

-- Q1. Row counts of the three tables, and the first and last match_date, in one row.
select (select count(match_id) from football.matches) as matches,
       (select count(goal_id) from `football.goals`) as goals,
       (select count(match_id) from `football.shootouts`) as shootouts,
       (select min(match_date) from `football.matches`) as first_match,
       (select max(match_date) from `football.matches`) as last_match
;
-- Rows: 1
-- Answer: The dataset contains 49,807 matches, 47,914 goals, and 694 shootouts,the first match was in November 30, 1872, and the last match was in September 30,2026.


-- Q2. The view football.team_matches: one row per team per match.
CREATE OR REPLACE VIEW football.team_matches AS
WITH both_sides AS (

select match_id,home_team as team , away_team as opponent, home_score as goals_for,away_score as goals_against,tournament,match_date
from `football.matches`

Union All

select match_id,away_team as team , home_team as opponent, away_score as goals_for,home_score as goals_against,tournament,match_date
from `football.matches`


)
SELECT match_id,tournament,team,opponent,goals_for,goals_against,match_date,
       case 
        when goals_for > goals_against then 'win'
        when goals_for < goals_against then 'loss'
        else 'draw'
        end as result
FROM both_sides
;

-- Q2 audit: rows, different matches, wins, losses, draws.
select (select count(match_id) from football.team_matches) as team_rows,
       (select count(match_id) from `football.matches`) as different_matches,
       (select count(match_id) from `football.team_matches` where result = 'win') as wins,
       (select count(match_id) from `football.team_matches` where result = 'loss') as losses,
       (select count(match_id) from `football.team_matches` where result = 'draw') as draws
;

-- Rows: 1
-- Answer: The team matches view contains 99,614 total rows across 49,807 unique matches, resulting in 38,498 wins, 38,498 losses, and 22,618 draws.


-- =====================================================================
-- Part 2. Jordan in numbers
-- =====================================================================

-- Q3. How has Jordan done overall?
select (select count(match_id) from football.team_matches where trim(upper(team)) = 'JORDAN') as matches,
       (select countif(result = 'win') from `football.team_matches` where trim(upper(team)) = 'JORDAN') as wins,
       (select countif(result = 'draw') from `football.team_matches` where trim(upper(team)) = 'JORDAN') as draws,
       (select countif(result = 'loss') from `football.team_matches` where trim(upper(team)) = 'JORDAN') as losses,
       (select sum(goals_for) from `football.team_matches` where trim(upper(team)) = 'JORDAN') as goals_for,
       (select sum(goals_against) from `football.team_matches` where trim(upper(team)) = 'JORDAN') as goals_against,
       (select round(((countif(result = 'win')/count(result)))*100,1) from `football.team_matches` where trim(upper(team)) = 'JORDAN' ) as win_pct,


;
-- Rows: 1
-- Answer: Jordan has played 494 matches,181 wins, 136 draws, and 177 losses, with 630 goals scored against 559 conceded, resulting in a win percentage of 36.6%.


-- Q4. Has Jordan got better over time? (by decade)
select div(extract(year from match_date),10)*10 as decade,
       count(match_id) as matches,
      round(((countif(result = 'win')/count(result)))*100,1) as win_pct
      from `football.team_matches`
      where trim(upper(team)) ='JORDAN'
      group by decade 
      order by decade 
;
-- Rows: 7
-- Answer:Jordan's football performance has shown a steady upward trend over the decades, rising from a 7.7% win rate in the 1960s across just 13 matches to a peak win percentage of 44.9% across 89 matches in the 2020s.


-- Q5. Opponents played at least 10 times.
select count(match_id) as matches,opponent
from `football.team_matches`
where team = 'Jordan'
group by opponent
having matches >= 10
order by matches desc

;
-- Rows: 14
-- Answer: Jordan's most frequent football opponents are regional neighbors in Western and Central Asia, led by Iraq with 48 matches, followed by Syria (30 matches) and a three-way tie with Bahrain, Kuwait, and Lebanon (26 matches each).


-- Q6. Jordan's five biggest wins.
select match_date,opponent,tournament,goals_for,goals_against,(goals_for - goals_against) as margin
from `football.team_matches`
where upper(trim(team)) = 'JORDAN' 
order by margin desc
limit 5

;
-- Rows: 5
-- Answer: 4 of the 5 biggest wins for Jordan team was in FIFA World Cup qualification, the first was against Nepal with 9-0 record. 



-- =====================================================================
-- Part 3. Goals, scorers and what the data covers
-- =====================================================================

-- Q7. The 2023 Asian Cup, match by match, with a running total of Jordan's goals.
select match_date,opponent,goals_for,goals_against,result,sum(goals_for) over (order by match_date) as goals_so_far
from `football.team_matches` 
where (team = 'Jordan') AND (tournament = 'AFC Asian Cup') AND (extract(year from match_date) = 2024)
order by match_date 
;
-- Rows:7
-- Answer:Jordan wins 4 matches which took it to the final , and lost two matches one of them was with the hosts of the tournament Qatar in the finals and the second with Bahrain, and one draw with South Korea, with 13 goals in total.


-- Q8. Every goal of Jordan's first World Cup.
select match_date,home_team,away_team,minute,team,scorer,own_goal,penalty
from `football.matches` as m    
join `football.goals` as g
on m.match_id = g.match_id
where (home_team = 'Jordan' OR away_team = 'Jordan') AND tournament = 'FIFA World Cup'
order by m.match_date
;
-- Rows: 11
-- Answer:Jordan team scored 3 goals in 2026 FIFA World Cup the first by Ali Olwan,the second by Nizar Al-Rashdan,and the third by Musa Al-Taamari which was a great goal,and received 8 goals 3 from Austria,2 from Algeria,and 3 from Argentina.


-- Q9. Can we trust an all-time top scorers list from this data?
-- Jordan scored at least one goal in [X] matches, and in [Y] of those matches, the goals table has no Jordan scorer recorded.
-- Jordan scored at least one goal in 321 matches, and in 240 of those matches, the goals table has no Jordan scorer recorded.
WITH jordan_goal_matches AS (
  SELECT DISTINCT match_id
  FROM `football.goals`
  WHERE team = 'Jordan'
)
SELECT 
  COUNT(DISTINCT CASE WHEN tm.team = 'Jordan' AND tm.goals_for > 0 THEN tm.match_id END) AS scoring_matches,
  COUNT(CASE WHEN tm.team = 'Jordan' AND tm.goals_for > 0 AND jgm.match_id IS NULL THEN 1 END) AS no_scorer_recorded
FROM `football.team_matches` tm
LEFT JOIN jordan_goal_matches jgm ON tm.match_id = jgm.match_id;

-- Rows: 1
-- Answer:Jordan scored at least one goal in 321 matches, and in 240 of those matches, the goals table has no Jordan scorer recorded.


-- =====================================================================
-- Part 4. The 2026 World Cup, step by step
-- =====================================================================

-- Q10. Teams with more goals per match than the average team.
WITH team_stats AS (
  SELECT 
    team, 
    COUNT(match_id) AS matches, 
    SUM(goals_for) AS goals,
    ROUND(SUM(goals_for) / COUNT(match_id), 2) AS goals_per_match
  FROM `football.team_matches`
  WHERE tournament = 'FIFA World Cup' 
    AND EXTRACT(YEAR FROM match_date) = 2026
  GROUP BY team
)
SELECT team, matches, goals, goals_per_match
FROM team_stats
WHERE goals_per_match > (
  SELECT AVG(CAST(goals AS FLOAT64) / matches) 
  FROM team_stats
)
ORDER BY goals_per_match DESC, team ASC
;

-- Rows:22
-- Answer: Germany and the Netherlands get the highest score with 2.75 goals per match, followed closely by England, France, and Senegal.


-- =====================================================================
-- Bonus (not graded)
-- =====================================================================

-- B1. The Golden Boot race: the top three places.

;
-- Rows:
-- Answer:


-- B2. Jordan's goals per year since 2015: change on the year before, and running total.

;
-- Rows:
-- Answer:


-- B3. Penalty shootouts.

;
-- Rows:
-- Answer:
