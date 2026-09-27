CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    is_system BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_categories_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
    CONSTRAINT chk_categories_owner
    CHECK (
        is_system = TRUE
        OR user_id IS NOT NULL
);

CREATE TABLE weekly_goals (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    name VARCHAR(150) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    target_profit NUMERIC(12,2) NOT NULL,
    initial_capital NUMERIC(12,2) NOT NULL,
    comment TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_weekly_goals_user
        FOREIGN KEY (user_id)
        REFERENCES users(id),
    CONSTRAINT chk_weekly_goals_dates
        CHECK (end_date >= start_date),

    CONSTRAINT chk_weekly_goals_target_profit
        CHECK (target_profit >= 0),

    CONSTRAINT chk_weekly_goals_initial_capital
        CHECK (initial_capital >= 0)
);

CREATE TABLE weekly_goal_categories (
    id BIGSERIAL PRIMARY KEY,
    weekly_goal_id BIGINT NOT NULL,
    category_id BIGINT NOT NULL,
    target_profit NUMERIC(12,2),

    CONSTRAINT fk_weekly_goal_categories_goal
        FOREIGN KEY (weekly_goal_id)
        REFERENCES weekly_goals(id),

    CONSTRAINT fk_weekly_goal_categories_category
        FOREIGN KEY (category_id)
        REFERENCES categories(id),

    CONSTRAINT chk_weekly_goal_categories_target_profit
        CHECK (target_profit IS NULL OR target_profit >= 0),

    CONSTRAINT uq_weekly_goal_category
        UNIQUE (weekly_goal_id, category_id)
);

CREATE TABLE tasks (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    weekly_goal_id BIGINT,
    category_id BIGINT,
    name VARCHAR(255) NOT NULL,
    task_date DATE NOT NULL,
    status VARCHAR(30) NOT NULL,
    priority VARCHAR(20),
    comment TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_tasks_user
        FOREIGN KEY (user_id)
        REFERENCES users(id),

    CONSTRAINT fk_tasks_weekly_goal
        FOREIGN KEY (weekly_goal_id)
        REFERENCES weekly_goals(id),

    CONSTRAINT fk_tasks_category
        FOREIGN KEY (category_id)
        REFERENCES categories(id),

    CONSTRAINT chk_tasks_status
        CHECK (status IN (
            'planned',
            'in_progress',
            'completed',
            'cancelled'
        )),

    CONSTRAINT chk_tasks_priority
        CHECK (
            priority IS NULL
            OR priority IN ('low', 'medium', 'high')
        )
);

CREATE TABLE deals (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    weekly_goal_id BIGINT,
    category_id BIGINT NOT NULL,
    name VARCHAR(255) NOT NULL,
    purchase_date DATE,
    sale_date DATE,
    purchase_price NUMERIC(12,2),
    sale_price NUMERIC(12,2),
    expenses NUMERIC(12,2) NOT NULL DEFAULT 0,
    profit NUMERIC(12,2),
    roi NUMERIC(8,2),
    status VARCHAR(30) NOT NULL,
    comment TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_deals_user
        FOREIGN KEY (user_id)
        REFERENCES users(id),

    CONSTRAINT fk_deals_weekly_goal
        FOREIGN KEY (weekly_goal_id)
        REFERENCES weekly_goals(id),

    CONSTRAINT fk_deals_category
        FOREIGN KEY (category_id)
        REFERENCES categories(id),

    CONSTRAINT chk_deals_purchase_price
        CHECK (purchase_price IS NULL OR purchase_price >= 0),

    CONSTRAINT chk_deals_sale_price
        CHECK (sale_price IS NULL OR sale_price >= 0),

    CONSTRAINT chk_deals_expenses
        CHECK (expenses >= 0),

    CONSTRAINT chk_deals_dates
        CHECK (
            sale_date IS NULL
            OR purchase_date IS NULL
            OR sale_date >= purchase_date
        ),

    CONSTRAINT chk_deals_status
        CHECK (status IN (
            'analysis',
            'planned',
            'purchased',
            'listed',
            'sold',
            'cancelled'
        ))
);

CREATE TABLE capital_transactions (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    category_id BIGINT,
    deal_id BIGINT,
    transaction_type VARCHAR(30) NOT NULL,
    amount NUMERIC(12,2) NOT NULL,
    transaction_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    comment TEXT,

    CONSTRAINT fk_capital_transactions_user
        FOREIGN KEY (user_id)
        REFERENCES users(id),

    CONSTRAINT fk_capital_transactions_category
        FOREIGN KEY (category_id)
        REFERENCES categories(id),

    CONSTRAINT fk_capital_transactions_deal
        FOREIGN KEY (deal_id)
        REFERENCES deals(id),

    CONSTRAINT chk_capital_transactions_amount
        CHECK (amount > 0),

    CONSTRAINT chk_capital_transactions_type
        CHECK (transaction_type IN (
            'deposit',
            'withdrawal',
            'purchase',
            'sale',
            'expense',
            'commission'
        ))
);

CREATE TABLE capital_history (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    total_capital NUMERIC(12,2) NOT NULL,
    free_capital NUMERIC(12,2) NOT NULL,
    capital_in_use NUMERIC(12,2) NOT NULL,
    recorded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_capital_history_user
        FOREIGN KEY (user_id)
        REFERENCES users(id),

    CONSTRAINT chk_capital_history_total
        CHECK (total_capital >= 0),

    CONSTRAINT chk_capital_history_free
        CHECK (free_capital >= 0),

    CONSTRAINT chk_capital_history_in_use
        CHECK (capital_in_use >= 0),

    CONSTRAINT chk_capital_history_balance
        CHECK (
            total_capital = free_capital + capital_in_use
        )
);