-- -------------------------------------------------------------------- --
-- BUSINESS CHALLENGE #1
-- MBANDD 2022
-- HULT INTERNATIONAL BUSINESS SCHOOL
-- -------------------------------------------------------------------- --

/*
For this analysis, we decided that the most recent returns were the most important ones, so 
we focused on a 12 month period (2021-2022). Plus, as recommended by the professor, 
we used adjusted prices for all our returns calculations.
*/

USE invest;

-- ----------------- --
-- CREATING 2 TABLES --
-- ----------------- --
/* 1) We created this first table t4_returns in Local Instance server to calculate the risk adjusted returns for each security 
for the FY 2021/22, using the LAG function and the formulas discussed during class. For that, we used the WITH clause to create 
temporary tables from our subqueries and, after, we used the CREATE TABLE function to make it permanent. */
CREATE TABLE t4_returns AS (WITH returns_2022 AS (SELECT a.date,
                                                      a.ticker,
                                                      s.security_name,
                                                      s.major_asset_class,
                                                      ROUND((a.value - a.lagged_price) / a.lagged_price, 3) as returns
                                               FROM (SELECT *,
                                                            LAG(value, 250) OVER (
                                                                PARTITION BY ticker
                                                                ORDER BY date
                                                                ) AS lagged_price
                                                     FROM invest.pricing_daily_new
                                                     WHERE price_type = 'Adjusted'
                                                     LIMIT 2000000 OFFSET 250) AS a
                                                        INNER JOIN security_masterlist AS s
                                                                   ON s.ticker = a.ticker
                                               WHERE date LIKE '2022-09-09'),
                               risk_2022 AS (SELECT a.date,
                                              a.ticker,
                                              a.value,
                                              a.lagged_price,
                                              a.price_type,
                                              (a.value - a.lagged_price) / a.lagged_price as returns
                                       FROM (SELECT *,
                                                    LAG(value, 1) OVER (PARTITION BY ticker
                                                        ORDER BY date
                                                        ) AS lagged_price
                                             FROM invest.pricing_daily_new
                                             WHERE price_type = 'Adjusted') AS a
                                       WHERE date BETWEEN '2021-09-09' AND '2022-09-09')
                         SELECT r.date,
                                r.ticker,
                                r.security_name,
                                r.major_asset_class,
                                r.returns,
                                ROUND(r.returns / (STD(rk.returns) * SQRT(250)), 3) AS risk_adj_returns
                         FROM returns_2022 AS r
                         INNER JOIN risk_2022 AS rk
                                 ON r.ticker=rk.ticker
                         GROUP BY
                                r.ticker,
                                r.date,
                                r.security_name,
                                r.major_asset_class,
                                r.returns)
;

/* 2) We felt the need to create a second table to show each customer's portfolio performance, including the following information: tickers, 
returns, weight, quantity and weighted returns for the same FY, and again using the formulas discussed in class. 
*/
CREATE TABLE T4_portfolio_performance AS (SELECT c.customer_id,
                                              a.main_account,
                                              h.ticker,
                                              h.quantity,
                                              ROUND(h.quantity / tot_quantity, 3)  AS weight,
                                              IFNULL(r.risk_adj_returns, 0)   AS returns,
                                              ROUND(IFNULL((h.quantity / tot_quantity) * r.risk_adj_returns, 0), 3) AS weighted_return
                                       FROM (SELECT customer_id,
                                                    SUM(quantity) AS tot_quantity
                                             FROM account_dim AS a
                                                      JOIN customer_details AS c
                                                           ON a.client_id = c.customer_id
                                                      JOIN holdings_current AS h
                                                           ON h.account_id = a.account_id
                                             GROUP BY customer_id) AS w
                                                INNER JOIN account_dim AS a
                                                           ON w.customer_id = a.client_id
                                                INNER JOIN customer_details AS c
                                                           ON a.client_id = c.customer_id
                                                INNER JOIN holdings_current AS h
                                                           ON h.account_id = a.account_id
                                                INNER JOIN t4_returns AS r
                                                           ON r.ticker = h.ticker
                                       ORDER BY customer_id);
                                       
-- ------------------------------------ --
-- SHOWCASING BEST AND WORST PORTFOLIOS --
-- ------------------------------------ --
/*
1) We used this first query to return the 5 best performing portfolios. After we grouped by customer_id and ordered by the returns
in a descending way, we limited to 5 results so that we could select the 5 best portfolios for 2022.
*/
SELECT pf.customer_id, cd.full_name,
       ROUND(SUM(weighted_return)*100, 3) AS portfolio_returns_2022
FROM T4_portfolio_performance AS pf
         INNER JOIN customer_details AS cd
                    ON pf.customer_id = cd.customer_id
GROUP BY customer_id, cd.full_name
ORDER BY portfolio_returns_2022 DESC
LIMIT 5;

/*
2) We used this second query to return the 5 worst performing portfolios. After we grouped by customer_id and ordered by the returns
in a ascending way, we limited to 5 results so that we could select the 5 worst portfolios for 2022.
*/
SELECT pf.customer_id, cd.full_name,
       ROUND(SUM(weighted_return)*100, 3) AS portfolio_returns_2022
FROM T4_portfolio_performance AS pf
         INNER JOIN customer_details AS cd
                    ON pf.customer_id = cd.customer_id
GROUP BY customer_id, cd.full_name
ORDER BY portfolio_returns_2022
LIMIT 5;

-- ------------------------------------ --
-- SHOWCASING BEST AND WORST SECURITIES --
-- ------------------------------------ --
/*
1) To return the securities of the 5 best portfolios, we created this query with a subquery in the WHERE clause to select the 5
 best portfolios that we observed in the queries above. We also decided to add a CASE STATEMENT to create another column with a
 "Keep" or "Sell" recommendation.
*/
SELECT customer_id,
       pp.ticker,
       sm.security_name,
       sm.major_asset_class,
       ROUND(IFNULL(returns,0),3) AS returns,
       ROUND(weight,3) AS weight,
       ROUND(SUM(weighted_return) OVER (PARTITION BY customer_id
                                            ORDER BY customer_id)*100,3) AS portfolio_return_percentage,
       CASE WHEN ROUND(IFNULL(returns,0),3) > 0 THEN 'KEEP'
	        WHEN ROUND(IFNULL(returns,0),3) <= 0 THEN 'SELL'
            END AS decision
FROM T4_portfolio_performance AS pp
INNER JOIN security_masterlist AS sm
        ON pp.ticker = sm.ticker
WHERE customer_id IN (SELECT customer_id -- using subquery to select top 5 portfolios
                      FROM (SELECT pf.customer_id,
                                   ROUND(SUM(weighted_return), 3) AS portfolio_returns_2022
                            FROM T4_portfolio_performance AS pf
                                     INNER JOIN customer_details AS cd
                                                ON pf.customer_id = cd.customer_id
                            GROUP BY customer_id
                            ORDER BY portfolio_returns_2022 DESC
                            LIMIT 5) AS s)
ORDER BY customer_id, returns DESC;

/*
2) To return the securities of the 5 worst portfolios, we created this query with a subquery in the WHERE clause to select the 5
 worst portfolios that we observed in the queries above. We also decided to add a CASE STATEMENT to create another column with a
 "Keep" or "Sell" recommendation.
 */
 SELECT customer_id,
       pp.ticker,
       sm.security_name,
       sm.major_asset_class,
       ROUND(IFNULL(returns,0),3) AS returns,
       ROUND(weight,3) AS weight,
       ROUND(SUM(weighted_return) OVER (PARTITION BY customer_id
                                            ORDER BY customer_id)*100,3) AS portfolio_return_percentage,
       CASE WHEN ROUND(IFNULL(returns,0),3) > 0 THEN 'KEEP'
	        WHEN ROUND(IFNULL(returns,0),3) <= 0 THEN 'SELL'
            END AS decision
FROM T4_portfolio_performance AS pp
INNER JOIN security_masterlist AS sm
        ON pp.ticker = sm.ticker
WHERE customer_id IN (SELECT customer_id -- using subquery to select bottom 3 portfolios
                      FROM (SELECT pf.customer_id,
                                   ROUND(SUM(weighted_return), 3) AS portfolio_returns_2022
                            FROM T4_portfolio_performance AS pf
                                     INNER JOIN customer_details AS cd
                                                ON pf.customer_id = cd.customer_id
                            GROUP BY customer_id
                            ORDER BY portfolio_returns_2022
                            LIMIT 5) AS s)
ORDER BY customer_id, returns DESC;


/*
3) With this query, our goal was to showcase the best performing securities' names, their tickers and asset class as well as their returns.
We did the same for the worst performing securities.
 */
SELECT ticker,
       security_name,
       major_asset_class,
       risk_adj_returns
FROM t4_returns
ORDER BY returns DESC
LIMIT 5
;
 
		-- worst performing securities
SELECT 
		r.ticker,
       r.security_name,
      r.major_asset_class,
       r.risk_adj_returns
FROM t4_returns as r
WHERE risk_adj_returns IS NOT NULL
ORDER BY risk_adj_returns
LIMIT 5
;

-- ----------------------- --
-- ADDITIONAL CALCULATIONS --
-- ----------------------- --
-- AS MENTIONED IN THE PRESENTATION, WE HAVE THIS EXTRA INFORMATION DERIVED FROM OUR CALCULATIONS.


-- Showing number of securities each customer invested in
SELECT c.customer_id,
       c.customer_location,
       COUNT(hc.ticker) as tot_tickers
FROM customer_details AS c
INNER JOIN account_dim AS a
        ON a.client_id = c.customer_id
INNER JOIN holdings_current hc
        ON a.account_id = hc.account_id
WHERE a.acct_open_status = 1
GROUP BY c.customer_id, c.customer_location
ORDER BY c.customer_id
;

-- Showing number of securities for 5 best performing portfolios
SELECT c.customer_id,
       c.customer_location,
       COUNT(hc.ticker) as tot_tickers
FROM customer_details AS c
INNER JOIN account_dim AS a
        ON a.client_id = c.customer_id
INNER JOIN holdings_current hc
        ON a.account_id = hc.account_id
WHERE a.acct_open_status = 1
  AND customer_id IN (SELECT customer_id -- using subquery to select top 5 portfolios
                      FROM (SELECT pf.customer_id,
                                   ROUND(SUM(weighted_return), 3) AS portfolio_returns_2022
                            FROM T4_portfolio_performance AS pf
                                     INNER JOIN customer_details AS cd
                                                ON pf.customer_id = cd.customer_id
                            GROUP BY customer_id
                            ORDER BY portfolio_returns_2022 DESC
                            LIMIT 5) AS s)
GROUP BY c.customer_id, c.customer_location
ORDER BY c.customer_id
;

-- Showing number of securities for 5 worst performing portfolios
SELECT c.customer_id,
       c.customer_location,
       COUNT(hc.ticker) as tot_tickers
FROM customer_details AS c
INNER JOIN account_dim AS a
        ON a.client_id = c.customer_id
INNER JOIN holdings_current hc
        ON a.account_id = hc.account_id
WHERE a.acct_open_status = 1
  AND customer_id IN (SELECT customer_id -- using subquery to select bottom 5 portfolios
                      FROM (SELECT pf.customer_id,
                                   ROUND(SUM(weighted_return), 3) AS portfolio_returns_2022
                            FROM T4_portfolio_performance AS pf
                                     INNER JOIN customer_details AS cd
                                                ON pf.customer_id = cd.customer_id
                            GROUP BY customer_id
                            ORDER BY portfolio_returns_2022
                            LIMIT 5) AS s)
GROUP BY c.customer_id, c.customer_location
ORDER BY c.customer_id
;


-- Showing minimum, maximum and average return for major asset class for 5 best performing portfolios
WITH top AS (SELECT customer_id,
       pp.ticker,
       sm.security_name,
       sm.major_asset_class,
       ROUND(IFNULL(returns,0),3) AS returns,
       ROUND(weight*100,3) AS weight,
       ROUND(SUM(weighted_return) OVER (PARTITION BY customer_id
                                            ORDER BY customer_id)*100,3) AS portfolio_return,
       CASE WHEN ROUND(IFNULL(returns,0),3) > 0 THEN 'KEEP'
	        WHEN ROUND(IFNULL(returns,0),3) <= 0 THEN 'SELL'
            END AS decision
FROM T4_portfolio_performance AS pp
INNER JOIN security_masterlist AS sm
        ON pp.ticker = sm.ticker
WHERE customer_id IN (SELECT customer_id -- using subquery to select top 5 portfolios
                      FROM (SELECT pf.customer_id,
                                   ROUND(SUM(weighted_return), 3) AS portfolio_returns_2022
                            FROM T4_portfolio_performance AS pf
                                     INNER JOIN customer_details AS cd
                                                ON pf.customer_id = cd.customer_id
                            GROUP BY customer_id
                            ORDER BY portfolio_returns_2022 DESC
                            LIMIT 5) AS s)
ORDER BY returns DESC)


SELECT major_asset_class,
       MAX(returns) AS max_return,
       MIN(returns) AS min_return,
       ROUND(AVG(returns),3) AS avg_return
FROM top
GROUP BY major_asset_class
;

-- Showing minimum, maximum and average return for major asset class for 5 worst performing portfolios
WITH bottom AS (SELECT customer_id,
       pp.ticker,
       sm.security_name,
       sm.major_asset_class,
       ROUND(IFNULL(returns,0)*100,3) AS returns,
       ROUND(weight*100,3) AS weight,
       ROUND(SUM(weighted_return) OVER (PARTITION BY customer_id
                                            ORDER BY customer_id)*100,3) AS portfolio_return,
       CASE WHEN ROUND(IFNULL(returns,0)*100,3) > 0 THEN 'KEEP'
	        WHEN ROUND(IFNULL(returns,0)*100,3) <= 0 THEN 'SELL'
            END AS decision
FROM T4_portfolio_performance AS pp
INNER JOIN security_masterlist AS sm
        ON pp.ticker = sm.ticker
WHERE customer_id IN (SELECT customer_id -- using subquery to select top 5 portfolios
                      FROM (SELECT pf.customer_id,
                                   ROUND(SUM(weighted_return), 3) AS portfolio_returns_2022
                            FROM T4_portfolio_performance AS pf
                                     INNER JOIN customer_details AS cd
                                                ON pf.customer_id = cd.customer_id
                            GROUP BY customer_id
                            ORDER BY portfolio_returns_2022
                            LIMIT 5) AS s)
ORDER BY returns DESC)


SELECT major_asset_class,
       MAX(returns) AS max_return,
       MIN(returns) AS min_return,
       ROUND(AVG(returns),3) AS avg_return
FROM bottom
GROUP BY major_asset_class
;
