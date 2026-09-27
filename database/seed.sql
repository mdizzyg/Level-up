INSERT INTO  users (name)
VALUES ('TEST NAME');

INSERT INTO categories (
    user_id,
    name,
    description,
    is_system
)
VALUES
    (NULL, 'Resale', 'Перепродажа физических товаров',TRUE),
    (NULL, 'Digital Assets', 'Цифровые товары и игровые предметы', TRUE)
    (NULL, 'Investments', 'Финансовые инструменты', TRUE)
    (NULL, 'Other', 'Другие направления',TRUE)

INSERT INTO weekly_goals (
    user_id,
    name,
    start_date,
    end_date,
    target_profit,
    initial_capital,
    comment
)
VALUES (
    1,
    'Неделя 1',
    '2026-09-28',
    '2026-10-04',
    4000,
    20000,
    'Первая тестовая недельная цель'
);

INSERT INTO weekly_goal_categories (
    weekly_goal_id,
    category_id,
    target_profit
)
VALUES
    (
        1,
        (SELECT id
         FROM categories
         WHERE name = 'Resale'),
        2500
    ),
    (
        1,
        (SELECT id
         FROM categories
         WHERE name = 'Digital Assets'),
        1000
    ),
    (
        1,
        (SELECT id
         FROM categories
         WHERE name = 'Investments'),
        500
    );



INSERT INTO tasks (
    user_id,
    weekly_goal_id,
    category_id,
    name,
    task_date,
    status,
    priority,
    comment
)
VALUES
    (
        1,
        1,
        (SELECT id
         FROM categories
         WHERE name = 'Resale'),
        'Найти 10 подходящих товаров для перепродажи',
        '2026-09-28',
        'completed',
        'high',
        'Проверить предложения и потенциальную маржу'
    ),
    (
        1,
        1,
        (SELECT id
         FROM categories
         WHERE name = 'Resale'),
        'Связаться с 3 продавцами',
        '2026-09-29',
        'in_progress',
        'medium',
        NULL
    ),
    (
        1,
        1,
        (SELECT id
         FROM categories
         WHERE name = 'Digital Assets'),
        'Проанализировать цены цифровых активов',
        '2026-09-29',
        'planned',
        'medium',
        NULL
    ),
    (
        1,
        1,
        (SELECT id
         FROM categories
         WHERE name = 'Investments'),
        'Проверить доступные инвестиционные инструменты',
        '2026-09-30',
        'planned',
        'low',
        NULL
    );

INSERT INTO deals (
    user_id,
    weekly_goal_id,
    category_id,
    name,
    purchase_date,
    sale_date,
    purchase_price,
    sale_price,
    expenses,
    profit,
    roi,
    status,
    comment
)
VALUES
    (
        1,
        1,
        (SELECT id
         FROM categories
         WHERE name = 'Resale'),
        'Перепродажа спортивных товаров',
        '2026-09-28',
        '2026-09-30',
        5000,
        6500,
        200,
        1300,
        26.00,
        'sold',
        'Тестовая прибыльная сделка'
    ),
    (
        1,
        1,
        (SELECT id
         FROM categories
         WHERE name = 'Digital Assets'),
        'Операция с цифровым активом',
        '2026-09-29',
        '2026-10-01',
        3000,
        3600,
        100,
        500,
        16.67,
        'sold',
        'Тестовая сделка категории Digital Assets'
    );



INSERT INTO capital_transactions (
    user_id,
    category_id,
    deal_id,
    transaction_type,
    amount,
    transaction_date,
    comment
)
VALUES
    (
        1,
        NULL,
        NULL,
        'deposit',
        20000,
        '2026-09-28 09:00:00',
        'Начальный капитал'
    ),
    (
        1,
        (SELECT id
         FROM categories
         WHERE name = 'Resale'),
        (SELECT id
         FROM deals
         WHERE name = 'Перепродажа спортивных товаров'),
        'purchase',
        5000,
        '2026-09-28 12:00:00',
        'Покупка товара'
    ),
    (
        1,
        (SELECT id
         FROM categories
         WHERE name = 'Digital Assets'),
        (SELECT id
         FROM deals
         WHERE name = 'Операция с цифровым активом'),
        'purchase',
        3000,
        '2026-09-29 15:00:00',
        'Покупка цифрового актива'
    ),
    (
        1,
        (SELECT id
         FROM categories
         WHERE name = 'Resale'),
        (SELECT id
         FROM deals
         WHERE name = 'Перепродажа спортивных товаров'),
        'sale',
        6500,
        '2026-09-30 18:00:00',
        'Продажа товара'
    ),
    (
        1,
        (SELECT id
         FROM categories
         WHERE name = 'Resale'),
        (SELECT id
         FROM deals
         WHERE name = 'Перепродажа спортивных товаров'),
        'expense',
        200,
        '2026-09-30 18:05:00',
        'Дополнительные расходы'
    ),
    (
        1,
        (SELECT id
         FROM categories
         WHERE name = 'Digital Assets'),
        (SELECT id
         FROM deals
         WHERE name = 'Операция с цифровым активом'),
        'sale',
        3600,
        '2026-10-01 17:00:00',
        'Продажа цифрового актива'
    ),
    (
        1,
        (SELECT id
         FROM categories
         WHERE name = 'Digital Assets'),
        (SELECT id
         FROM deals
         WHERE name = 'Операция с цифровым активом'),
        'expense',
        100,
        '2026-10-01 17:05:00',
        'Комиссия и дополнительные расходы'
    );

INSERT INTO capital_history (
    user_id,
    total_capital,
    free_capital,
    capital_in_use,
    recorded_at
)
VALUES
    (
        1,
        20000,
        20000,
        0,
        '2026-09-28 09:00:00'
    ),
    (
        1,
        20000,
        12000,
        8000,
        '2026-09-29 15:30:00'
    ),
    (
        1,
        21800,
        21800,
        0,
        '2026-10-01 18:00:00'
    );
