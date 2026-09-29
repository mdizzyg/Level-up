-- 1. Прибыль по категориям 
SELECT
    c.name as category,
    count(d.id) as deals_count,
    sum(d.profit) as total_profit,
    round (AVG(d.roi), 2) AS avg_roi
FROM deals d
JOIN categories c
    ON d.category_id = c.id
WHERE d.status = 'sold'
Group by c.name
order by total_profit DESC;

-- 2. Общая прибыль
SELECT
    SUM(profit) AS total_profit
FROM deals
WHERE status = 'sold';


-- 3. Средний ROI

SELECT
    ROUND(AVG(roi), 2) AS avg_roi
FROM deals
WHERE status = 'sold';


-- 4. Количество сделок

SELECT
    COUNT(*) AS deals_count
FROM deals;


-- 5. Процент прибыльных сделок

SELECT
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE profit > 0)
        / NULLIF(COUNT(*), 0),
        2
    ) AS profitable_deals_rate
FROM deals
WHERE status = 'sold';


-- 6. Выполнение недельной цели

SELECT
    wg.name,
    wg.target_profit,
    COALESCE(SUM(d.profit), 0) AS actual_profit,
    ROUND(
        COALESCE(SUM(d.profit), 0)
        / NULLIF(wg.target_profit, 0)
        * 100,
        2
    ) AS goal_completion_percent
FROM weekly_goals wg
LEFT JOIN deals d
    ON wg.id = d.weekly_goal_id
    AND d.status = 'sold'
GROUP BY
    wg.id,
    wg.name,
    wg.target_profit;


-- 7. Задачи по статусам

SELECT
    status,
    COUNT(*) AS tasks_count
FROM tasks
GROUP BY status
ORDER BY tasks_count DESC;


-- 8. Последнее состояние капитала

SELECT
    total_capital,
    free_capital,
    capital_in_use,
    recorded_at
FROM capital_history
ORDER BY recorded_at DESC
LIMIT 1;