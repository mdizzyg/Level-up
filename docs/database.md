# LEVEL UP — Database

## 1. СУБД

PostgreSQL

База данных используется для хранения информации о пользователе, недельных целях, категориях, задачах, сделках и изменениях капитала.

---

## 2. Основные сущности

Планируемые таблицы:

- users
- weekly_goals
- categories
- weekly_goal_categories
- tasks
- deals
- capital_transactions
- capital_history

---

## 3. Назначение таблиц

### users

Хранит данные пользователя приложения.

### weekly_goals

Хранит недельные финансовые цели пользователя.

### categories

Хранит категории направлений заработка или размещения капитала.

Примеры:

- Sport
- Gaming
- Investments
- Other

### weekly_goal_categories

Связывает недельные цели с категориями.

Используется потому, что одна недельная цель может включать несколько категорий, а одна категория может использоваться в разных недельных целях.

### tasks

Хранит действия и задачи пользователя.

Примеры:

- найти 10 объявлений;
- написать 3 продавцам;
- проверить стоимость CS2-предметов;
- обновить цену объявления.

### deals

Хранит информацию о сделках пользователя.

Включает:

- покупку;
- продажу;
- дополнительные расходы;
- прибыль;
- ROI;
- статус сделки.

### capital_transactions

Хранит отдельные движения капитала.

Примеры:

- пополнение;
- вывод;
- покупка;
- продажа;
- комиссия;
- дополнительный расход.

### capital_history

Хранит историю изменения общего капитала пользователя во времени.

Используется для построения графика динамики капитала.

---

# 4. Структура таблиц

## 4.1 users

Назначение:

Хранит данные пользователя приложения.

| Поле | Тип данных | Ограничения | Описание |
|---|---|---|---|
| id | BIGSERIAL | PRIMARY KEY | Уникальный идентификатор пользователя |
| name | VARCHAR(100) | NOT NULL | Имя пользователя |
| created_at | TIMESTAMP | NOT NULL | Дата создания пользователя |

### Связи

Один пользователь может иметь:

- несколько недельных целей;
- несколько категорий;
- несколько задач;
- несколько сделок;
- несколько операций с капиталом;
- несколько записей истории капитала.

---

## 4.2 categories

Назначение:

Хранит категории, по которым пользователь получает доход или размещает капитал.

| Поле | Тип данных | Ограничения | Описание |
|---|---|---|---|
| id | BIGSERIAL | PRIMARY KEY | Уникальный идентификатор категории |
| user_id | BIGINT | FOREIGN KEY, NOT NULL | Пользователь, которому принадлежит категория |
| name | VARCHAR(100) | NOT NULL | Название категории |
| description | TEXT |  | Описание категории |
| created_at | TIMESTAMP | NOT NULL | Дата создания категории |

### Связи

Каждая категория принадлежит одному пользователю.

Одна категория может использоваться:

- в нескольких сделках;
- в нескольких задачах;
- в нескольких недельных целях.

---

## 4.3 weekly_goals

Назначение:

Хранит финансовые цели пользователя на определённый период.

| Поле | Тип данных | Ограничения | Описание |
|---|---|---|---|
| id | BIGSERIAL | PRIMARY KEY | Уникальный идентификатор цели |
| user_id | BIGINT | FOREIGN KEY, NOT NULL | Пользователь |
| name | VARCHAR(150) | NOT NULL | Название цели |
| start_date | DATE | NOT NULL | Дата начала |
| end_date | DATE | NOT NULL | Дата окончания |
| target_profit | NUMERIC(12,2) | NOT NULL | Планируемая прибыль |
| initial_capital | NUMERIC(12,2) | NOT NULL | Капитал на начало периода |
| comment | TEXT |  | Комментарий |
| created_at | TIMESTAMP | NOT NULL | Дата создания цели |

### Связи

Одна недельная цель:

- принадлежит одному пользователю;
- может быть связана с несколькими категориями;
- может содержать несколько задач;
- может быть связана с несколькими сделками.

---

## 4.4 weekly_goal_categories

Назначение:

Промежуточная таблица для связи недельных целей и категорий.

| Поле | Тип данных | Ограничения | Описание |
|---|---|---|---|
| id | BIGSERIAL | PRIMARY KEY | Уникальный идентификатор записи |
| weekly_goal_id | BIGINT | FOREIGN KEY, NOT NULL | Недельная цель |
| category_id | BIGINT | FOREIGN KEY, NOT NULL | Категория |
| target_profit | NUMERIC(12,2) |  | Планируемая прибыль по категории |

### Связи

Позволяет реализовать связь:

`weekly_goals N:M categories`

---

## 4.5 tasks

Назначение:

Хранит действия и задачи пользователя.

| Поле | Тип данных | Ограничения | Описание |
|---|---|---|---|
| id | BIGSERIAL | PRIMARY KEY | Уникальный идентификатор задачи |
| user_id | BIGINT | FOREIGN KEY, NOT NULL | Пользователь |
| weekly_goal_id | BIGINT | FOREIGN KEY | Недельная цель |
| category_id | BIGINT | FOREIGN KEY | Категория |
| name | VARCHAR(255) | NOT NULL | Название задачи |
| task_date | DATE | NOT NULL | Дата выполнения |
| status | VARCHAR(30) | NOT NULL | Статус задачи |
| priority | VARCHAR(20) |  | Приоритет |
| comment | TEXT |  | Комментарий |
| created_at | TIMESTAMP | NOT NULL | Дата создания |

### Возможные статусы

- planned
- in_progress
- completed
- cancelled

### Возможные приоритеты

- low
- medium
- high

---

## 4.6 deals

Назначение:

Хранит сделки пользователя.

| Поле | Тип данных | Ограничения | Описание |
|---|---|---|---|
| id | BIGSERIAL | PRIMARY KEY | Уникальный идентификатор сделки |
| user_id | BIGINT | FOREIGN KEY, NOT NULL | Пользователь |
| weekly_goal_id | BIGINT | FOREIGN KEY | Недельная цель |
| category_id | BIGINT | FOREIGN KEY, NOT NULL | Категория |
| name | VARCHAR(255) | NOT NULL | Название сделки |
| purchase_date | DATE |  | Дата покупки |
| sale_date | DATE |  | Дата продажи |
| purchase_price | NUMERIC(12,2) |  | Цена покупки |
| sale_price | NUMERIC(12,2) |  | Цена продажи |
| expenses | NUMERIC(12,2) | DEFAULT 0 | Дополнительные расходы |
| profit | NUMERIC(12,2) |  | Прибыль |
| roi | NUMERIC(8,2) |  | ROI в процентах |
| status | VARCHAR(30) | NOT NULL | Статус сделки |
| comment | TEXT |  | Комментарий |
| created_at | TIMESTAMP | NOT NULL | Дата создания |

### Возможные статусы

- analysis
- planned
- purchased
- listed
- sold
- cancelled

### Расчёт прибыли

`Profit = Sale Price - Purchase Price - Expenses`

### Расчёт ROI

`ROI = Profit / Purchase Price × 100%`

Profit и ROI должны рассчитываться автоматически после появления необходимых данных.

---

## 4.7 capital_transactions

Назначение:

Хранит отдельные движения капитала.

| Поле | Тип данных | Ограничения | Описание |
|---|---|---|---|
| id | BIGSERIAL | PRIMARY KEY | Уникальный идентификатор операции |
| user_id | BIGINT | FOREIGN KEY, NOT NULL | Пользователь |
| category_id | BIGINT | FOREIGN KEY | Категория |
| deal_id | BIGINT | FOREIGN KEY | Связанная сделка |
| transaction_type | VARCHAR(30) | NOT NULL | Тип операции |
| amount | NUMERIC(12,2) | NOT NULL | Сумма |
| transaction_date | TIMESTAMP | NOT NULL | Дата операции |
| comment | TEXT |  | Комментарий |

### Возможные типы операций

- deposit
- withdrawal
- purchase
- sale
- expense
- commission

---

## 4.8 capital_history

Назначение:

Хранит снимки общего состояния капитала пользователя во времени.

| Поле | Тип данных | Ограничения | Описание |
|---|---|---|---|
| id | BIGSERIAL | PRIMARY KEY | Уникальный идентификатор |
| user_id | BIGINT | FOREIGN KEY, NOT NULL | Пользователь |
| total_capital | NUMERIC(12,2) | NOT NULL | Общий капитал |
| free_capital | NUMERIC(12,2) | NOT NULL | Свободный капитал |
| capital_in_use | NUMERIC(12,2) | NOT NULL | Капитал в обороте |
| recorded_at | TIMESTAMP | NOT NULL | Дата и время записи |

Используется для построения графика:

`дата → размер капитала`

---

# 5. Связи между таблицами

Основные связи:

- `users 1:N weekly_goals`
- `users 1:N categories`
- `users 1:N tasks`
- `users 1:N deals`
- `users 1:N capital_transactions`
- `users 1:N capital_history`

- `weekly_goals 1:N tasks`
- `weekly_goals 1:N deals`

- `categories 1:N tasks`
- `categories 1:N deals`
- `categories 1:N capital_transactions`

- `weekly_goals N:M categories`

Связь `N:M` реализуется через таблицу:

`weekly_goal_categories`

---

# 6. Ограничения и бизнес-правила

## 6.1 Пользователь

- `name` обязателен;
- `created_at` устанавливается автоматически.

## 6.2 Недельная цель

- `start_date` не должна быть позже `end_date`;
- `target_profit` должна быть больше или равна 0;
- `initial_capital` должна быть больше или равна 0.

## 6.3 Сделки

- `purchase_price` не может быть отрицательной;
- `sale_price` не может быть отрицательной;
- `expenses` не могут быть отрицательными;
- `sale_date` не должна быть раньше `purchase_date`;
- Profit рассчитывается автоматически;
- ROI рассчитывается автоматически после завершения сделки.

## 6.4 Капитал

- сумма операций с капиталом должна быть положительной;
- направление движения определяется типом операции;
- капитал в обороте рассчитывается по активным сделкам;
- свободный капитал рассчитывается как:

`Free Capital = Total Capital - Capital In Use`

---

# 7. Индексы

На этапе реализации рекомендуется создать индексы для полей, которые часто используются в фильтрации и JOIN.

Например:

- deals.user_id
- deals.category_id
- deals.weekly_goal_id
- deals.status
- tasks.task_date
- tasks.status
- capital_transactions.transaction_date
- capital_history.recorded_at

---

# 8. ER-диаграмма

На основе данной структуры необходимо построить ER-диаграмму.

Инструмент:

draw.io / diagrams.net

Диаграмма должна показывать:

- таблицы;
- основные поля;
- Primary Keys;
- Foreign Keys;
- связи 1:N;
- связь N:M.

---

# 9. Следующий этап

После согласования структуры БД необходимо:

1. построить ER-диаграмму;
2. сохранить исходник `.drawio`;
3. экспортировать диаграмму в PNG;
4. создать `database/schema.sql`;
5. создать таблицы в PostgreSQL;
6. добавить тестовые данные;
7. проверить связи;
8. написать первые аналитические SQL-запросы.