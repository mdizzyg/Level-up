# LEVEL UP — Architecture

## 1. Общая архитектура

User
↓
React + TypeScript
↓
FastAPI
↓
PostgreSQL

## 2. Frontend

Frontend отвечает за:

- Dashboard;
- отображение целей;
- задачи;
- сделки;
- аналитику;
- формы ввода данных.

Стек:

- React
- TypeScript
- Vite

## 3. Backend

Backend отвечает за:

- обработку запросов frontend;
- бизнес-логику;
- расчёт прибыли;
- расчёт ROI;
- работу с базой данных;
- формирование аналитических показателей.

Стек:

- Python
- FastAPI

## 4. Database

PostgreSQL используется для хранения:

- пользователей;
- недельных целей;
- категорий;
- задач;
- сделок;
- движения капитала;
- истории капитала.

## 5. Analytics

Аналитический слой использует:

- SQL;
- Python;
- Pandas;
- Power BI.

## 6. Основной поток данных

User Action
↓
React
↓
HTTP Request
↓
FastAPI
↓
Business Logic
↓
PostgreSQL
↓
FastAPI Response
↓
React

## 7. Пример работы

Пользователь добавляет сделку.

React
↓
POST /deals
↓
FastAPI
↓
расчёт Profit
↓
расчёт ROI
↓
INSERT INTO deals
↓
PostgreSQL

После этого Dashboard получает обновлённые данные.

## 8. План развития

В будущем можно добавить:

- AI assistant;
- Telegram bot;
- market data APIs;
- CS2 data;
- notifications;
- authentication;
- multi-user mode.