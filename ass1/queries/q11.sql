# Return the store id, and the total “earning difference” of the store who had the largest
# difference in earning, between two succeeding months.
USE sakila;
SELECT STORE_ID,
       max(EARNING_AMOUNT - PREV_EARNINGS) AS MAX_DIFFERENCE

FROM (SELECT *,
             LAG(MONTH_ID) OVER ( PARTITION BY STORE_ID)       AS PREV_MONTH,
             LAG(YEAR_ID) OVER ( PARTITION BY STORE_ID)       AS PREV_YEAR,
             LAG(EARNING_AMOUNT) OVER ( PARTITION BY STORE_ID) AS PREV_EARNINGS


             # A subquery that calculates the sum of payments per month, per store, per year.
      FROM (SELECT SUM(payment.amount)        AS EARNING_AMOUNT,
                   MONTH(payment_date)        AS MONTH_ID,
                   YEAR(payment.payment_date) AS YEAR_ID,
                   staff.store_id          AS STORE_ID
            FROM payment
                     JOIN staff ON payment.staff_id = staff.staff_id
                     JOIN store ON store.store_id = staff.store_id
            GROUP BY MONTH_ID, store.store_id,
                     YEAR_ID, STORE_ID
            ORDER BY STORE_ID, YEAR_ID, MONTH_ID) AS SUM_PER_MONTH_YEAR_AND_STORE) AS EARNING_CURRENT_MONTH_AND_PERVIOUS_MONTH

WHERE (MONTH_ID = PREV_MONTH + 1) OR (MONTH_ID = 1 AND PREV_MONTH =12 AND YEAR_ID = PREV_YEAR + 1)
GROUP BY STORE_ID
ORDER BY MAX_DIFFERENCE DESC
LIMIT 1




