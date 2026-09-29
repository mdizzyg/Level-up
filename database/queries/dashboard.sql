-- ============================================
-- LEVEL UP
-- Dashboard queries
-- ============================================


-- 1. Последнее состояние капитала

SELECT
    total_capital,
    free_capital,
    capital_in_use,
    recorded_at
FROM capital_history
ORDER BY recorded_at DESC
LIMIT 1;


-- 2. Текущая недельная цель

SELECT
    id,
    name,
    start_date,
    end_date,
    target_profit,
    initial_capital
FROM weekly_goals
ORDER BY start_date DESC
LIMIT 1;


-- 3. Прибыль по текущей недельной цели

SELECT
    wg.id AS weekly_goal_id,
    wg.name,
    wg.target_profit,
    COALESCE(SUM(d.profit), 0) AS actual_profit
FROM weekly_goals wg
LEFT JOIN deals d
    ON d.weekly_goal_id = wg.id
    AND d.status = 'sold'
WHERE wg.id = (
    SELECT id
    FROM weekly_goals
    ORDER BY start_date DESC
    LIMIT 1
)
GROUP BY
    wg.id,
    wg.name,
    wg.target_profit;


-- 4. Прогресс недельной цели

SELECT
    wg.target_profit,
    COALESCE(SUM(d.profit), 0) AS actual_profit,

    GREATEST(
        wg.target_profit - COALESCE(SUM(d.profit), 0),
        0
    ) AS remaining_profit,

    ROUND(
        COALESCE(SUM(d.profit), 0)
        / NULLIF(wg.target_profit, 0)
        * 100,
        2
    ) AS progress_percent

FROM weekly_goals wg

LEFT JOIN deals d
    ON d.weekly_goal_id = wg.id
    AND d.status = 'sold'

WHERE wg.id = (
    SELECT id
    FROM weekly_goals
    ORDER BY start_date DESC
    LIMIT 1
)

GROUP BY
    wg.id,
    wg.target_profit;


-- 5. Задачи на сегодня

SELECT
    t.id,
    t.name,
    t.task_date,
    t.status,
    t.priority,
    c.name AS category

FROM tasks t

LEFT JOIN categories c
    ON c.id = t.category_id

WHERE t.task_date = CURRENT_DATE
AND t.status <> 'cancelled'

ORDER BY
    CASE t.priority
        WHEN 'high' THEN 1
        WHEN 'medium' THEN 2
        WHEN 'low' THEN 3
        ELSE 4
    END,
    t.id;


-- 6. Последние сделки

SELECT
    d.id,
    d.name,
    c.name AS category,
    d.purchase_price,
    d.sale_price,
    d.profit,
    d.roi,
    d.status,
    d.created_at

FROM deals d

JOIN categories c
    ON c.id = d.category_id

ORDER BY d.created_at DESC

LIMIT 5;


-- 7. Прибыль по категориям

SELECT
    c.name AS category,
    COALESCE(SUM(d.profit), 0) AS total_profit

FROM categories c

LEFT JOIN deals d
    ON d.category_id = c.id
    AND d.status = 'sold'

WHERE c.is_active = TRUE

GROUP BY
    c.id,
    c.name

ORDER BY total_profit DESC;


-- 8. Динамика капитала

SELECT
    recorded_at,
    total_capital,
    free_capital,
    capital_in_use

FROM capital_history

ORDER BY recorded_at;